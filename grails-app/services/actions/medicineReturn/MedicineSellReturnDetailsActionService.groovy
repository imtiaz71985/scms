package actions.medicineReturn

import com.scms.MedicineInfo
import com.scms.MedicineReturn
import com.scms.MedicineReturnDetails
import com.scms.SystemEntity
import grails.converters.JSON
import grails.plugin.springsecurity.SpringSecurityService
import grails.transaction.Transactional
import org.apache.log4j.Logger
import scms.ActionServiceIntf
import scms.BaseService

@Transactional
class MedicineSellReturnDetailsActionService extends BaseService implements ActionServiceIntf {

    SpringSecurityService springSecurityService

    private static final String NOT_FOUND_MASSAGE = "Selected record not found"
    private static final String TOTAL_AMOUNT = "totalAmount"
    private static final String TRACE_NO = "traceNo"
    private static final String RETURN_DATE = "returnDate"
    private static final String MEDICINE_DETAILS = "requisitionDetails"
    private static final String GRID_MODEL_MEDICINE = "gridModelMedicine"

    private Logger log = Logger.getLogger(getClass())


    @Transactional(readOnly = true)
    public Map executePreCondition(Map params) {
        try {
            long id = Long.parseLong(params.id.toString())
            MedicineReturn medicineReturn = MedicineReturn.read(id)
            if (!medicineReturn) {
                return super.setError(params, NOT_FOUND_MASSAGE)
            }
            params.put(TOTAL_AMOUNT, medicineReturn.totalAmount)
            params.put(TRACE_NO, medicineReturn.traceNo)
            params.put(RETURN_DATE, medicineReturn.returnDate)
            return params
        } catch (Exception e) {
            log.error(e.getMessage())
            throw new RuntimeException(e)
        }
    }

    @Transactional(readOnly = true)
    public Map execute(Map result) {
        try {
            String traceNo = result.get(TRACE_NO)
            List<MedicineReturnDetails> lstMedicine = (List<MedicineReturnDetails>) MedicineReturnDetails.findAllByTraceNo(traceNo)
            result.put(MEDICINE_DETAILS, lstMedicine)
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
            List<MedicineReturnDetails> lstMedicine = (List<MedicineReturnDetails>) result.get(MEDICINE_DETAILS)
            Map gridObjects = wrapMedicineGrid(lstMedicine)
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

    private Map wrapMedicineGrid(List<MedicineReturnDetails> lstMedicine) {
        List lstRows = []
        MedicineReturnDetails singleRow
        for (int i = 0; i < lstMedicine.size(); i++) {
            singleRow = lstMedicine[i]
            long medicineId = singleRow.medicineId
            int quantity = singleRow.quantity
            double amount = singleRow.amount
            String medicineName = EMPTY_SPACE

            MedicineInfo medicineInfo = MedicineInfo.read(medicineId)
            SystemEntity medicineType = SystemEntity.read(medicineInfo.type)
            if(medicineInfo.strength){
                medicineName = medicineInfo.brandName + ' (' + medicineInfo.strength + ')' + ' - ' + medicineType.name
            }else{
                medicineName = medicineInfo.brandName + ' - ' + medicineType.name
            }

            Map eachDetails = [medicineName:medicineName,quantity:quantity,amount:amount]
            lstRows << eachDetails
        }
        return [lstMedicine: lstRows]
    }
}
