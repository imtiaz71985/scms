package actions.DiseaseGroup

import com.model.ListDiseaseGroupActionServiceModel
import com.model.ListServiceTypeActionServiceModel
import com.scms.DiseaseGroup
import grails.transaction.Transactional
import org.apache.log4j.Logger
import scms.ActionServiceIntf
import scms.BaseService

@Transactional
class UpdateDiseaseGroupActionService extends BaseService implements ActionServiceIntf {

    private static final String UPDATE_SUCCESS_MESSAGE = "Service Type has been updated successfully"
    private static final String ROLE_ALREADY_EXIST = "Same Type already exist"
    private static final String DISEASE_GROUP = "diseaseGroup"


    private Logger log = Logger.getLogger(getClass())

    public Map executePreCondition(Map params) {
        try {
            if ((!params.id) || (!params.name)) {
                return super.setError(params, INVALID_INPUT_MSG)
            }
            long id = Long.parseLong(params.id.toString())
            DiseaseGroup oldDiseaseGroup = (DiseaseGroup) DiseaseGroup.read(id)
            String name = params.name.toString()
            int duplicateCount = DiseaseGroup.countByNameIlikeAndIdNotEqual(name, id)
            if (duplicateCount > 0) {
                return super.setError(params, ROLE_ALREADY_EXIST)
            }
            DiseaseGroup diseaseGroup = buildObject(params, oldDiseaseGroup)
            params.put(DISEASE_GROUP, diseaseGroup)
            return params
        } catch (Exception ex) {
            log.error(ex.getMessage())
            throw new RuntimeException(ex)
        }
    }

    @Transactional
    public Map execute(Map result) {
        try {
            DiseaseGroup diseaseGroup = (DiseaseGroup) result.get(DISEASE_GROUP)
            diseaseGroup.save()
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
        DiseaseGroup diseaseGroup = (DiseaseGroup) result.get(DISEASE_GROUP)
        ListDiseaseGroupActionServiceModel model = ListDiseaseGroupActionServiceModel.read(diseaseGroup.id)
        result.put(DISEASE_GROUP, model)
        return super.setSuccess(result, UPDATE_SUCCESS_MESSAGE)
    }

    public Map buildFailureResultForUI(Map params) {
        return params
    }

    private static DiseaseGroup buildObject(Map parameterMap, DiseaseGroup oldDiseaseGroup) {
        DiseaseGroup diseaseGroup = new DiseaseGroup(parameterMap)
        oldDiseaseGroup.name = diseaseGroup.name
        oldDiseaseGroup.description = diseaseGroup.description
        oldDiseaseGroup.isActive = diseaseGroup.isActive
        return oldDiseaseGroup
    }
}
