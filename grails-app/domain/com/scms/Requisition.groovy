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
    Date procAdjDate
    boolean isSend
    long sendTo
    Date sendDate

    static constraints = {
        approvedDate(nullable: true)
        sendDate(nullable: true)
        sendTo(nullable: true)
        approvedBy(nullable: true)
    }
    static mapping = {
        createDate type:'date'
        approvedDate type:'date'
        procAdjDate type:'date'
        sendDate type:'date'
        hospitalCode index: 'requisition_hospital_code_idx'

    }
}
