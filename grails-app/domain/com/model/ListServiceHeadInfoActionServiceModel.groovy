package com.model

class ListServiceHeadInfoActionServiceModel {
    public static final String MODEL_NAME = 'list_service_head_info_action_service_model'
    public static final String SQL_LIST_SERVICE_TYPE_MODEL = """
      CREATE OR REPLACE VIEW list_service_head_info_action_service_model AS
           SELECT sh.service_code,sc.id, 0 AS VERSION,sh.name,sc.charge_amount,sh.service_type_id,
           st.name AS service_type_name,sc.last_active_date,sc.activation_date,sh.is_active
          FROM service_head_info sh LEFT JOIN service_charges sc
          ON sh.service_code=sc.service_code
          LEFT JOIN service_type st ON sh.service_type_id=st.id
          WHERE sc.last_active_date IS NULL
          ORDER BY  st.name, sh.name ASC;
    """

    long id
    long version
    String serviceCode
    String name
    double chargeAmount
    long serviceTypeId
    String serviceTypeName
    Date lastActiveDate
    Date activationDate
    boolean isActive


    static mapping = {
        cache usage: "read-only"
    }
    static constraints = {
    }
}
