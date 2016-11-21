package actions.ServiceTokenInfo

import com.scms.*
import grails.plugin.springsecurity.SpringSecurityService
import grails.transaction.Transactional
import org.apache.log4j.Logger
import scms.ActionServiceIntf
import scms.BaseService
import scms.utility.DateUtility

@Transactional
class ApproveOldServiceActionService extends BaseService implements ActionServiceIntf {

    SpringSecurityService springSecurityService
    private static final String SAVE_SUCCESS_MESSAGE = "Approved successfully"
    private static final String OLD_SERVICE_TOKEN_INFO = "oldServiceTokenInfo"
    private Logger log = Logger.getLogger(getClass())


    @Transactional
    public Map executePreCondition(Map params) {
        try {
            //Check parameters
            if (!params.serviceTokenNo ) {
                return super.setError(params, INVALID_INPUT_MSG)
            }
            
            OldServiceTokenInfo oldServiceTokenInfo = buildObjectOfOldService(params)
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
            oldServiceTokenInfo.save()
            if(oldServiceTokenInfo.isApproved==true) {
                ServiceTokenInfo serviceTokenInfo = buildObject(oldServiceTokenInfo.serviceTokenNo)
                serviceTokenInfo.save()

                List<OldTokenAndDiseaseMapping> lstOldTokenAndDiseaseMapping = OldTokenAndDiseaseMapping.findAllByServiceTokenNo(oldServiceTokenInfo.serviceTokenNo)
                if(lstOldTokenAndDiseaseMapping.size()>0) {
                    for (int i = 0; i < lstOldTokenAndDiseaseMapping.size(); i++) {
                        TokenAndDiseaseMapping tokenAndDiseaseMapping = new TokenAndDiseaseMapping()
                        tokenAndDiseaseMapping.serviceTokenNo = lstOldTokenAndDiseaseMapping[i].serviceTokenNo
                        tokenAndDiseaseMapping.diseaseCode = lstOldTokenAndDiseaseMapping[i].diseaseCode
                        tokenAndDiseaseMapping.serviceDate=oldServiceTokenInfo.serviceDate
                        tokenAndDiseaseMapping.save()
                    }
                }

                List<OldTokenAndChargeMapping> lstOldTokenAndChargeMapping=OldTokenAndChargeMapping.findAllByServiceTokenNo(oldServiceTokenInfo.serviceTokenNo)
                if (lstOldTokenAndChargeMapping.size() > 0) {
                    for (int i = 0; i < lstOldTokenAndChargeMapping.size(); i++) {
                        TokenAndChargeMapping tokenAndChargeMapping = new TokenAndChargeMapping()
                        tokenAndChargeMapping.serviceTokenNo = lstOldTokenAndChargeMapping[i].serviceTokenNo
                        tokenAndChargeMapping.serviceChargeId = lstOldTokenAndChargeMapping[i].serviceChargeId
                        tokenAndChargeMapping.serviceDate=oldServiceTokenInfo.serviceDate
                        tokenAndChargeMapping.save()
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
        if (result.isApprove == 'true') {
            return super.setSuccess(result, '<div style="font-size: 16px">Service approved successfully. Token No: <b>' + result.serviceTokenNo + '</b></div>')
        }
        else {
            return super.setSuccess(result, '<div style="font-size: 16px">Service decline successfully. Token No: <b>' + result.serviceTokenNo + '</b></div>')
        }
    }

    public Map buildFailureResultForUI(Map result) {
        return result
    }

    /**
     * Build systemEntity object
     * @param parameterMap -serialized parameters from UI
     * @return -new systemEntity object
     /*        */
    private ServiceTokenInfo buildObject(String tokenNo) {

        OldServiceTokenInfo oldServiceTokenInfo = OldServiceTokenInfo.findByServiceTokenNo(tokenNo)
        ServiceTokenInfo serviceTokenInfo=new ServiceTokenInfo()
        serviceTokenInfo.serviceTokenNo=oldServiceTokenInfo.serviceTokenNo
        serviceTokenInfo.regNo=oldServiceTokenInfo.regNo
        serviceTokenInfo.serviceDate=oldServiceTokenInfo.serviceDate
        serviceTokenInfo.createBy=oldServiceTokenInfo.createBy
        serviceTokenInfo.subsidyAmount=oldServiceTokenInfo.subsidyAmount
        serviceTokenInfo.visitTypeId=oldServiceTokenInfo.visitTypeId
        serviceTokenInfo.serviceProviderId=oldServiceTokenInfo.serviceProviderId
        serviceTokenInfo.prescriptionType=oldServiceTokenInfo.prescriptionType
        serviceTokenInfo.isFollowupNeeded=oldServiceTokenInfo.isFollowupNeeded
        serviceTokenInfo.modifyDate=oldServiceTokenInfo.createDate
        serviceTokenInfo.modifyBy=oldServiceTokenInfo.createBy
        serviceTokenInfo.referenceServiceTokenNo=oldServiceTokenInfo.referenceServiceTokenNo
        serviceTokenInfo.referralCenterId=oldServiceTokenInfo.referralCenterId
        serviceTokenInfo.isDeleted=false
        serviceTokenInfo.createDate=oldServiceTokenInfo.createDate

        return serviceTokenInfo
    }
    private OldServiceTokenInfo buildObjectOfOldService(Map params) {

        //OldServiceTokenInfo oldServiceTokenInfo=OldServiceTokenInfo.read(params.serviceTokenNo)
        //OldServiceTokenInfo oldServiceTokenInfox=OldServiceTokenInfo.findById(params.serviceTokenNo)
        OldServiceTokenInfo oldServiceTokenInfo=OldServiceTokenInfo.findByServiceTokenNo(params.serviceTokenNo)

        oldServiceTokenInfo.approveBy= springSecurityService.principal.id
        oldServiceTokenInfo.approveDate=DateUtility.getSqlDate(new Date())
        if(params.isApprove=='true') {
            oldServiceTokenInfo.isApproved = true
            oldServiceTokenInfo.isDecline=false
        }else{
            oldServiceTokenInfo.isApproved = false
            oldServiceTokenInfo.isDecline=true
        }

        return oldServiceTokenInfo
    }
}
