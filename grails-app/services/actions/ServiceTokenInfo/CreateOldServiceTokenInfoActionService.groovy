package actions.ServiceTokenInfo

import com.scms.OldTokenAndChargeMapping
import com.scms.RegistrationInfo
import com.scms.OldServiceTokenInfo
import com.scms.OldTokenAndDiseaseMapping
import com.scms.ServiceTokenInfo
import grails.plugin.springsecurity.SpringSecurityService
import grails.transaction.Transactional
import org.apache.log4j.Logger
import scms.ActionServiceIntf
import scms.BaseService
import scms.utility.DateUtility
import service.RegistrationInfoService
import service.ServiceHeadInfoService
import service.ServiceTokenRelatedInfoService

class CreateOldServiceTokenInfoActionService extends BaseService implements ActionServiceIntf {

    SpringSecurityService springSecurityService
    private static final String SAVE_SUCCESS_MESSAGE = "Data saved successfully"
    private static final String OLD_SERVICE_TOKEN_INFO = "oldServiceTokenInfo"
    private Logger log = Logger.getLogger(getClass())

    ServiceHeadInfoService serviceHeadInfoService
    RegistrationInfoService registrationInfoService
    ServiceTokenRelatedInfoService serviceTokenRelatedInfoService

    @Transactional
    public Map executePreCondition(Map params) {
        try {
            if (params.referenceServiceNoDDL) {
                params.serviceTypeId = 5L
            }
            //Check parameters
            if (!params.serviceTokenNo || !params.regNo) {
                return super.setError(params, INVALID_INPUT_MSG)
            }
            if (!params.serviceTypeId && !params.chkboxPathology) {
                return super.setError(params, INVALID_INPUT_MSG)
            }
            if (params.chkboxDocReferral) {
                if (!params.referralCenterId)
                    return super.setError(params, 'Sorry! Please select referral center.')
                if (!params.serviceTypeId)
                    return super.setError(params, 'Sorry! Please select service type.')
            }
            long serviceTypeId = 0L
            if (params.serviceTypeId) {
                if (params.referenceServiceNoDDL) {
                    serviceTypeId = 5L
                } else {
                    serviceTypeId = Long.parseLong(params.serviceTypeId)
                }
                if (serviceTypeId != 4 && !params.serviceProviderId) {
                    return super.setError(params, 'Sorry! Please select service provider.')
                }
                if (serviceTypeId == 5) {
                    if (params.referenceServiceNoDDL == 'Please Select...') {
                        return super.setError(params, 'Sorry! Please select reference token no.')
                    }
                    String diseaseCodes = params.diseaseCode
                    if (diseaseCodes == 'Please Select...') {
                        return super.setError(params, 'Sorry! Please select at least one disease.')
                    }
                } else if (serviceTypeId == 4) {
                    String len = params.selectedChargeId
                    if (len.length() < 1) {
                        return super.setError(params, 'Sorry! Please select at least one pathology test.')
                    }
                } else {
                    String diseaseCodes = params.diseaseCode
                    String chargeId = params.selectedConsultancyId
                    if (diseaseCodes == 'Please Select...') {
                        return super.setError(params, 'Sorry! Please select at least one disease.')
                    } else if (chargeId.length() < 1) {
                        return super.setError(params, 'Sorry! Please select taken service.')
                    } else {
                        RegistrationInfo registrationInfo = RegistrationInfo.findByRegNo(params.regNo)
                        boolean isNotApplicable = serviceTokenRelatedInfoService.getDiseaseApplicableFor(diseaseCodes, registrationInfo.sexId)
                        if (isNotApplicable)
                            return super.setError(params, 'Sorry! This disease could not applied for this patient.')
                    }
                }
            } else {
                String len = params.selectedChargeId
                if (len.length() < 1) {
                    return super.setError(params, 'Sorry! Please select at least one pathology test.')
                }
            }

            if(!params.txtRemarks){
                String remarks=params.txtRemarks
                if(remarks.length()<3){
                    return super.setError(params, 'Sorry! Please give remarks.')
                }
            }

            OldServiceTokenInfo oldServiceTokenInfo = buildObject(params, serviceTypeId)
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
            
            if (result.diseaseCode) {
                OldTokenAndDiseaseMapping oldTokenAndDiseaseMapping = new OldTokenAndDiseaseMapping()
                oldTokenAndDiseaseMapping.serviceTokenNo = oldServiceTokenInfo.serviceTokenNo
                oldTokenAndDiseaseMapping.diseaseCode = result.diseaseCode
                oldTokenAndDiseaseMapping.save()
            }

            String str = result.selectedChargeId
            String chargeIds = result.selectedConsultancyId
            if (chargeIds.length() > 1)
                str = str + ',' + chargeIds
            if (str.length() > 1) {
                List<String> lst = Arrays.asList(str.split("\\s*,\\s*"));
                for (int i = 0; i < lst.size(); i++) {
                    OldTokenAndChargeMapping oldTokenAndChargeMapping = new OldTokenAndChargeMapping()
                    oldTokenAndChargeMapping.serviceTokenNo = oldServiceTokenInfo.serviceTokenNo
                    try {
                        if (lst.get(i) != '') {
                            oldTokenAndChargeMapping.serviceChargeId = Long.parseLong(lst.get(i))
                            oldTokenAndChargeMapping.save()
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
        String msg = registrationInfoService.patientServed()
        result.put('patientServed', msg)
        return super.setSuccess(result, '<div style="font-size: 16px">Data Saved successfully. Token No: <b>' + result.serviceTokenNo + '</b></div>')
    }

    public Map buildFailureResultForUI(Map result) {
        return result
    }

    /**
     * Build systemEntity object
     * @param parameterMap -serialized parameters from UI
     * @return -new systemEntity object
     /*        */
    private OldServiceTokenInfo buildObject(Map parameterMap, long serviceTypeId) {

        OldServiceTokenInfo oldServiceTokenInfo = new OldServiceTokenInfo()
        oldServiceTokenInfo.serviceTokenNo = parameterMap.serviceTokenNo
        oldServiceTokenInfo.regNo = parameterMap.regNo
        if (parameterMap.serviceProviderId) {
            oldServiceTokenInfo.serviceProviderId = Long.parseLong(parameterMap.serviceProviderId)
        } else {
            oldServiceTokenInfo.serviceProviderId = 0 // When give counselor service
        }
        Date serviceDate = DateUtility.parseDateForDB(parameterMap.serviceDate)
        oldServiceTokenInfo.serviceDate = DateUtility.getSqlDate(serviceDate)
        oldServiceTokenInfo.createDate = DateUtility.getSqlDate(new Date())
        oldServiceTokenInfo.createBy = springSecurityService.principal.id
        if (serviceTypeId == 5) {
            oldServiceTokenInfo.visitTypeId = 3L // Follow-Up patient
            oldServiceTokenInfo.referenceServiceTokenNo = parameterMap.referenceServiceNoDDL
        } else {
            int count = ServiceTokenInfo.countByRegNo(parameterMap.regNo)
            if (count > 0) {
                oldServiceTokenInfo.visitTypeId = 2L // re-visit
            } else {
                int oldCount = RegistrationInfo.countByRegNoAndIsOldPatient(parameterMap.regNo, true)
                if (oldCount > 0)
                    oldServiceTokenInfo.visitTypeId = 2L // re-visit patient
                else
                    oldServiceTokenInfo.visitTypeId = 1L  // new patient
            }
        }

        if (!parameterMap.subsidyAmount) {
            oldServiceTokenInfo.subsidyAmount = 0d
        } else {
            oldServiceTokenInfo.subsidyAmount = Double.parseDouble(parameterMap.subsidyAmount)
        }
        String prescription = ''

        if (parameterMap.chkboxMedicine && parameterMap.chkboxPathology && parameterMap.chkboxDocReferral)
            prescription = 'Medicine & Pathology Test & Doctors Referral'
        else if (parameterMap.chkboxMedicine && parameterMap.chkboxPathology)
            prescription = 'Medicine & Pathology Test'
        else if (parameterMap.chkboxMedicine && parameterMap.chkboxDocReferral)
            prescription = 'Medicine & Doctors Referral'
        else if (parameterMap.chkboxPathology && parameterMap.chkboxDocReferral)
            prescription = 'Pathology Test & Doctors Referral'
        else
            prescription = (parameterMap.chkboxMedicine ? 'Medicine' : parameterMap.chkboxPathology ? 'Pathology Test' : parameterMap.chkboxDocReferral ? 'Doctors Referral' : '')

        if (parameterMap.chkboxDocReferral)
            oldServiceTokenInfo.referralCenterId = Long.parseLong(parameterMap.referralCenterId)

        oldServiceTokenInfo.isFollowupNeeded = false
        if (parameterMap.chkboxFollowupNeeded)
            oldServiceTokenInfo.isFollowupNeeded = true

        oldServiceTokenInfo.prescriptionType = prescription
        oldServiceTokenInfo.remarks=parameterMap.txtRemarks

        return oldServiceTokenInfo
    }
}
