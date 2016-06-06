package actions.ServiceTokenInfo

import com.scms.ServiceTokenInfo
import com.scms.TokenAndChargeMapping
import grails.plugin.springsecurity.SpringSecurityService
import grails.transaction.Transactional
import org.apache.log4j.Logger
import scms.ActionServiceIntf
import scms.BaseService
import scms.utility.DateUtility
import service.ServiceHeadInfoService

class CreateServiceTokenInfoActionService extends BaseService implements ActionServiceIntf {

    SpringSecurityService springSecurityService
    private static final String SAVE_SUCCESS_MESSAGE = "Data saved successfully"   
    private static final String SERVICE_TOKEN_INFO = "serviceTokenInfo"
    private Logger log = Logger.getLogger(getClass())

    ServiceHeadInfoService serviceHeadInfoService

    @Transactional
    public Map executePreCondition(Map params){
        try {
            //Check parameters

            if (!params.serviceTokenNo||!params.serviceTypeId||!params.regNo||!params.referToId) {
                return super.setError(params, INVALID_INPUT_MSG)
            }
            try{
                String  len=params.selectedChargeId
               if(len.length()<1){
                   return super.setError(params, 'Sorry! Please select at least one service.')
               }
            }
            catch (Exception ex){
                return super.setError(params, 'Sorry! Please select at least one service.')
            }
            ServiceTokenInfo serviceTokenInfo = buildObject(params)
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

            //In future use this format
            // def lst=result.List('paramName')
            //see in internet
            String str=result.selectedChargeId
            List<String> lst = Arrays.asList(str.split("\\s*,\\s*"));
            for(int i=0;i<lst.size();i++) {
                TokenAndChargeMapping tokenAndChargeMapping = new TokenAndChargeMapping()
                tokenAndChargeMapping.createDate = DateUtility.getSqlDate(new Date())
                tokenAndChargeMapping.createBy = springSecurityService.principal.id
                tokenAndChargeMapping.serviceTokenNo = serviceTokenInfo.serviceTokenNo
                try {
                    if(lst.get(i)!='') {
                        tokenAndChargeMapping.serviceChargeId = Long.parseLong(lst.get(i))
                        tokenAndChargeMapping.save()
                    }
                }
                catch (Exception ex){}
            }

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
       /* ServiceTokenInfo serviceTokenInfo = (ServiceTokenInfo) result.get(SERVICE_TOKEN_INFO)
        ListSystemEntityActionServiceModel model = ListSystemEntityActionServiceModel.read(serviceTokenInfo.serviceCode)
        result.put(SERVICE_TOKEN_INFO, model)*/
        ///return super.setSuccess(result, SAVE_SUCCESS_MESSAGE)
        return super.setSuccess(result, 'Data Saved successfully. Token No:'+result.serviceTokenNo)
    }

    public Map buildFailureResultForUI(Map result) {
        return result
    }

    /**
     * Build systemEntity object
     * @param parameterMap -serialized parameters from UI
     * @return -new systemEntity object
     /*    */
    private ServiceTokenInfo buildObject(Map parameterMap) {
        ServiceTokenInfo serviceTokenInfo = new ServiceTokenInfo()
        serviceTokenInfo.serviceTokenNo=parameterMap.serviceTokenNo
        serviceTokenInfo.regNo=parameterMap.regNo
        serviceTokenInfo.referToId=Long.parseLong(parameterMap.referToId)
        serviceTokenInfo.serviceDate=DateUtility.getSqlDate(new Date())
        serviceTokenInfo.createBy= springSecurityService.principal.id
        serviceTokenInfo.visitTypeId=1
        serviceTokenInfo.isExit =false
        try {
            if (Long.parseLong(parameterMap.serviceTypeId)>2)
                serviceTokenInfo.isExit = true
        }catch (Exception ex){}
        return serviceTokenInfo
    }
}
