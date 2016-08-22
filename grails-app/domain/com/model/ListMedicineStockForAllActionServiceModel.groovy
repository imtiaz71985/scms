package com.model

class ListMedicineStockForAllActionServiceModel {

    public static final String MODEL_NAME = 'list_medicine_stock_for_all_action_service_model'
    public static final String SQL_LIST_MEDICINE_STOCK_FOR_ALL_MODEL = """
                 CREATE OR REPLACE VIEW list_medicine_stock_for_all_action_service_model AS

                        SELECT mi.id, mi.version,ms.hospital_code AS hospital_code,se.id AS type_id,se.name AS TYPE,mi.generic_name,mi.brand_name,
                        (CASE
                                WHEN mi.strength IS NOT NULL THEN CONCAT(mi.brand_name,' (',mi.strength,')')
                        ELSE mi.brand_name END) AS medicine_name,
                                                   mi.strength,mi.unit_type,mi.unit_price,mi.mrp_price,v.id AS vendor_id, v.name AS vendor_name,
                        0 AS amount,SUM(ms.stock_qty) AS stock_qty,mi.box_size,mi.box_rate,mi.warn_qty,NULL AS expiry_date
                        FROM medicine_info mi
                        LEFT JOIN system_entity se ON se.id=mi.type
                        LEFT JOIN vendor v ON v.id=mi.vendor_id
                        LEFT JOIN medicine_stock ms ON ms.medicine_id=mi.id
                        GROUP BY mi.id
                        ORDER BY ms.hospital_code,se.name;
    """

    long id
    long version
    long typeId
    long vendorId
    String hospitalCode
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
    Double stockQty
    Integer boxSize
    Integer warnQty
    Double boxRate
    Date expiryDate

    static mapping = {
        cache usage: "read-only"
    }
    static constraints = {
    }
}
