package com.scms

class HospitalLocation {
    long id
    long version
    String name
    String address
    String code

    static mapping = {}
    static constraints = {
        address nullable: true
    }
}
