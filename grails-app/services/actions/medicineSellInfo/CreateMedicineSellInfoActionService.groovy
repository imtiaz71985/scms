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
import scms.utility.DateUtility

@Transactional
class CreateMedicineSellInfoActionService extends BaseService implements ActionServiceIntf {

    SpringSecurityService springSecurityService
    private static final String SAVE_SUCCESS_MESSAGE = "Data saved successfully"
    private static final String MEDICINE_SELL_INFO = "medicineSellInfo"
    private static final String MEDICINE_SELL_DETAILS_MAP = "medicineDetailsMap"
    private static final String HOSPITAL_CODE = "hospitalCode"
    private Logger log = Logger.getLogger(getClass())

    @Transactional
    public Map executePreCondition(Map params) {
        try {
            if (!params.voucherNo) {
                return super.setError(params, INVALID_INPUT_MSG)
            }
            String hospitalCode = SecUser.read(springSecurityService.principal.id)?.hospitalCode
            MedicineSellInfo medicineSellInfo = buildMedicineObject(params, hospitalCode)
            List<MedicineSellInfoDetails> lstMedicineDetails = buildMedicineDetailsMap(params)
            params.put(MEDICINE_SELL_INFO, medicineSellInfo)
            params.put(MEDICINE_SELL_DETAILS_MAP, lstMedicineDetails)
            params.put(HOSPITAL_CODE, hospitalCode)
            return params
        } catch (Exception ex) {
            log.error(ex.getMessage())
            throw new RuntimeException(ex)
        }


    }

    @Transactional
    public Map execute(Map result) {
        try {
            String hospitalCode = result.get(HOSPITAL_CODE)
            MedicineSellInfo sellInfo = (MedicineSellInfo) result.get(MEDICINE_SELL_INFO)
            double totalAmount = 0.0d
            List<MedicineSellInfoDetails> lstMedicineInfoDetails = (List<MedicineSellInfoDetails>) result.get(MEDICINE_SELL_DETAILS_MAP)
            for (int i = 0; i < lstMedicineInfoDetails.size(); i++) {
                totalAmount+=lstMedicineInfoDetails[i].amount
                lstMedicineInfoDetails[i].save()

                MedicineStock stock = MedicineStock.findByMedicineIdAndHospitalCode(lstMedicineInfoDetails[i].medicineId,hospitalCode)
                stock.stockQty = stock.stockQty - lstMedicineInfoDetails[i].quantity
                stock.save()
            }
            sellInfo.totalAmount = Math.ceil(totalAmount)
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
        return super.setSuccess(result, SAVE_SUCCESS_MESSAGE)
    }

    public Map buildFailureResultForUI(Map result) {
        return result
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
    private MedicineSellInfo buildMedicineObject(Map params, String hospitalCode) {
        MedicineSellInfo sellInfo = new MedicineSellInfo(params)
        sellInfo.voucherNo = params.voucherNo
        sellInfo.hospitalCode = hospitalCode
        sellInfo.sellDate = DateUtility.getSqlDate(new Date())
        sellInfo.sellDateExt = DateUtility.getSqlFromDateWithSeconds(new Date())
        sellInfo.sellBy = springSecurityService.principal.id
        return sellInfo
    }
}
