package com.model

class ListRequisitionReceiveActionServiceModel {
    public static final String MODEL_NAME = 'list_requisition_action_service_model'
    public static final String SQL_LIST_REQUISITION_RECEIVE_MODEL = """
        CREATE OR REPLACE VIEW list_requisition_receive_action_service_model AS

            SELECT rq.id,rq.version, rq.req_no AS requisition_no,au.username AS requisition_by,rq.create_date AS requisition_date,
                   hl.name AS location, rq.approved_date,rq.is_received AS is_action_complete,
                   CASE WHEN rcv.req_no=r.req_no THEN TRUE ELSE FALSE END AS receive_in_process
                        FROM requisition rq
                        LEFT JOIN receive rcv ON rcv.req_no=rq.req_no
                        LEFT JOIN receive r ON r.req_no=rq.req_no
                        LEFT JOIN hospital_location hl ON hl.code = rq.hospital_code
                        LEFT JOIN sec_user au ON au.id = rq.created_by
                        WHERE rq.is_send = TRUE
                        GROUP BY rq.req_no
                  ORDER BY rq.is_received,rq.id DESC;
    """

    long id
    long version
    String requisitionNo
    Date requisitionDate
    Date approvedDate
    String requisitionBy
    boolean isActionComplete
    boolean receiveInProcess
    String location

    static mapping = {
        cache usage: "read-only"
    }
    static constraints = {
    }
}
