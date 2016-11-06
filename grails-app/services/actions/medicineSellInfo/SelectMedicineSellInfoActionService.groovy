package actions.medicineSellInfo

import com.scms.MedicineInfo
import com.scms.MedicineSellInfo
import com.scms.MedicineSellInfoDetails
import com.scms.MedicineStock
import com.scms.SecUser
import com.scms.SystemEntity
import grails.converters.JSON
import grails.plugin.springsecurity.SpringSecurityService
import grails.transaction.Transactional
import org.apache.log4j.Logger
import scms.ActionServiceIntf
import scms.BaseService

@Transactional
class SelectMedicineSellInfoActionService extends BaseService implements ActionServiceIntf {

    SpringSecurityService springSecurityService

    private static final String NOT_FOUND_MASSAGE = "Selected record not found"
    private static final String TOTAL_AMOUNT = "totalAmount"
    private static final String VOUCHER_NO = "voucherNo"
    private static final String MEDICINE_DETAILS = "requisitionDetails"
    private static final String GRID_MODEL_MEDICINE = "gridModelMedicine"
    private static final String SELL_DATE = "sellDate"

    private Logger log = Logger.getLogger(getClass())


    @Transactional(readOnly = true)
    public Map executePreCondition(Map params) {
        try {
            long id = Long.parseLong(params.id.toString())
            MedicineSellInfo sellInfo = MedicineSellInfo.read(id)
            if (!sellInfo) {
                return super.setError(params, NOT_FOUND_MASSAGE)
            }
            params.put(SELL_DATE, sellInfo.sellDate)
            params.put(TOTAL_AMOUNT, sellInfo.totalAmount)
            params.put(VOUCHER_NO, sellInfo.voucherNo)
            params.put(MEDICINE_DETAILS, sellInfo)
            return params
        } catch (Exception e) {
            log.error(e.getMessage())
            throw new RuntimeException(e)
        }
    }

    @Transactional(readOnly = true)
    public Map execute(Map result) {
        try {
            MedicineSellInfo sellInfo = (MedicineSellInfo) result.get(MEDICINE_DETAILS)
            List<MedicineSellInfoDetails> lstMedicine = (List<MedicineSellInfoDetails>) MedicineSellInfoDetails.findAllByVoucherNo(sellInfo.voucherNo)
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
            List<MedicineSellInfoDetails> lstMedicine = (List<MedicineSellInfoDetails>) result.get(MEDICINE_DETAILS)
            Map gridObjects = wrapEducationGrid(lstMedicine)
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

    private Map wrapEducationGrid(List<MedicineSellInfoDetails> lstMedicine) {
        String hospitalCode = SecUser.read(springSecurityService.principal.id)?.hospitalCode
        List lstRows = []
        MedicineSellInfoDetails singleRow
        for (int i = 0; i < lstMedicine.size(); i++) {
            singleRow = lstMedicine[i]
            long id = singleRow.id
            long version = singleRow.version
            String voucherNo = singleRow.voucherNo
            long medicineId = singleRow.medicineId
            int quantity = singleRow.quantity
            double amount = singleRow.amount
            String medicineName = EMPTY_SPACE
            String unitPriceTxt = EMPTY_SPACE

            MedicineInfo medicineInfo = MedicineInfo.read(medicineId)
            MedicineStock stock = MedicineStock.findByMedicineIdAndHospitalCode(medicineId,hospitalCode)
            SystemEntity medicineType = SystemEntity.read(medicineInfo.type)
            if(medicineInfo.strength){
                medicineName = medicineInfo.brandName + ' (' + medicineInfo.strength + ')' + ' - ' + medicineType.name
            }else{
                medicineName = medicineInfo.brandName + ' - ' + medicineType.name
            }
            if(medicineInfo.unitType){
                unitPriceTxt= ((float)Math.round((amount/quantity)*100)/100).toString()+' /'+medicineInfo.unitType
            }else{
                unitPriceTxt=  ((float)Math.round((amount/quantity)*100)/100).toString()
            }
            Map eachDetails = [ id:id,version:version,voucherNo:voucherNo,medicineName:medicineName,
                               medicineId:medicineId,quantity:quantity,amount:amount,
                               stock:stock.stockQty+quantity,unitPriceTxt:unitPriceTxt
            ]
            lstRows << eachDetails
        }
        return [lstMedicine: lstRows]
    }

}
