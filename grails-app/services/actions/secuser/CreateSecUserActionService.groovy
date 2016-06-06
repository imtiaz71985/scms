package actions.secuser

import com.scms.SecUser
import grails.plugin.springsecurity.SpringSecurityService
import grails.transaction.Transactional
import org.apache.log4j.Logger
import scms.ActionServiceIntf
import scms.BaseService
import service.SecUserService

class CreateSecUserActionService extends BaseService implements ActionServiceIntf {

    private static final String SAVE_SUCCESS_MESSAGE = "User has been saved successfully"
    private static final String ALREADY_EXIST = "Same User name already exist"
    private static final String SEC_USER = "secUser"

    private Logger log = Logger.getLogger(getClass())

    SecUserService secUserService
    SpringSecurityService springSecurityService

    /**
     * 1. input validation check
     * 2. duplicate check for user-name
     * @param params - receive user object from controller
     * @return - map.
     */
    @Transactional(readOnly = true)
    public Map executePreCondition(Map params) {
        try {
            //Check parameters
            if (!params.username) {
                return super.setError(params, INVALID_INPUT_MSG)
            }
            int duplicateCount = secUserService.countByUsernameIlike(params.username)
            if (duplicateCount > 0) {
                return super.setError(params, ALREADY_EXIST)
            }
            SecUser secUser = buildObject(params)
            params.put(SEC_USER, secUser)
            return params
        } catch (Exception ex) {
            log.error(ex.getMessage())
            throw new RuntimeException(ex)
        }
    }
    /**
     * 1. receive user object from pre execute method
     * 2. create new user
     * This method is in transactional block and will roll back in case of any exception
     * @param result - map received from pre execute method
     * @return - map.
     */
    @Transactional
    public Map execute(Map result) {
        try {
            SecUser secUser = (SecUser) result.get(SEC_USER)
            secUserService.create(secUser)
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

    /**
     * Build User object
     * @param parameterMap -serialized parameters from UI
     * @return -new user object
     */
    private SecUser buildObject(Map parameterMap) {
        SecUser secUser = new SecUser(parameterMap)
        secUser.hospitalCode = "01"
        return secUser
    }
}
