package com.model

class ListDiseaseInfoActionServiceModel {

    public static final String MODEL_NAME = 'list_disease_info_action_service_model'
    public static final String SQL_LIST_SYSTEM_ENTITY_MODEL = """
         CREATE OR REPLACE VIEW list_disease_info_action_service_model AS
              SELECT di.disease_code,di.disease_code AS id,0 AS VERSION, di.name,dg.id AS disease_group_id,dg.name AS disease_group_name,
              di.description,di.is_active,COALESCE(se.id,0) AS applicable_to, COALESCE(se.name,'ALL') AS applicable_to_name
              FROM disease_info di
              LEFT JOIN disease_group dg ON di.disease_group_id=dg.id
              LEFT JOIN system_entity se ON se.id=di.applicable_to
              ORDER BY di.name ASC;
    """

    long id
    long version
    String diseaseCode
    String name
    String description
    long diseaseGroupId
    long applicableTo
    String diseaseGroupName
    String applicableToName
    boolean isActive

    static mapping = {
        cache usage: "read-only"
    }
    static constraints = {
    }
}
