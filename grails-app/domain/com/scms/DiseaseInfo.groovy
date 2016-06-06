package com.scms

class DiseaseInfo {
    String diseaseCode
    String name
    long diseaseGroupId
    String description
    boolean isActive
    Date createDate
    Date modifyDate
    long modifyBy
    long createdBy
    static constraints = {
        createDate type:'date'
        modifyDate type:'date'
        modifyDate(nullable: true)
        modifyBy (nullable: true)
    }
    static mapping = {

        id name: 'diseaseCode'
        version false
        id generator: 'assigned'
        diseaseGroupId       index: 'disease_info_disease_group_id_idx'
    }
}
