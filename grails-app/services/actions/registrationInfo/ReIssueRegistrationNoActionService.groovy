package actions.registrationInfo

import com.scms.RegistrationInfo
import com.scms.RegistrationReissue
import grails.plugin.springsecurity.SpringSecurityService
import grails.transaction.Transactional
import org.apache.log4j.Logger
import scms.ActionServiceIntf
import scms.BaseService
import scms.utility.DateUtility
import service.RegistrationInfoService
import service.ServiceHeadInfoService

@Transactional
class ReIssueRegistrationNoActionService extends BaseService implements ActionServiceIntf{

    private Logger log = Logger.getLogger(getClass())

    private static final String REISSUE_SUCCESS_MESSAGE = "Record has been re issued successfully"
    private static final String NOT_FOUND = "Selected record does not exits"
    private static final String REGISTRATION_INFO = "registrationInfo"
    SpringSecurityService springSecurityService
    RegistrationInfoService registrationInfoService
    ServiceHeadInfoService serviceHeadInfoService

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

            RegistrationReissue registrationReissue =new RegistrationReissue()
            registrationReissue.regNo=registrationInfo.regNo
            registrationReissue.createDate= DateUtility.getSqlDate(new Date())
            registrationReissue.createBy=springSecurityService.principal.id
            registrationReissue.serviceChargeId=serviceHeadInfoService.serviceChargeIdByServiceType(1L)
            registrationReissue.description=result.description
            registrationReissue.save()

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
        return super.setSuccess(result, REISSUE_SUCCESS_MESSAGE)
    }

    public Map buildFailureResultForUI(Map params) {
        return params
    }

    private  RegistrationInfo buildObject(RegistrationInfo oldRegistrationInfo) {

        oldRegistrationInfo.isReissue=true

        return oldRegistrationInfo
    }
}
