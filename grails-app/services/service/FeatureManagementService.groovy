package service

import grails.transaction.Transactional
import groovy.sql.GroovyRowResult
import scms.BaseService

@Transactional
class FeatureManagementService extends BaseService{

    /**
     * Method to update assigned or removed requestMap for particular role
     * @param lstAssignedFeatures - list of assigned features
     * @param roleAuthority - string of role authority
     */
    public boolean update(List<Long> lstAssignedFeatures, String roleAuthority) {
        String queryStr = """
                SELECT id FROM feature_management
                WHERE
                (
                config_attribute LIKE '%,${roleAuthority},%'
                OR
                config_attribute LIKE '${roleAuthority},%'
                OR
                config_attribute LIKE '%,${roleAuthority}'
                OR
                config_attribute =  '${roleAuthority}'
                )
                AND url NOT LIKE '/'
        """

        // First get the current assigned role
        List<GroovyRowResult> result = executeSelectSql(queryStr)

        List<Long> lstOldFeatures = []
        for (int i = 0; i < result.size(); i++) {
            lstOldFeatures << result[i].id
        }

        // Find the common elements
        List lstCommonFeatures = lstOldFeatures.intersect(lstAssignedFeatures)

        List<Long> lstToRemove = (List<Long>) lstOldFeatures.clone()
        // Get the IDs of requestMap where current ROLE has lost the RIGHT
        lstToRemove.removeAll(lstCommonFeatures)      // i.e. ToBeRemoved=(Existing Feature) - (Common Features)
        // Get the IDs of requestMap where current ROLE has gain the RIGHT
        List<Long> lstToAdd = (List<Long>) lstAssignedFeatures.clone()
        lstToAdd.removeAll(lstCommonFeatures)        // i.e. ToBeAdded=(All assigned Feature) - (Common Features)

        // If something to add then execute sql
        if (lstToAdd.size() > 0) {
            String idsForAdd = buildCommaSeparatedStringOfIds(lstToAdd)
            String queryToAdd = """
                UPDATE feature_management
                SET config_attribute =
                    CASE WHEN config_attribute IS NULL THEN '${roleAuthority}'
                    WHEN config_attribute ='' THEN '${roleAuthority}'
                    ELSE CONCAT(config_attribute, ',${roleAuthority}')
                    END
                WHERE id IN (${idsForAdd})
        """
            executeUpdateSql(queryToAdd)
        }

        // If something to remove then execute sql
        if (lstToRemove.size() > 0) {
            String idsForRemove = buildCommaSeparatedStringOfIds(lstToRemove)
            String queryToRemove = """
            UPDATE feature_management
            SET config_attribute =
                CASE WHEN config_attribute LIKE '%${roleAuthority},%' THEN
                    REPLACE(config_attribute, '${roleAuthority},' , '')
                WHEN config_attribute LIKE '%,${roleAuthority}%' THEN
                    REPLACE(config_attribute, ',${roleAuthority}' , '')
                ELSE NULL
                END
            WHERE id IN (${idsForRemove})
        """
            executeUpdateSql(queryToRemove)
        }
        return true
    }

    /**
     * Method to update when role name is changed
     * @param previousRole - string of previous role from caller method
     * @param newRole - string of new role from caller method
     * @return
     */
    public boolean update(String previousRole, String newRole) {
        String queryStr = """
            UPDATE feature_management
                SET config_attribute =
            CASE WHEN config_attribute LIKE '%,${previousRole},%' THEN
                REPLACE(config_attribute, ',${previousRole},' , ',${newRole},')
            WHEN config_attribute LIKE '%,${previousRole}' THEN
                REPLACE(config_attribute, ',${previousRole}' , ',${newRole}')
            ELSE config_attribute
            END
        """

        executeUpdateSql(queryStr)

        return true;
    }

    public boolean isRoleAssociatedWithRequestmap(String roleAuthority){
        String queryStr = """
                SELECT id FROM feature_management
                WHERE
                (
                config_attribute LIKE '%,${roleAuthority},%'
                OR
                config_attribute LIKE '${roleAuthority},%'
                OR
                config_attribute LIKE '%,${roleAuthority}'
                OR
                config_attribute =  '${roleAuthority}'
                )
                AND url NOT LIKE '/'
        """

        // First get the current assigned role
        List<GroovyRowResult> result = executeSelectSql(queryStr)
        if(result.size() > 0){
            return true
        }
        return false
    }

    public void addRoleToRoot(String roleAuthority){
        String queryStr = """
            UPDATE feature_management
            SET config_attribute = CONCAT(config_attribute, ',${roleAuthority}')
            WHERE url LIKE '/'
        """
        executeUpdateSql(queryStr)
    }
    public void removeRoleFromRoot(String roleAuthority){
        String queryStr = """
            UPDATE feature_management
            SET config_attribute =
                CASE WHEN config_attribute LIKE '%${roleAuthority},%' THEN
                    REPLACE(config_attribute, '${roleAuthority},' , '')
                WHEN config_attribute LIKE '%,${roleAuthority}%' THEN
                    REPLACE(config_attribute, ',${roleAuthority}' , '')
                ELSE NULL
                END
            WHERE url LIKE '/'
        """
        executeUpdateSql(queryStr)
    }
}
