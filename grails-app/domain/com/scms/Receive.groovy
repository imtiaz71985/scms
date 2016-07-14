package com.scms

class Receive {
    long id
    long version
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
        reqNo index: 'medicine_receive_req_no_idx'

    }
}
