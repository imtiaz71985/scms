package com.scms

class RegistrationReissue {

    long id
    long version
    String regNo
    long serviceChargeId
    String description
    long createBy
    Date createDate
    Date originalCreateDate

    static constraints = {
        description (nullable: true)
        originalCreateDate (nullable: true)
    }
    static mapping = {
        createDate sqltype:'date'
        regNo index: 'registration_reissue_reg_no_idx'
        serviceChargeId index: 'registration_reissue_service_charge_id_idx'
    }
}
