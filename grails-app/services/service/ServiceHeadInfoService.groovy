package service

import com.scms.ServiceHeadInfo
import grails.transaction.Transactional
import groovy.sql.GroovyRowResult
import scms.BaseService

@Transactional
class ServiceHeadInfoService extends  BaseService {

    public int countByNameIlikeAndServiceTypeId(String name,String typeIdStr){
        long typeId = Long.parseLong(typeIdStr)
        int count = ServiceHeadInfo.countByNameIlikeAndServiceTypeId(name,typeId)
        return count
    }
    public long serviceChargeIdByServiceType(long typeId){
        String queryStr = """
            SELECT sc.id AS chargeId FROM service_head_info sh LEFT JOIN service_charges sc ON  sh.service_code=sc.service_code
                WHERE sh.service_type_id=${typeId} AND sh.is_active=TRUE AND sc.activation_date<=CURRENT_DATE
            AND CURRENT_DATE BETWEEN sc.activation_date AND  COALESCE(sc.last_active_date,CURRENT_DATE)
                GROUP BY sc.service_code
        """
        List<GroovyRowResult> result = executeSelectSql(queryStr)
        long chargeId=(long)result[0].chargeId
        return chargeId
    }
    public  List<GroovyRowResult> serviceHeadInfoByType(long typeId){
        String queryStr=""
        if(typeId>0) {
            queryStr = """
             SELECT sh.service_code AS serviceCode,sc.id, 0 AS VERSION,sh.name,sc.charge_amount AS chargeAmount,sh.service_type_id AS serviceTypeId,
 st.name AS serviceTypeName,sc.activation_date AS activationDate,sh.is_active AS isActive
 FROM service_head_info sh INNER JOIN service_charges sc ON sh.service_code=sc.service_code
 LEFT JOIN service_type st ON sh.service_type_id=st.id WHERE sh.is_active=TRUE AND sc.activation_date<=CURRENT_DATE
 AND CURRENT_DATE BETWEEN sc.activation_date AND  COALESCE(sc.last_active_date,CURRENT_DATE) AND sh.service_type_id=${typeId}
 GROUP BY sc.service_code ORDER BY  st.name, sh.name ASC;
        """
        }
        else {
            queryStr = """
             SELECT sh.service_code AS serviceCode,sc.id, 0 AS VERSION,sh.name,sc.charge_amount AS chargeAmount,sh.service_type_id AS serviceTypeId,
 st.name AS serviceTypeName,sc.activation_date AS activationDate,sh.is_active AS isActive
 FROM service_head_info sh INNER JOIN service_charges sc ON sh.service_code=sc.service_code
 LEFT JOIN service_type st ON sh.service_type_id=st.id WHERE sh.is_active=TRUE AND sc.activation_date<=CURRENT_DATE
 AND CURRENT_DATE BETWEEN sc.activation_date AND  COALESCE(sc.last_active_date,CURRENT_DATE)
 GROUP BY sc.service_code ORDER BY  st.name, sh.name ASC;
        """
        }
        List<GroovyRowResult> result = executeSelectSql(queryStr)

        return result
    }
    public  List<GroovyRowResult> serviceHeadInfoList(){
        String queryStr = """
           SELECT sh.service_code AS serviceCode,sc.id, 0 AS VERSION,sh.name,sc.charge_amount AS chargeAmount,sh.service_type_id AS serviceTypeId
,st.name AS serviceTypeName,sc.activation_date AS activationDate,sh.is_active AS isActive FROM service_head_info sh LEFT JOIN
(SELECT MAX(COALESCE(last_active_date,CURRENT_DATE)) AS last_active_date,id,service_code,charge_amount,activation_date
 FROM service_charges GROUP BY service_code ORDER BY service_code DESC) AS sc
ON sh.service_code=sc.service_code LEFT JOIN service_type st ON sh.service_type_id=st.id ORDER BY  st.name, sh.name ASC;
        """

        List<GroovyRowResult> result = executeSelectSql(queryStr)

        return result
    }
}
