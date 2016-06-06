package actions.registrationInfo

import com.scms.RegistrationInfo
import grails.plugin.springsecurity.SpringSecurityService
import grails.transaction.Transactional
import org.apache.log4j.Logger
import scms.ActionServiceIntf
import scms.BaseService
import scms.utility.DateUtility
import service.RegistrationInfoService

@Transactional
class DeleteRegistrationInfoActionService extends BaseService implements ActionServiceIntf{

    private Logger log = Logger.getLogger(getClass())

    private static final String DELETE_SUCCESS_MESSAGE = "Record has been deleted successfully"
    private static final String NOT_FOUND = "Selected record does not exits"
    private static final String REGISTRATION_INFO = "registrationInfo"
    SpringSecurityService springSecurityService
    RegistrationInfoService registrationInfoService

    @Transactional(readOnly = true)
    public Map executePreCondition(Map params) {
        try {
            String regNo=params.regNo.toString()
            RegistrationInfo oldRegistrationInfo = RegistrationInfo.findByRegNo(regNo)
            if(!oldRegistrationInfo){
                return super.setError(params, NOT_FOUND)
            }
            RegistrationInfo registrationInfo = buildObject(oldRegistrationInfo)
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
        return super.setSuccess(result, DELETE_SUCCESS_MESSAGE)
    }

    public Map buildFailureResultForUI(Map params) {
        return params
    }

    private  RegistrationInfo buildObject(RegistrationInfo oldRegistrationInfo) {

        oldRegistrationInfo.modifyDate = DateUtility.getSqlDate(new Date())
        oldRegistrationInfo.modifyBy = springSecurityService.principal.id
        oldRegistrationInfo.isActive=false

        return oldRegistrationInfo
    }
}
