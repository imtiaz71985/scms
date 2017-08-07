package com.scms

class UserDepartment {

    long id
    long version
    long userId
    long serviceId

    static mapping = {
        datasource 'mis'
    }
    static constraints = {
    }
}
