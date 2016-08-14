package com.scms

class SubsidyOnMedicine {

    long id
    long version
    long medicineId
    double subsidyPert
    Date start
    Date end
    boolean isActive

    static constraints = {
        end(nullable: true)
    }
}
