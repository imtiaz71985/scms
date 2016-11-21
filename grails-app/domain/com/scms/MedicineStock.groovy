package com.scms

class MedicineStock {

    long id
    long version
    long medicineId
    String hospitalCode
    Double stockQty
    Date expiryDate

    static constraints = {
        expiryDate (nullable: true)
    }
    static mapping = {
        expiryDate sqltype:'date'
        hospitalCode index: 'hospital_code_idx'
        medicineId index: 'medicine_id_idx'
    }
}
