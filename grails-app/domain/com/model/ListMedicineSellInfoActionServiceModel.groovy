package com.model

class ListMedicineSellInfoActionServiceModel {

    public static final String MODEL_NAME = 'list_medicine_sell_info_action_service_model'
    public static final String SQL_LIST_SELL_INFO_MODEL = """
        CREATE OR REPLACE VIEW list_medicine_sell_info_action_service_model AS

                  SELECT msi.id, msi.version,msi.voucher_no,SUBSTRING(msi.voucher_no,2,2) AS hospital_code,
                    msi.total_amount, msi.sell_date,u.employee_name AS seller
                    FROM medicine_sell_info msi
                    LEFT JOIN login_auth.sec_user u ON u.id = msi.sell_by WHERE is_delete<>TRUE ;
    """

    long id
    long version
    String voucherNo
    String hospitalCode
    double totalAmount
    Date sellDate
    String seller

    static mapping = {
        cache usage: "read-only"
    }
    static constraints = {
    }
}
