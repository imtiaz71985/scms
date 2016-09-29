package actions.registrationInfo

import com.model.ListRegistrationInfoActionServiceModel
import com.scms.RegistrationInfo
import com.scms.ServiceCharges
import com.scms.ServiceHeadInfo
import com.scms.ServiceType
import com.scms.Village
import grails.plugin.springsecurity.SpringSecurityService
import grails.transaction.Transactional
import org.apache.log4j.Logger
import scms.ActionServiceIntf
import scms.BaseService
import scms.utility.DateUtility
import service.RegistrationInfoService
import service.ServiceHeadInfoService

@Transactional
class CreateRegistrationInfoActionService extends BaseService implements ActionServiceIntf {

    private static final String SAVE_SUCCESS_MESSAGE = "Data saved successfully"
    private static final String REGISTRATION_INFO = "registrationInfo"
    private static final String REG_NO = "regNo"

    private Logger log = Logger.getLogger(getClass())

    RegistrationInfoService registrationInfoService
    ServiceHeadInfoService serviceHeadInfoService

    SpringSecurityService springSecurityService

    @Transactional
    public Map executePreCondition(Map params) {
        try {
            if (!params.regNo) {
                return super.setError(params, INVALID_INPUT_MSG)
            }
            if (!params.patientName) {
                return super.setError(params, INVALID_INPUT_MSG)
            }
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
            RegistrationInfo registrationInfo = buildObject(params, villageId)
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
        String regNo = registrationInfoService.retrieveRegNo()
        result.put(REG_NO, regNo)
        return super.setSuccess(result, SAVE_SUCCESS_MESSAGE)
    }

    public Map buildFailureResultForUI(Map result) {
        return result
    }


    private RegistrationInfo buildObject(Map parameterMap, long villageId) {

        long serviceChargeId = serviceHeadInfoService.serviceChargeIdByServiceType(1L)
        RegistrationInfo registrationInfo = new RegistrationInfo()
        registrationInfo.regNo = parameterMap.regNo
        registrationInfo.dateOfBirth = DateUtility.getSqlDate(DateUtility.parseMaskedDate(parameterMap.dateOfBirth))
        registrationInfo.fatherOrMotherName = parameterMap.fatherOrMotherName
        registrationInfo.maritalStatusId = Long.parseLong(parameterMap.maritalStatusId)
        registrationInfo.sexId = Long.parseLong(parameterMap.sexId)
        registrationInfo.mobileNo = parameterMap.mobileNo
        registrationInfo.patientName = parameterMap.patientName
        registrationInfo.villageId = villageId
        registrationInfo.service_charge_id = serviceChargeId
        registrationInfo.createDate = DateUtility.getSqlDate(new Date())
        registrationInfo.createdBy = springSecurityService.principal.id
        registrationInfo.hospitalCode = registrationInfo.regNo.substring(0, 2)
        registrationInfo.isActive = true
        if(parameterMap.newOrRevisit=="new")
            registrationInfo.isOldPatient=false
        else
            registrationInfo.isOldPatient=true
        return registrationInfo
    }

}
