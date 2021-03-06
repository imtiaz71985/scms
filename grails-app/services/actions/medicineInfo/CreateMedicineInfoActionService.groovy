package actions.medicineInfo

import com.model.ListMedicineInfoActionServiceModel
import com.scms.HospitalLocation
import com.scms.MedicineInfo
import com.scms.MedicinePrice
import com.scms.MedicineStock
import com.scms.SubsidyOnMedicine
import grails.transaction.Transactional
import org.apache.log4j.Logger
import scms.ActionServiceIntf
import scms.BaseService
import scms.utility.DateUtility

@Transactional
class CreateMedicineInfoActionService extends BaseService implements ActionServiceIntf {

    private static final String SAVE_SUCCESS_MESSAGE = "Medicine has been saved successfully"
    private static final String ALREADY_EXIST = "Same Medicine already exist"
    private static final String MEDICINE_INFO = "medicineInfo"
    private static final String SUBSIDY_PERT = "subsidyPert"

    private Logger log = Logger.getLogger(getClass())

    @Transactional(readOnly = true)
    public Map executePreCondition(Map params) {
        try {
            if (!params.typeId||!params.genericName) {
                return super.setError(params, INVALID_INPUT_MSG)
            }
            long typeId = Long.parseLong(params.typeId)
            double subsidyPert = Double.parseDouble(params.subsidyPert)
            if (params.strength) {
                int duplicateCount = MedicineInfo.countByGenericNameIlikeAndTypeAndStrength(params.name,typeId,params.strength)
                if (duplicateCount > 0) {
                    return super.setError(params, ALREADY_EXIST)
                }
            }
            MedicineInfo medicineInfo = buildObject(params)
            params.put(MEDICINE_INFO, medicineInfo)
            params.put(SUBSIDY_PERT, subsidyPert)
            return params
        } catch (Exception ex) {
            log.error(ex.getMessage())
            throw new RuntimeException(ex)
        }
    }

    @Transactional
    public Map execute(Map result) {
        try {
            double subsidyPert = (double) result.get(SUBSIDY_PERT)
            MedicineInfo medicineInfo = (MedicineInfo) result.get(MEDICINE_INFO)
            double priceAfterSubsidy=medicineInfo.mrpPrice-((medicineInfo.mrpPrice*subsidyPert)/100)
            medicineInfo.unitPrice = priceAfterSubsidy
            medicineInfo.save()

            List<HospitalLocation> lstClinic = HospitalLocation.findAllByIsClinic(true)
            for(int i =0; i<lstClinic.size(); i++){
                MedicineStock stock = new MedicineStock()
                stock.medicineId = medicineInfo.id
                stock.stockQty = 0.0d
                stock.hospitalCode=lstClinic[i].code
                stock.save()
            }

            MedicinePrice medicinePrice = new MedicinePrice()
            medicinePrice.medicineId = medicineInfo.id
            medicinePrice.mrpPrice = medicineInfo.mrpPrice
            medicinePrice.price = priceAfterSubsidy
            medicinePrice.isActive = Boolean.TRUE
            medicinePrice.start = new Date()
            medicinePrice.save()

            SubsidyOnMedicine som = new SubsidyOnMedicine()
            som.medicineId = medicineInfo.id
            som.subsidyPert = subsidyPert
            som.start = new Date()
            som.isActive = Boolean.TRUE
            som.save()

            return result
        } catch (Exception ex) {
            log.error(ex.getMessage())
            throw new RuntimeException(ex)
        }
    }
    /**
     *
     * @param result - map received from execute method
     * @return - map
     */
    public Map executePostCondition(Map result) {
        return result
    }
    /**
     *
     * @param result - map received from executePost method
     * @return - map containing success message
     */
    public Map buildSuccessResultForUI(Map result) {
        MedicineInfo medicineInfo = (MedicineInfo) result.get(MEDICINE_INFO)
        ListMedicineInfoActionServiceModel model = ListMedicineInfoActionServiceModel.read(medicineInfo.id)
        result.put(MEDICINE_INFO, model)
        return super.setSuccess(result, SAVE_SUCCESS_MESSAGE)
    }
    /**
     *
     * @param result - map received from previous method
     * @return - map
     */
    public Map buildFailureResultForUI(Map result) {
        return result
    }

    private MedicineInfo buildObject(Map parameterMap) {
        MedicineInfo medicineInfo = new MedicineInfo(parameterMap)
        medicineInfo.mrpPrice = Double.parseDouble(parameterMap.mrpPrice)
        if(parameterMap.boxSize) medicineInfo.boxSize = Integer.parseInt(parameterMap.boxSize)
        if(parameterMap.warnQty) medicineInfo.warnQty = Integer.parseInt(parameterMap.warnQty)
        if(parameterMap.boxRate) medicineInfo.boxRate = Double.parseDouble(parameterMap.boxRate)
        medicineInfo.type = Double.parseDouble(parameterMap.typeId)
        medicineInfo.vendorId = Long.parseLong(parameterMap.vendorId)
        return medicineInfo
    }
}
