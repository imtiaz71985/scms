package service

import com.scms.RegistrationInfo
import com.scms.SecUser
import grails.transaction.Transactional
import groovy.sql.GroovyRowResult
import scms.utility.DateUtility

import java.sql.Timestamp
import java.text.SimpleDateFormat

@Transactional
class RegistrationInfoService {

    def springSecurityService
    def baseService

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

        List<GroovyRowResult> rowResults = baseService.executeSelectSql(queryStr)
        return [unionId: rowResults[0].unionId,upazilaId: rowResults[0].upazilaId,districtId: rowResults[0].districtId]
    }
}
