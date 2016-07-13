package com.model

class ListRequisitionAuthorityActionServiceModel {

    public static final String MODEL_NAME = 'list_requisition_authority_action_service_model'
    public static final String SQL_LIST_AUTHORITY_MODEL = """
        CREATE OR REPLACE VIEW list_requisition_authority_action_service_model AS

              SELECT ra.id, ra.version,ra.name,ra.designation,hl.name AS location,hl.code AS location_code,
                    se.id AS rights_id, se.name AS rights,ra.is_active
                    FROM requisition_authority ra
                    LEFT JOIN hospital_location hl ON hl.code=ra.location_code
                    LEFT JOIN system_entity se ON se.id=ra.rights_id
                    ORDER BY ra.id ASC;
    """

    long id
    long version
    String name
    String designation
    String location
    String rights
    String locationCode
    long rightsId
    boolean isActive

    static mapping = {
        cache usage: "read-only"
    }
}
