package com.model

class ListRequisitionActionServiceModel {

    public static final String MODEL_NAME = 'list_requisition_action_service_model'
    public static final String SQL_LIST_REQUISITION_MODEL = """
             CREATE OR REPLACE VIEW list_requisition_action_service_model AS

                      SELECT r.id,r.version, r.req_no as requisition_no,r.create_date AS requisition_date, u.username AS requisition_by,
                      r.total_amount,r.is_approved,au.username AS approved_by,r.approved_date,r.is_send,hl.code AS hospital_code,hl.name AS hospital_name
                            FROM requisition r
                            LEFT JOIN sec_user u ON u.id = r.created_by
                            LEFT JOIN hospital_location hl ON hl.code = u.hospital_code
                            LEFT JOIN sec_user au ON au.id = r.approved_by
                      ORDER BY r.id ASC;
    """

    long id
    long version
    String requisitionNo
    Date requisitionDate
    String requisitionBy

    Date approvedDate
    String approvedBy
    boolean isApproved
    boolean isSend
    double totalAmount
    String hospitalCode
    String hospitalName

    static mapping = {
        cache usage: "read-only"
    }
    static constraints = {
    }
}
