package com.scms

class RequisitionDetails {
    long id
    long version
    String reqNo
    long medicineId
    double reqQty
    double approvedQty
    double procurementQty
    double amount
    double approveAmount
    double procAmount

    static constraints = {
        approvedQty(nullable: true)
        procurementQty(nullable: true)
        approveAmount(nullable: true)
        procAmount(nullable: true)
    }
    static mapping = {
        reqNo index: 'requisition_details_req_no_idx'
        medicineId index: 'requisition_details_medicine_id_idx'
    }
}
