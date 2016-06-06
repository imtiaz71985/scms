package actions.secRole

import com.model.ListSecRoleActionServiceModel
import com.scms.SecRole
import grails.transaction.Transactional
import org.apache.log4j.Logger
import scms.ActionServiceIntf
import scms.BaseService
import service.SecRoleService

@Transactional
class UpdateSecRoleActionService extends BaseService implements ActionServiceIntf {

    private static final String UPDATE_SUCCESS_MESSAGE = "Role has been updated successfully"
    private static final String ROLE_ALREADY_EXIST = "Same Role already exist"
    private static final String SEC_ROLE = "secRole"

    SecRoleService secRoleService

    private Logger log = Logger.getLogger(getClass())

    public Map executePreCondition(Map params) {
        try {
            //Check parameters
            if ((!params.id) || (!params.name)) {
                return super.setError(params, INVALID_INPUT_MSG)
            }
            long id = Long.parseLong(params.id.toString())
            //long version = Long.parseLong(params.version.toString())

            //Check existing of Obj and version matching
            SecRole oldSecRole = (SecRole) secRoleService.read(id)
            /*if ((!oldSecRole) || oldSecRole.version != version) {
                return super.setError(params, OBJ_CHANGED_MSG)
            }*/
            // Check existing of same secUser name
            String name = params.name.toString()
            int duplicateCount = secRoleService.countByNameIlikeAndIdNotEqual(name, id)
            if (duplicateCount > 0) {
                return super.setError(params, ROLE_ALREADY_EXIST)
            }
            SecRole secRole = buildObject(params, oldSecRole)
            params.put(SEC_ROLE, secRole)
            return params
        } catch (Exception ex) {
            log.error(ex.getMessage())
            throw new RuntimeException(ex)
        }
    }

    @Transactional
    public Map execute(Map result) {
        try {
            SecRole secRole = (SecRole) result.get(SEC_ROLE)
            secRoleService.update(secRole)
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
     * @param result - map received from execute method
     * @return - map with success message
     */
    public Map buildSuccessResultForUI(Map result) {
        SecRole secRole = (SecRole) result.get(SEC_ROLE)
        ListSecRoleActionServiceModel model = ListSecRoleActionServiceModel.read(secRole.id)
        result.put(SEC_ROLE, model)
        return super.setSuccess(result, UPDATE_SUCCESS_MESSAGE)
    }

    /**
     *
     * @param result - map received from previous method
     * @return - map
     */
    public Map buildFailureResultForUI(Map params) {
        return params
    }

    /**
     * Build SecRole object
     * @param parameterMap -serialized parameters from UI
     * @param oldSecRole -object of SecRole
     * @return -new SecRole object
     */
    private static SecRole buildObject(Map parameterMap, SecRole oldSecRole) {
        SecRole role = new SecRole(parameterMap)
        oldSecRole.name = role.name
        return oldSecRole
    }
}
