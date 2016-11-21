package com.scms

class TokenAndDiseaseMapping {

    long id
    long version
    String serviceTokenNo
    String diseaseCode
    Date serviceDate
    static constraints = {

    }
    static mapping = {
        serviceTokenNo       index: 'token_and_disease_mapping_serviceTokenNo_idx'
        diseaseCode          index: 'token_and_disease_mapping_diseaseCode_idx'
    }
}
