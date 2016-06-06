package actions.systemEntity

import com.scms.SystemEntity
import grails.transaction.Transactional
import org.apache.log4j.Logger
import scms.ActionServiceIntf
import scms.BaseService
import service.SystemEntityService

@Transactional
class DeleteSystemEntityActionService extends BaseService implements ActionServiceIntf {

    private Logger log = Logger.getLogger(getClass())

    private static final String DELETE_SUCCESS_MESSAGE = "Record has been deleted successfully"
    private static final String NOT_FOUND = "Selected record does not exits"
    private static final String SYSTEM_ENTITY = "systemEntity"

    SystemEntityService systemEntityService

    @Transactional(readOnly = true)
    public Map executePreCondition(Map params) {
        long id = Long.parseLong(params.id)
        SystemEntity systemEntity = systemEntityService.read(id)
        if(!systemEntity){
            return super.setError(params, NOT_FOUND)
        }
        params.put(SYSTEM_ENTITY, systemEntity)
        return params
    }

    @Transactional
    public Map execute(Map result) {
        try {
            SystemEntity systemEntity = (SystemEntity) result.get(SYSTEM_ENTITY)
            systemEntity.delete()
            return result
        } catch (Exception ex) {
            log.error(ex.getMessage())
            throw new RuntimeException(ex)
        }
    }

    /**
     * There is no postCondition, so return the same map as received
     *
     * @param result - resulting map from execute
     * @return - same map of input-parameter containing isError(true/false)
     */
    public Map executePostCondition(Map result) {
        return result
    }

    /**
     * 1. put success message
     *
     * @param result - map from execute/executePost method
     * @return - same map of input-parameter containing isError(true/false)
     */
    public Map buildSuccessResultForUI(Map result) {
        return super.setSuccess(result, DELETE_SUCCESS_MESSAGE)
    }

    /**
     * The input-parameter Map must have "isError:true" with corresponding message
     *
     * @param result - map returned from previous methods
     * @return - same map of input-parameter containing isError(true/false)
     */
    public Map buildFailureResultForUI(Map result) {
        return result
    }
}
