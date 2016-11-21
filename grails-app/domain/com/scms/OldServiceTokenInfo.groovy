package com.scms

class OldServiceTokenInfo {

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
    Date approveDate
    long approveBy
    String referenceServiceTokenNo
    String remarks
    long referralCenterId
    boolean isApproved
    boolean isDecline

    static constraints = {
        approveDate(nullable: true)
        approveBy (nullable: true)
        referenceServiceTokenNo (nullable: true)
        prescriptionType (nullable: true)
        referralCenterId (nullable: true)
        isApproved (nullable: true)
        isDecline (nullable: true)
        isFollowupNeeded (nullable: true)
    }
    static mapping = {
        id name: 'serviceTokenNo', generator: 'assigned'
        version false
        //id generator: 'assigned'
        serviceDate sqlType: 'date'
        approveDate sqlType: 'date'
        regNo index: 'old_service_token_info_reg_no_idx'
        visitTypeId index: 'old_service_token_info_visit_type_id_idx'
        serviceProviderId index: 'old_service_token_info_service_provider_id_idx'
        referralCenterId index: 'old_service_token_info_referral_center_id_idx'

    }
}
