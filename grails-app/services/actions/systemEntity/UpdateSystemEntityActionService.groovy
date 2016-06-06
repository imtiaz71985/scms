package actions.systemEntity

import com.model.ListSystemEntityActionServiceModel
import com.scms.SystemEntity
import grails.transaction.Transactional
import org.apache.log4j.Logger
import scms.ActionServiceIntf
import scms.BaseService
import service.SystemEntityService

@Transactional
class UpdateSystemEntityActionService extends BaseService implements ActionServiceIntf {

    private static final String UPDATE_SUCCESS_MESSAGE = "Data has been updated successfully"
    private static final String ALREADY_EXIST = "Name already exist for this type"
    private static final String SYSTEM_ENTITY = "systemEntity"

    SystemEntityService systemEntityService

    private Logger log = Logger.getLogger(getClass())

    public Map executePreCondition(Map params) {
        try {
            if ((!params.id) || (!params.name)|| (!params.type)) {
                return super.setError(params, INVALID_INPUT_MSG)
            }
            long id = Long.parseLong(params.id.toString())
            SystemEntity oldSystemEntity = (SystemEntity) systemEntityService.read(id)
            String name = params.name.toString()
            int duplicateCount = systemEntityService.countByNameIlikeAndTypeAndIdNotEqual(name,params.type, id)
            if (duplicateCount > 0) {
                return super.setError(params, ALREADY_EXIST)
            }
            SystemEntity systemEntity = buildObject(params, oldSystemEntity)
            params.put(SYSTEM_ENTITY, systemEntity)
            return params
        } catch (Exception ex) {
            log.error(ex.getMessage())
            throw new RuntimeException(ex)
        }
    }

    @Transactional
    public Map execute(Map result) {
        try {
            SystemEntity systemEntity = (SystemEntity) result.get(SYSTEM_ENTITY)
            systemEntity.save()
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
        SystemEntity systemEntity = (SystemEntity) result.get(SYSTEM_ENTITY)
        ListSystemEntityActionServiceModel model = ListSystemEntityActionServiceModel.read(systemEntity.id)
        result.put(SYSTEM_ENTITY, model)
        return super.setSuccess(result, UPDATE_SUCCESS_MESSAGE)
    }

    public Map buildFailureResultForUI(Map params) {
        return params
    }

    private static SystemEntity buildObject(Map parameterMap, SystemEntity oldSystemEntity) {
        SystemEntity systemEntity = new SystemEntity(parameterMap)
        oldSystemEntity.name = systemEntity.name
        oldSystemEntity.description = systemEntity.description
        oldSystemEntity.type = systemEntity.type
        return oldSystemEntity
    }
}
