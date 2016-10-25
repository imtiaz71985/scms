package com.scms

class ServiceChargeFreeDays {
    long id
    long version
    long serviceTypeId
    String description
    long daysForFree
    Date activationDate
    boolean isActive
    Date createDate
    long createdBy

    static constraints = {
        createDate     type : 'date'
        activationDate     type : 'date'
        description (nullable: true)
    }
    static mapping = {
        serviceTypeId index: 'service_charge_free_days_type_id_idx'
    }
}
