package com.scms

class ReferralCenter {
    long id
    long version
    String name
    String address
    boolean isActive
    static constraints = {
        address (nullable: true)
    }
}
