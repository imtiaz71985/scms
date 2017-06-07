package com.scms


class TransactionClosing {

    long id
    long version
    String remarks
    Date closingDate
    Date unlockDate
    long unlockBy
    Date createDate
    long createBy
    Date modifyDate
    long modifyBy
    boolean isTransactionClosed
    String hospitalCode

    static constraints = {
        isTransactionClosed (nullable:true)
        remarks (nullable:true)
        modifyBy (nullable:true)
        modifyDate (nullable:true)
        unlockBy (nullable:true)
        unlockDate (nullable:true)
        remarks     size: 2..15000

    }
    static mapping = {
        remarks     sqlType: 'text'
        closingDate sqltype:'date'
        hospitalCode  index: 'transaction_closing_hospital_code_idx'
        createBy  index: 'transaction_closing_create_by_idx'
    }
}
