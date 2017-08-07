package com.model

class ListSecRoleActionServiceModel {
    public static final String SQL_LIST_SEC_ROLE_MODEL = """
          SELECT role.id, role.version, role.name,role.authority, COUNT(au.id) AS `count`, role.apps_id
          FROM sec_role AS role
          LEFT JOIN sec_user_sec_role ur ON ur.sec_role_id = role.id
          LEFT JOIN sec_user au ON au.id = ur.sec_user_id AND au.enabled = TRUE
          GROUP BY role.id,role.name,role.authority,role.version;
    """

    long id
    long version
    long appsId
    String name
    String authority
    int count

    static mapping = {
        datasource 'comn'
        cache usage: "read-only"
    }
}
