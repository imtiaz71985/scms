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
class CreateDiseaseInfoActionService extends BaseService implements ActionServiceIntf {

    SpringSecurityService springSecurityService
    private static final String SAVE_SUCCESS_MESSAGE = "Data saved successfully"
    private static final String ALREADY_EXIST = "Name & Group already exist"
    private static final String DISEASE_INFO = "diseaseInfo"
    private Logger log = Logger.getLogger(getClass())
    ServiceChargesService serviceChargesService

    @Transactional
    public Map executePreCondition(Map params){
        try {
            //Check parameters

            if (!params.diseaseCode||!params.diseaseGroupId||!params.name||!params.applicableTo) {
                return super.setError(params, INVALID_INPUT_MSG)
            }
            long diseaseGroupId = Long.parseLong(params.diseaseGroupId.toString())
            double chargeAmount=serviceChargesService.chargeInfoByDiseaseGroupId(diseaseGroupId)
            if(chargeAmount<=0 && !params.activationDate){
                return super.setError(params, 'Error for invalid activation date')
            }
            int duplicateCount = DiseaseInfo.countByNameIlikeAndDiseaseGroupId(params.name,params.diseaseGroupId)
            if (duplicateCount > 0) {
                return super.setError(params, ALREADY_EXIST)
            }
            DiseaseInfo diseaseInfo = buildObject(params)
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
                ServiceCharges serviceCharges = new ServiceCharges()
                serviceCharges.serviceCode = '02D' + diseaseInfo.diseaseCode
                serviceCharges.chargeAmount = Double.parseDouble(result.chargeAmount)
                serviceCharges.activationDate = DateUtility.getSqlDate(DateUtility.parseMaskedDate(result.activationDate))
                serviceCharges.createDate = DateUtility.getSqlDate(new Date())
                serviceCharges.createdBy = springSecurityService.principal.id
                serviceCharges.save()
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
        ListDiseaseInfoActionServiceModel model = ListDiseaseInfoActionServiceModel.read(diseaseInfo.diseaseCode)
        result.put(DISEASE_INFO, model)
        return super.setSuccess(result, SAVE_SUCCESS_MESSAGE)
    }

    public Map buildFailureResultForUI(Map result) {
        return result
    }

    /**
     * Build systemEntity object
     * @param parameterMap -serialized parameters from UI
     * @return -new systemEntity object
     */
    private DiseaseInfo buildObject(Map parameterMap) {
        parameterMap.applicableTo = Long.parseLong(parameterMap.applicableTo)
        DiseaseInfo diseaseInfo = new DiseaseInfo(parameterMap)
        diseaseInfo.createDate=DateUtility.getSqlDate(new Date())
        diseaseInfo.createdBy= springSecurityService.principal.id
        diseaseInfo.isActive=true
        return diseaseInfo
    }
}
