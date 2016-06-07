package com.scms

class Calendar {

    Date dateField
    String holidayStatus
    Boolean isHoliday

    static mapping = {
        dateField type: 'date'
    }

    static constraints = {

    }
}
