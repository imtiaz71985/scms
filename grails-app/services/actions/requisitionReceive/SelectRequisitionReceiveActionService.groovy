package actions.requisitionReceive

import com.scms.Requisition
import grails.converters.JSON
import grails.transaction.Transactional
import groovy.sql.GroovyRowResult
import org.apache.log4j.Logger
import scms.ActionServiceIntf
import scms.BaseService

@Transactional
class SelectRequisitionReceiveActionService extends BaseService implements ActionServiceIntf {

    private static final String NOT_FOUND_MASSAGE = "Selected record not found"
    private static final String REQUISITION_NO = "requisitionNo"
    private static final String GRID_MODEL_MEDICINE = "gridModelMedicine"

    private Logger log = Logger.getLogger(getClass())


    @Transactional(readOnly = true)
    public Map executePreCondition(Map params) {
        try {
            long id = Long.parseLong(params.id.toString())
            Requisition requisition = Requisition.read(id)
            if (!requisition) {
                return super.setError(params, NOT_FOUND_MASSAGE)
            }
            params.put(REQUISITION_NO, requisition.reqNo)
            return params
        } catch (Exception e) {
            log.error(e.getMessage())
            throw new RuntimeException(e)
        }
    }

    @Transactional(readOnly = true)
    public Map execute(Map result) {
        try {
            String requisitionNo = result.get(REQUISITION_NO)
            LinkedHashMap resultMap = getDetails(requisitionNo)
            List<GroovyRowResult> lst = resultMap.rowResults
            result.put(LIST, lst)
            return result
        } catch (Exception e) {
            log.error(e.getMessage())
            throw new RuntimeException(e)
        }
    }

    public Map executePostCondition(Map result) {
        return result
    }

    public Map buildSuccessResultForUI(Map result) {
        try {
            List<GroovyRowResult> lstMedicine = (List<GroovyRowResult>) result.get(LIST)
            Map gridObjects = wrapMedicineGrid(lstMedicine)
            result.put(GRID_MODEL_MEDICINE, gridObjects.lstMedicine as JSON)
            return result
        } catch (Exception e) {
            log.error(e.getMessage())
            throw new RuntimeException(e)
        }    }
    /**
     * Build failure result in case of any error
     * @param result -map returned from previous methods, can be null
     * @return -a map containing isError = true & relevant error message to display on page load
     */
    public Map buildFailureResultForUI(Map result) {
        return result
    }

    private LinkedHashMap getDetails(String requisitionNo) {

        String queryStr = """
            SELECT req.req_no,rec.create_date AS receive_date,rd.medicine_id,SUM(rd.receive_qty) AS receive_qty,
                md.generic_name,se.name AS TYPE,
                CASE WHEN md.strength IS NULL THEN md.brand_name ELSE CONCAT(md.brand_name,' (',md.strength,')') END AS medicine_name,
                COALESCE(v.short_name,v.name) AS vendor
                    FROM requisition req
                RIGHT JOIN receive rec ON rec.req_no = req.req_no
                LEFT JOIN receive_details rd ON rd.receive_id=rec.id
                LEFT JOIN medicine_info md ON md.id=rd.medicine_id
                LEFT JOIN vendor v ON v.id = md.vendor_id
                LEFT JOIN system_entity se ON se.id = md.type AND se.type="Medicine Type"
                    WHERE req.req_no = '${requisitionNo}'
                    GROUP BY rec.create_date,md.id
                ORDER BY rec.create_date,md.brand_name ASC;
        """

        List<GroovyRowResult> rowResults = executeSelectSql(queryStr)
        return [rowResults: rowResults]
    }

    private static Map wrapMedicineGrid(List<GroovyRowResult> lstMedicine) {
        List lstRows = []
        GroovyRowResult singleRow
        for (int i = 0; i < lstMedicine.size(); i++) {
            singleRow = lstMedicine[i]
            Date receiveDate  = singleRow.receive_date
            String medicineName = singleRow.medicine_name
            String vendor       = singleRow.vendor
            String type         = singleRow.type
            String genericName  = singleRow.generic_name
            int receiveQty      = singleRow.receive_qty

            Map eachDetails = [
                    receiveDate   : receiveDate,
                    type          : type,
                    genericName   : genericName,
                    medicineName  : medicineName,
                    vendor        : vendor,
                    receiveQty    : receiveQty
            ]
            lstRows << eachDetails
        }
        return [lstMedicine: lstRows]
    }
}
