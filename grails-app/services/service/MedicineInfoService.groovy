package service

import grails.transaction.Transactional
import groovy.sql.GroovyRowResult
import scms.BaseService

@Transactional
class MedicineInfoService extends BaseService {

    public  List<GroovyRowResult> listOfMedicineShortageInStock(String hospitalCode){
        String queryStr = """
SELECT mi.id, mi.version,se.name AS type,mi.generic_name AS genericName,
                 (CASE
                 WHEN mi.strength IS NOT NULL THEN CONCAT(mi.brand_name,' (',mi.strength,')')
                 ELSE mi.brand_name END) AS medicineName,
                 mi.unit_type AS unitType,mi.unit_price AS unitPrice,mi.mrp_price AS mrpPrice, v.name AS vendorName,
                 COALESCE(mi.warn_qty,0) AS warnQty ,COALESCE(ms.stock_qty,0) AS stockQty,ms.expiry_date AS expiryDate
                    FROM medicine_info mi
                    LEFT JOIN system_entity se ON se.id=mi.type
                    LEFT JOIN vendor v ON v.id=mi.vendor_id
                    LEFT JOIN medicine_stock ms ON ms.medicine_id = mi.id
                    WHERE  COALESCE(ms.stock_qty,0)<=COALESCE(mi.warn_qty,0) AND ms.hospital_code='${hospitalCode}'
                    ORDER BY mi.brand_name ASC;
        """

        List<GroovyRowResult> result = executeSelectSql(queryStr)

        return result
    }
}
