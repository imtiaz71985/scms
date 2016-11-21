package service

import grails.transaction.Transactional
import groovy.sql.GroovyRowResult
import scms.BaseService

@Transactional
class ServiceTokenRelatedInfoService extends BaseService{

    public List<GroovyRowResult> getTotalHealthServiceCharge(String tokenNo){
        String queryStr = """
            SELECT st.reg_no,sh.service_type_id,SUM(sc.charge_amount) AS totalHealthCharge FROM service_token_info st
            LEFT JOIN token_and_charge_mapping tcm ON tcm.service_token_no=st.service_token_no
            LEFT JOIN service_charges sc
            ON tcm.service_charge_id=sc.id LEFT JOIN service_head_info sh ON sc.service_code=sh.service_code
            WHERE tcm.service_token_no='${tokenNo}' GROUP BY tcm.service_token_no,sh.service_type_id,reg_no ORDER BY sh.service_type_id ASC
        """
        List<GroovyRowResult> result = executeSelectSql(queryStr)
        return result
    }
    public String findLastTokenNoByRegNo(String regNo){
        String queryStr = """
            SELECT service_token_no FROM service_token_info  WHERE reg_no='${regNo}' ORDER BY service_date DESC LIMIT 1
        """
        List<GroovyRowResult> result = executeSelectSql(queryStr)
        String service_token_no=(String)result[0].service_token_no
        return service_token_no
    }
    public List<GroovyRowResult> getDiseaseOfReferenceTokenNo(String tokenNo){
        String queryStr = """
            SELECT di.name AS diseaseName,di.disease_code,CAST(SUBSTRING(di.disease_code,1,2) AS UNSIGNED ) AS groupId FROM token_and_disease_mapping  tdm
            JOIN disease_info di ON tdm.disease_code=di.disease_code
                WHERE tdm.service_token_no='${tokenNo}'  LIMIT 1;
        """
        List<GroovyRowResult> result = executeSelectSql(queryStr)
        return result
    }
    public List<GroovyRowResult> RegAndServiceDetails(Date start,Date end, String hospital_code){
        String queryStr =""
        String hospital_str = EMPTY_SPACE
        if(!hospital_code.isEmpty()) {
            hospital_str=" SUBSTRING(sti.service_token_no,2,2)='${hospital_code}' AND "
        }
            queryStr = """

                    SELECT  ri.date_of_birth AS dateOfBirth,ri.reg_no AS regNo,ri.patient_name AS patientName,ri.mobile_no AS mobileNo,
                  COALESCE(sti.service_token_no,'') AS serviceTokenNo,CONVERT(sti.service_date,DATE) AS serviceDate,sti.subsidy_amount AS subsidyAmount,
                  SUM( CASE WHEN SUBSTRING(sc.service_code,1,2)='02' THEN sc.charge_amount ELSE 0 END) AS consultancyAmt,
                  SUM(CASE WHEN SUBSTRING(sc.service_code,1,2)='03' THEN sc.charge_amount ELSE 0 END )AS pathologyAmt,
                  COALESCE(SUM(sc.charge_amount)-sti.subsidy_amount,0) AS totalCharge,
                  (CASE WHEN sti.visit_type_id=3 AND tcm.service_charge_id>0 AND SUBSTRING(sc.service_code,1,2)='03' THEN 'Follow-up, Pathology Service'
                        WHEN sti.visit_type_id=3 AND (tcm.service_charge_id IS NULL OR SUBSTRING(sc.service_code,1,2)='02') THEN 'Follow-up'
                        ELSE COALESCE(GROUP_CONCAT(DISTINCT st.name),'') END) AS serviceType

                   FROM registration_info ri
                  INNER JOIN service_token_info sti ON ri.reg_no=sti.reg_no
                  LEFT JOIN token_and_charge_mapping tcm ON tcm.service_token_no=sti.service_token_no
                  LEFT JOIN service_charges sc ON tcm.service_charge_id=sc.id
                  LEFT JOIN service_type st ON CAST(SUBSTRING(sc.service_code,1,2)AS UNSIGNED)=st.id
                  WHERE ${hospital_str} sti.service_date BETWEEN '${start}' AND '${end}'  AND sti.is_deleted <> TRUE
                   GROUP BY sti.service_token_no
                   ORDER BY sti.service_date ASC
        """

        List<GroovyRowResult> result = executeSelectSql(queryStr)

        return result
    }

