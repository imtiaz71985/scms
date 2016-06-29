package service

import grails.transaction.Transactional
import groovy.sql.GroovyRowResult
import scms.BaseService

@Transactional
class RequisitionService extends BaseService {

    public List<GroovyRowResult> listOfMedicine(){
        String queryStr = """

           SELECT mi.id,mi.version,generic_name AS genericName , CONCAT(se.name,'-',mi.brand_name,'-',mi.strength) AS medicineName,
mi.unit_price AS unitPrice,mi.unit_type AS unitType,mi.stock_qty AS stockQty,0 AS reqQty ,0 AS approveQty,0 AS procQty,0 AS amount
FROM medicine_info mi LEFT JOIN system_entity se ON mi.type=se.id ORDER BY mi.brand_name
        """
        List<GroovyRowResult> result = executeSelectSql(queryStr)
        //double totalHealthCharge=(double) result[0].totalHealthCharge
        return result
    }
}
