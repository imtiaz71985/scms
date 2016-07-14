package actions.requisitionReceive

import com.scms.MedicineInfo
import com.scms.ReceiveDetails
import com.scms.Receive
import com.scms.Requisition
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
class CreateRequisitionReceiveActionService extends BaseService implements ActionServiceIntf{

    SpringSecurityService springSecurityService
    private static final String SAVE_SUCCESS_MESSAGE = "Data saved successfully"
    private static final String RECEIVE = "receive"
    private static final String RECEIVE_DETAILS = "receiveDetails"
    private Logger log = Logger.getLogger(getClass())

    @Transactional
    public Map executePreCondition(Map params) {
        try {
            if (!params.requisitionNo) {
                return super.setError(params, INVALID_INPUT_MSG)
            }
            Receive receive = buildReceiveObject(params)
            List<ReceiveDetails> lstDetails = buildMedicineDetailsMap(params)
            params.put(RECEIVE, receive)
            params.put(RECEIVE_DETAILS, lstDetails)
            return params
        } catch (Exception ex) {
            log.error(ex.getMessage())
            throw new RuntimeException(ex)
        }
    }

    @Transactional
    public Map execute(Map result) {
        try {
            Receive receive = (Receive) result.get(RECEIVE)
            receive.save()
            List<ReceiveDetails> lstDetails = (List<ReceiveDetails>) result.get(RECEIVE_DETAILS)
            for (int i = 0; i < lstDetails.size(); i++) {

                MedicineInfo medicineInfo=MedicineInfo.read(lstDetails[i].medicineId)
                medicineInfo.stockQty+=lstDetails[i].receiveQty
                medicineInfo.save()

                lstDetails[i].receiveId= receive.id
                lstDetails[i].save()
            }
            if(result.isReceived) {
                Requisition requisition = Requisition.read(receive.reqNo)
                requisition.isReceived = result.isReceived
                requisition.save()
            }


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

    private static List<ReceiveDetails> buildMedicineDetailsMap(Map parameterMap) {
        List<ReceiveDetails> lstMedicine = []
        JSONElement gridModelMedicine = JSON.parse(parameterMap.gridModelMedicine.toString())
        List lstRowsMedicine = (List) gridModelMedicine
        for (int i = 0; i < lstRowsMedicine.size(); i++) {
            if(lstRowsMedicine[i].receiveQty>0){
                ReceiveDetails details = new ReceiveDetails(lstRowsMedicine[i])
                ReceiveDetails medicine = details
                lstMedicine.add(medicine)
            }
        }
        return lstMedicine
    }


    private Receive buildReceiveObject(Map params) {
        String hospital_code= SecUser.read(springSecurityService.principal.id)?.hospitalCode
        Receive receive = new Receive(params)
        receive.reqNo = params.requisitionNo
        receive.hospitalCode = hospital_code
        receive.createDate = DateUtility.getSqlDate(new Date())
        receive.createdBy = springSecurityService.principal.id
        return receive
    }
}
