package actions.ServiceTokenInfo

import com.scms.DiseaseInfo
import com.scms.RegistrationInfo
import com.scms.ServiceCharges
import com.scms.ServiceTokenInfo
import com.scms.TokenAndChargeMapping
import com.scms.TokenAndDiseaseMapping
import grails.plugin.springsecurity.SpringSecurityService
import grails.transaction.Transactional
import org.apache.log4j.Logger
import scms.ActionServiceIntf
import scms.BaseService
import scms.utility.DateUtility
import service.RegistrationInfoService
import service.ServiceHeadInfoService
import service.ServiceTokenRelatedInfoService

class CreateServiceTokenInfoActionService extends BaseService implements ActionServiceIntf {

    SpringSecurityService springSecurityService
    private static final String SAVE_SUCCESS_MESSAGE = "Data saved successfully"
    private static final String SERVICE_TOKEN_INFO = "serviceTokenInfo"
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
            if (!params.serviceTypeId && !params.chkboxPathology && !params.chkboxDocReferral) {
                return super.setError(params, 'Please select service type or pathology test or doctor referral.')
            }
            if (params.chkboxDocReferral) {
                if (!params.referralCenterId || !params.serviceProviderId)
                    return super.setError(params, 'Sorry! Please select referral center and service provider.')
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
                if (!params.serviceProviderId) {
                    return super.setError(params, 'Sorry! Please select service provider.')
                }
                if(params.chkboxPathology ) {
                    String len = params.selectedChargeId
                    if (len.length() < 1) {
                        return super.setError(params, 'Sorry! Please select at least one pathology test.')
                    }
                }
            }

            ServiceTokenInfo serviceTokenInfo = buildObject(params, serviceTypeId)
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
            if (serviceTokenInfo.referenceServiceTokenNo) {
                ServiceTokenInfo serviceTokenInfoForRef = ServiceTokenInfo.findByServiceTokenNo(serviceTokenInfo.referenceServiceTokenNo)
                serviceTokenInfoForRef.isFollowupNeeded = false
                serviceTokenInfoForRef.save()
            }
            if (result.diseaseCode) {
                TokenAndDiseaseMapping tokenAndDiseaseMapping = new TokenAndDiseaseMapping()
                tokenAndDiseaseMapping.serviceDate = serviceTokenInfo.serviceDate
                tokenAndDiseaseMapping.serviceTokenNo = serviceTokenInfo.serviceTokenNo
                tokenAndDiseaseMapping.diseaseCode = result.diseaseCode
                tokenAndDiseaseMapping.save()
            }

            String str = result.selectedChargeId
            String chargeIds = result.selectedConsultancyId
            if (chargeIds.length() > 1)
                str = str + ',' + chargeIds
            if (str.length() > 1) {
                List<String> lst = Arrays.asList(str.split("\\s*,\\s*"));
                for (int i = 0; i < lst.size(); i++) {
                    TokenAndChargeMapping tokenAndChargeMapping = new TokenAndChargeMapping()
                    tokenAndChargeMapping.serviceDate = serviceTokenInfo.serviceDate
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
        String msg = registrationInfoService.patientServed(DateUtility.getSqlDate(DateUtility.parseDateForDB(result.serviceDate)))
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
    private ServiceTokenInfo buildObject(Map parameterMap, long serviceTypeId) {

        ServiceTokenInfo serviceTokenInfo = new ServiceTokenInfo()
        serviceTokenInfo.serviceTokenNo = parameterMap.serviceTokenNo
        serviceTokenInfo.regNo = parameterMap.regNo
        if (parameterMap.serviceProviderId) {
            serviceTokenInfo.serviceProviderId = Long.parseLong(parameterMap.serviceProviderId)
        } else {
            serviceTokenInfo.serviceProviderId = 0 // When give counselor service
        }
        Date serviceDate = DateUtility.parseDateForDB(parameterMap.serviceDate)
        serviceTokenInfo.serviceDate = DateUtility.getSqlDate(serviceDate)
        serviceTokenInfo.createDate = DateUtility.getSqlDate(new Date())
        serviceTokenInfo.createBy = springSecurityService.principal.id
        if (serviceTypeId == 5) {
            serviceTokenInfo.visitTypeId = 3L // Follow-Up patient
            serviceTokenInfo.referenceServiceTokenNo = parameterMap.referenceServiceNoDDL
        } else {
            int count = ServiceTokenInfo.countByRegNo(parameterMap.regNo)
            if (count > 0) {
                serviceTokenInfo.visitTypeId = 2L // re-visit
            } else {
                int oldCount = RegistrationInfo.countByRegNoAndIsOldPatient(parameterMap.regNo, true)
                if (oldCount > 0)
                    serviceTokenInfo.visitTypeId = 2L // re-visit patient
                else
                    serviceTokenInfo.visitTypeId = 1L  // new patient
            }
        }

        if (!parameterMap.subsidyAmount) {
            serviceTokenInfo.subsidyAmount = 0d
        } else {
            serviceTokenInfo.subsidyAmount = Double.parseDouble(parameterMap.subsidyAmount)
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
            serviceTokenInfo.referralCenterId = Long.parseLong(parameterMap.referralCenterId)

        serviceTokenInfo.isFollowupNeeded = false
        if (parameterMap.chkboxFollowupNeeded)
            serviceTokenInfo.isFollowupNeeded = true

        serviceTokenInfo.prescriptionType = prescription
        serviceTokenInfo.modifyDate = DateUtility.getSqlDate(new Date())
        serviceTokenInfo.modifyBy = springSecurityService.principal.id

        return serviceTokenInfo
    }
}
