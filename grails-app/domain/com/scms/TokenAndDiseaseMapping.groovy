package com.scms

class TokenAndDiseaseMapping {

    long id
    long version
    String serviceTokenNo
    String diseaseCode
    Date createDate
    long createBy
    static constraints = {
        createDate type:'date'
    }
    static mapping = {
        serviceTokenNo       index: 'token_and_disease_mapping_serviceTokenNo_idx'
        diseaseCode          index: 'token_and_disease_mapping_diseaseCode_idx'
    }
}
