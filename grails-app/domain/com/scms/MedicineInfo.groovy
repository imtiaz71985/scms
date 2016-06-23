package com.scms

class MedicineInfo {

    long id
    long version
    long type
    long vendorId
    String genericName
    String brandName
    String strength
    String unitType
    double unitPrice
    double mrpPrice

    static constraints = {

    }
    static mapping = {
        type  index: 'system_entity_medicine_type_id_idx'
        vendorId index: 'vendor_id_idx'
    }
}
