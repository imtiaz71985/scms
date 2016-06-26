package com.scms

class DamarageAdjustment {
    long id
    long version
    long medicineId
    double appliedQty
    double approvedQty
    long approvedBy
    Date approvedDate
    Date createDate
    long createBy
    String description
    String approvalRemarks
    long damarageTypeId

    static constraints = {
        approvedDate(nullable: true)
        approvedBy(nullable: true)
        approvedQty(nullable: true)
        approvalRemarks(nullable: true)

    }
    static mapping = {
        createDate type:'date'
        approvedDate type:'date'

        medicineId index: 'damarage_adjustment_medicine_id_idx'

    }
}
