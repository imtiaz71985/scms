package actions.ServiceTokenInfo

import com.scms.ServiceTokenInfo
import grails.plugin.springsecurity.SpringSecurityService
import grails.transaction.Transactional
import org.apache.log4j.Logger
import scms.ActionServiceIntf
import scms.BaseService
import scms.utility.DateUtility

@Transactional
class DeleteServiceTokenInfoActionService extends BaseService implements ActionServiceIntf {

    private Logger log = Logger.getLogger(getClass())

    private static final String DELETE_SUCCESS_MESSAGE = "Service has been deleted successfully"
    private static final String NOT_FOUND = "Selected record does not exits"
    private static final String SERVICE_TOKEN_INFO= "serviceTokenInfo"
   
    SpringSecurityService springSecurityService

    @Transactional(readOnly = true)
    public Map executePreCondition(Map params) {
        try {
            String tokenNo=params.tokenNo.toString()
            ServiceTokenInfo oldServiceTokenInfo = ServiceTokenInfo.findByServiceTokenNo(tokenNo)
            if(!oldServiceTokenInfo){
                return super.setError(params, NOT_FOUND)
            }
            ServiceTokenInfo serviceTokenInfo = buildObject(oldServiceTokenInfo)
            params.put(SERVICE_TOKEN_INFO, serviceTokenInfo)
            return params
        } catch (Exception ex) {
            log.error(ex.getMessage())
            throw new RuntimeException(ex)
        }
    }

    @Transactional
    public Map execute(Map result) {
        try {
            ServiceTokenInfo serviceTokenInfo = (ServiceTokenInfo) result.get(SERVICE_TOKEN_INFO)
            serviceTokenInfo.save()
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

    private  ServiceTokenInfo buildObject(ServiceTokenInfo oldServiceTokenInfo) {

        oldServiceTokenInfo.modifyDate = DateUtility.getSqlDate(new Date())
        oldServiceTokenInfo.modifyBy = springSecurityService.principal.id
        oldServiceTokenInfo.isDeleted=true

        return oldServiceTokenInfo
    }
}

