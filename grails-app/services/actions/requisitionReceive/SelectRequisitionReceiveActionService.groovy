package actions.requisitionReceive

import com.scms.MedicineInfo
import com.scms.Requisition
import com.scms.RequisitionDetails
import com.scms.SystemEntity
import grails.converters.JSON
import grails.transaction.Transactional
import org.apache.log4j.Logger
import scms.ActionServiceIntf
import scms.BaseService

@Transactional
class SelectRequisitionReceiveActionService extends BaseService implements ActionServiceIntf {

    private static final String NOT_FOUND_MASSAGE = "Selected record not found"
    private static final String APVD_AMOUNT = "apvdAmount"
    private static final String REQUISITION_NO = "requisitionNo"
    private static final String REQUISITION = "requisition"
    private static final String IS_RECEIVED = "isReceived"
    private static final String REQUISITION_DETAILS = "requisitionDetails"
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
            params.put(APVD_AMOUNT, requisition.approvedAmount)
            params.put(REQUISITION_NO, requisition.reqNo)
            params.put(REQUISITION, requisition)
            params.put(IS_RECEIVED, requisition.isReceived)
            return params
        } catch (Exception e) {
            log.error(e.getMessage())
            throw new RuntimeException(e)
        }
    }

    @Transactional(readOnly = true)
    public Map execute(Map result) {
        try {
            Requisition requisition = (Requisition) result.get(REQUISITION)
            List<RequisitionDetails> lstMedicine = (List<RequisitionDetails>) RequisitionDetails.findAllByReqNo(requisition.reqNo)
            result.put(REQUISITION_DETAILS, lstMedicine)
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
            boolean isReceived = result.get(IS_RECEIVED)
            List<RequisitionDetails> lstMedicine = (List<RequisitionDetails>) result.get(REQUISITION_DETAILS)
            Map gridObjects = wrapEducationGrid(lstMedicine, isReceived)
            result.put(GRID_MODEL_MEDICINE, gridObjects.lstMedicine as JSON)
            return result
        } catch (Exception e) {
            log.error(e.getMessage())
            throw new RuntimeException(e)
        }
    }
    /**
     * Build failure result in case of any error
     * @param result -map returned from previous methods, can be null
     * @return -a map containing isError = true & relevant error message to display on page load
     */
    public Map buildFailureResultForUI(Map result) {
        return result
    }

    private static Map wrapEducationGrid(List<RequisitionDetails> lstMedicine,boolean isReceived) {
        List lstRows = []
        RequisitionDetails singleRow
        for (int i = 0; i < lstMedicine.size(); i++) {
            singleRow = lstMedicine[i]
            long id = singleRow.id
            long version = singleRow.version
            String voucherNo = singleRow.reqNo
            long medicineId = singleRow.medicineId
            int quantity = singleRow.reqQty
            int apvdQty = singleRow.approvedQty
            int recvdQty = singleRow.receiveQty
            double amount = singleRow.amount
            double apvdAmount = singleRow.approveAmount
            double recvdAmount = singleRow.receiveQty
            String medicineName = EMPTY_SPACE
            int reminingQty = apvdQty-recvdQty
            if(isReceived) reminingQty = 0

            MedicineInfo medicineInfo = MedicineInfo.read(medicineId)
            SystemEntity medicineType = SystemEntity.read(medicineInfo.type)
            String genericName = medicineInfo.genericName
            String type = medicineType.name

            if (medicineInfo.strength) {
                medicineName = medicineInfo.brandName + ' (' + medicineInfo.strength + ')'
            } else {
                medicineName = medicineInfo.brandName
            }

            Map eachDetails = [
                    id          : id,
                    version     : version,
                    voucherNo   : voucherNo,
                    type        : type,
                    medicineName: medicineName,
                    genericName : genericName,
                    medicineId  : medicineId,
                    unitPrice   : medicineInfo.unitPrice,
                    quantity    : quantity,
                    amount      : amount,
                    apvdQty     : apvdQty,
                    apvdAmount  : apvdAmount,
                    recvdQty    : recvdQty,
                    recvdAmount : recvdAmount,
                    reminingQty : reminingQty
            ]
            lstRows << eachDetails
        }
        return [lstMedicine: lstRows]
    }
}
