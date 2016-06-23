package com.scms

class MedicinePrice {

    long id
    long version
    long medicineId
    double price
    double mrpPrice
    Date start
    Date end
    boolean isActive

    static constraints = {
        end(nullable: true)
    }
}
