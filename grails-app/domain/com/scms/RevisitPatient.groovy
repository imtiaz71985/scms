package com.scms

class RevisitPatient {
    String regNo
    Date createDate
    long createdBy
    long visitTypeId
    String hospitalCode
    Date originalCreateDate
    static constraints = {
        originalCreateDate (nullable: true)
    }
    static mapping = {
        createDate sqltype:'date'
        hospitalCode index: 'revisit_patient_hospital_code_idx'
        visitTypeId index: 'revisit_patient_visit_type_id_idx'
    }
}
