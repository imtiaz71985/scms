package com.scms

class Vendor {

    long id
    long version
    String name
    String address


    static constraints = {
        address(nullable: true)
    }
}