    public List<GroovyRowResult> getTokenDetails(String tokenNo){
        String queryStr = """
        SELECT ri.patient_name,sti.reg_no, sti.service_token_no,DATE_FORMAT(sti.service_date,'%d-%m-%y') AS serviceDate,
            (CASE WHEN sti.visit_type_id=3 AND tcm.service_charge_id>0 AND SUBSTRING(sc.service_code,1,2)='03' THEN 'Follow-up, Pathology Service'
                        WHEN sti.visit_type_id=3 AND (tcm.service_charge_id IS NULL OR SUBSTRING(sc.service_code,1,2)='02') THEN 'Follow-up'
                        ELSE COALESCE(GROUP_CONCAT(DISTINCT st.name),'') END) AS serviceType,
            ri.date_of_birth AS date_of_birth,se.name AS gender,
            CONCAT('Vill:',COALESCE(v.name,''),', Union:',COALESCE(u.name,''),', Upazila:',COALESCE(up.name,''),', Dist:',COALESCE(d.name,'')) AS address,
           sp.name AS service_provider,sti.prescription_type,rc.name AS referral_center,
            (SELECT COALESCE(GROUP_CONCAT(di.name),'')   FROM token_and_disease_mapping tdm
                    LEFT JOIN disease_info di ON tdm.disease_code=di.disease_code
                WHERE tdm.service_token_no=sti.service_token_no) AS disease,
                 COALESCE(GROUP_CONCAT(shi.name),'') AS diagnosis_info,
                sti.subsidy_amount AS subsidyAmount,
                  SUM( CASE WHEN SUBSTRING(sc.service_code,1,2)='02' THEN sc.charge_amount ELSE 0 END) AS consultancyAmt,
                  SUM(CASE WHEN SUBSTRING(sc.service_code,1,2)='03' THEN sc.charge_amount ELSE 0 END )AS pathologyAmt,
                  COALESCE(SUM(sc.charge_amount)-sti.subsidy_amount,0) AS totalCharge,'' as remarks
              FROM service_token_info sti
              LEFT JOIN token_and_charge_mapping tcm ON tcm.service_token_no=sti.service_token_no
              LEFT JOIN service_charges sc ON tcm.service_charge_id=sc.id
              LEFT JOIN service_type st ON CAST(SUBSTRING(sc.service_code,1,2)AS UNSIGNED)=st.id
              JOIN registration_info ri ON ri.reg_no = sti.reg_no
              LEFT JOIN village v ON v.id = ri.village_id
              LEFT JOIN st_union u ON v.union_id=u.id
              LEFT JOIN upazila up ON u.upazila_id=up.id
              LEFT JOIN district d ON up.district_id=d.id
              LEFT JOIN service_provider sp ON sp.id = sti.service_provider_id
              LEFT JOIN referral_center rc ON rc.id = sti.referral_center_id
              LEFT JOIN system_entity se ON ri.sex_id=se.id
              LEFT JOIN service_head_info shi ON shi.service_code=sc.service_code

          WHERE sti.service_token_no='${tokenNo}'
          GROUP BY sti.service_token_no
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
    public List<GroovyRowResult> dateWiseConsultancyDetails(Date start,Date end, String hospital_code){
        String hospital_str = EMPTY_SPACE
        if(hospital_code!='') {
            if(hospital_code!=ALL) {
                hospital_str = "AND ri.hospital_code = '${hospital_code}' "
            }
        }
        String queryStr = """
            SELECT tcm.id,tcm.version,tcm.service_token_no,sti.reg_no,ri.patient_name,ri.date_of_birth,se.name AS gender,
                     COALESCE(GROUP_CONCAT(di.name),'Counselor Service') AS consultancy_info,
                    ri.mobile_no,DATE(tcm.service_date) AS service_date,
                    CONCAT('Vill:',COALESCE(v.name,''),', Union:',COALESCE(u.name,''),', Upazila:',COALESCE(up.name,''),', Dist:',COALESCE(d.name,'')) AS address,
                    sc.charge_amount AS consultancy_amt
                        FROM token_and_charge_mapping tcm
                            JOIN service_token_info sti ON sti.service_token_no=tcm.service_token_no
                            JOIN registration_info ri ON ri.reg_no = sti.reg_no
                            LEFT JOIN village v ON v.id = ri.village_id
                            LEFT JOIN st_union u ON v.union_id=u.id
                            LEFT JOIN upazila up ON u.upazila_id=up.id
                            LEFT JOIN district d ON up.district_id=d.id
                            LEFT JOIN system_entity se ON ri.sex_id=se.id
                            RIGHT JOIN service_charges sc ON sc.id = tcm.service_charge_id AND (LEFT(sc.service_code,2)='02' OR LEFT(sc.service_code,2)='04')
                            LEFT JOIN token_and_disease_mapping tdm ON tdm.service_token_no = sti.service_token_no
                            LEFT JOIN disease_info di ON di.disease_code=tdm.disease_code
                        WHERE  sti.is_deleted <> TRUE AND sti.visit_type_id<>3 AND tcm.service_date BETWEEN '${start}' AND '${end}'
                              ${hospital_str}
                        GROUP BY tcm.service_token_no
        """
        List<GroovyRowResult> result = executeSelectSql(queryStr)

        return result
    }
    public List<GroovyRowResult> dateWiseSubsidyDetails(Date start,Date end, String hospital_code){
        String hospital_str = EMPTY_SPACE
        if(hospital_code!='') {
            if(hospital_code!=ALL) {
                hospital_str = "AND ri.hospital_code = '${hospital_code}' "
            }
        }
        String queryStr = """
               SELECT tcm.id,tcm.version,tcm.service_token_no,sti.reg_no,ri.patient_name,ri.date_of_birth,se.name AS gender,
                    ri.mobile_no,DATE(tcm.service_date) AS service_date,
                    CONCAT('Vill:',COALESCE(v.name,''),', Union:',COALESCE(u.name,''),', Upazila:',COALESCE(up.name,''),', Dist:',COALESCE(d.name,'')) AS address,
                    sti.subsidy_amount AS subsidy_amt
                        FROM token_and_charge_mapping tcm
                            JOIN service_token_info sti ON sti.service_token_no=tcm.service_token_no
                            JOIN registration_info ri ON ri.reg_no = sti.reg_no
                            LEFT JOIN village v ON v.id = ri.village_id
                            LEFT JOIN st_union u ON v.union_id=u.id
                            LEFT JOIN upazila up ON u.upazila_id=up.id
                            LEFT JOIN district d ON up.district_id=d.id
                            LEFT JOIN system_entity se ON ri.sex_id=se.id
                        WHERE sti.subsidy_amount!= 0  AND sti.is_deleted <> TRUE AND tcm.service_date BETWEEN '${start}' AND '${end}'
                             ${hospital_str}
                        GROUP BY tcm.service_token_no
        """
        List<GroovyRowResult> result = executeSelectSql(queryStr)
        return result
    }
    public List<GroovyRowResult> dateWiseDiagnosisDetails(Date start,Date end, String hospital_code){
        String hospital_str = EMPTY_SPACE
        if(hospital_code!='') {
            if(hospital_code!=ALL) {
                hospital_str = "AND ri.hospital_code = '${hospital_code}' "
            }
        }
        String queryStr = """
             SELECT tcm.id,tcm.version,tcm.service_token_no,sti.reg_no,ri.patient_name,ri.date_of_birth,se.name AS gender,
                    COALESCE(GROUP_CONCAT(di.name),'Followup') AS consultancy_info,ri.mobile_no,DATE(tcm.service_date) AS service_date,
                    COALESCE(GROUP_CONCAT(shi.name),'') AS diagnosis_info,SUM(sc.charge_amount) AS diagnosis_amt,
                    CONCAT('Vill:',COALESCE(v.name,''),', Union:',COALESCE(u.name,''),', Upazila:',COALESCE(up.name,''),', Dist:',COALESCE(d.name,'')) AS address
                        FROM token_and_charge_mapping tcm
                            LEFT JOIN service_token_info sti ON sti.service_token_no=tcm.service_token_no
                            LEFT JOIN registration_info ri ON ri.reg_no = sti.reg_no
                            LEFT JOIN village v ON v.id = ri.village_id
                            LEFT JOIN st_union u ON v.union_id=u.id
                            LEFT JOIN upazila up ON u.upazila_id=up.id
                            LEFT JOIN district d ON up.district_id=d.id
                            LEFT JOIN system_entity se ON ri.sex_id=se.id
                            RIGHT JOIN service_charges sc ON sc.id = tcm.service_charge_id
                                AND LEFT(sc.service_code,2)='03'
                            LEFT JOIN token_and_disease_mapping tdm ON tdm.service_token_no = tcm.service_token_no
                            LEFT JOIN disease_info di ON di.disease_code=tdm.disease_code
                            LEFT JOIN service_head_info shi ON shi.service_code=sc.service_code
                        WHERE  sti.is_deleted <> TRUE AND tcm.service_date BETWEEN '${start}' AND '${end}'
                            ${hospital_str}
                        GROUP BY tcm.service_token_no
        """
        List<GroovyRowResult> result = executeSelectSql(queryStr)

        return result
    }
    public List<GroovyRowResult> getDiseaseByGroupIdForDDL(long groupId){
        String queryStr = """
                SELECT CONCAT(name,'(',disease_code,')') AS name , disease_code AS id FROM disease_info
                WHERE disease_group_id=${groupId} AND is_active=TRUE ORDER BY NAME ASC
        """
        List<GroovyRowResult> result = executeSelectSql(queryStr)
        return result
    }
    public List<GroovyRowResult> monthlyPathologySummary(String start,String end, String hospital_code){
        String hospital_str = EMPTY_SPACE
        if(hospital_code!='') {
            if(hospital_code!=ALL) {
                hospital_str = "AND SUBSTRING(sti.service_token_no,2,2) = '${hospital_code}' "
            }
        }
        String queryStr = """
             SELECT c.date_field,tbl.pathology_name,tbl.pathology_count,tbl.charge_amount,tbl.total
                        FROM (SELECT DATE_FORMAT(date_field,'%Y') AS yr,MONTH(date_field) AS mnth,date_field FROM calendar
                        WHERE date_field BETWEEN '${start}' AND '${end}' GROUP BY DATE_FORMAT(date_field,'%Y'),MONTH(date_field) ) c
                        LEFT JOIN
                        (SELECT DATE_FORMAT(tcm.service_date,'%Y') AS yr,MONTH(tcm.service_date) AS mnth,tcm.service_charge_id
                        ,shi.name AS pathology_name,
                        COALESCE(COUNT(tcm.service_charge_id),0) AS pathology_count,sc.charge_amount,COALESCE(SUM(sc.charge_amount),0) AS total
                         FROM token_and_charge_mapping tcm
                            LEFT JOIN service_token_info sti ON sti.service_token_no=tcm.service_token_no
                            JOIN service_charges sc ON sc.id = tcm.service_charge_id AND LEFT(sc.service_code,2)='03'
                            JOIN service_head_info shi ON shi.service_code=sc.service_code
                            WHERE sti.is_deleted <> TRUE AND tcm.service_date BETWEEN '${start}' AND '${end}'
                            ${hospital_str}
                            GROUP BY yr,mnth,tcm.service_charge_id
                            ) tbl ON c.yr= tbl.yr AND c.mnth =tbl.mnth

                        ORDER BY c.yr,c.mnth, tbl.pathology_count DESC


        """
        List<GroovyRowResult> result = executeSelectSql(queryStr)

        return result
    }
    public List<GroovyRowResult> RegAndOldServiceDetails(String hospital_code){
        String queryStr =""
        String hospital_str = EMPTY_SPACE
        if(!hospital_code.isEmpty()) {
            hospital_str=" WHERE SUBSTRING(sti.service_token_no,2,2)='${hospital_code}' "
        }
        queryStr = """

                    SELECT  ri.date_of_birth AS dateOfBirth,ri.reg_no AS regNo,ri.patient_name AS patientName,ri.mobile_no AS mobileNo,
                  COALESCE(sti.service_token_no,'') AS serviceTokenNo,CONVERT(sti.service_date,DATE) AS serviceDate,sti.subsidy_amount AS subsidyAmount,
                  SUM( CASE WHEN SUBSTRING(sc.service_code,1,2)='02' THEN sc.charge_amount ELSE 0 END) AS consultancyAmt,
                  SUM(CASE WHEN SUBSTRING(sc.service_code,1,2)='03' THEN sc.charge_amount ELSE 0 END )AS pathologyAmt,
                  COALESCE(SUM(sc.charge_amount)-sti.subsidy_amount,0) AS totalCharge,
                  (CASE WHEN sti.visit_type_id=3 AND tcm.service_charge_id>0 AND SUBSTRING(sc.service_code,1,2)='03' THEN 'Follow-up, Pathology Service'
                        WHEN sti.visit_type_id=3 AND (tcm.service_charge_id IS NULL OR SUBSTRING(sc.service_code,1,2)='02') THEN 'Follow-up'
                        ELSE COALESCE(GROUP_CONCAT(DISTINCT st.name),'') END) AS serviceType,sti.is_approved,sti.remarks,sti.is_decline,
                   hl.name AS hospitalName, u.username AS CreatedBy

                   FROM registration_info ri
                  INNER JOIN old_service_token_info sti ON ri.reg_no=sti.reg_no
                  LEFT JOIN old_token_and_charge_mapping tcm ON tcm.service_token_no=sti.service_token_no
                  LEFT JOIN service_charges sc ON tcm.service_charge_id=sc.id
                  LEFT JOIN service_type st ON CAST(SUBSTRING(sc.service_code,1,2)AS UNSIGNED)=st.id
                  LEFT JOIN sec_user u ON u.id = sti.create_by
                  LEFT JOIN hospital_location hl ON hl.code = u.hospital_code
                   ${hospital_str}
                   GROUP BY sti.service_token_no
                   ORDER BY sti.create_date DESC

        """

        List<GroovyRowResult> result = executeSelectSql(queryStr)

        return result
    }
    public List<GroovyRowResult> getOldTokenDetails(String tokenNo){
        String queryStr = """
       SELECT ri.patient_name,sti.reg_no, sti.service_token_no,DATE_FORMAT(sti.service_date,'%d-%m-%y') AS serviceDate,
            (CASE WHEN sti.visit_type_id=3 AND tcm.service_charge_id>0 AND SUBSTRING(sc.service_code,1,2)='03' THEN 'Follow-up, Pathology Service'
                        WHEN sti.visit_type_id=3 AND (tcm.service_charge_id IS NULL OR SUBSTRING(sc.service_code,1,2)='02') THEN 'Follow-up'
                        ELSE COALESCE(GROUP_CONCAT(DISTINCT st.name),'') END) AS serviceType,
            ri.date_of_birth AS date_of_birth,se.name AS gender,
            CONCAT('Vill:',COALESCE(v.name,''),', Union:',COALESCE(u.name,''),', Upazila:',COALESCE(up.name,''),', Dist:',COALESCE(d.name,'')) AS address,
           sp.name AS service_provider,sti.prescription_type,rc.name AS referral_center,
            (SELECT COALESCE(GROUP_CONCAT(di.name),'')   FROM old_token_and_disease_mapping tdm
                    LEFT JOIN disease_info di ON tdm.disease_code=di.disease_code
                WHERE tdm.service_token_no=sti.service_token_no) AS disease,
                 COALESCE(GROUP_CONCAT(shi.name),'') AS diagnosis_info,
                sti.subsidy_amount AS subsidyAmount,
                  SUM( CASE WHEN SUBSTRING(sc.service_code,1,2)='02' THEN sc.charge_amount ELSE 0 END) AS consultancyAmt,
                  SUM(CASE WHEN SUBSTRING(sc.service_code,1,2)='03' THEN sc.charge_amount ELSE 0 END )AS pathologyAmt,
                  COALESCE(SUM(sc.charge_amount)-sti.subsidy_amount,0) AS totalCharge,sti.remarks
              FROM old_service_token_info sti
              LEFT JOIN old_token_and_charge_mapping tcm ON tcm.service_token_no=sti.service_token_no
              LEFT JOIN service_charges sc ON tcm.service_charge_id=sc.id
              LEFT JOIN service_type st ON CAST(SUBSTRING(sc.service_code,1,2)AS UNSIGNED)=st.id
              JOIN registration_info ri ON ri.reg_no = sti.reg_no
              LEFT JOIN village v ON v.id = ri.village_id
              LEFT JOIN st_union u ON v.union_id=u.id
              LEFT JOIN upazila up ON u.upazila_id=up.id
              LEFT JOIN district d ON up.district_id=d.id
              LEFT JOIN service_provider sp ON sp.id = sti.service_provider_id
              LEFT JOIN referral_center rc ON rc.id = sti.referral_center_id
              LEFT JOIN system_entity se ON ri.sex_id=se.id
              LEFT JOIN service_head_info shi ON shi.service_code=sc.service_code

          WHERE sti.service_token_no='${tokenNo}'
          GROUP BY sti.service_token_no
        """
        List<GroovyRowResult> result = executeSelectSql(queryStr)
        return result
    }
}
