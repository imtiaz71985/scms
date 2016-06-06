package com.scms

class TokenAndChargeMapping {
    long id
    long version
    String serviceTokenNo
    long serviceChargeId
    Date createDate
    long createBy
    static constraints = {
        createDate type:'date'
    }
    static mapping = {
        serviceTokenNo       index: 'token_and_charge_mapping_serviceTokenNo_idx'
        serviceChargeId          index: 'token_and_charge_mapping_serviceChargeId_idx'
    }
}
