package actions.medicineInfo

import com.model.ListMedicineInfoActionServiceModel
import com.model.ListSecRoleActionServiceModel
import com.scms.MedicineInfo
import com.scms.MedicinePrice
import com.scms.SubsidyOnMedicine
import grails.transaction.Transactional
import org.apache.log4j.Logger
import scms.ActionServiceIntf
import scms.BaseService
import scms.utility.DateUtility

@Transactional
class UpdateMedicineInfoActionService extends BaseService implements ActionServiceIntf {

    private static final String UPDATE_SUCCESS_MESSAGE = "Medicine has been updated successfully"
    private static final String ALREADY_EXIST = "Same Medicine already exist"
    private static final String MEDICINE_INFO = "medicineInfo"

    private Logger log = Logger.getLogger(getClass())

    public Map executePreCondition(Map params) {
        try {
            if (!params.id||!params.typeId||!params.genericName) {
                return super.setError(params, INVALID_INPUT_MSG)
            }
            long id = Long.parseLong(params.id)
            long typeId = Long.parseLong(params.typeId)
            if (params.strength) {
                int duplicateCount = MedicineInfo.countByGenericNameIlikeAndTypeAndStrengthAndIdNotEqual(params.genericName, typeId, params.strength, id)
                if (duplicateCount > 0) {
                    return super.setError(params, ALREADY_EXIST)
                }
            }
            MedicineInfo oldMedicineInfo = MedicineInfo.read(id)
            MedicineInfo medicineInfo = buildObject(params, oldMedicineInfo)
            params.put(MEDICINE_INFO, medicineInfo)
            return params
        } catch (Exception ex) {
            log.error(ex.getMessage())
            throw new RuntimeException(ex)
        }
    }

    @Transactional
    public Map execute(Map result) {
        try {
            double subsidyPert = Double.parseDouble(result.subsidyPert)
            MedicineInfo medicineInfo = (MedicineInfo) result.get(MEDICINE_INFO)
            SubsidyOnMedicine som = SubsidyOnMedicine.findByMedicineIdAndIsActive(medicineInfo.id, Boolean.TRUE)
            if(som.subsidyPert!=subsidyPert){
                som.isActive = Boolean.FALSE
                som.end = new Date()
                som.save()

                SubsidyOnMedicine som2 = new SubsidyOnMedicine()
                som2.medicineId = medicineInfo.id
                som2.isActive = Boolean.TRUE
                som2.subsidyPert = subsidyPert
                som2.start = new Date()
                som2.save()

                double priceAfterSubsidy=medicineInfo.mrpPrice-((medicineInfo.mrpPrice*subsidyPert)/100)

                MedicinePrice medicinePrice = MedicinePrice.findByMedicineIdAndIsActive(medicineInfo.id, Boolean.TRUE)
                medicinePrice.price = priceAfterSubsidy
                medicinePrice.save()

                medicineInfo.unitPrice = priceAfterSubsidy
                medicineInfo.save()
            }

            medicineInfo.save()

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
     * @param result - map received from execute method
     * @return - map with success message
     */
    public Map buildSuccessResultForUI(Map result) {
        MedicineInfo medicineInfo = (MedicineInfo) result.get(MEDICINE_INFO)
        ListMedicineInfoActionServiceModel model = ListMedicineInfoActionServiceModel.read(medicineInfo.id)
        result.put(MEDICINE_INFO, model)
        return super.setSuccess(result, UPDATE_SUCCESS_MESSAGE)
    }

    /**
     *
     * @param result - map received from previous method
     * @return - map
     */
    public Map buildFailureResultForUI(Map params) {
        return params
    }

    private static MedicineInfo buildObject(Map parameterMap, MedicineInfo oldMedicineInfo) {
        MedicineInfo medicineInfo = new MedicineInfo(parameterMap)
        oldMedicineInfo.brandName = medicineInfo.brandName
        oldMedicineInfo.genericName = medicineInfo.genericName
        oldMedicineInfo.type = Long.parseLong(parameterMap.typeId)
        oldMedicineInfo.vendorId = Long.parseLong(parameterMap.vendorId)
        oldMedicineInfo.strength = medicineInfo.strength
        if(parameterMap.boxSize) oldMedicineInfo.boxSize = medicineInfo.boxSize
        if(parameterMap.warnQty) oldMedicineInfo.warnQty = medicineInfo.warnQty
        if(parameterMap.boxRate) oldMedicineInfo.boxRate = medicineInfo.boxRate
        oldMedicineInfo.unitType = medicineInfo.unitType
        return oldMedicineInfo
    }
}
