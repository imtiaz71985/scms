package service

import grails.transaction.Transactional
import groovy.sql.GroovyRowResult
import scms.BaseService

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

    public List<GroovyRowResult> getTotalChargeByListOfDiseaseCode(String groupCode) {
        String queryStr = """

               SELECT sc.id, 0 AS VERSION,sc.charge_amount AS chargeAmount,sc.service_code,
                    sc.activation_date AS activationDate
                        FROM  service_charges sc
                    WHERE sc.activation_date<=CURRENT_DATE
                    AND CURRENT_DATE BETWEEN sc.activation_date AND  COALESCE(sc.last_active_date,CURRENT_DATE) AND SUBSTRING(sc.service_code,3,1)='D'
                    AND SUBSTRING(sc.service_code,4,LENGTH(sc.service_code)) IN (${groupCode})
                    ORDER BY sc.service_code ASC
        """

        List<GroovyRowResult> result = executeSelectSql(queryStr)

        return result

    }

}
