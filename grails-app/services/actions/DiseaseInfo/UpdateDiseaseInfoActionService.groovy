package actions.DiseaseInfo

import com.model.ListDiseaseInfoActionServiceModel
import com.scms.DiseaseInfo
import com.scms.ServiceCharges
import com.scms.SystemEntity
import grails.plugin.springsecurity.SpringSecurityService
import grails.transaction.Transactional
import groovy.sql.GroovyRowResult
import org.apache.log4j.Logger
import scms.ActionServiceIntf
import scms.BaseService
import scms.utility.DateUtility
import service.ServiceChargesService

@Transactional
class UpdateDiseaseInfoActionService extends BaseService implements ActionServiceIntf {

    SpringSecurityService springSecurityService
    private static final String UPDATE_SUCCESS_MESSAGE = "Data has been updated successfully"
    private static final String DISEASE_INFO = "diseaseInfo"
    ServiceChargesService serviceChargesService

    private Logger log = Logger.getLogger(getClass())

    public Map executePreCondition(Map params) {
        try {

            if (!params.diseaseCode || !params.name) {
                return super.setError(params, INVALID_INPUT_MSG)
            }
            long diseaseGroupId = Long.parseLong(params.diseaseGroupId.toString())
            double chargeAmount=serviceChargesService.chargeInfoByDiseaseGroupId(diseaseGroupId)
            if(chargeAmount<=0 && !params.activationDate){
                return super.setError(params, 'Error for invalid activation date')
            }
            DiseaseInfo oldDiseaseInfo = DiseaseInfo.findByDiseaseCode(params.diseaseCode.toString())

            DiseaseInfo diseaseInfo = buildObject(params, oldDiseaseInfo)
            params.put(DISEASE_INFO, diseaseInfo)
            return params
        } catch (Exception ex) {
            log.error(ex.getMessage())
            throw new RuntimeException(ex)
        }
    }

    @Transactional
    public Map execute(Map result) {
        try {
            DiseaseInfo diseaseInfo = (DiseaseInfo) result.get(DISEASE_INFO)
            diseaseInfo.save()

            double chargeAmount=serviceChargesService.chargeInfoByDiseaseGroupId(diseaseInfo.diseaseGroupId)
            if(chargeAmount<=0) {

                String groupCode = '02D' + diseaseInfo.diseaseCode
                ServiceCharges serviceCharges = ServiceCharges.findByServiceCodeAndLastActiveDate(groupCode, null)

                Date d = DateUtility.parseMaskedDate(result.activationDate)
                d = d.minus(1)
                boolean newEntry = true
                if (serviceCharges != null) {

                    if (serviceCharges.activationDate > DateUtility.getSqlFromDateWithSeconds(new Date())) {
                        serviceCharges.chargeAmount = Double.parseDouble(result.chargeAmount)
                        serviceCharges.activationDate = DateUtility.getSqlDate(DateUtility.parseMaskedDate(result.activationDate))
                        serviceCharges.createDate = DateUtility.getSqlDate(new Date())
                        serviceCharges.createdBy = springSecurityService.principal.id
                        newEntry = false
                    } else {
                        serviceCharges.lastActiveDate = DateUtility.getSqlDate(d)
                    }
                    serviceCharges.save()
                    if (!newEntry) {
                        ServiceCharges serviceCharges3 = ServiceCharges.findByServiceCodeAndLastActiveDateIsNotNull(groupCode, [sort: 'id', order: 'desc', limit: 1])
                        if (serviceCharges3 != null) {
                            serviceCharges3.lastActiveDate = DateUtility.getSqlDate(d)
                            serviceCharges3.save();
                        }
                    }
                }

                if (diseaseInfo.isActive && newEntry) {
                    ServiceCharges serviceCharges2 = new ServiceCharges()
                    serviceCharges2.serviceCode = groupCode
                    serviceCharges2.chargeAmount = Double.parseDouble(result.chargeAmount)
                    serviceCharges2.activationDate = DateUtility.getSqlDate(DateUtility.parseMaskedDate(result.activationDate))
                    serviceCharges2.createDate = DateUtility.getSqlDate(new Date())
                    serviceCharges2.createdBy = springSecurityService.principal.id
                    serviceCharges2.save()
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
        DiseaseInfo diseaseInfo = (DiseaseInfo) result.get(DISEASE_INFO)
        ListDiseaseInfoActionServiceModel model = ListDiseaseInfoActionServiceModel.findByDiseaseCode(diseaseInfo.diseaseCode)
        result.put(DISEASE_INFO, model)
        return super.setSuccess(result, UPDATE_SUCCESS_MESSAGE)
    }

    public Map buildFailureResultForUI(Map params) {
        return params
    }

    private DiseaseInfo buildObject(Map parameterMap, DiseaseInfo oldDiseaseInfo) {

        DiseaseInfo diseaseInfo = new DiseaseInfo(parameterMap)
        oldDiseaseInfo.isActive = diseaseInfo.isActive
        oldDiseaseInfo.name = diseaseInfo.name
        oldDiseaseInfo.description=diseaseInfo.description
        oldDiseaseInfo.modifyDate = DateUtility.getSqlDate(new Date())
        oldDiseaseInfo.modifyBy = springSecurityService.principal.id
        oldDiseaseInfo.applicableTo = Long.parseLong(parameterMap.applicableTo)

        return oldDiseaseInfo
    }
}
