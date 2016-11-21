package com.scms

class RegistrationReissue {

    long id
    long version
    String regNo
    long serviceChargeId
    String description
    long createBy
    Date createDate

    static constraints = {
        createDate sqltype:'date'
        description (nullable: true)
    }
    static mapping = {
    }
}
