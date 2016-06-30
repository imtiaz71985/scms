package service

import grails.transaction.Transactional
import groovy.sql.GroovyRowResult
import scms.BaseService

@Transactional
class RequisitionService extends BaseService {

    public List<GroovyRowResult> listOfMedicine(String requisitionNo){
        String queryStr = """
                SELECT mi.id AS id,mi.version,mi.id AS medicineId,generic_name AS genericName,
                        (CASE
                    WHEN mi.strength IS NULL THEN CONCAT(mi.brand_name,' -',se.name)
                    ELSE CONCAT(mi.brand_name,' (',mi.strength,') -',se.name)
                         END) AS medicineName,
                        mi.unit_price AS unitPrice,mi.unit_type AS unitType,mi.stock_qty AS stockQty,
                        COALESCE(rq.req_qty,0) AS reqQty ,0 AS approveQty,0 AS procQty,COALESCE(rq.amount,0) AS amount
                FROM medicine_info mi
                LEFT JOIN system_entity se ON mi.type=se.id
                LEFT JOIN requisition_details rq ON rq.medicine_id = mi.id AND rq.req_no = :requisitionNo
                ORDER BY mi.brand_name
        """
        Map queryParams = [ requisitionNo : requisitionNo ]
        List<GroovyRowResult> result = executeSelectSql(queryStr, queryParams)
        return result
    }
    public List<GroovyRowResult> listOfRegMedicineForReceive(String requisitionNo){
        String queryStr = """
                SELECT rd.id AS id,rd.version,mi.id AS medicineId,generic_name AS genericName,
            (CASE
            WHEN mi.strength IS NULL THEN CONCAT(mi.brand_name,' -',se.name)
            ELSE CONCAT(mi.brand_name,' (',mi.strength,') -',se.name)
            END) AS medicineName,
            mi.unit_price AS unitPrice,mi.unit_type AS unitType,mi.stock_qty AS stockQty,COALESCE(rd.req_qty,0) AS reqQty,
            COALESCE(rd.approved_qty) AS approveQty,COALESCE(rd.procurement_qty) AS procQty,COALESCE(rd.procurement_qty) AS receiveQty
            FROM requisition r INNER JOIN requisition_details rd ON r.req_no=rd.req_no AND rd.req_no = :requisitionNo
            AND r.is_approved=TRUE AND r.is_delivered=TRUE
            INNER JOIN medicine_info mi ON rd.medicine_id = mi.id
            LEFT JOIN system_entity se ON mi.type=se.id
            ORDER BY mi.brand_name
        """
        Map queryParams = [ requisitionNo : requisitionNo ]
        List<GroovyRowResult> result = executeSelectSql(queryStr, queryParams)
        return result
    }
}
