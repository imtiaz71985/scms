package com.model

class ListMedicineInfoActionServiceModel {

    public static final String MODEL_NAME = 'list_medicine_info_action_service_model'
    public static final String SQL_LIST_ALL_MEDICINE_MODEL = """
            CREATE OR REPLACE VIEW list_medicine_info_action_service_model AS

              SELECT mi.id, mi.version,se.id AS type_id,se.name AS TYPE,mi.generic_name,mi.brand_name,
                 mi.strength,mi.unit_type,mi.unit_price,mi.mrp_price,v.id AS vendor_id, v.name AS vendor_name,
                 0 AS amount
                    FROM medicine_info mi
                    LEFT JOIN system_entity se ON se.id=mi.type
                    LEFT JOIN vendor v ON v.id=mi.vendor_id
              ORDER BY se.name;
    """

    long id
    long version
    long typeId
    long vendorId
    String type
    String genericName
    String brandName
    String vendorName
    String strength
    String unitType
    double unitPrice
    double mrpPrice
    double amount

    static mapping = {
        cache usage: "read-only"
    }
    static constraints = {
    }
}
