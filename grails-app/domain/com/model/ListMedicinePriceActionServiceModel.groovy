package com.model

class ListMedicinePriceActionServiceModel {

    public static final String MODEL_NAME = 'list_medicine_price_action_service_model'
    public static final String SQL_LIST_MEDICINE_PRICE_MODEL = """
                CREATE OR REPLACE VIEW list_medicine_price_action_service_model AS

                      SELECT mp.id, mp.version,mp.start,mp.end,mp.medicine_id,
                      mi.generic_name,mi.brand_name,mi.strength,mp.price,mp.mrp_price,mp.is_active
                            FROM medicine_price mp
                            LEFT JOIN medicine_info mi ON mp.medicine_id=mi.id
                      ORDER BY mp.start DESC,mp.medicine_id;
    """

    long id
    long version
    long medicineId
    Date start
    Date end
    String genericName
    String brandName
    String strength
    double price
    double mrpPrice
    boolean isActive

    static mapping = {
        cache usage: "read-only"
    }
    static constraints = {
    }
}
