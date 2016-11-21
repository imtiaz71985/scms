package com.scms

class OldTokenAndDiseaseMapping {

    long id
    long version
    String serviceTokenNo
    String diseaseCode
    static constraints = {
    }
    static mapping = {
        serviceTokenNo       index: 'old_token_and_disease_mapping_serviceTokenNo_idx'
        diseaseCode          index: 'old_token_and_disease_mapping_diseaseCode_idx'
    }
}
