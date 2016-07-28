package com.scms

class Receive {
    long id
    long version
    String chalanNo
    String prNo
    Date createDate
    long createdBy
    String hospitalCode
    String reqNo
    String remarks

    static constraints = {
        chalanNo(nullable: true)
        prNo(nullable: true)
        remarks(nullable: true)
    }
    static mapping = {
        createDate type:'date'
        hospitalCode index: 'medicine_receive_hospital_code_idx'
        reqNo index: 'medicine_receive_req_no_idx'
    }
}
