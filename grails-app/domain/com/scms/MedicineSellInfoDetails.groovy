package com.scms

class MedicineSellInfoDetails {

    long id
    long version
    long medicineId
    int quantity
    double amount
    String voucherNo

    static constraints = {
    }
    static mapping = {
        medicineId  index: 'medicine_sell_info_details_id_idx'
    }
}
