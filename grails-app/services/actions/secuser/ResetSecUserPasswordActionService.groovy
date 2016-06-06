package actions.secuser

import com.scms.SecUser
import grails.plugin.springsecurity.SpringSecurityService
import grails.transaction.Transactional
import org.apache.log4j.Logger
import org.codehaus.groovy.grails.web.servlet.mvc.GrailsParameterMap
import scms.ActionServiceIntf
import scms.BaseService

@Transactional
class ResetSecUserPasswordActionService extends BaseService implements ActionServiceIntf {

    private Logger log = Logger.getLogger(getClass())

    private static final String USER_NOT_FOUND_MSG = 'User not found or password already been reset'
    private static final String SUCCESS_MESSAGE = 'Password has been reset successfully'
    private static final String SEC_USER = 'secUser'
    private static final String INCORRECT_PASSWORD_MSG = 'Current password is incorrect'
    private static final String PASSWORD_MISMATCH_MSG = 'Password mismatched, please type again'

    SpringSecurityService springSecurityService

    /**
     * 1. get companyId from request
     * 2. check input validation
     * @param params -serialized parameters from UI
     * @param obj -HttpServletRequest request
     * @return -a map containing all objects necessary for execute
     * map contains isError(true/false) depending on method success
     */
    @Transactional(readOnly = true)
    public Map executePreCondition(Map parameters) {
        try {
            GrailsParameterMap params = (GrailsParameterMap) parameters
            // check required parameters
            if ((!params.userId) || (!params.curPassword) || (!params.newPassword) || (!params.retypePassword)) {
                return super.setError(params, INVALID_INPUT_MSG)
            }
            long id = Long.parseLong(params.userId.toString())
            SecUser user = SecUser.read(id)
            String checkValidationMsg = checkInputValidation(params, user)
            if (checkValidationMsg) {
                return super.setError(params, checkValidationMsg)
            }
            params.put(SEC_USER, user)
            return params
        } catch (Exception e) {
            log.error(e.getMessage())
            throw new RuntimeException(e)
        }
    }

    /**
     * Set and update properties of AppUser for reset password
     * @param parameters -serialized parameters from UI
     * @param obj -map returned from executePreCondition method
     * @return -a map contains isError(true/false) depending on method success and related message
     */
    @Transactional
    public Map execute(Map result) {
        try {
            SecUser secUser = (SecUser) result.get(SEC_USER)
            cleanPasswordResetProperties(secUser, result)    // set password reset link, code and validity null
            updatePasswordResetProperties(secUser) // update properties for reset password
            return result
        } catch (Exception e) {
            log.error(e.getMessage())
            throw new RuntimeException(e)
        }
    }

    /**
     * Do nothing for post operation
     */
    public Map executePostCondition(Map result) {
        return result
    }

    /**
     * Do nothing for build success result for UI
     */
    public Map buildSuccessResultForUI(Map result) {
        return super.setSuccess(result, SUCCESS_MESSAGE)
    }

    /**
     * Build failure result in case of any error
     * @param obj -map returned from previous methods, can be null
     * @return -a map containing isError = true & relevant error message
     */
    public Map buildFailureResultForUI(Map result) {
        return result
    }

    /**
     * 1. check required parameters
     * 2. get AppUser object by link and companyId
     * 3. check if user exists or not
     * 4. check security code
     * 5. check time validation for reset password
     * 6. check password confirmation
     * 7. check password length
     * 8. check character combination of password
     * @param params -serialized parameters from UI
     * @return -a map containing AppUser object, isError (true/false) and relevant error message
     */
    private String checkInputValidation(GrailsParameterMap params, SecUser secUser) {
        // check if user exists or not
        if (!secUser) {
            return USER_NOT_FOUND_MSG
        }
        SecUser activeUser =(SecUser) springSecurityService.currentUser
        String password = params.curPassword.toString()
        if (!springSecurityService.passwordEncoder.isPasswordValid(activeUser.getPassword(), password, null)) {
            return INCORRECT_PASSWORD_MSG
        }
        String newPassword = params.newPassword
        String retypePassword = params.retypePassword
        // check password confirmation
        if (!newPassword.equals(retypePassword)) {
            return PASSWORD_MISMATCH_MSG
        }
        return null
    }

    /**
     * Set properties of AppUser for reset password
     * @param user -object of AppUser
     * @param params -serialized parameters from UI
     */
    private void cleanPasswordResetProperties(SecUser user, Map result) {
        user.password = springSecurityService.encodePassword(result.newPassword)
    }

    private static final String UPDATE_USER = """
        UPDATE sec_user
        SET
            password=:password,
            version=version+1
        WHERE
            id=:id
    """

    /**
     * Update AppUser properties for reset password
     * @param user -object of AppUser
     * @return -an integer containing the value of update count
     */
    private int updatePasswordResetProperties(SecUser user) {
        Map queryParams = [
                password: user.password,
                id: user.id,
                version: user.version
        ]
        int updateCount = executeUpdateSql(UPDATE_USER, queryParams)
        if (updateCount <= 0) {
            throw new RuntimeException('Error occurred while reset password')
        }
        user.version = user.version + 1
        return updateCount
    }
}
