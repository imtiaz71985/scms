package com.model

class ListReferralCenterActionServiceModel {
    public static final String MODEL_NAME = 'list_referral_center_action_service_model'
    public static final String SQL_LIST_SYSTEM_ENTITY_MODEL = """
        CREATE OR REPLACE VIEW list_referral_center_action_service_model AS
          SELECT id,VERSION, NAME,address,is_active FROM referral_center
          ORDER BY id DESC;
    """

    long id
    long version
    String name
    String address
    boolean isActive
    static mapping = {
        cache usage: "read-only"
    }
    static constraints = {
    }
}
