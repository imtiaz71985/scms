package actions.userDepartment

import com.model.ListUserDepartmentActionServiceModel
import com.scms.UserDepartment
import grails.transaction.Transactional
import org.apache.log4j.Logger
import scms.ActionServiceIntf
import scms.BaseService

@Transactional
class CreateUserDepartmentActionService extends BaseService implements ActionServiceIntf {

    private static final String SAVE_SUCCESS_MESSAGE = "Mapping has been saved successfully"
    private static final String USER_DEPARTMENT = "userDepartment"

    private Logger log = Logger.getLogger(getClass())

    /**
     * 1. input validation check
     * 2. duplicate check for role-name
     * @param params - receive role object from controller
     * @return - map.
     */
    @Transactional(readOnly = true)
    public Map executePreCondition(Map params) {
        try {
            //Check parameters
            if (!params.userId && !params.serviceId) {
                return super.setError(params, INVALID_INPUT_MSG)
            }
            UserDepartment userDepartment = buildObject(params)
            params.put(USER_DEPARTMENT, userDepartment)
            return params
        } catch (Exception ex) {
            log.error(ex.getMessage())
            throw new RuntimeException(ex)
        }
    }

    @Transactional
    public Map execute(Map result) {
        try {
            UserDepartment userDepartment = (UserDepartment) result.get(USER_DEPARTMENT)
            userDepartment.save()
            return result
        } catch (Exception ex) {
            log.error(ex.getMessage())
            throw new RuntimeException(ex)
        }
    }
    /**
     *
     * @param result - map received from execute method
     * @return - map
     */
    public Map executePostCondition(Map result) {
        return result
    }
    /**
     *
     * @param result - map received from executePost method
     * @return - map containing success message
     */
    public Map buildSuccessResultForUI(Map result) {
        UserDepartment userDepartment = (UserDepartment) result.get(USER_DEPARTMENT)
        ListUserDepartmentActionServiceModel model = ListUserDepartmentActionServiceModel.read(userDepartment.id)
        result.put(USER_DEPARTMENT, model)
        return super.setSuccess(result, SAVE_SUCCESS_MESSAGE)
    }
    /**
     *
     * @param result - map received from previous method
     * @return - map
     */
    public Map buildFailureResultForUI(Map result) {
        return result
    }

    private UserDepartment buildObject(Map parameterMap) {
        UserDepartment userDepartment = new UserDepartment(parameterMap)
        userDepartment.userId = Long.parseLong(parameterMap.userId)
        userDepartment.serviceId = Long.parseLong(parameterMap.serviceId)
        return userDepartment
    }
}
