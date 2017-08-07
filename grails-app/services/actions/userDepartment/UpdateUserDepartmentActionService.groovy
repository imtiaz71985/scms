package actions.userDepartment

import com.scms.SecRole
import grails.transaction.Transactional
import org.apache.log4j.Logger
import scms.ActionServiceIntf
import scms.BaseService
import service.FeatureManagementService
import service.SecRoleService

@Transactional
class UpdateUserDepartmentActionService extends BaseService implements ActionServiceIntf {

    private Logger log = Logger.getLogger(getClass())

    private static final String DELETE_SUCCESS_MESSAGE = "Role has been deleted successfully"
    private static final String NOT_FOUND = "Selected role does not exits"
    private static final String RELATED_USER_FOUND = " user(s) associated with this role"
    private static final String RELATED_FEATURE_FOUND = "Different features associated with this role"
    private static final String SEC_ROLE = "role"


    SecRoleService secRoleService
    FeatureManagementService featureManagementService

    @Transactional(readOnly = true)
    public Map executePreCondition(Map params) {
        long userId = Long.parseLong(params.id)
        SecRole role = secRoleService.read(userId)
        if(!role){
            return super.setError(params, NOT_FOUND)
        }
        boolean isMapped = featureManagementService.isRoleAssociatedWithRequestmap(role.authority)
        if(isMapped){
            return super.setError(params, RELATED_FEATURE_FOUND)
        }
        params.put(SEC_ROLE, role)
        return params
    }

    @Transactional
    public Map execute(Map result) {
        try {
            SecRole role = (SecRole) result.get(SEC_ROLE)
            featureManagementService.removeRoleFromRoot(role.authority)
            secRoleService.delete(role)
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
