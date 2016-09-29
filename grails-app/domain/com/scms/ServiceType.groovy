package com.scms

class ServiceType {

    long id
    long version
    String name
    String description
    boolean isActive
    boolean isForCounselor

    static constraints = {
        description(nullable: true)
        isForCounselor(nullable: true)
    }

    static mapping = {

    }
}
