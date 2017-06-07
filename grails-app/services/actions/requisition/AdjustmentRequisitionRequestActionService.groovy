package actions.requisition

import com.scms.Requisition
import com.scms.RequisitionDetails
import grails.converters.JSON
import grails.plugin.springsecurity.SpringSecurityService
import grails.transaction.Transactional
import org.apache.log4j.Logger
import org.codehaus.groovy.grails.web.json.JSONElement
import scms.ActionServiceIntf
import scms.BaseService
import scms.utility.DateUtility

@Transactional
class AdjustmentRequisitionRequestActionService extends BaseService implements ActionServiceIntf {

    SpringSecurityService springSecurityService

    private static final String UPDATE_SUCCESS_MESSAGE = "Data has been updated successfully"
    private static final String REQUISITION = "requisition"
    private static final String REQUISITION_DETAILS = "requisitionDetails"

    private Logger log = Logger.getLogger(getClass())

    public Map executePreCondition(Map params) {
        try {
            if (!params.requisitionNo) {
                return super.setError(params, INVALID_INPUT_MSG)
            }
            Requisition requisition = Requisition.findByReqNo(params.requisitionNo)
            if(!requisition){
                return super.setError(params, INVALID_INPUT_MSG)
            }
            List<RequisitionDetails> lstDetails = buildMedicineDetailsMap(params)

            params.put(REQUISITION, requisition)
            params.put(REQUISITION_DETAILS, lstDetails)
            return params
        } catch (Exception ex) {
            log.error(ex.getMessage())
            throw new RuntimeException(ex)
        }
    }

    @Transactional
    public Map execute(Map result) {
        try {
            Requisition requisition = (Requisition) result.get(REQUISITION)
            double totalAmount = 0.0d
            deleteAllChild(requisition.reqNo)
            List<RequisitionDetails> lstReqDetails = (List<RequisitionDetails>) result.get(REQUISITION_DETAILS)
            for (int i = 0; i < lstReqDetails.size(); i++) {
                totalAmount+=lstReqDetails[i].approveAmount
                lstReqDetails[i].save()
            }
            requisition.approvedAmount = totalAmount
            requisition.save()
            return result
        } catch (Exception ex) {
            log.error(ex.getMessage())
            throw new RuntimeException(ex)
        }
    }

    public Map executePostCondition(Map result) {
        return result
    }

    public Map buildSuccessResultForUI(Map result) {
        return super.setSuccess(result, UPDATE_SUCCESS_MESSAGE)
    }

    public Map buildFailureResultForUI(Map params) {
        return params
    }
    private static List<RequisitionDetails> buildMedicineDetailsMap(Map parameterMap) {
        List<RequisitionDetails> lstMedicine = []
        JSONElement gridModelMedicine = JSON.parse(parameterMap.gridModelMedicine.toString())
        String requisitionNo = parameterMap.requisitionNo
        List lstRowsMedicine = (List) gridModelMedicine
        for (int i = 0; i < lstRowsMedicine.size(); i++) {
            if(lstRowsMedicine[i].approvedQty>0){
                RequisitionDetails medicine = buildMedicineDetailsObject(lstRowsMedicine[i],requisitionNo)
                lstMedicine.add(medicine)
            }
        }
        return lstMedicine
    }

    private static RequisitionDetails buildMedicineDetailsObject(def params, String requisitionNo) {
        RequisitionDetails details = new RequisitionDetails(params)
        details.reqNo = requisitionNo
        return details
    }

    private static final String DELETE_QUERY = """ DELETE FROM requisition_details WHERE req_no = :requisitionNo """

    public void deleteAllChild(String requisitionNo) {
        Map params = [requisitionNo: requisitionNo]
        executeUpdateSql(DELETE_QUERY, params)
    }
}
