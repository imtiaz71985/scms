package actions.transactionClosing

import com.model.ListSystemEntityActionServiceModel
import com.model.ListTransactionClosingActionServiceModel
import com.scms.SecUser
import com.scms.TransactionClosing
import grails.plugin.springsecurity.SpringSecurityService
import grails.transaction.Transactional
import org.apache.log4j.Logger
import org.exolab.castor.types.DateTime
import scms.ActionServiceIntf
import scms.BaseService
import scms.utility.DateUtility

@Transactional
class CreateTransactionClosingActionService extends BaseService implements ActionServiceIntf {
    private static final String SAVE_SUCCESS_MESSAGE = "Transaction closed successfully"
    private static final String ALREADY_EXIST = "Date already exist"
    private static final String TRANSACTION_CLOSING = "transactionClosing"
    private Logger log = Logger.getLogger(getClass())
    SpringSecurityService springSecurityService

    @Transactional(readOnly = true)
    public Map executePreCondition(Map params){
       try {
            //Check parameters
           if (!params.closingDate) {
               return super.setError(params, INVALID_INPUT_MSG)
           }
           if(Long.parseLong(params.totalPatient)!=Long.parseLong(params.servedPatient)){
               return super.setError(params, 'Total patient and served patient is not equal.')
           }
            TransactionClosing transactionClosing = buildObject(params)
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
       // ListSystemEntityActionServiceModel model = ListSystemEntityActionServiceModel.read(transactionClosing.id)
        ListTransactionClosingActionServiceModel model=ListTransactionClosingActionServiceModel.read(transactionClosing.id)
        result.put(TRANSACTION_CLOSING, model)
        return super.setSuccess(result, SAVE_SUCCESS_MESSAGE)
    }

    public Map buildFailureResultForUI(Map result) {
        return result
    }

    /**
     * Build transactionClosing object
     * @param parameterMap -serialized parameters from UI
     * @return -new transactionClosing object
 /*    */
    private TransactionClosing buildObject(Map parameterMap) {
        parameterMap.closingDate = DateUtility.getSqlDate(DateUtility.parseDateForDB(parameterMap.closingDate))
        String hospitalCode=SecUser.read(springSecurityService.principal.id)?.hospitalCode
        TransactionClosing transactionClosing
        transactionClosing= TransactionClosing.findByHospitalCodeAndClosingDate(hospitalCode,DateUtility.getSqlDate(parameterMap.closingDate))
        if(transactionClosing){
            transactionClosing.modifyDate=DateUtility.getSqlDate(new Date())
            transactionClosing.modifyBy=springSecurityService.principal.id
            transactionClosing.isTransactionClosed=true
            if(parameterMap.remarks)
                transactionClosing.remarks=parameterMap.remarks
        }else {
            transactionClosing = new TransactionClosing(parameterMap)
            transactionClosing.createDate = DateUtility.getSqlDate(new Date())
            transactionClosing.createBy = springSecurityService.principal.id
            transactionClosing.isTransactionClosed = true
            transactionClosing.hospitalCode = hospitalCode
        }
        return transactionClosing
    }
}
