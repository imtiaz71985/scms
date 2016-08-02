package service

import grails.transaction.Transactional
import groovy.sql.GroovyRowResult
import scms.BaseService

@Transactional
class RequisitionService extends BaseService {

    public List<GroovyRowResult> listOfMedicine(String requisitionNo, hospitalCode) {
        String queryStr = """
                SELECT mi.id AS id,mi.version,mi.id AS medicineId,generic_name AS genericName,se.name AS type,
                        (CASE
                    WHEN mi.strength IS NULL THEN mi.brand_name
                    ELSE CONCAT(mi.brand_name,' (',mi.strength,')')
                         END) AS medicineName,
                        mi.unit_price AS unitPrice,mi.unit_type AS unitType,ms.stock_qty AS stockQty,
                        COALESCE(rq.req_qty,0) AS reqQty ,0 AS approveQty,0 AS procQty,COALESCE(rq.amount,0) AS amount
                FROM medicine_info mi
                LEFT JOIN system_entity se ON mi.type=se.id
                LEFT JOIN requisition_details rq ON rq.medicine_id = mi.id AND rq.req_no = :requisitionNo
                LEFT JOIN medicine_stock ms ON ms.medicine_id=mi.id  AND ms.hospital_code = :hospitalCode
                ORDER BY rq.amount DESC,mi.brand_name ASC
        """
        Map queryParams = [
                hospitalCode : hospitalCode,
                requisitionNo: requisitionNo
        ]
        List<GroovyRowResult> result = executeSelectSql(queryStr, queryParams)
        return result
    }

    public List<GroovyRowResult> listOfMedicineHO(String requisitionNo) {
        String queryStr = """
                SELECT mi.id AS id,mi.version,mi.id AS medicineId,generic_name AS genericName,se.name AS type,
                         (CASE
                    WHEN mi.strength IS NULL THEN mi.brand_name
                    ELSE CONCAT(mi.brand_name,' (',mi.strength,')')
                         END) AS medicineName,
                        mi.unit_price AS unitPrice,mi.unit_type AS unitType,ms.stock_qty AS stockQty,
                        COALESCE(rq.req_qty,0) AS reqQty ,COALESCE(rq.req_qty,0) AS approvedQty,0 AS procQty,
                        COALESCE(rq.amount,0) AS amount,
                        (CASE WHEN rq.approve_amount=0 THEN COALESCE(rq.amount,0) ELSE COALESCE(rq.approve_amount,0) END)
                         AS approveAmount
                FROM medicine_info mi
                LEFT JOIN system_entity se ON mi.type=se.id
                LEFT JOIN medicine_stock ms on ms.medicine_id=mi.id AND ms.hospital_code = SUBSTRING(:requisitionNo,2,2)
                LEFT JOIN requisition_details rq ON rq.medicine_id = mi.id AND rq.req_no = :requisitionNo
                ORDER BY rq.amount DESC,mi.brand_name ASC
        """
        Map queryParams = [requisitionNo: requisitionNo]
        List<GroovyRowResult> result = executeSelectSql(queryStr, queryParams)
        return result
    }
    public List<GroovyRowResult> listOfMedicineForReceive(String requisitionNo,long vendorId){
        String queryStr =""
        if(vendorId<=0) {

            queryStr = """
                SELECT rd.id AS id,rd.version,mi.id AS medicineId,generic_name AS genericName,se.name AS type,
                         (CASE
                    WHEN mi.strength IS NULL THEN mi.brand_name
                    ELSE CONCAT(mi.brand_name,' (',mi.strength,')')
                         END) AS medicineName,
            mi.unit_price AS unitPrice,mi.unit_type AS unitType,COALESCE(rd.req_qty,0) AS reqQty,
             mi.unit_price AS unitPrice,mi.unit_type AS unitType,COALESCE(rd.req_qty,0) AS reqQty,
            COALESCE(rd.approved_qty) AS approvedQty,COALESCE(rd.procurement_qty) AS procQty,COALESCE(SUM(receive_details.receive_qty),0) AS prevReceiveQty ,
            (rd.approved_qty - COALESCE(SUM(receive_details.receive_qty),0)) AS receiveQty,
            ROUND(((rd.approved_qty - COALESCE(SUM(receive_details.receive_qty),0))*mi.unit_price),2) AS amount,'' AS remarks
            FROM requisition r INNER JOIN requisition_details rd ON r.req_no=rd.req_no AND rd.req_no  =:requisitionNo
            AND r.is_approved=TRUE AND r.is_delivered=TRUE
            INNER JOIN medicine_info mi ON rd.medicine_id = mi.id
            LEFT JOIN system_entity se ON mi.type=se.id
            LEFT JOIN receive ON receive.req_no=r.req_no LEFT JOIN receive_details ON receive.id=receive_details.receive_id
            AND receive_details.medicine_id= rd.medicine_id GROUP BY r.req_no,rd.medicine_id
            ORDER BY mi.brand_name
        """
        }
        else{
            queryStr = """
                SELECT rd.id AS id,rd.version,mi.id AS medicineId,generic_name AS genericName,se.name AS type,
                         (CASE
                    WHEN mi.strength IS NULL THEN mi.brand_name
                    ELSE CONCAT(mi.brand_name,' (',mi.strength,')')
                         END) AS medicineName,
             mi.unit_price AS unitPrice,mi.unit_type AS unitType, COALESCE(rd.req_qty,0) AS reqQty,
            COALESCE(rd.approved_qty) AS approvedQty,COALESCE(rd.procurement_qty) AS procQty,COALESCE(SUM(receive_details.receive_qty),0) AS prevReceiveQty ,
            (rd.approved_qty - COALESCE(SUM(receive_details.receive_qty),0)) AS receiveQty,
            ROUND(((rd.approved_qty - COALESCE(SUM(receive_details.receive_qty),0))*mi.unit_price),2) AS amount,'' AS remarks
            FROM requisition r INNER JOIN requisition_details rd ON r.req_no=rd.req_no AND rd.req_no  =:requisitionNo
            AND r.is_approved=TRUE AND r.is_delivered=TRUE
            INNER JOIN medicine_info mi ON rd.medicine_id = mi.id AND mi.vendor_id=:vendorId
            LEFT JOIN system_entity se ON mi.type=se.id
            LEFT JOIN receive ON receive.req_no=r.req_no LEFT JOIN receive_details ON receive.id=receive_details.receive_id
            AND receive_details.medicine_id= rd.medicine_id GROUP BY r.req_no,rd.medicine_id
            ORDER BY mi.brand_name
        """
        }

        Map queryParams = [ requisitionNo : requisitionNo ]
        List<GroovyRowResult> result = executeSelectSql(queryStr, queryParams)
        return result
    }

