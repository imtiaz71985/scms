package com.scms

class MedicineReturnDetails {

    long id
    long version
    long medicineId
    int quantity
    double amount
    String traceNo

    static constraints = {
    }
    static mapping = {
        medicineId  index: 'medicine_return_details_medicine_id_idx'
    }
}
