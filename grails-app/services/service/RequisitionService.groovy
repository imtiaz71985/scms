package service

import grails.transaction.Transactional
import groovy.sql.GroovyRowResult
import scms.BaseService

@Transactional
class RequisitionService extends BaseService {

    public List<GroovyRowResult> listOfMedicine(String requisitionNo){
        String queryStr = """
                SELECT mi.id AS id,mi.version,mi.id AS medicineId,generic_name AS genericName,se.name AS type,
                        (CASE
                    WHEN mi.strength IS NULL THEN mi.brand_name
                    ELSE CONCAT(mi.brand_name,' (',mi.strength,')')
                         END) AS medicineName,
                        mi.unit_price AS unitPrice,mi.unit_type AS unitType,mi.stock_qty AS stockQty,
                        COALESCE(rq.req_qty,0) AS reqQty ,0 AS approveQty,0 AS procQty,COALESCE(rq.amount,0) AS amount
                FROM medicine_info mi
                LEFT JOIN system_entity se ON mi.type=se.id
                LEFT JOIN requisition_details rq ON rq.medicine_id = mi.id AND rq.req_no = :requisitionNo
                ORDER BY rq.amount DESC,mi.brand_name ASC
        """
        Map queryParams = [ requisitionNo : requisitionNo ]
        List<GroovyRowResult> result = executeSelectSql(queryStr, queryParams)
        return result
    }
    public List<GroovyRowResult> listOfMedicineHO(String requisitionNo){
        String queryStr = """
                SELECT mi.id AS id,mi.version,mi.id AS medicineId,generic_name AS genericName,se.name AS type,
                         (CASE
                    WHEN mi.strength IS NULL THEN mi.brand_name
                    ELSE CONCAT(mi.brand_name,' (',mi.strength,')')
                         END) AS medicineName,
                        mi.unit_price AS unitPrice,mi.unit_type AS unitType,mi.stock_qty AS stockQty,
                        COALESCE(rq.req_qty,0) AS reqQty ,COALESCE(rq.req_qty,0) AS approvedQty,0 AS procQty,
                        COALESCE(rq.amount,0) AS amount,
                        (CASE WHEN rq.approve_amount=0 THEN COALESCE(rq.amount,0) ELSE COALESCE(rq.approve_amount,0) END)
                         AS approveAmount
                FROM medicine_info mi
                LEFT JOIN system_entity se ON mi.type=se.id
                LEFT JOIN requisition_details rq ON rq.medicine_id = mi.id AND rq.req_no = :requisitionNo
                ORDER BY rq.amount DESC,mi.brand_name ASC
        """
        Map queryParams = [ requisitionNo : requisitionNo ]
        List<GroovyRowResult> result = executeSelectSql(queryStr, queryParams)
        return result
    }
    public List<GroovyRowResult> listOfRegMedicineForReceive(String requisitionNo){
        String queryStr = """
                SELECT rd.id AS id,rd.version,mi.id AS medicineId,generic_name AS genericName,se.name AS type,
                         (CASE
                    WHEN mi.strength IS NULL THEN mi.brand_name
                    ELSE CONCAT(mi.brand_name,' (',mi.strength,')')
                         END) AS medicineName,
            mi.unit_price AS unitPrice,mi.unit_type AS unitType,mi.stock_qty AS stockQty,COALESCE(rd.req_qty,0) AS reqQty,
            COALESCE(rd.approved_qty) AS approvedQty,COALESCE(rd.procurement_qty) AS procQty,COALESCE(rd.procurement_qty) AS receiveQty,0 AS amount
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
    public List<GroovyRowResult> listOfDeliveredMedicine(String hospitalCode){
        String queryStr = """

 SELECT r.id,r.version, r.req_no AS requisitionNo,r.create_date AS requisitionDate, u.username AS requisitionBy,
                      r.total_amount AS reqAmount,r.is_approved AS isApproved,au.username AS approvedBy,r.approved_date AS approvedDate,r.is_send AS isSend,
                      r.approved_amount AS approvedAmount,r.delivery_date AS deliveryDate
                            FROM requisition r
                            LEFT JOIN sec_user u ON u.id = r.created_by
                            LEFT JOIN sec_user au ON au.id = r.approved_by
                            WHERE r.is_approved=TRUE AND r.is_delivered=TRUE  AND u.hospital_code=${hospitalCode} AND r.is_received=FALSE
                      ORDER BY r.id ASC;
        """

        List<GroovyRowResult> result = executeSelectSql(queryStr)
        return result
    }
}
