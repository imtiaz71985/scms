package actions.requisition

import com.model.ListRequisitionActionServiceModel
import com.scms.Requisition
import grails.transaction.Transactional
import org.apache.log4j.Logger
import scms.ActionServiceIntf
import scms.BaseService

@Transactional
class SendRequisitionRequestActionService extends BaseService implements ActionServiceIntf {

    private static final String UPDATE_SUCCESS_MESSAGE = "Requisition request send successfully"
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

    private static Requisition buildObject(Requisition oldRequisition) {
        oldRequisition.isSend = Boolean.TRUE
        return oldRequisition
    }
}
