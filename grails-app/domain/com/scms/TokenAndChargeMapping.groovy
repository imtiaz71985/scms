package com.scms

class TokenAndChargeMapping {
    long id
    long version
    String serviceTokenNo
    long serviceChargeId
    Date serviceDate
    static constraints = {

    }
    static mapping = {
        serviceTokenNo       index: 'token_and_charge_mapping_serviceTokenNo_idx'
        serviceChargeId          index: 'token_and_charge_mapping_serviceChargeId_idx'
    }
}
