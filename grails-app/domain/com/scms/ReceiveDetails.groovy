package com.scms

class ReceiveDetails {
    long id
    long version
    long receiveId
    long medicineId
    double receiveQty

    static constraints = {
    }
    static mapping = {
        medicineId index: 'receive_details_medicine_id_idx'
        receiveId index: 'receive_details_receive_id_idx'
    }
}
