package com.scms

class MedicineInfo {

    long id
    long version
    long type
    String genericName
    String strength
    String unitType
    double unitPrice

    static constraints = {
        genericName(nullable: true)
        strength (nullable: true)
        unitType (nullable: true)
        unitPrice (nullable: true)
    }
    static mapping = {
        type  index: 'system_entity_medicine_type_id_idx'
    }
}
