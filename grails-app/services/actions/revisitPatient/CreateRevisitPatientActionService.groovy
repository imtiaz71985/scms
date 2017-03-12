package actions.revisitPatient

import com.model.ListDiseaseGroupActionServiceModel
import com.scms.RevisitPatient
import com.scms.ServiceCharges
import grails.plugin.springsecurity.SpringSecurityService
import grails.transaction.Transactional
import org.apache.log4j.Logger
import scms.ActionServiceIntf
import scms.BaseService
import scms.utility.DateUtility
import service.RegistrationInfoService

@Transactional
class CreateRevisitPatientActionService extends BaseService implements ActionServiceIntf{

    private static final String SAVE_SUCCESS_MESSAGE = "Revisit patient saved successfully"
    private static final String ALREADY_EXIST = "Patient already exist"
    private static final String REVISIT_PATIENT = "revisitPatient"

    SpringSecurityService springSecurityService
    RegistrationInfoService registrationInfoService
    private Logger log = Logger.getLogger(getClass())

    @Transactional(readOnly = true)
    public Map executePreCondition(Map params) {
        try {
            //Check parameters
            if (!params.regNo) {
                return super.setError(params, INVALID_INPUT_MSG)
            }
            int duplicateCount = RevisitPatient.countByRegNoAndCreateDateBetween(params.regNo, DateUtility.getSqlFromDateWithSeconds(DateUtility.parseDateForDB(params.creatingDate)), DateUtility.getSqlToDateWithSeconds(DateUtility.parseDateForDB(params.creatingDate)))
            if (duplicateCount > 0) {
                return super.setError(params, ALREADY_EXIST)
            }
            RevisitPatient revisitPatient = buildObject(params)
            params.put(REVISIT_PATIENT, revisitPatient)
            return params
        } catch (Exception ex) {
            log.error(ex.getMessage())
            throw new RuntimeException(ex)
        }
    }

    @Transactional
    public Map execute(Map result) {
        try {
            RevisitPatient revisitPatient = (RevisitPatient) result.get(REVISIT_PATIENT)
            revisitPatient.save()

            return result
        } catch (Exception ex) {
            log.error(ex.getMessage())
            throw new RuntimeException(ex)
        }
    }

    public Map executePostCondition(Map result) {
        return result
    }

    public Map buildSuccessResultForUI(Map result) {
        String msg = registrationInfoService.patientServed()
        result.put('patientServed',msg)
        return super.setSuccess(result, SAVE_SUCCESS_MESSAGE)
    }

    public Map buildFailureResultForUI(Map result) {
        return result
    }

    /**
     * Build RevisitPatient object
     * @param parameterMap -serialized parameters from UI
     * @return -new RevisitPatient object
     */
    private RevisitPatient buildObject(Map parameterMap) {
        RevisitPatient revisitPatient = new RevisitPatient(parameterMap)
        revisitPatient.createDate=DateUtility.getSqlDate(DateUtility.parseDateForDB(parameterMap.creatingDate))
        revisitPatient.originalCreateDate=DateUtility.getSqlDate(new Date())
        revisitPatient.createdBy= springSecurityService.principal.id
        revisitPatient.visitTypeId=2
        revisitPatient.hospitalCode=parameterMap.regNo.substring(0, 2)
        return revisitPatient
    }
}
