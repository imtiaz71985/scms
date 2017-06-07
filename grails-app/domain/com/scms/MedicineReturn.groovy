package com.scms

class MedicineReturn {

    long id
    long version
    String traceNo
    Date returnDate
    long returnBy
    double totalAmount
    String hospitalCode
    long returnTypeId

    static constraints = {
    }
    static mapping = {
        returnDate sqltype:'date'
        returnBy  index: 'medicine_return_sec_user_id_idx'
        returnTypeId  index: 'medicine_return_return_type_id_idx'
    }
}