    public List<GroovyRowResult> listOfDeliveredMedicine(String hospitalCode) {
        String queryStr = """
                SELECT r.id,r.version, r.req_no AS requisitionNo,r.create_date AS requisitionDate, u.username AS requisitionBy,
                      r.total_amount AS reqAmount,r.is_approved AS isApproved,au.username AS approvedBy,r.approved_date AS approvedDate,r.is_send AS isSend,
                      r.approved_amount AS approvedAmount,r.delivery_date AS deliveryDate
                            FROM requisition r
                            LEFT JOIN sec_user u ON u.id = r.created_by
                            LEFT JOIN sec_user au ON au.id = r.approved_by
                            WHERE r.is_approved=TRUE AND r.is_delivered=TRUE  AND u.hospital_code=${hospitalCode}
                                    AND r.is_received=FALSE
                      ORDER BY r.id ASC;
        """

        List<GroovyRowResult> result = executeSelectSql(queryStr)
        return result
    }

    public List<GroovyRowResult> listRequisitionNoForReceive(String hospitalCode, String vendorId) {
        String queryForList = ""
        if (vendorId.isEmpty() || vendorId == null) {
            queryForList = """
             SELECT req_no as id, req_no as name FROM requisition
                WHERE is_received=FALSE AND is_approved=TRUE
                     AND hospital_code=${hospitalCode}
                 ORDER BY id DESC
        """
        } else {
            queryForList = """
            SELECT DISTINCT r.req_no as id, r.req_no as name FROM requisition r
                INNER JOIN requisition_details rd ON  r.req_no=rd.req_no
                INNER JOIN medicine_info mi ON rd.medicine_id=mi.id
            WHERE r.is_received=FALSE
                    AND r.is_approved=TRUE
                    AND r.hospital_code=${hospitalCode}
                    AND mi.vendor_id=${vendorId}
                     ORDER BY id DESC
        """
        }
        List<GroovyRowResult> lstMedicine = executeSelectSql(queryForList)
        return lstMedicine
    }
}
