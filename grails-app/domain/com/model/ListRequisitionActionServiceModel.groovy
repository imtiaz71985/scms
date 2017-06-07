package com.model

class ListRequisitionActionServiceModel {

    public static final String MODEL_NAME = 'list_requisition_action_service_model'
    public static final String SQL_LIST_REQUISITION_MODEL = """
              CREATE OR REPLACE VIEW list_requisition_action_service_model AS

                      SELECT r.id,r.version, r.req_no AS requisition_no,r.create_date AS requisition_date, u.username AS requisition_by,
                          ROUND(r.total_amount,2) AS total_amount,r.is_approved,au.username AS approved_by,r.approved_date,r.is_send,hl.code AS hospital_code,
                          hl.name AS hospital_name,ROUND(CASE WHEN r.is_approved=TRUE THEN r.approved_amount ELSE 0 END,2) AS approved_amount,r.is_generatepr,
                          r.is_received,CASE WHEN rcv.req_no=r.req_no THEN TRUE ELSE FALSE END AS receive_in_process
                                FROM requisition r
                                LEFT JOIN receive rcv ON rcv.req_no=r.req_no
                                LEFT JOIN sec_user u ON u.id = r.created_by
                                LEFT JOIN hospital_location hl ON hl.code = u.hospital_code
                                LEFT JOIN sec_user au ON au.id = r.approved_by
                                GROUP BY r.req_no
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
    boolean isReceived
    boolean receiveInProcess
    double totalAmount
    double approvedAmount
    String hospitalCode
    String hospitalName
    boolean isGeneratePR

    static mapping = {
        cache usage: "read-only"
    }
    static constraints = {
    }
}
