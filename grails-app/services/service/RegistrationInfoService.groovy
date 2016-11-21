package service

import com.scms.RegistrationInfo
import com.scms.SecUser
import grails.transaction.Transactional
import groovy.sql.GroovyRowResult
import scms.BaseService
import scms.utility.DateUtility

import java.sql.Timestamp
import java.text.SimpleDateFormat

@Transactional
class RegistrationInfoService extends BaseService {

    def springSecurityService

    public RegistrationInfo read(String regNo){
        return RegistrationInfo.read(regNo)
    }

    public String retrieveRegNo() {
        Timestamp fromDate = DateUtility.getSqlFromDateWithSeconds(new Date())
        Timestamp toDate = DateUtility.getSqlToDateWithSeconds(new Date())
        String hospital_code= SecUser.read(springSecurityService.principal.id)?.hospitalCode
        int c = RegistrationInfo.countByCreateDateBetweenAndHospitalCode(fromDate, toDate,hospital_code)
        c+=1
        String DATE_FORMAT = "ddMMyy";
        SimpleDateFormat sdf = new SimpleDateFormat(DATE_FORMAT);
        Calendar c1 = Calendar.getInstance(); // today
        String regNo=sdf.format(c1.getTime())
        String patientNo= (c<10? '00' : c<100? '0' : '')+c.toString()
        regNo=hospital_code+regNo+patientNo
        return regNo
    }

