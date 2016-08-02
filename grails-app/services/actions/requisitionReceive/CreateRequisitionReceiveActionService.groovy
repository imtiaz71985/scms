package actions.requisitionReceive

import com.scms.*
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
            List<ReceiveDetails> lstDetails = (List<ReceiveDetails>) result.get(RECEIVE_DETAILS)
            if(lstDetails.size()>0) {
                receive.save()

                for (int i = 0; i < lstDetails.size(); i++) {
                    MedicineStock stock = MedicineStock.read(lstDetails[i].medicineId)
                    stock.stockQty += lstDetails[i].receiveQty
                    stock.save()

                    RequisitionDetails requisitionDetails=RequisitionDetails.findByMedicineIdAndReqNo(lstDetails[i].medicineId,receive.reqNo)
                    requisitionDetails.receiveQty+=lstDetails[i].receiveQty
                    requisitionDetails.save()

                    lstDetails[i].receiveId = receive.id
                    lstDetails[i].save()
                }
                if (Boolean.parseBoolean(result.isReceived)) {
                    Requisition requisition = Requisition.findByReqNo(receive.reqNo)
                    requisition.isReceived = result.isReceived
                    requisition.save()
                }
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
        receive.remarks=params.remarks

        return receive
    }
}
