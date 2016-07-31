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
    Double stockQty
    Integer boxSize
    Double boxRate
    Integer warnQty = 0
    Date expiryDate


    static constraints = {
        strength (nullable: true)
        stockQty (nullable: true)
        boxSize (nullable: true)
        boxRate (nullable: true)
        unitType (nullable: true)
        warnQty (nullable: true)
        expiryDate (nullable: true)

    }
    static mapping = {
        expiryDate type:'date'
        type index: 'system_entity_medicine_type_id_idx'
        vendorId index: 'vendor_id_idx'
    }
}
