package actions.systemEntity

import com.model.ListSystemEntityActionServiceModel
import com.scms.SystemEntity
import grails.transaction.Transactional
import org.apache.log4j.Logger
import scms.ActionServiceIntf
import scms.BaseService
import service.SystemEntityService

@Transactional
class CreateSystemEntityActionService extends BaseService implements ActionServiceIntf {
    private static final String SAVE_SUCCESS_MESSAGE = "Data saved successfully"
    private static final String ALREADY_EXIST = "Name & type already exist"
    private static final String SYSTEM_ENTITY = "systemEntity"
    private Logger log = Logger.getLogger(getClass())

    SystemEntityService systemEntityService

    @Transactional(readOnly = true)
    public Map executePreCondition(Map params){
       try {
            //Check parameters
           if (!params.type||!params.name) {
               return super.setError(params, INVALID_INPUT_MSG)
           }
            int duplicateCount = systemEntityService.countByNameIlikeAndType(params.name,params.type)
            if (duplicateCount > 0) {
                return super.setError(params, ALREADY_EXIST)
            }
            SystemEntity systemEntity = buildObject(params)
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
        return super.setSuccess(result, SAVE_SUCCESS_MESSAGE)
    }

    public Map buildFailureResultForUI(Map result) {
        return result
    }

    /**
     * Build systemEntity object
     * @param parameterMap -serialized parameters from UI
     * @return -new systemEntity object
 /*    */
    private SystemEntity buildObject(Map parameterMap) {
        SystemEntity systemEntity = new SystemEntity(parameterMap)
        return systemEntity
    }
}
