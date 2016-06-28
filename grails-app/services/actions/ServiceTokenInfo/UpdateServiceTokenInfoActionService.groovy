package actions.ServiceTokenInfo

import com.scms.ServiceTokenInfo
import com.scms.TokenAndChargeMapping
import com.scms.TokenAndDiseaseMapping
import grails.plugin.springsecurity.SpringSecurityService
import grails.transaction.Transactional
import org.apache.log4j.Logger
import scms.ActionServiceIntf
import scms.BaseService
import scms.utility.DateUtility

@Transactional
class UpdateServiceTokenInfoActionService extends BaseService implements ActionServiceIntf {

    SpringSecurityService springSecurityService
    private static final String UPDATE_SUCCESS_MESSAGE = "Data has been updated successfully"
    private static final String COUNSELOR_ACTION = "serviceTokenInfo"


    private Logger log = Logger.getLogger(getClass())

    public Map executePreCondition(Map params) {
        try {

            if (!params.serviceTokenNo||!params.prescriptionTypeId) {
                return super.setError(params, INVALID_INPUT_MSG)
            }
            try{
                if (Double.parseDouble(params.payableAmount)<0) {
                    return super.setError(params, 'Invalid amount.')
                }
            }
            catch (Exception ex){
                return super.setError(params, 'Invalid amount.')
            }
            /*try{
                String  len=params.selectedDiseaseCode
                if(len.length()<1){
                    return super.setError(params, 'Sorry! Please select at least one disease.')
                }
            }
            catch (Exception ex){
                return super.setError(params, 'Sorry! Please select at least one disease.')
            }*/

            ServiceTokenInfo oldServiceTokenInfo = ServiceTokenInfo.findByServiceTokenNo(params.serviceTokenNo.toString())

            ServiceTokenInfo serviceTokenInfo = buildObject(params, oldServiceTokenInfo)
            params.put(COUNSELOR_ACTION, serviceTokenInfo)
            return params
        } catch (Exception ex) {
            log.error(ex.getMessage())
            throw new RuntimeException(ex)
        }
    }

    @Transactional
    public Map execute(Map result) {
        try {
            ServiceTokenInfo serviceTokenInfo = (ServiceTokenInfo) result.get(COUNSELOR_ACTION)
            serviceTokenInfo.save()

            if(result.pathologyCharges!='') {
                String str = result.selectedChargeId
                List<String> lst = Arrays.asList(str.split("\\s*,\\s*"));
                for (int i = 0; i < lst.size(); i++) {
                    TokenAndChargeMapping tokenAndChargeMapping = new TokenAndChargeMapping()
                    tokenAndChargeMapping.createDate = DateUtility.getSqlDate(new Date())
                    tokenAndChargeMapping.createBy = springSecurityService.principal.id
                    tokenAndChargeMapping.serviceTokenNo = serviceTokenInfo.serviceTokenNo
                    try {
                        if(lst.get(i)!='') {
                            tokenAndChargeMapping.serviceChargeId = Long.parseLong(lst.get(i))
                            tokenAndChargeMapping.save()
                        }
                    } catch (Exception ex) {
                    }
                }
            }
            String str = result.selectedDiseaseCode
            if(str.length()>1) {
                List<String> lst = Arrays.asList(str.split("\\s*,\\s*"));
                for (int i = 0; i < lst.size(); i++) {
                    TokenAndDiseaseMapping tokenAndDiseaseMapping = new TokenAndDiseaseMapping()
                    tokenAndDiseaseMapping.createDate = DateUtility.getSqlDate(new Date())
                    tokenAndDiseaseMapping.createBy = springSecurityService.principal.id
                    tokenAndDiseaseMapping.serviceTokenNo = serviceTokenInfo.serviceTokenNo
                    try {
                        if (lst.get(i) != '') {
                            tokenAndDiseaseMapping.diseaseCode = lst.get(i)
                            tokenAndDiseaseMapping.save()
                        }
                    } catch (Exception ex) {
                    }
                }
            }

            /*Map resultMap = super.getSearchResult(result, ListServiceHeadInfoActionServiceModel.class)
            result.put(LIST, resultMap.list)
            result.put(COUNT, resultMap.count)*/
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

        return super.setSuccess(result, UPDATE_SUCCESS_MESSAGE)
    }

    public Map buildFailureResultForUI(Map params) {
        return params
    }

    private ServiceTokenInfo buildObject(Map parameterMap, ServiceTokenInfo oldServiceTokenInfo) {

        if(!parameterMap.subsidyAmount){
            oldServiceTokenInfo.subsidyAmount =0d
        }else {
            oldServiceTokenInfo.subsidyAmount = Double.parseDouble(parameterMap.subsidyAmount)
        }
        oldServiceTokenInfo.serviceTokenNo=parameterMap.serviceTokenNo
        oldServiceTokenInfo.isExit = true
        oldServiceTokenInfo.prescriptionTypeId = Long.parseLong(parameterMap.prescriptionTypeId)
        oldServiceTokenInfo.modifyDate = DateUtility.getSqlDate(new Date())
        oldServiceTokenInfo.modifyBy = springSecurityService.principal.id

        return oldServiceTokenInfo
    }
}
