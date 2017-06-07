package actions.transactionClosing

import com.model.ListDiseaseInfoActionServiceModel
import com.model.ListTransactionClosingActionServiceModel
import com.scms.TransactionClosing
import com.scms.ServiceCharges
import com.scms.TransactionClosing
import grails.plugin.springsecurity.SpringSecurityService
import grails.transaction.Transactional
import org.apache.log4j.Logger
import scms.ActionServiceIntf
import scms.BaseService
import scms.utility.DateUtility
import service.ServiceChargesService

@Transactional
class UpdateTransactionClosingActionService extends BaseService implements ActionServiceIntf {

    SpringSecurityService springSecurityService
    private static final String UPDATE_SUCCESS_MESSAGE = "Transaction closing has been unlocked successfully"
    private static final String TRANSACTION_CLOSING = "transactionClosing"
    ServiceChargesService serviceChargesService

    private Logger log = Logger.getLogger(getClass())

    public Map executePreCondition(Map params) {
        try {

            if (!params.closingDate) {
                return super.setError(params, INVALID_INPUT_MSG)
            }
            Date closingDate = DateUtility.getSqlDate(DateUtility.parseDateForDB(params.closingDate))
           
            TransactionClosing oldTransactionClosing = TransactionClosing.findByClosingDate(closingDate)

            TransactionClosing transactionClosing = buildObject(params, oldTransactionClosing)
            params.put(TRANSACTION_CLOSING, transactionClosing)
            return params
        } catch (Exception ex) {
            log.error(ex.getMessage())
            throw new RuntimeException(ex)
        }
    }

    @Transactional
    public Map execute(Map result) {
        try {
            TransactionClosing transactionClosing = (TransactionClosing) result.get(TRANSACTION_CLOSING)
            transactionClosing.save()

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
        TransactionClosing transactionClosing = (TransactionClosing) result.get(TRANSACTION_CLOSING)
        ListTransactionClosingActionServiceModel model = ListTransactionClosingActionServiceModel.findById(transactionClosing.id)
        result.put(TRANSACTION_CLOSING, model)
        return super.setSuccess(result, UPDATE_SUCCESS_MESSAGE)
    }

    public Map buildFailureResultForUI(Map params) {
        return params
    }

    private TransactionClosing buildObject(Map parameterMap, TransactionClosing oldDiseaseInfo) {

        TransactionClosing transactionClosing = new TransactionClosing(parameterMap)
        oldDiseaseInfo.isTransactionClosed = false
        oldDiseaseInfo.unlockDate = DateUtility.getSqlDate(new Date())
        oldDiseaseInfo.unlockBy = springSecurityService.principal.id

        return oldDiseaseInfo
    }
}