    public Map getAddressDetails(long villageId) {

        String queryStr = """
            SELECT u.id AS unionId,up.id AS upazilaId,d.id AS districtId
              FROM village v
              LEFT JOIN st_union u ON v.union_id=u.id
                      LEFT JOIN upazila up ON u.upazila_id=up.id
                      LEFT JOIN district d ON up.district_id=d.id
                      WHERE v.id=${villageId};
        """

        List<GroovyRowResult> rowResults = executeSelectSql(queryStr)
        return [unionId: rowResults[0].unionId,upazilaId: rowResults[0].upazilaId,districtId: rowResults[0].districtId]
    }
    public List<GroovyRowResult> listOfPatientServedDetails(String hospitalCode, Date date){

        String hospital_sti = EMPTY_SPACE

        if (hospitalCode.length() > 1) {
            hospital_sti = """
               AND SUBSTRING(sti.service_token_no,2,2)='${hospitalCode}'
            """

        }
        String queryStr = """
                SELECT dateOfBirth,regNo,patientName,mobileNo,gender,GROUP_CONCAT(serviceType) AS serviceType FROM (
                    SELECT  ri.date_of_birth AS dateOfBirth,ri.reg_no AS regNo,ri.patient_name AS patientName,ri.mobile_no AS mobileNo,se.name AS gender,

                  (CASE WHEN sti.visit_type_id=3 AND tcm.service_charge_id>0 AND SUBSTRING(sc.service_code,1,2)='03' THEN 'Follow-up, Pathology Service'
                        WHEN sti.visit_type_id=3 AND (tcm.service_charge_id IS NULL OR SUBSTRING(sc.service_code,1,2)='02') THEN 'Follow-up'
                        ELSE COALESCE(GROUP_CONCAT(DISTINCT st.name),'') END) AS serviceType

                   FROM registration_info ri
                  INNER JOIN service_token_info sti ON ri.reg_no=sti.reg_no
                  LEFT JOIN token_and_charge_mapping tcm ON tcm.service_token_no=sti.service_token_no
                  LEFT JOIN service_charges sc ON tcm.service_charge_id=sc.id
                  LEFT JOIN service_type st ON CAST(SUBSTRING(sc.service_code,1,2)AS UNSIGNED)=st.id
                   LEFT JOIN system_entity se ON ri.sex_id=se.id
                  WHERE DATE(sti.service_date) = '${date}' AND sti.is_deleted <> TRUE """+hospital_sti+"""
                  GROUP BY sti.service_token_no ) tbl GROUP BY tbl.regNo
                   ORDER BY tbl.patientName ASC
        """

        List<GroovyRowResult> result = executeSelectSql(queryStr)

        return result
    }
    public List<GroovyRowResult> listOfPatientServedSummary(String hospitalCode, Date fromDate, Date toDate) {
        String hospital_rp = EMPTY_SPACE
        String hospital_ri = EMPTY_SPACE
        String hospital_sti = EMPTY_SPACE

        if (hospitalCode.length() > 1) {
            hospital_rp = """
                AND rp.hospital_code='${hospitalCode}'
            """
            hospital_ri = """
               AND ri.hospital_code='${hospitalCode}'
            """
            hospital_sti = """
               AND SUBSTRING(sti.service_token_no,2,2)='${hospitalCode}'
            """

        }
        String queryStr = """
               SELECT c.id,c.version,c.date_field,c.holiday_status,c.is_holiday,COUNT(DISTINCT ri.reg_no) AS new_patient,COUNT(DISTINCT rp.id) AS patient_revisit,
                (COUNT( DISTINCT ri.reg_no)+COUNT(DISTINCT rp.id)) AS total_patient
                 ,COUNT(DISTINCT sti.reg_no) AS total_served
                FROM calendar c
                 LEFT JOIN revisit_patient rp ON c.date_field=DATE(rp.create_date) """+hospital_rp+"""
                 LEFT JOIN registration_info ri ON c.date_field=DATE(ri.create_date) AND ri.is_old_patient=FALSE """+hospital_ri+"""
                 LEFT JOIN service_token_info sti ON c.date_field=DATE(sti.service_date) """+hospital_sti+""" AND sti.is_deleted=FALSE

                WHERE c.date_field BETWEEN '${fromDate}' AND '${toDate}' GROUP BY c.date_field
                ORDER BY c.date_field ASC
        """

        List<GroovyRowResult> result = executeSelectSql(queryStr)

        return result
    }
    public String patientServed(){
        String hospital_code = SecUser.read(springSecurityService.principal.id)?.hospitalCode
        Date fromDate,toDate
        fromDate=DateUtility.getSqlFromDateWithSeconds(new Date())
        toDate=DateUtility.getSqlToDateWithSeconds(new Date())
        List<GroovyRowResult> lst = listOfPatientServedSummary(hospital_code,fromDate,toDate)
        String msg='Registered: '+lst[0].total_patient+'; Served: '+lst[0].total_served
        return msg
    }
    public List<GroovyRowResult> listOfRevisitPatient(String hospitalCode, Date fromDate, Date toDate) {
        String hospital_rp = EMPTY_SPACE


        if (hospitalCode.length() > 1) {

            hospital_rp = """
               AND rp.hospital_code='${hospitalCode}'
            """
        }
        String queryStr = """
               SELECT ri.reg_no AS id,0 AS version, ri.date_of_birth dateOfBirth,ri.father_or_mother_name fatherOrMotherName,ri.patient_name patientName,ri.reg_no regNo,SUBSTRING(ri.reg_no,1,2) AS hospitalCode,ri.mobile_no mobileNo,
                      CONCAT('Vill:',v.name,', Union:',u.name,', Upazila:',up.name,', Dist:',d.name) AS address,ri.create_date createDate,DATE(rp.create_date) AS revisitDate,
                      se.name AS maritalStatus,ri.marital_status_id maritalStatusId,se1.name AS sex,ri.sex_id sexId,ri.village_id AS village,u.id AS unionId,up.id AS upazilaId,d.id AS districtId
                      FROM registration_info ri
                      JOIN revisit_patient rp ON rp.reg_no = ri.reg_no
                      LEFT JOIN village v ON ri.village_id=v.id
                      LEFT JOIN st_union u ON v.union_id=u.id
                      LEFT JOIN upazila up ON u.upazila_id=up.id
                      LEFT JOIN district d ON up.district_id=d.id
                      LEFT JOIN system_entity se ON ri.marital_status_id=se.id
                      LEFT JOIN system_entity se1 ON ri.sex_id=se1.id
                      WHERE ri.is_active!=FALSE AND rp.create_date BETWEEN '${fromDate}' AND '${toDate}'
                       """+hospital_rp+""" ORDER BY rp.create_date DESC;
        """

        List<GroovyRowResult> result = executeSelectSql(queryStr)

        return result
    }
    public List<GroovyRowResult> listOfRegNoByDate(String hospitalCode, Date fromDate, Date toDate) {

        String queryStr = """
               SELECT DISTINCT ri.reg_no AS id, CONCAT(ri.reg_no,' (',ri.patient_name,')') AS name
            FROM registration_info ri LEFT JOIN revisit_patient rp ON ri.reg_no=rp.reg_no
            WHERE ri.is_active = TRUE  AND SUBSTRING(ri.reg_no,1,2)='${hospitalCode}' AND
            (ri.create_date BETWEEN '${fromDate}' AND '${toDate}' OR rp.create_date BETWEEN '${fromDate}' AND '${toDate}')
            ORDER BY ri.create_date DESC;
        """

        List<GroovyRowResult> result = executeSelectSql(queryStr)

        return result
    }
}
