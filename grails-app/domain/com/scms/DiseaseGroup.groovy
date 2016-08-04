package com.scms

class DiseaseGroup {

    long id
    long version
    String name
    String description
    boolean isActive
    static constraints = {
        description (nullable: true)
    }
}
