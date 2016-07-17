package com.scms

class ServiceCharges {

    long id
    long version
    String serviceCode
    double chargeAmount
    Date activationDate
    Date lastActiveDate
    Date createDate
    long createdBy

    static constraints = {
        lastActiveDate type : 'date'
        createDate     type : 'date'
        lastActiveDate (nullable: true)
    }
    static mapping = {
        serviceCode index: 'service_charges_service_code_idx'
    }
}
