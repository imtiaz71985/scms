package actions.ServiceTokenInfo

import com.scms.OldServiceTokenInfo
import com.scms.OldTokenAndChargeMapping
import com.scms.OldTokenAndDiseaseMapping
import grails.plugin.springsecurity.SpringSecurityService
import grails.transaction.Transactional
import org.apache.log4j.Logger
import scms.ActionServiceIntf
import scms.BaseService
import scms.utility.DateUtility

@Transactional
class DeleteOldServiceTokenInfoActionService extends BaseService implements ActionServiceIntf {

    private Logger log = Logger.getLogger(getClass())

    private static final String DELETE_SUCCESS_MESSAGE = "Service has been deleted successfully"
    private static final String NOT_FOUND = "Selected record does not exits"
    private static final String OLD_SERVICE_TOKEN_INFO= "oldServiceTokenInfo"
   
    SpringSecurityService springSecurityService

    @Transactional(readOnly = true)
    public Map executePreCondition(Map params) {
        try {
            String tokenNo=params.tokenNo.toString()
            OldServiceTokenInfo oldServiceTokenInfo = OldServiceTokenInfo.findByServiceTokenNo(tokenNo)
            if(!oldServiceTokenInfo){
                return super.setError(params, NOT_FOUND)
            }
            if(oldServiceTokenInfo.isApproved){
                return super.setError(params, 'Sorry! can not delete already approved.')
            }

            params.put(OLD_SERVICE_TOKEN_INFO, oldServiceTokenInfo)
            return params
        } catch (Exception ex) {
            log.error(ex.getMessage())
            throw new RuntimeException(ex)
        }
    }

    @Transactional
    public Map execute(Map result) {
        try {
            OldServiceTokenInfo oldServiceTokenInfo = (OldServiceTokenInfo) result.get(OLD_SERVICE_TOKEN_INFO)
            oldServiceTokenInfo.delete()

           // List<OldTokenAndChargeMapping> lstTCM = OldTokenAndChargeMapping.findAllByServiceTokenNo(oldServiceTokenInfo.serviceTokenNo)

            OldTokenAndChargeMapping.executeUpdate("delete OldTokenAndChargeMapping where serviceTokenNo = '${oldServiceTokenInfo.serviceTokenNo}'")
            OldTokenAndDiseaseMapping.executeUpdate("delete OldTokenAndDiseaseMapping where serviceTokenNo = '${oldServiceTokenInfo.serviceTokenNo}'")

           /* OldTokenAndDiseaseMapping oldTokenAndDiseaseMapping = OldTokenAndDiseaseMapping.findByServiceTokenNo(oldServiceTokenInfo.serviceTokenNo)

            oldTokenAndDiseaseMapping.delete()*/
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

