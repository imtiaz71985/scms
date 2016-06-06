package com.scms

class ServiceType {

    long id
    long version
    String name
    String description
    boolean isActive

    static constraints = {
        description(nullable: true)
    }

    static mapping = {
    }
}
