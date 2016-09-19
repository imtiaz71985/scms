package service

import com.scms.ServiceHeadInfo
import com.scms.TokenAndChargeMapping
import grails.transaction.Transactional
import groovy.sql.GroovyRowResult
import scms.BaseService

import java.sql.Timestamp

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
    public String getDiseaseOfReferenceTokenNo(String tokenNo){
        String queryStr = """
            SELECT COALESCE(GROUP_CONCAT(di.name),'')  AS disease FROM token_and_disease_mapping  tdm
            JOIN disease_info di ON tdm.disease_code=di.disease_code
                WHERE tdm.service_token_no='${tokenNo}'
        """
        List<GroovyRowResult> result = executeSelectSql(queryStr)
        String diseaseInfo=(String)result[0].disease
        return diseaseInfo
    }
    public List<GroovyRowResult> RegAndServiceDetails(Date start,Date end, String hospital_code){
        String queryStr =""
        if(hospital_code.isEmpty()) {
            queryStr = """
            SELECT  ri.date_of_birth AS dateOfBirth,ri.reg_no AS regNo,ri.patient_name AS patientName,ri.mobile_no AS mobileNo,
                  COALESCE(st.is_exit,FALSE) AS isExit,
                  COALESCE(st.service_token_no,'') AS serviceTokenNo,CONVERT(st.service_date,DATE) AS serviceDate,st.subsidy_amount AS subsidyAmount,
                  SUM( CASE WHEN SUBSTRING(sc.service_code,1,2)='02' THEN sc.charge_amount ELSE 0 END) AS consultancyAmt,
                  SUM(CASE WHEN SUBSTRING(sc.service_code,1,2)='03' THEN sc.charge_amount ELSE 0 END )AS pathologyAmt,
                  COALESCE(SUM(sc.charge_amount)-st.subsidy_amount,0) AS totalCharge,
                  (SELECT CASE WHEN COALESCE(GROUP_CONCAT(NAME),'')='' THEN 'Follow Up' ELSE COALESCE(GROUP_CONCAT(NAME),'') END
                   FROM service_type WHERE (CASE WHEN id<10 THEN CONCAT(0,id) ELSE id END)
                  IN ( SELECT SUBSTRING(sc.service_code,1,2) FROM token_and_charge_mapping tcm
                   LEFT JOIN service_charges sc ON tcm.service_charge_id=sc.id WHERE tcm.service_token_no=st.service_token_no)) AS serviceType
                   FROM registration_info ri
                  INNER JOIN service_token_info st ON ri.reg_no=st.reg_no
                  LEFT JOIN token_and_charge_mapping tcm ON tcm.service_token_no=st.service_token_no
                  LEFT JOIN service_charges sc ON tcm.service_charge_id=sc.id
                  WHERE st.service_date BETWEEN '${start}' AND '${end}' OR st.modify_date BETWEEN '${start}' AND '${end}'
                   GROUP BY st.service_token_no
                   ORDER BY isExit,serviceDate ASC
        """
        }
        else {
            queryStr = """
           SELECT  ri.date_of_birth AS dateOfBirth,ri.reg_no AS regNo,ri.patient_name AS patientName,ri.mobile_no AS mobileNo,
                  COALESCE(st.is_exit,FALSE) AS isExit,
                  COALESCE(st.service_token_no,'') AS serviceTokenNo,CONVERT(st.service_date,DATE) AS serviceDate,st.subsidy_amount AS subsidyAmount,
                  SUM( CASE WHEN SUBSTRING(sc.service_code,1,2)='02' THEN sc.charge_amount ELSE 0 END) AS consultancyAmt,
                  SUM(CASE WHEN SUBSTRING(sc.service_code,1,2)='03' THEN sc.charge_amount ELSE 0 END )AS pathologyAmt,
                  COALESCE(SUM(sc.charge_amount)-st.subsidy_amount,0) AS totalCharge,
                  (SELECT CASE WHEN COALESCE(GROUP_CONCAT(NAME),'')='' THEN 'Follow Up' ELSE COALESCE(GROUP_CONCAT(NAME),'') END
                   FROM service_type WHERE (CASE WHEN id<10 THEN CONCAT(0,id) ELSE id END)
                   IN ( SELECT SUBSTRING(sc.service_code,1,2) FROM token_and_charge_mapping tcm
                   LEFT JOIN service_charges sc ON tcm.service_charge_id=sc.id WHERE tcm.service_token_no=st.service_token_no)) AS serviceType
                   FROM registration_info ri
                  INNER JOIN service_token_info st ON ri.reg_no=st.reg_no
                  LEFT JOIN token_and_charge_mapping tcm ON tcm.service_token_no=st.service_token_no
                  LEFT JOIN service_charges sc ON tcm.service_charge_id=sc.id
                  WHERE SUBSTRING(st.service_token_no,2,2)='${hospital_code}'
                    AND st.service_date BETWEEN '${start}' AND '${end}' OR st.modify_date BETWEEN '${start}' AND '${end}'
                   GROUP BY st.service_token_no
                   ORDER BY isExit,serviceDate ASC
        """
        }
        List<GroovyRowResult> result = executeSelectSql(queryStr)

        return result
    }

    public List<GroovyRowResult> getTokenDetails(String tokenNo){
        String queryStr = """
        SELECT ri.patient_name,sti.reg_no, sti.service_token_no,sti.prescription_type,ri.date_of_birth AS date_of_birth,se.name AS gender,
            CONCAT('Vill:',COALESCE(v.name,''),', Union:',COALESCE(u.name,''),', Upazila:',COALESCE(up.name,''),', Dist:',COALESCE(d.name,'')) AS address,
            sp.name AS service_provider,rc.name AS referral_center,
            (SELECT COALESCE(GROUP_CONCAT(di.name),'')   FROM token_and_disease_mapping tdm
                    LEFT JOIN disease_info di ON tdm.disease_code=di.disease_code
                WHERE tdm.service_token_no=sti.service_token_no) AS disease
                FROM service_token_info sti
              LEFT JOIN registration_info ri ON ri.reg_no = sti.reg_no
              LEFT JOIN village v ON v.id = ri.village_id
              LEFT JOIN st_union u ON v.union_id=u.id
              LEFT JOIN upazila up ON u.upazila_id=up.id
              LEFT JOIN district d ON up.district_id=d.id
              LEFT JOIN service_provider sp ON sp.id = sti.service_provider_id
              LEFT JOIN referral_center rc ON rc.id = sti.referral_center_id
              LEFT JOIN system_entity se ON ri.sex_id=se.id
          WHERE sti.service_token_no='${tokenNo}'
        """
        List<GroovyRowResult> result = executeSelectSql(queryStr)
        return result
    }
    public boolean getDiseaseApplicableFor(String diseaseCodes,long sexId){
        String queryStr = """
           SELECT * FROM disease_info WHERE applicable_to!=0 and applicable_to!='${sexId}' AND disease_code IN (${diseaseCodes})
        """
        List<GroovyRowResult> result = executeSelectSql(queryStr)
        boolean isNotApplicable=false
        try {
            if (result.size()>0) {
                isNotApplicable = true
            }
        }catch(Exception ex){}
        return isNotApplicable
    }
    public List<GroovyRowResult> getReferenceTokenForFollowup(String regNo,Timestamp fromDate, Timestamp toDate){
        String queryStr = """
        SELECT DISTINCT sti.service_token_no AS serviceTokenNo FROM service_token_info sti JOIN token_and_charge_mapping tcm ON tcm.service_token_no=sti.service_token_no
        JOIN service_charges sc ON sc.id=tcm.service_charge_id
        WHERE sti.reg_no='${regNo}' AND sti.visit_type_id != 3
        AND sti.service_date BETWEEN '${fromDate}' AND '${toDate}'
        AND SUBSTRING(sc.service_code,1,2) NOT IN ('01','03','04','05')  ORDER BY sti.service_date DESC
        """
        List<GroovyRowResult> result = executeSelectSql(queryStr)
        return result
    }
}
