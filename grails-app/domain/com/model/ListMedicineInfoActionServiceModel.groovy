package com.model

class ListMedicineInfoActionServiceModel {

    public static final String MODEL_NAME = 'list_medicine_info_action_service_model'
    public static final String SQL_LIST_ALL_MEDICINE_MODEL = """
           CREATE OR REPLACE VIEW list_medicine_info_action_service_model AS

           SELECT mi.id, mi.version,mi.mrp_price,
                ROUND(mi.mrp_price-(ROUND((mi.mrp_price*sa.subsidy_pert)/100,2)),2) AS unit_price,
                se.id AS type_id,se.name AS TYPE,mi.generic_name,mi.brand_name,sa.subsidy_pert,
                 (CASE
                 WHEN mi.strength IS NOT NULL THEN CONCAT(mi.brand_name,' (',mi.strength,')')
                 ELSE mi.brand_name END) AS medicine_name,
                 mi.strength,mi.unit_type,
                 v.id AS vendor_id, v.name AS vendor_name,
                 0 AS amount,mi.box_size,mi.box_rate,mi.warn_qty
                    FROM medicine_info mi
                    LEFT JOIN system_entity se ON se.id=mi.type
                    LEFT JOIN vendor v ON v.id=mi.vendor_id
                    LEFT JOIN subsidy_on_medicine sa ON sa.medicine_id=mi.id
              ORDER BY mi.brand_name;
    """

    long id
    long version
    long typeId
    long vendorId
    String type
    String genericName
    String brandName
    String medicineName
    String vendorName
    String strength
    String unitType
    double unitPrice
    double subsidyPert
    double mrpPrice
    double amount
    Integer boxSize
    Integer warnQty
    Double boxRate

    static mapping = {
        cache usage: "read-only"
    }
    static constraints = {
    }
}
