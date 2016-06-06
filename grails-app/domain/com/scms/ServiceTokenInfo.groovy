package com.scms

class ServiceTokenInfo {

    String serviceTokenNo
    String regNo
    Date serviceDate
    long createBy
    double subsidyAmount=0
    long visitTypeId
    long referToId
    long prescriptionTypeId
    boolean isExit
    Date modifyDate
    long modifyBy
    static constraints = {
        serviceDate type: 'date'
        modifyDate type:'date'
        modifyDate(nullable: true)
        modifyBy (nullable: true)
        prescriptionTypeId (nullable: true)
    }
    static mapping = {
        id name: 'serviceTokenNo'
        version false
        id generator: 'assigned'
        regNo index: 'service_token_info_reg_no_idx'
        visitTypeId index: 'service_token_info_visit_type_id_idx'
        referToId index: 'service_token_info_refer_to_id_idx'

    }
}
