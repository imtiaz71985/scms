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
class UpdateDiseaseInfoActionService extends BaseService implements ActionServiceIntf {

    SpringSecurityService springSecurityService
    private static final String UPDATE_SUCCESS_MESSAGE = "Data has been updated successfully"
    private static final String DISEASE_INFO = "diseaseInfo"


    private Logger log = Logger.getLogger(getClass())

    public Map executePreCondition(Map params) {
        try {

            if (!params.diseaseCode || !params.name) {
                return super.setError(params, INVALID_INPUT_MSG)
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
