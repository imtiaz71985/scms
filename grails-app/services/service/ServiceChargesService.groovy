package service

import grails.transaction.Transactional
import groovy.sql.GroovyRowResult
import scms.BaseService
import sun.org.mozilla.javascript.internal.regexp.SubString

@Transactional
class ServiceChargesService extends BaseService {
    public List<GroovyRowResult> DiseaseInfoList() {
        String queryStr = """

                 SELECT dg.id,dg.VERSION, dg.name,dg.description AS Description,dg.is_active AS isActive,COALESCE(sc.charge_amount,0) AS chargeAmount,sc.activation_date AS activationDate
           FROM disease_group dg LEFT JOIN (SELECT MAX(COALESCE(last_active_date,CURRENT_DATE)) AS last_active_date,
                                        service_code,charge_amount,activation_date
                                        FROM service_charges
                                        GROUP BY service_code
                                        ORDER BY service_code DESC) AS sc
                                           ON dg.id=SUBSTRING(sc.service_code,4,LENGTH(sc.service_code))
                                           AND SUBSTRING(sc.service_code,3,1)='D'
          ORDER BY dg.name ASC;

        """

        List<GroovyRowResult> result = executeSelectSql(queryStr)

        return result
    }

    public List<GroovyRowResult> getTotalChargeByListOfDiseaseGroupId(Date serviceDate,String groupCode) {
        String queryStr = """

               SELECT sc.id, 0 AS VERSION,sc.charge_amount AS chargeAmount,sc.service_code,
                    sc.activation_date AS activationDate
                        FROM  service_charges sc
                    WHERE sc.activation_date<='${serviceDate}'
                    AND '${serviceDate}' BETWEEN sc.activation_date AND  COALESCE(sc.last_active_date,'${serviceDate}') AND SUBSTRING(sc.service_code,3,1)='D'
                    AND SUBSTRING(sc.service_code,4,LENGTH(sc.service_code)) IN (${groupCode})
                    ORDER BY sc.service_code ASC
        """

        List<GroovyRowResult> result = executeSelectSql(queryStr)

        return result

    }
    public  double chargeInfoByDiseaseGroupId(long diseaseGroupId) {
        String queryStr = """
                            SELECT COALESCE(charge_amount,0) AS chargeAmount,activation_date
                            FROM service_charges WHERE SUBSTRING(service_code,4,LENGTH(service_code))='${diseaseGroupId}'
                            AND SUBSTRING(service_code,3,1)='D'
                            AND last_active_date IS NULL

        """

        List<GroovyRowResult> result = executeSelectSql(queryStr)
        double d = Double.parseDouble(result[0].chargeAmount.toString())
        return d
    }

    public List<GroovyRowResult> getTotalChargeByDiseaseCode(Date serviceDate,String diseaseCode) {
        String queryStr = """

               SELECT sc.id, 0 AS VERSION,sc.charge_amount AS chargeAmount,sc.service_code,
                    sc.activation_date AS activationDate
                        FROM  service_charges sc
                    WHERE sc.activation_date<='${serviceDate}'
                    AND '${serviceDate}' BETWEEN sc.activation_date AND  COALESCE(sc.last_active_date,'${serviceDate}') AND SUBSTRING(sc.service_code,3,1)='D'
                    AND SUBSTRING(sc.service_code,4,LENGTH(sc.service_code)) = (${diseaseCode})
                    ORDER BY sc.service_code ASC
        """

        List<GroovyRowResult> result = executeSelectSql(queryStr)
if(result.size()<=0){
    result= getTotalChargeByListOfDiseaseGroupId(serviceDate,diseaseCode.substring(0,2))
}

        return result

    }
}
