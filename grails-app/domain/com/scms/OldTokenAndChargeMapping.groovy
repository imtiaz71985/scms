package com.scms

class OldTokenAndChargeMapping {
    long id
    long version
    String serviceTokenNo
    long serviceChargeId
    static constraints = {
    }
    static mapping = {
        serviceTokenNo       index: 'old_token_and_charge_mapping_serviceTokenNo_idx'
        serviceChargeId          index: 'old_token_and_charge_mapping_serviceChargeId_idx'
    }
}
