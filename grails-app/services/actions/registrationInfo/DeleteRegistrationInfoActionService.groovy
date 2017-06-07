package actions.registrationInfo

import com.scms.RegistrationInfo
import com.scms.RevisitPatient
import com.scms.ServiceTokenInfo
import grails.plugin.springsecurity.SpringSecurityService
import grails.transaction.Transactional
import org.apache.log4j.Logger
import scms.ActionServiceIntf
import scms.BaseService
import service.RegistrationInfoService

@Transactional
class DeleteRegistrationInfoActionService extends BaseService implements ActionServiceIntf {

    private Logger log = Logger.getLogger(getClass())

    private static final String DELETE_SUCCESS_MESSAGE = "Record has been deleted successfully"
    private static final String NOT_FOUND = "Selected record does not exits"
    private static final String REGISTRATION_INFO = "registrationInfo"
    SpringSecurityService springSecurityService
    RegistrationInfoService registrationInfoService

    @Transactional(readOnly = true)
    public Map executePreCondition(Map params) {
        try {
            String regNo = params.regNo.toString()

            RegistrationInfo registrationInfo = RegistrationInfo.findByRegNo(regNo)
            if (!registrationInfo) {
                return super.setError(params, NOT_FOUND)
            }
            int count = ServiceTokenInfo.countByRegNo(regNo)
            if (count > 0) {
                return super.setError(params, 'Sorry! Patient already taken service.')
            }
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
            if (registrationInfo.isOldPatient) {
                RevisitPatient revisitPatient = RevisitPatient.findByRegNo(registrationInfo.regNo)
                revisitPatient.delete()
            }

            registrationInfo.delete()

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

}
