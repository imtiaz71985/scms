package com.model

class ListSystemEntityActionServiceModel {

    public static final String MODEL_NAME = 'list_system_entity_action_service_model'
    public static final String SQL_LIST_SYSTEM_ENTITY_MODEL = """
     CREATE OR REPLACE VIEW list_system_entity_action_service_model AS
          SELECT id,VERSION,TYPE,NAME,description
          FROM system_entity
          ORDER BY TYPE,NAME ASC;
    """

    long id
    long version
    String type
    String name
    String description

    static mapping = {
        cache usage: "read-only"
    }
    static constraints = {
    }
}
