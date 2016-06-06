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
        createDate type:'date'
        modifyDate type:'date'
        modifyDate(nullable: true)
        modifyBy (nullable: true)
    }
    static mapping = {

        id name: 'serviceCode'
        version false
        id generator: 'assigned'
        serviceTypeId       index: 'service_head_info_service_type_id_idx'
    }
}
