package com.scms

class ReceiveDetails {
    long id
    long version
    long receiveId
    long medicineId
    double receiveQty
    String remarks

    static constraints = {
        remarks (nullable:true)
    }
    static mapping = {
        medicineId index: 'receive_details_medicine_id_idx'
        receiveId index: 'receive_details_receive_id_idx'
    }
}
