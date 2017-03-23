package actions.requisition

import com.model.ListRequisitionActionServiceModel
import com.scms.Requisition
import com.scms.RequisitionDetails
import grails.plugin.springsecurity.SpringSecurityService
import grails.transaction.Transactional
import org.apache.log4j.Logger
import scms.ActionServiceIntf
import scms.BaseService
import scms.utility.DateUtility

@Transactional
class ApproveRequisitionRequestActionService extends BaseService implements ActionServiceIntf {

    SpringSecurityService springSecurityService

    private static final String UPDATE_SUCCESS_MESSAGE = "Requisition approved successfully"
    private static final String REQUISITION = "requisition"

    private Logger log = Logger.getLogger(getClass())

    public Map executePreCondition(Map params) {
        try {
            if ((!params.id)) {
                return super.setError(params, INVALID_INPUT_MSG)
            }
            long id = Long.parseLong(params.id.toString())
            Requisition oldRequisition = Requisition.read(id)
            Requisition requisition = buildObject(oldRequisition)
            params.put(REQUISITION, requisition)
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
            List<RequisitionDetails> lstDetails = RequisitionDetails.findAllByReqNo(requisition.reqNo)
            if (lstDetails[0].approvedQty == 0) {
                for (int i = 0; i < lstDetails.size(); i++) {
                    lstDetails[i].approvedQty = lstDetails[i].reqQty
                    lstDetails[i].approveAmount = lstDetails[i].amount
                    lstDetails[i].save()
                }
                requisition.approvedAmount = requisition.totalAmount
            }
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
        Requisition requisition = (Requisition) result.get(REQUISITION)
        ListRequisitionActionServiceModel model = ListRequisitionActionServiceModel.findByRequisitionNo(requisition.reqNo)
        result.put(REQUISITION, model)
        return super.setSuccess(result, UPDATE_SUCCESS_MESSAGE)
    }

    public Map buildFailureResultForUI(Map params) {
        return params
    }

    private Requisition buildObject(Requisition oldRequisition) {
        oldRequisition.isApproved = Boolean.TRUE
        oldRequisition.approvedBy = springSecurityService.principal.id
        oldRequisition.approvedDate = DateUtility.getSqlDate(new Date())
        oldRequisition.isDelivered = Boolean.TRUE
        oldRequisition.deliveryDate = DateUtility.getSqlDate(new Date())
        return oldRequisition
    }
}
