package service

import com.scms.SecUser
import com.scms.SystemEntity
import grails.transaction.Transactional
import groovy.sql.GroovyRowResult
import scms.BaseService
import scms.utility.DateUtility

@Transactional
class SystemEntityService extends BaseService {

    public SystemEntity read(long id){
        return SystemEntity.read(id)
    }

    public int countByNameIlikeAndType(String name,String type){
        int count = SystemEntity.countByNameIlikeAndType(name,type)
        return count
    }

    public int countByNameIlikeAndTypeAndIdNotEqual(String name,String type,long id){
        int count = SystemEntity.countByNameIlikeAndTypeAndIdNotEqual(name,type, id)
        return count
    }
    public List<GroovyRowResult> listServedAndTotalPatient(Date date, String hospitalCode){

        String hospital_rp = EMPTY_SPACE
        String hospital_ri = EMPTY_SPACE
        String hospital_sti = EMPTY_SPACE

        Date toDate = DateUtility.getSqlToDateWithSeconds(date);
        Date fromDate = DateUtility.getSqlFromDateWithSeconds(date);

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

        String queryForList = """

                SELECT c.date_field AS id,DATE_FORMAT(c.date_field,'%d-%m-%Y') AS name
                 ,(COALESCE((SELECT COUNT( DISTINCT rp.id) FROM revisit_patient rp WHERE DATE(rp.create_date)=c.date_field
               """ + hospital_rp + """ GROUP BY DATE(rp.create_date)),0) +
                COALESCE((SELECT COUNT(DISTINCT ri.reg_no) FROM registration_info ri
                WHERE DATE(ri.create_date)=c.date_field AND ri.is_old_patient=FALSE
                """ + hospital_ri + """ GROUP BY DATE(ri.create_date)),0)) AS total_patient
                ,COALESCE((SELECT COUNT(DISTINCT sti.reg_no) FROM service_token_info sti WHERE DATE(sti.service_date)=c.date_field
                """ + hospital_sti + """ AND sti.is_deleted=FALSE),0)AS total_served
                FROM calendar c
                WHERE c.date_field BETWEEN '${fromDate}' AND '${toDate}'
                ORDER BY c.date_field ASC

        """

        List<GroovyRowResult> lst = executeSelectSql(queryForList)
        return lst
    }
}
