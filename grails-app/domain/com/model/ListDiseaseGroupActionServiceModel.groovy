package com.model

class ListDiseaseGroupActionServiceModel {


    public static final String MODEL_NAME = 'list_disease_group_action_service_model'
    public static final String SQL_LIST_SYSTEM_ENTITY_MODEL = """
        CREATE OR REPLACE VIEW list_disease_group_action_service_model AS
          SELECT id,VERSION, NAME,description,is_active FROM disease_group
          ORDER BY id DESC;
    """

    long id
    long version
    String name
    String description
    boolean isActive
    static mapping = {
        cache usage: "read-only"
    }
    static constraints = {
    }
}
