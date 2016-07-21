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

            if (!params.serviceTokenNo || !params.serviceTypeId || !params.regNo) {
                return super.setError(params, INVALID_INPUT_MSG)
            }
            long serviceTypeId = 0
            try {
                serviceTypeId=Long.parseLong(params.serviceTypeId)
            } catch (Exception ex) {
            }
            if(serviceTypeId<4 && !params.referToId){
                return super.setError(params, INVALID_INPUT_MSG)
            }
            if (serviceTypeId == 5) {
                if (!params.referenceServiceNoDDL){
                    return super.setError(params, 'Sorry! Please select reference service no.')
                }
            }else {
                try {
                    String len = params.selectedChargeId
                    if (len.length() < 1) {
                        return super.setError(params, 'Sorry! Please select at least one service.')
                    }
                }
                catch (Exception ex) {
                    return super.setError(params, 'Sorry! Please select at least one service.')
                }
            }
            ServiceTokenInfo serviceTokenInfo = buildObject(params,serviceTypeId)
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
            long serviceTypeId = 0
            try {
                serviceTypeId=Long.parseLong(result.serviceTypeId)
            } catch (Exception ex) {
            }
            if (serviceTypeId != 5) {
                String str = result.selectedChargeId
                List<String> lst = Arrays.asList(str.split("\\s*,\\s*"));
                for (int i = 0; i < lst.size(); i++) {
                    TokenAndChargeMapping tokenAndChargeMapping = new TokenAndChargeMapping()
                    tokenAndChargeMapping.createDate = DateUtility.getSqlDate(new Date())
                    tokenAndChargeMapping.createBy = springSecurityService.principal.id
                    tokenAndChargeMapping.serviceTokenNo = serviceTokenInfo.serviceTokenNo
                    try {
                        if (lst.get(i) != '') {
                            tokenAndChargeMapping.serviceChargeId = Long.parseLong(lst.get(i))
                            tokenAndChargeMapping.save()
                        }
                    }
                    catch (Exception ex) {
                    }
                }
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
    private ServiceTokenInfo buildObject(Map parameterMap,long serviceTypeId) {

        ServiceTokenInfo serviceTokenInfo = new ServiceTokenInfo()
        serviceTokenInfo.serviceTokenNo=parameterMap.serviceTokenNo
        serviceTokenInfo.regNo=parameterMap.regNo
        if(parameterMap.referToId)
        {
            serviceTokenInfo.referToId = Long.parseLong(parameterMap.referToId)
        }
        else{
            serviceTokenInfo.referToId =0 // When give general counselling
        }
        serviceTokenInfo.serviceDate=DateUtility.getSqlDate(new Date())
        serviceTokenInfo.createBy= springSecurityService.principal.id
        if(serviceTypeId==5) {
            serviceTokenInfo.visitTypeId =3L // Follow-Up
            serviceTokenInfo.referenceServiceTokenNo=parameterMap.referenceServiceNoDDL
        }
        else {
            int count = ServiceTokenInfo.countByRegNo(parameterMap.regNo)
            if (count > 0) {
                serviceTokenInfo.visitTypeId = 2L // re-visit
            } else {
                serviceTokenInfo.visitTypeId = 1L
            }
            serviceTokenInfo.isExit = false
        }
        if (serviceTypeId>2)
                serviceTokenInfo.isExit = true

        return serviceTokenInfo
    }
}
