package actions.DiseaseInfo

import com.model.ListDiseaseInfoActionServiceModel
import com.scms.DiseaseInfo
import com.scms.SystemEntity
import grails.plugin.springsecurity.SpringSecurityService
import grails.transaction.Transactional
import org.apache.log4j.Logger
import scms.ActionServiceIntf
import scms.BaseService
import scms.utility.DateUtility

@Transactional
class CreateDiseaseInfoActionService extends BaseService implements ActionServiceIntf {

    SpringSecurityService springSecurityService
    private static final String SAVE_SUCCESS_MESSAGE = "Data saved successfully"
    private static final String ALREADY_EXIST = "Name & Group already exist"
    private static final String DISEASE_INFO = "diseaseInfo"
    private Logger log = Logger.getLogger(getClass())

    @Transactional
    public Map executePreCondition(Map params){
        try {
            //Check parameters

            if (!params.diseaseCode||!params.diseaseGroupId||!params.name) {
                return super.setError(params, INVALID_INPUT_MSG)
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
        long applicableTo = SystemEntity.findByNameLikeAndType(parameterMap.applicableTo, "Disease Applicable To").id
        parameterMap.applicableTo = applicableTo
        DiseaseInfo diseaseInfo = new DiseaseInfo(parameterMap)
        diseaseInfo.createDate=DateUtility.getSqlDate(new Date())
        diseaseInfo.createdBy= springSecurityService.principal.id
        diseaseInfo.isActive=true
        return diseaseInfo
    }
}
