package com.model

class ListMedicineReturnSellActionServiceModel {

    public static final String MODEL_NAME = 'list_medicine_return_sell_action_service_model'
    public static final String SQL_LIST_SELL_RETURN_MODEL = """
           CREATE OR REPLACE VIEW list_medicine_return_sell_action_service_model AS

                  SELECT mr.id, mr.version, mr.trace_no,mr.return_date,mr.hospital_code,mr.total_amount,u.full_name AS return_by,mr.return_type_id,se.name as return_type
                    FROM medicine_return mr
                    LEFT JOIN sec_user u ON u.id= mr.return_by
                    LEFT JOIN system_entity se ON se.id=mr.return_type_id
    """

    long id
    long version
    String traceNo
    String hospitalCode
    double totalAmount
    Date returnDate
    String returnBy
    long returnTypeId
    String returnType

    static mapping = {
        cache usage: "read-only"
    }
    static constraints = {
    }
}
