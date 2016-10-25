package com.model

class ListServiceChargeFreeDaysActionServiceModel {
    public static final String MODEL_NAME = 'list_service_charge_free_days_action_service_model'
    public static final String SQL_LIST_SYSTEM_ENTITY_MODEL = """

CREATE OR REPLACE VIEW  list_service_charge_free_days_action_service_model AS
                 SELECT scf.id,scf.version,scf.service_type_id,scf.is_active,scf.description,scf.days_for_free,
                 scf.activation_date,st.name AS service_type_name
                FROM service_charge_free_days scf LEFT JOIN service_type st ON scf.service_type_id=st.id
                ORDER BY scf.create_date DESC
    """

    long id
    long version
    long serviceTypeId
    String serviceTypeName
    String description
    long daysForFree
    Date activationDate
    boolean isActive

    static mapping = {
        cache usage: "read-only"
    }
    static constraints = {
    }
}
