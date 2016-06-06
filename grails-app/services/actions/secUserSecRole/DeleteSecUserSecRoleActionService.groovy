package actions.secUserSecRole

import com.scms.SecRole
import com.scms.SecUser
import com.scms.SecUserSecRole
import grails.transaction.Transactional
import org.apache.log4j.Logger
import scms.ActionServiceIntf
import scms.BaseService
import service.SecRoleService
import service.SecUserSecRoleService
import service.SecUserService

@Transactional
class DeleteSecUserSecRoleActionService extends BaseService implements ActionServiceIntf {

    private Logger log = Logger.getLogger(getClass())

    private static final String DELETE_SUCCESS_MESSAGE = "User has been deleted successfully"
    private static final String NOT_FOUND = "Selected user does not exits"
    private static final String USER_ROLE = "userRole"


    SecUserService secUserService
    SecRoleService secRoleService
    SecUserSecRoleService secUserSecRoleService

    @Transactional(readOnly = true)
    public Map executePreCondition(Map params) {
        if(!params.userId || !params.roleId){
            return super.setError(params, INVALID_INPUT_MSG)
        }
        long userId = Long.parseLong(params.userId.toString())
        long roleId = Long.parseLong(params.roleId.toString())
        SecUser user = secUserService.read(userId)
        SecRole role = secRoleService.read(roleId)
        SecUserSecRole userSecRole = secUserSecRoleService.findBySecRoleAndSecUser(user, role)
        if(!userSecRole){
            super.setError(params, NOT_FOUND)
        }
        params.put(USER_ROLE, userSecRole)
        return params
    }

    @Transactional
    public Map execute(Map result) {
        try {
            SecUserSecRole userSecRole = (SecUserSecRole) result.get(USER_ROLE)
            secUserSecRoleService.delete(userSecRole)
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
