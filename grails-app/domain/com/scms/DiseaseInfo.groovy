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

        modifyDate(nullable: true)
        modifyBy (nullable: true)
        description (nullable: true)
    }
    static mapping = {

        id name: 'diseaseCode'
        version false
        id generator: 'assigned'
        createDate type:'date'
        modifyDate type:'date'
        diseaseGroupId       index: 'disease_info_disease_group_id_idx'
    }
}
