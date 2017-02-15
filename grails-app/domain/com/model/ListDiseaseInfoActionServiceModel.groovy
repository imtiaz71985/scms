package com.model

class ListDiseaseInfoActionServiceModel {

    public static final String MODEL_NAME = 'list_disease_info_action_service_model'
    public static final String SQL_LIST_SYSTEM_ENTITY_MODEL = """
         CREATE OR REPLACE VIEW list_disease_info_action_service_model AS
             SELECT di.disease_code,di.disease_code AS id,0 AS VERSION, di.name,dg.id AS disease_group_id,dg.name AS disease_group_name,
              di.description,di.is_active,COALESCE(se.id,0) AS applicable_to, COALESCE(se.name,'ALL') AS applicable_to_name
              ,(SELECT COALESCE(charge_amount,0) FROM service_charges WHERE SUBSTRING(service_code,4,LENGTH(service_code))=dg.id
                            AND SUBSTRING(service_code,3,1)='D'  AND last_active_date IS NULL) AS group_charge_amount,
                 CASE WHEN (SELECT COALESCE(charge_amount,0) FROM service_charges WHERE SUBSTRING(service_code,4,LENGTH(service_code))=dg.id
                            AND SUBSTRING(service_code,3,1)='D'  AND last_active_date IS NULL)>0 THEN (SELECT COALESCE(charge_amount,0) FROM service_charges WHERE SUBSTRING(service_code,4,LENGTH(service_code))=dg.id
                            AND SUBSTRING(service_code,3,1)='D'  AND last_active_date IS NULL) ELSE
                 COALESCE((SELECT charge_amount FROM service_charges WHERE SUBSTRING(service_code,4,LENGTH(service_code))=di.disease_code
                            AND SUBSTRING(service_code,3,1)='D'  AND last_active_date IS NULL),0) END AS charge_amount,
                (SELECT activation_date FROM service_charges WHERE SUBSTRING(service_code,4,LENGTH(service_code))=dg.id
                            AND SUBSTRING(service_code,3,1)='D'  AND last_active_date IS NULL) AS activation_date

              FROM disease_info di
              LEFT JOIN disease_group dg ON di.disease_group_id=dg.id
              LEFT JOIN system_entity se ON se.id=di.applicable_to
              ORDER BY di.name ASC;
    """

    long id
    long version
    String diseaseCode
    String name
    String description
    long diseaseGroupId
    long applicableTo
    String diseaseGroupName
    String applicableToName
    boolean isActive
    double chargeAmount
    double groupChargeAmount
    Date activationDate


    static mapping = {
        cache usage: "read-only"
    }
    static constraints = {
    }
}
