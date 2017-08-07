package com.model

class ListUserDepartmentActionServiceModel {

    public static final String SQL_LIST_USER_DEPARTMENT_MODEL = """
        SELECT ud.id, ud.version, ud.user_id AS user_id,ur.employee_name user_name,
         ud.service_id, s.name service_name,s.short_name service_short_name,s.sequence
                FROM mis.user_department ud
                LEFT JOIN mis.service s ON s.id = ud.service_id
                LEFT JOIN login_auth.sec_user ur ON ur.id = ud.user_id
    """

    long id
    long version
    long serviceId
    long userId
    String serviceName
    String serviceShortName
    float sequence

    static mapping = {
        datasource 'mis'
        cache usage: "read-only"
    }
    static constraints = {
    }
}
