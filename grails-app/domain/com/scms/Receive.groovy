package com.scms

class Receive {
    long id
    long version
    String receiveNo
    String chalanNo
    Date createDate
    long createdBy
    String hospitalCode
    String reqNo

    static constraints = {
        chalanNo(nullable: true)
    }
    static mapping = {
        createDate type:'date'

        hospitalCode index: 'medicine_receive_hospital_code_idx'

    }
}
