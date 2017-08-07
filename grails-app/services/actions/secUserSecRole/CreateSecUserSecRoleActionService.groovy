package actions.secUserSecRole

import com.model.ListSecUserSecRoleActionServiceModel
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
class CreateSecUserSecRoleActionService extends BaseService implements ActionServiceIntf {

    private Logger log = Logger.getLogger(getClass())

    SecUserService secUserService
    SecRoleService secRoleService
    SecUserSecRoleService secUserSecRoleService

    private static final String SAVE_SUCCESS_MESSAGE = "User has been added successfully"
    private static final String USER_ROLE = "userRole"


    /**
     * No pre conditions required for searching project domains
     *
     * @param params - Request parameters
     * @return - same map of input-parameter containing isError(true/false)
     */
    public Map executePreCondition(Map params) {
        try {
            //Check parameters
            if (!params.userId || !params.roleId) {
                return super.setError(params, INVALID_INPUT_MSG)
            }
            SecUserSecRole userRole = buildObject(params)
            params.put(USER_ROLE, userRole)
            return params
        } catch (Exception ex) {
            log.error(ex.getMessage())
            throw new RuntimeException(ex)
        }
    }

    /**
     * 1. initialize params for pagination of list
     *
     * 2. pull all appUser list from database (if no criteria)
     *
     * 3. pull filtered result from database (if given criteria)
     *
     * @param result - parameter from pre-condition
     * @return - same map of input-parameter containing isError(true/false)
     */
    @Transactional
    public Map execute(Map result) {
        try {
            SecUserSecRole userRole = (SecUserSecRole) result.get(USER_ROLE)
            secUserSecRoleService.create(userRole)
            return result
        } catch (Exception e) {
            log.error(e.getMessage())
            throw new RuntimeException(e)
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
     * Since there is no success message return the same map
     * @param result -map from execute/executePost method
     * @return - same map of input-parameter containing isError(true/false)
     */
    public Map buildSuccessResultForUI(Map result) {
        SecUserSecRole userSecRole = (SecUserSecRole) result.get(USER_ROLE)
        ListSecUserSecRoleActionServiceModel model = ListSecUserSecRoleActionServiceModel.findByRoleIdAndUserId(userSecRole.secRole.id, userSecRole.secUser.id)
        result.put(USER_ROLE, model)
        return super.setSuccess(result, SAVE_SUCCESS_MESSAGE)
    }

    /**
     * The input-parameter Map must have "isError:true" with corresponding message
     * @param result -map returned from previous methods
     * @return - same map of input-parameter containing isError(true/false)
     */
    public Map buildFailureResultForUI(Map result) {
        return result
    }

    private SecUserSecRole buildObject(Map parameterMap) {
        SecUserSecRole userRole = new SecUserSecRole(parameterMap)
        long userId = Long.parseLong(parameterMap.userId.toString())
        long roleId = Long.parseLong(parameterMap.roleId.toString())
        SecUser user = secUserService.read(userId)
        SecRole role = secRoleService.read(roleId)
        userRole.secUser = user
        userRole.secRole = role
        userRole.appsId = 3L
        return userRole
    }
}
