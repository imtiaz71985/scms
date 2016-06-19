package com.scms

class MedicineInfo {

    long id
    long version
    long type
    String genericName
    String brandName
    String strength
    String unitType
    double unitPrice

    static constraints = {

    }
    static mapping = {
        type  index: 'system_entity_medicine_type_id_idx'
    }
}
