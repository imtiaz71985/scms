package com.scms

class MedicineSellInfo {

    long id
    long version
    String voucherNo
    Date sellDate
    Date sellDateExt
    long sellBy
    double totalAmount
    String hospitalCode

    static constraints = {
        sellDate type:'date'
    }
    static mapping = {
        sellBy  index: 'medicine_sell_info_sec_user_id_idx'
    }
}
