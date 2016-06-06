package com.model

class ListServiceTypeActionServiceModel {
    public static final String MODEL_NAME = 'list_service_type_action_service_model'
    public static final String SQL_LIST_SERVICE_TYPE_MODEL = """
   CREATE OR REPLACE VIEW list_service_type_action_service_model AS
          SELECT st.id, st.version,st.name,st.description,st.is_active
          FROM service_type st
          ORDER BY st.name ASC;
    """

    long id
    long version
    String name
    String description
    boolean isActive

    static mapping = {
        cache usage: "read-only"
    }
}
