package com.scms

class ServiceHeadInfo {

    String serviceCode
    String name
    long serviceTypeId
    boolean isActive
    Date createDate
    Date modifyDate
    long modifyBy
    long createdBy

    static constraints = {

        modifyDate(nullable: true)
        modifyBy (nullable: true)
    }
    static mapping = {

        id name: 'serviceCode'
        version false
        id generator: 'assigned'
        createDate sqltype:'date'
        modifyDate sqltype:'date'
        serviceTypeId       index: 'service_head_info_service_type_id_idx'
    }
}
