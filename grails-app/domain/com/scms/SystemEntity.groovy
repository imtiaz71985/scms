package com.scms

class SystemEntity {

    long id
    long version
    String type
    String name
    String description

    static constraints = {
        description(nullable:true)
    }
}
