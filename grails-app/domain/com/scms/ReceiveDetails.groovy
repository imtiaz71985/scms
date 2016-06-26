package com.scms

class ReceiveDetails {
    long id
    long version
    String receiveNo
    long medicineId
    double receiveQty

    static constraints = {
    }
    static mapping = {

        medicineId index: 'receive_details_medicine_id_idx'

    }
}
