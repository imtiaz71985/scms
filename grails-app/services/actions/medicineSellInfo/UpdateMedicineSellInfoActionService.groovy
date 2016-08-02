package actions.medicineSellInfo

import com.scms.MedicineSellInfo
import com.scms.MedicineSellInfoDetails
import com.scms.MedicineStock
import com.scms.SecUser
import grails.converters.JSON
import grails.plugin.springsecurity.SpringSecurityService
import grails.transaction.Transactional
import org.apache.log4j.Logger
import org.codehaus.groovy.grails.web.json.JSONElement
import scms.ActionServiceIntf
import scms.BaseService

@Transactional
class UpdateMedicineSellInfoActionService extends BaseService implements ActionServiceIntf {

    SpringSecurityService springSecurityService

    private static final String UPDATE_SUCCESS_MESSAGE = "Data has been updated successfully"
    private static final String MEDICINE_SELL_INFO = "medicineSellInfo"
    private static final String MEDICINE_SELL_DETAILS_MAP = "medicineDetailsMap"

    private Logger log = Logger.getLogger(getClass())

    public Map executePreCondition(Map params) {
        try {
            if (!params.voucherNo) {
                return super.setError(params, INVALID_INPUT_MSG)
            }
            MedicineSellInfo medicineInfo = MedicineSellInfo.findByVoucherNo(params.voucherNo)
            if (!medicineInfo) {
                return super.setError(params, INVALID_INPUT_MSG)
            }
            List<MedicineSellInfoDetails> lstMedicineDetails = buildMedicineDetailsMap(params)

            params.put(MEDICINE_SELL_INFO, medicineInfo)
            params.put(MEDICINE_SELL_DETAILS_MAP, lstMedicineDetails)
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
            MedicineSellInfo sellInfo = (MedicineSellInfo) result.get(MEDICINE_SELL_INFO)
            double totalAmount = 0.0d

            def list = MedicineSellInfoDetails.executeQuery("select medicineId, quantity from MedicineSellInfoDetails" +
                    " where voucherNo = :voucherNo", [voucherNo: sellInfo.voucherNo])

            deleteAllChild(sellInfo.voucherNo)
            List<MedicineSellInfoDetails> lstMedicineInfoDetails = (List<MedicineSellInfoDetails>) result.get(MEDICINE_SELL_DETAILS_MAP)
            for (int i = 0; i < lstMedicineInfoDetails.size(); i++) {
                totalAmount += lstMedicineInfoDetails[i].amount
                lstMedicineInfoDetails[i].save()

                MedicineStock stock = MedicineStock.findByMedicineIdAndHospitalCode(lstMedicineInfoDetails[i].medicineId,hospitalCode)
                int previousQty = 0
                for (int j = 0; j < list.size(); j++) {
                    if (stock.id == list[j][0]) {
                        previousQty = list[j][1]
                    }
                }
                stock.stockQty = stock.stockQty - lstMedicineInfoDetails[i].quantity + previousQty
                stock.save()
            }
            sellInfo.totalAmount = totalAmount
            sellInfo.save()
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
        return super.setSuccess(result, UPDATE_SUCCESS_MESSAGE)
    }

    public Map buildFailureResultForUI(Map params) {
        return params
    }

    private static List<MedicineSellInfoDetails> buildMedicineDetailsMap(Map parameterMap) {
        List<MedicineSellInfoDetails> lstMedicine = []
        JSONElement gridModelMedicine = JSON.parse(parameterMap.gridModelMedicine.toString())
        String voucherNo = parameterMap.voucherNo
        List lstRowsMedicine = (List) gridModelMedicine
        for (int i = 0; i < lstRowsMedicine.size(); i++) {
            MedicineSellInfoDetails medicine = buildMedicineDetailsObject(lstRowsMedicine[i], voucherNo)
            lstMedicine.add(medicine)
        }
        return lstMedicine
    }

    private static MedicineSellInfoDetails buildMedicineDetailsObject(def params, String voucherNo) {
        MedicineSellInfoDetails details = new MedicineSellInfoDetails(params)
        details.voucherNo = voucherNo
        return details
    }

    private static final String DELETE_QUERY = """ DELETE FROM medicine_sell_info_details WHERE voucher_no = :voucherNo """

    public void deleteAllChild(String voucherNo) {
        Map params = [voucherNo: voucherNo]
        executeUpdateSql(DELETE_QUERY, params)
    }
}
