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
    boolean isReturn
    Date createDate
    boolean isDelete=false

    static constraints = {
        isReturn (nullable:true)
        createDate (nullable:true)
    }
    static mapping = {
        sellDate sqltype:'date'
        sellBy  index: 'medicine_sell_info_sec_user_id_idx'
    }
}
