package com.scms

class ServiceTokenInfo {

    String serviceTokenNo
    String regNo
    Date serviceDate
    long createBy
    double subsidyAmount=0
    long visitTypeId
    long serviceProviderId
    String prescriptionType
    boolean isExit
    Date modifyDate
    long modifyBy
    String referenceServiceTokenNo
    static constraints = {
        modifyDate(nullable: true)
        modifyBy (nullable: true)
        referenceServiceTokenNo (nullable: true)
        prescriptionType (nullable: true)
    }
    static mapping = {
        id name: 'serviceTokenNo'
        version false
        id generator: 'assigned'
        regNo index: 'service_token_info_reg_no_idx'
        visitTypeId index: 'service_token_info_visit_type_id_idx'
        serviceProviderId index: 'service_token_info_service_provider_id_idx'

    }
}
