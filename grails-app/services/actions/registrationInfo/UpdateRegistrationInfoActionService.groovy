package actions.registrationInfo

import com.model.ListRegistrationInfoActionServiceModel
import com.scms.RegistrationInfo
import com.scms.Village
import grails.transaction.Transactional
import org.apache.log4j.Logger
import scms.ActionServiceIntf
import scms.BaseService
import scms.utility.DateUtility

@Transactional
class UpdateRegistrationInfoActionService extends BaseService implements ActionServiceIntf {

    def springSecurityService
    private static final String UPDATE_SUCCESS_MESSAGE = "Data has been updated successfully"
    private static final String REGISTRATION_INFO = "registrationInfo"


    private Logger log = Logger.getLogger(getClass())

    public Map executePreCondition(Map params) {
        try {
            if (!params.regNo) {
                return super.setError(params, INVALID_INPUT_MSG)
            }
            RegistrationInfo oldRegistrationInfo = RegistrationInfo.findByRegNo(params.regNo.toString())
            long villageId
            boolean b = isInteger(params.village)
            if (b) {
                villageId = Long.parseLong(params.village.toString())
            } else {
                if (!params.unionId || !params.upazilaId || !params.districtId) {
                    return super.setError(params, INVALID_INPUT_MSG)
                }
                Village village = new Village()
                village.name = params.village
                village.unionId = Long.parseLong(params.unionId)
                village.save()
                villageId = village.id
            }
            params.village = villageId
            RegistrationInfo registrationInfo = buildObject(villageId,params, oldRegistrationInfo)
            params.put(REGISTRATION_INFO, registrationInfo)
            return params
        } catch (Exception ex) {
            log.error(ex.getMessage())
            throw new RuntimeException(ex)
        }
    }

    @Transactional
    public Map execute(Map result) {
        try {
            RegistrationInfo registrationInfo = (RegistrationInfo) result.get(REGISTRATION_INFO)
            registrationInfo.save()
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
        RegistrationInfo registrationInfo = (RegistrationInfo) result.get(REGISTRATION_INFO)
        ListRegistrationInfoActionServiceModel model = ListRegistrationInfoActionServiceModel.read(registrationInfo.regNo)
        result.put(REGISTRATION_INFO, model)
        return super.setSuccess(result, UPDATE_SUCCESS_MESSAGE)
    }

    public Map buildFailureResultForUI(Map params) {
        return params
    }

    private  RegistrationInfo buildObject(long villageId,Map parameterMap, RegistrationInfo oldRegistrationInfo) {

        RegistrationInfo registrationInfo = new RegistrationInfo(parameterMap)
        oldRegistrationInfo.patientName = registrationInfo.patientName
        oldRegistrationInfo.fatherOrMotherName = registrationInfo.fatherOrMotherName
        oldRegistrationInfo.dateOfBirth = DateUtility.getSqlDate(DateUtility.parseMaskedDate(parameterMap.dateOfBirth))
        oldRegistrationInfo.maritalStatusId = registrationInfo.maritalStatusId
        oldRegistrationInfo.mobileNo = registrationInfo.mobileNo
        oldRegistrationInfo.modifyDate = DateUtility.getSqlDate(new Date())
        oldRegistrationInfo.modifyBy = springSecurityService.principal.id
        oldRegistrationInfo.villageId = villageId

        return oldRegistrationInfo
    }
}
