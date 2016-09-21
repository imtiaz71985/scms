package service

import grails.transaction.Transactional
import groovy.sql.GroovyRowResult
import scms.BaseService

@Transactional
class MedicineInfoService extends BaseService {

    public List<GroovyRowResult> listOfMedicineShortageInStock(String hospitalCode) {
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

    public List<GroovyRowResult> listOfMedicineWiseSalesWithStock(String hospitalCode, Date fromDate, Date toDate) {
        String isHospital = EMPTY_SPACE
        String hospitalRet=EMPTY_SPACE
        String hospitalStock=EMPTY_SPACE
        if (hospitalCode.length() > 1) {
            isHospital = """
                msi.hospital_code='${hospitalCode}' AND
            """
            hospitalRet = """
                mr.hospital_code='${hospitalCode}' AND
            """
            hospitalStock = """
                ms.hospital_code='${hospitalCode}' AND
            """
        }
        String queryStr = """
               SELECT mi.id, mi.version,se.name AS type,mi.generic_name AS genericName,
                 (CASE
                 WHEN mi.strength IS NOT NULL THEN CONCAT(mi.brand_name,' (',mi.strength,')')
                 ELSE mi.brand_name END) AS medicineName,
                 mi.unit_type AS unitType,mi.unit_price AS unitPrice,mi.mrp_price AS mrpPrice, v.short_name AS vendorName,
                 COALESCE(ms.stock_qty,0) AS stockQty,COALESCE(SUM(msid.quantity),0) AS saleQty, COALESCE(SUM(msid.amount),0) AS saleAmt,
                COALESCE(SUM(ret.quantity),0) AS returnQty, COALESCE(SUM(ret.amount),0) AS returnAmt
                    FROM medicine_sell_info msi
                    JOIN medicine_sell_info_details msid ON msi.voucher_no=msid.voucher_no
                    JOIN medicine_info mi ON msid.medicine_id=mi.id
                    LEFT JOIN system_entity se ON se.id=mi.type
                    LEFT JOIN vendor v ON v.id=mi.vendor_id
                    LEFT JOIN medicine_stock ms ON ms.medicine_id = mi.id """+hospitalStock+"""
                    LEFT JOIN (SELECT mrd.medicine_id,mrd.quantity,mrd.amount FROM medicine_return mr JOIN medicine_return_details mrd
                        ON mr.trace_no=mrd.trace_no WHERE """+hospitalRet+""" mr.return_date BETWEEN '${fromDate}' AND '${toDate}')ret
                    ON mi.id=ret.medicine_id
                    WHERE """+isHospital+""" msi.sell_date BETWEEN '${fromDate}' AND '${toDate}' GROUP BY msid.medicine_id
                    ORDER BY SUM(msid.amount) DESC;
        """

        List<GroovyRowResult> result = executeSelectSql(queryStr)

        return result
    }
}
