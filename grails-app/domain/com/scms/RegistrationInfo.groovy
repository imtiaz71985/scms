package com.scms

class RegistrationInfo {

    String regNo
    String patientName
    String fatherOrMotherName
    Date dateOfBirth
    long sexId
    long maritalStatusId
    String mobileNo
    Date createDate
    Date modifyDate
    long modifyBy
    long createdBy
    long villageId
    String hospitalCode
    boolean isActive
    long service_charge_id
    boolean isReissue
    boolean isOldPatient

    static constraints = {
        fatherOrMotherName(nullable: true)
        mobileNo(nullable: true)
        modifyDate(nullable: true)
        modifyBy (nullable: true)
        isReissue (nullable: true)
        isOldPatient (nullable: true)
    }

    static mapping = {
        id name: 'regNo'
        modifyDate type:'date'
        dateOfBirth type:'date'
        version false
        id generator: 'assigned'
        sexId index: 'registration_info_sex_id_idx'
        maritalStatusId index: 'registration_info_marital_status_id_idx'
        hospitalCode index: 'registration_info_hospital_code_idx'
        villageId index: 'registration_info_village_id_idx'
    }
}
