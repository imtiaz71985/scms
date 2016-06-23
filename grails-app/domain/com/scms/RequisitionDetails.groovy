package com.scms

class RequisitionDetails {
    long id
    long version
    String reqNo
    long medicineId
    double reqQty
    double approvedQty
    double procurementQty

    static constraints = {
        approvedQty(nullable: true)
        procurementQty(nullable: true)
    }
    static mapping = {
        medicineId index: 'requisition_details_medicine_id_idx'
        reqNo index: 'requisition_details_req_no_idx'
    }
}
