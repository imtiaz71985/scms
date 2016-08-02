package com.model

class ListMedicineStockActionServiceModel {

    public static final String MODEL_NAME = 'list_medicine_stock_action_service_model'
    public static final String SQL_LIST_MEDICINE_INFO_MODEL = """
        CREATE OR REPLACE VIEW list_medicine_stock_action_service_model AS

              SELECT mi.id, mi.version,se.id AS type_id,se.name AS TYPE,mi.generic_name,mi.brand_name,
                 (CASE
                 WHEN mi.strength IS NOT NULL THEN CONCAT(mi.brand_name,' (',mi.strength,')')
                 ELSE mi.brand_name END) AS medicine_name,
                 mi.strength,mi.unit_type,mi.unit_price,mi.mrp_price,v.id AS vendor_id, v.name AS vendor_name,
                 0 AS amount,mi.box_size,mi.box_rate,mi.warn_qty,ms.stock_qty,ms.expiry_date,ms.hospital_code
                    FROM medicine_info mi
                    LEFT JOIN system_entity se ON se.id=mi.type
                    LEFT JOIN vendor v ON v.id=mi.vendor_id
                    LEFT JOIN medicine_stock ms ON ms.medicine_id = mi.id
                    ORDER BY ms.hospital_code,se.name;
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
    double mrpPrice
    double amount
    Integer boxSize
    Integer warnQty
    Double boxRate
    Double stockQty
    Date expiryDate
    String hospitalCode

    static mapping = {
        cache usage: "read-only"
    }
    static constraints = {
    }
}
