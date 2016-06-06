package service

import com.scms.ServiceHeadInfo
import com.scms.TokenAndChargeMapping
import grails.transaction.Transactional
import groovy.sql.GroovyRowResult
import scms.BaseService

@Transactional
class ServiceTokenRelatedInfoService extends BaseService{

    public List<GroovyRowResult> getTotalHealthServiceCharge(String tokenNo){
        String queryStr = """

            SELECT st.reg_no,COALESCE(st.is_exit,FALSE) AS isExit,sh.service_type_id,SUM(sc.charge_amount) AS totalHealthCharge FROM service_token_info st
            LEFT JOIN token_and_charge_mapping tcm ON tcm.service_token_no=st.service_token_no
            LEFT JOIN service_charges sc
            ON tcm.service_charge_id=sc.id LEFT JOIN service_head_info sh ON sc.service_code=sh.service_code
            WHERE tcm.service_token_no='${tokenNo}' GROUP BY tcm.service_token_no,sh.service_type_id,reg_no ORDER BY sh.service_type_id ASC
        """
        List<GroovyRowResult> result = executeSelectSql(queryStr)
        //double totalHealthCharge=(double) result[0].totalHealthCharge
        return result
    }
    public String findLastTokenNoByRegNoAndIsExit(String regNo,boolean isExit){
        String queryStr = """
            SELECT service_token_no FROM service_token_info  WHERE reg_no='${regNo}' AND is_exit=${isExit} ORDER BY service_date DESC LIMIT 1
        """
        List<GroovyRowResult> result = executeSelectSql(queryStr)
        String service_token_no=(String)result[0].service_token_no
        return service_token_no
    }
    public List<GroovyRowResult> RegAndServiceDetails(Date start,Date end){
        String queryStr = """
            SELECT  ri.date_of_birth AS dateOfBirth,ri.reg_no AS regNo,ri.patient_name AS patientName,ri.mobile_no AS mobileNo,
                  COALESCE(st.is_exit,FALSE) AS isExit,
                  COALESCE(st.service_token_no,'') AS serviceTokenNo,st.service_date AS serviceDate,
                  COALESCE(( SELECT SUM(sc.charge_amount) AS Charge FROM token_and_charge_mapping tcm LEFT JOIN service_charges sc
   ON tcm.service_charge_id=sc.id WHERE tcm.service_token_no=st.service_token_no GROUP BY tcm.service_token_no),0) AS totalCharge
                   FROM registration_info ri
                  INNER JOIN service_token_info st ON ri.reg_no=st.reg_no
                  WHERE st.service_date BETWEEN '${start}' AND '${end}'
                   ORDER BY isExit,serviceDate ASC
        """
        List<GroovyRowResult> result = executeSelectSql(queryStr)

        return result
    }
}
