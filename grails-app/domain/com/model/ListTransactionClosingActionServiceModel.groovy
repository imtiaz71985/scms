package com.model

class ListTransactionClosingActionServiceModel {

    public static final String MODEL_NAME = 'list_transaction_closing_action_service_model'
    public static final String LIST_TRANSACTION_CLOSING_ACTION_SERVICE_MODEL = """
     CREATE OR REPLACE VIEW list_transaction_closing_action_service_model AS
          SELECT tc.id,tc.version,tc.closing_date,tc.create_by,tc.create_date,tc.hospital_code,
          tc.is_transaction_closed,tc.remarks,su.employee_name AS creator
          FROM transaction_closing tc
          LEFT JOIN login_auth.sec_user su ON tc.create_by=su.id
          ORDER BY tc.closing_date DESC;
    """

    long id
    long version
    String remarks
    Date closingDate
    Date createDate
    long createBy
    String creator
    boolean isTransactionClosed
    String hospitalCode

    static mapping = {
        cache usage: "read-only"
    }
    static constraints = {
    }
}
