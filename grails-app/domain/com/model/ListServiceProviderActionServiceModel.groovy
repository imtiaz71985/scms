package com.model

class ListServiceProviderActionServiceModel {

    public static final String MODEL_NAME = 'list_service_provider_action_service_model'
    public static final String SQL_LIST_SERVICE_PROVIDER_MODEL = """
            SELECT sp.id, sp.version, se.id AS type_id, se.name AS type_name,sp.name,sp.is_active,sp.mobile_no
                  FROM service_provider sp
                  LEFT JOIN system_entity se ON se.id=sp.type_id AND se.type = 'Service Provider';
    """

    long id
    long version
    long typeId
    String name
    String typeName
    String mobileNo
    boolean isActive

    static mapping = {
        cache usage: "read-only"
    }
}
