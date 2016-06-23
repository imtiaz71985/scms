package com.scms

class MedicineReceive {
    long id
    long version
    String receiveNo
    String chalanNo
    Date createDate
    long createdBy
    String hospitalCode

    static constraints = {
    }
    static mapping = {
        createDate type:'date'

        hospitalCode index: 'medicine_receive_hospital_code_idx'

    }
}
