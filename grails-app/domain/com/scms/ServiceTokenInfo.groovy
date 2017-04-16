package com.scms

class ServiceTokenInfo {

    String serviceTokenNo
    String regNo
    Date serviceDate
    Date createDate
    long createBy
    double subsidyAmount=0
    long visitTypeId
    long serviceProviderId
    String prescriptionType
    boolean isFollowupNeeded
    Date modifyDate
    long modifyBy
    String referenceServiceTokenNo
    long referralCenterId
    boolean isDeleted

    static constraints = {
        modifyDate(nullable: true)
        createDate(nullable: true)
        modifyBy (nullable: true)
        referenceServiceTokenNo (nullable: true)
        prescriptionType (nullable: true)
        referralCenterId (nullable: true)
        isDeleted (nullable: true)
        isFollowupNeeded (nullable: true)
    }
    static mapping = {
        id name: 'serviceTokenNo'
        version false
        id generator: 'assigned'
        serviceDate sqlType: 'Date'
        regNo index: 'service_token_info_reg_no_idx'
        visitTypeId index: 'service_token_info_visit_type_id_idx'
        serviceProviderId index: 'service_token_info_service_provider_id_idx'
        referralCenterId index: 'service_token_info_referral_center_id_idx'

    }
}
