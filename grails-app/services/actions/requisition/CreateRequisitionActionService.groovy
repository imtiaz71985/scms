package actions.requisition

import com.scms.Requisition
import com.scms.RequisitionDetails
import com.scms.SecUser
import grails.converters.JSON
import grails.plugin.springsecurity.SpringSecurityService
import grails.transaction.Transactional
import org.apache.log4j.Logger
import org.codehaus.groovy.grails.web.json.JSONElement
import scms.ActionServiceIntf
import scms.BaseService
import scms.utility.DateUtility

@Transactional
class CreateRequisitionActionService extends BaseService implements ActionServiceIntf {

    SpringSecurityService springSecurityService
    private static final String SAVE_SUCCESS_MESSAGE = "Data saved successfully"
    private static final String REQUISITION = "requisition"
    private static final String REQUISITION_DETAILS = "requisitionDetails"
    private Logger log = Logger.getLogger(getClass())

    @Transactional
    public Map executePreCondition(Map params) {
        try {
            if (!params.requisitionNo) {
                return super.setError(params, INVALID_INPUT_MSG)
            }
            Requisition requisition = buildRequisitionObject(params)
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
            List<RequisitionDetails> lstDetails = (List<RequisitionDetails>) result.get(REQUISITION_DETAILS)
            for (int i = 0; i < lstDetails.size(); i++) {
                totalAmount+=lstDetails[i].amount
                lstDetails[i].save()
            }
            requisition.totalAmount = totalAmount
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
        return super.setSuccess(result, SAVE_SUCCESS_MESSAGE)
    }

    public Map buildFailureResultForUI(Map result) {
        return result
    }

    private static List<RequisitionDetails> buildMedicineDetailsMap(Map parameterMap) {
        List<RequisitionDetails> lstMedicine = []
        JSONElement gridModelMedicine = JSON.parse(parameterMap.gridModelMedicine.toString())
        String requisitionNo = parameterMap.requisitionNo
        List lstRowsMedicine = (List) gridModelMedicine
        for (int i = 0; i < lstRowsMedicine.size(); i++) {
            if(lstRowsMedicine[i].reqQty>0){
                RequisitionDetails medicine = buildRequisitionDetailsObject(lstRowsMedicine[i],requisitionNo)
                lstMedicine.add(medicine)
            }
        }
        return lstMedicine
    }

    private static RequisitionDetails buildRequisitionDetailsObject(def params, String requisitionNo) {
        RequisitionDetails details = new RequisitionDetails(params)
        details.reqNo = requisitionNo
        return details
    }
    private Requisition buildRequisitionObject(Map params) {
        String hospital_code= SecUser.read(springSecurityService.principal.id)?.hospitalCode
        Requisition requisition = new Requisition(params)
        requisition.reqNo = params.requisitionNo
        requisition.hospitalCode = hospital_code
        requisition.createDate = DateUtility.getSqlDate(new Date())
        requisition.createdBy = springSecurityService.principal.id
        requisition.isApproved = Boolean.FALSE
        requisition.isReceived = Boolean.FALSE
        return requisition
    }
}
