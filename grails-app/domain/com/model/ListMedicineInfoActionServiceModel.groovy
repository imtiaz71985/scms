package com.model

class ListMedicineInfoActionServiceModel {

    public static final String MODEL_NAME = 'list_medicine_info_action_service_model'
    public static final String SQL_LIST_SYSTEM_ENTITY_MODEL = """
        CREATE OR REPLACE VIEW list_medicine_info_action_service_model AS

                  SELECT mi.id, mi.version,se.id AS type_id,se.name AS TYPE,mi.generic_name,mi.strength,mi.unit_type,mi.unit_price
                  FROM medicine_info mi
                  LEFT JOIN system_entity se ON se.id=mi.type
                  ORDER BY se.name
    """

    long id
    long version
    long typeId
    String type
    String genericName
    String strength
    String unitType
    double unitPrice

    static mapping = {
        cache usage: "read-only"
    }
    static constraints = {
    }
}
