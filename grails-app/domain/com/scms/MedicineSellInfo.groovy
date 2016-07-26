package com.scms

class MedicineSellInfo {

    long id
    long version
    String voucherNo
    String refTokenNo
    Date sellDate
    Date sellDateExt
    long sellBy
    double totalAmount
    String hospitalCode

    static constraints = {
        refTokenNo (nullable: true)
    }
    static mapping = {
        sellDate type:'date'
        sellBy  index: 'medicine_sell_info_sec_user_id_idx'
    }
}
