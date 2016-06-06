package com.model

class ListSecRoleActionServiceModel {
    public static final String MODEL_NAME = 'list_sec_role_action_service_model'
    public static final String SQL_LIST_SEC_ROLE_MODEL = """
    CREATE OR REPLACE VIEW list_sec_role_action_service_model AS
          SELECT role.id, role.version, role.name,role.authority, COUNT(au.id) AS count FROM sec_role AS role
          LEFT JOIN sec_user_sec_role ur ON ur.sec_role_id = role.id
          LEFT JOIN sec_user au ON au.id = ur.sec_user_id AND au.enabled = true
          GROUP BY role.id,role.name,role.authority,role.version;
    """

    long id
    long version
    String name
    String authority
    int count

    static mapping = {
        cache usage: "read-only"
    }
}
