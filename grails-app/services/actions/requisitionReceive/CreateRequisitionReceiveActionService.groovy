package actions.requisitionReceive

import com.scms.*
import grails.converters.JSON
import grails.plugin.springsecurity.SpringSecurityService
import grails.transaction.Transactional
import groovy.sql.GroovyRowResult
import org.apache.log4j.Logger
import org.codehaus.groovy.grails.web.json.JSONElement
import scms.ActionServiceIntf
import scms.BaseService
import scms.utility.DateUtility
import service.RequisitionService

@Transactional
class CreateRequisitionReceiveActionService extends BaseService implements ActionServiceIntf{

    SpringSecurityService springSecurityService
    RequisitionService requisitionService
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
            String hospitalCode = SecUser.read(springSecurityService.principal.id)?.hospitalCode

            Receive receive = (Receive) result.get(RECEIVE)
            boolean isComplete=true
            List<ReceiveDetails> lstDetails = (List<ReceiveDetails>) result.get(RECEIVE_DETAILS)
            if(lstDetails.size()>0) {
                receive.save()

                for (int i = 0; i < lstDetails.size(); i++) {
                    RequisitionDetails requisitionDetails=RequisitionDetails.findByMedicineIdAndReqNo(lstDetails[i].medicineId,receive.reqNo)
                    if(requisitionDetails.approvedQty!=requisitionDetails.receiveQty) {
                        if (requisitionDetails.approvedQty > requisitionDetails.receiveQty) {
                            if (lstDetails[i].remarks == 'Partial receive') {
                                isComplete = false
                            }
                        }

                        MedicineStock stock = MedicineStock.findByMedicineIdAndHospitalCode(lstDetails[i].medicineId, hospitalCode)
                        stock.stockQty += lstDetails[i].receiveQty
                        stock.save()

                        requisitionDetails.receiveQty += lstDetails[i].receiveQty
                        requisitionDetails.save()

                        lstDetails[i].receiveId = receive.id
                        lstDetails[i].save()
                    }
                }
                if (isComplete) {
                    List<GroovyRowResult> lst= requisitionService.listOfMedicineForReceive(receive.reqNo)
                    if(lst.size()<1) {
                        Requisition requisition = Requisition.findByReqNo(receive.reqNo)
                        requisition.isReceived = true
                        requisition.save()
                    }
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

            ReceiveDetails details = new ReceiveDetails(lstRowsMedicine[i])
            if (details.receiveQty > 0) {
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
