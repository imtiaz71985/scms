package com.model

class ListHospitalLocationActionServiceModel {

    public static final String MODEL_NAME = 'list_hospital_location_action_service_model'
    public static final String SQL_LIST_HOSPITAL_MODEL = """
        CREATE OR REPLACE VIEW list_hospital_location_action_service_model AS
                  SELECT id,version, name,address,code,is_clinic
                       FROM hospital_location
                  ORDER BY id  ASC;
    """

    long id
    long version
    String name
    String address
    String code
    boolean isClinic

    static mapping = {
        cache usage: "read-only"
    }
    static constraints = {
    }
}
