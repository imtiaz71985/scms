package actions.featureManagement

import com.scms.SecRole
import grails.transaction.Transactional
import groovy.sql.GroovyRowResult
import org.apache.log4j.Logger
import scms.ActionServiceIntf
import scms.BaseService
import service.SecRoleService

@Transactional
class ListAvailableRoleActionService extends BaseService implements ActionServiceIntf {

    private static final String ROLE = "role"

    private Logger log = Logger.getLogger(getClass())

    SecRoleService secRoleService
    /**
     * Do nothing for pre operation
     */
    public Map executePreCondition(Map params) {
        if (!params.roleId) {
            return super.setError(params, INVALID_INPUT_MSG)
        }
        Long roleId = Long.valueOf(params.roleId.toString())
        SecRole role = secRoleService.read(roleId)
        params.put(ROLE, role)
        return params
    }

    /**
     * Get list of assigned & available features
     * 1. Get role object
     * 2. Check required parameters
     * @param parameters - parameters from UI
     * @param obj - N/A
     * @return - a map containing list of assigned, available features, isError(true/false) depending on method success
     */
    @org.springframework.transaction.annotation.Transactional(readOnly = true)
    public Map execute(Map params) {
        try {

            SecRole role = (SecRole) params.get(ROLE)
            List lstAvailableFeatures = getAvailableFeatureByRole(role.authority)
            params.put(LIST, lstAvailableFeatures)
            params.put(COUNT, lstAvailableFeatures.size())
            return params
        } catch (Exception ex) {
            log.error(ex.getMessage())
            throw new RuntimeException(ex)
        }
    }

    /**
     * Do nothing for post operation
     */
    public Map executePostCondition(Map params) {
        return params
    }

    /**
     * Build a map with request map object & other necessary properties to show on UI
     * @param obj - map returned from execute method
     * @return - a map containing all objects necessary for show
     */
    public Map buildSuccessResultForUI(Map params) {
        return params
    }

    /**
     * Build failure result in case of any error
     * @param obj -map returned from previous methods, can be null
     * @return -a map containing isError = true & relevant error message
     */
    public Map buildFailureResultForUI(Map params) {
        return params
    }

    /**
     * Get list of available features
     * @param roleAuthority - role authority is a string comes from caller method
     * @return - a list of available features
     */
    private List<GroovyRowResult> getAvailableFeatureByRole(String roleAuthority) {
        String queryStr = """
            SELECT id , feature_name, url, group_name
            FROM feature_management
            WHERE id NOT IN (
                SELECT id
                FROM feature_management
                WHERE
                config_attribute LIKE '%,${roleAuthority},%'
                OR
                config_attribute LIKE '${roleAuthority},%'
                OR
                config_attribute LIKE '%,${roleAuthority}'
                OR
                config_attribute = '${roleAuthority}'
            )
            AND feature_name IS NOT NULL
            AND url NOT LIKE '/'
            AND config_attribute <> 'IS_AUTHENTICATED_ANONYMOUSLY'
            ORDER BY group_name, feature_name ASC
        """

        List<GroovyRowResult> lstAvailableFeatures = executeSelectSql(queryStr)
        return lstAvailableFeatures
    }
}
