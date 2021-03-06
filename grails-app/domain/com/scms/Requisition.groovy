package com.scms

class Requisition {
    long id
    long version
    String reqNo
    Date createDate
    Date approvedDate
    long approvedBy
    long createdBy
    String hospitalCode
    boolean isApproved
    boolean isReceived
    boolean isDelivered
    Date deliveryDate
    Date procAdjDate
    boolean isSend
    Date sendDate
    double totalAmount
    double approvedAmount
    boolean isGeneratePR

    static constraints = {
        approvedDate(nullable: true)
        sendDate(nullable: true)
        approvedBy(nullable: true)
        procAdjDate(nullable: true)
        isApproved(nullable: true)
        isReceived(nullable: true)
        isSend(nullable: true)
        totalAmount(nullable: true)
        approvedAmount(nullable: true)
        deliveryDate(nullable: true)
        isDelivered(nullable: true)
        isGeneratePR(nullable: true)
    }
    static mapping = {
        createDate sqltype:'date'
        approvedDate sqltype:'date'
        procAdjDate sqltype:'date'
        sendDate sqlType: 'date'
        deliveryDate sqltype:'date'
        hospitalCode index: 'requisition_hospital_code_idx'
    }
}
