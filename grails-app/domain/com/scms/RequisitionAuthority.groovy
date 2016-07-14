package com.scms

class RequisitionAuthority {

    long id
    long version
    String name
    String designation
    String locationCode
    long rightsId
    boolean isActive

    static constraints = {
        isActive(nullable: true)
    }
}
