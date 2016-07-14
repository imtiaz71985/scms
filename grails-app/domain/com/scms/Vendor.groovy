package com.scms

class Vendor {

    long id
    long version
    String name
    String shortName
    String address


    static constraints = {
        shortName(nullable: true)
        address(nullable: true)
    }
}
