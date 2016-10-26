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
    public List<GroovyRowResult> listOfPatientAndService(String hospitalCode, Date fromDate, Date toDate) {
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
        List<GroovyRowResult> lst = listOfPatientAndService(hospital_code,fromDate,toDate)
        String msg='Registered: '+lst[0].total_patient+'; Served: '+lst[0].total_served
        return msg
    }
}
