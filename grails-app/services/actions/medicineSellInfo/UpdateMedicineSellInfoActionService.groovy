package actions.medicineSellInfo

import com.scms.MedicineSellInfo
import com.scms.MedicineSellInfoDetails
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
            if(!medicineInfo){
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
            MedicineSellInfo medicineInfo = (MedicineSellInfo) result.get(MEDICINE_SELL_INFO)
            double totalAmount = 0.0d
            deleteAllChild(medicineInfo.voucherNo)
            List<MedicineSellInfo> lstMedicineInfo = (List<MedicineSellInfo>) result.get(MEDICINE_SELL_DETAILS_MAP)
            for (int i = 0; i < lstMedicineInfo.size(); i++) {
                totalAmount+=lstMedicineInfo[i].amount
                lstMedicineInfo[i].save()
            }
            medicineInfo.totalAmount = totalAmount
            medicineInfo.save()
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
            MedicineSellInfoDetails medicine = buildMedicineDetailsObject(lstRowsMedicine[i],voucherNo)
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
