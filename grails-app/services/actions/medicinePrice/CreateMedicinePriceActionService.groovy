package actions.medicinePrice

import com.model.ListMedicinePriceActionServiceModel
import com.scms.MedicineInfo
import com.scms.MedicinePrice
import com.scms.SubsidyOnMedicine
import grails.transaction.Transactional
import org.apache.log4j.Logger
import scms.ActionServiceIntf
import scms.BaseService
import scms.utility.DateUtility

import java.text.DateFormat
import java.text.SimpleDateFormat

@Transactional
class CreateMedicinePriceActionService  extends BaseService implements ActionServiceIntf {

    private static final String SAVE_SUCCESS_MESSAGE = "Medicine price has been saved successfully"
    private static final String MEDICINE_PRICE = "medicinePrice"

    private Logger log = Logger.getLogger(getClass())

    @Transactional(readOnly = true)
    public Map executePreCondition(Map params) {
        try {
            if (!params.medicineId||!params.price) {
                return super.setError(params, INVALID_INPUT_MSG)
            }
            long medicineId = Long.parseLong(params.medicineId)
            String newStartStr = parseDateFormat(params.start)
            SimpleDateFormat simpleDF = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss")
            Date retDate = simpleDF.parse(newStartStr);

            MedicinePrice activePrice = MedicinePrice.findByMedicineIdAndIsActive(medicineId,true)
            if (activePrice) {
                activePrice.end = setExpireTime(retDate)
                activePrice.isActive = Boolean.FALSE
            }
            MedicinePrice medicinePrice = buildObject(params,retDate)
            params.put(MEDICINE_PRICE, medicinePrice)
            return params
        } catch (Exception ex) {
            log.error(ex.getMessage())
            throw new RuntimeException(ex)
        }
    }

    @Transactional
    public Map execute(Map result) {
        try {
            MedicinePrice medicinePrice = (MedicinePrice) result.get(MEDICINE_PRICE)
            SubsidyOnMedicine som = SubsidyOnMedicine.findByMedicineId(medicinePrice.id)
            double priceAfterSubsidy=medicinePrice.mrpPrice-((medicinePrice.mrpPrice*som.subsidyPert)/100)
            medicinePrice.price = priceAfterSubsidy
            medicinePrice.save()

            MedicineInfo medicineInfo = MedicineInfo.read(medicinePrice.medicineId)
            medicineInfo.mrpPrice = medicinePrice.mrpPrice
            medicineInfo.unitPrice = priceAfterSubsidy
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
     * @param result - map received from executePost method
     * @return - map containing success message
     */
    public Map buildSuccessResultForUI(Map result) {
        MedicinePrice medicinePrice = (MedicinePrice) result.get(MEDICINE_PRICE)
        ListMedicinePriceActionServiceModel model = ListMedicinePriceActionServiceModel.findByMedicineId(medicinePrice.id)
        result.put(MEDICINE_PRICE, model)
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

    private MedicinePrice buildObject(Map parameterMap,Date retDate) {
        parameterMap.start = retDate
        MedicinePrice medicinePrice = new MedicinePrice(parameterMap)
        medicinePrice.mrpPrice = Double.parseDouble(parameterMap.mrpPrice)
        medicinePrice.isActive = Boolean.TRUE
        return medicinePrice
    }

    private static Date setExpireTime(Date dateTime){
        Calendar cal = Calendar.getInstance()
        cal.setTime(dateTime)
        cal.add(Calendar.SECOND, cal.get(Calendar.SECOND)-1)
        return cal.getTime()
    }

    private static String parseDateFormat(String dateStr) {
        DateFormat readFormat = new SimpleDateFormat("dd/MM/yyyy HH:mm:ss");
        DateFormat writeFormat = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
        Date date = null;
        try {
            date = readFormat.parse(dateStr);
        }
        catch (Exception e) {
            e.printStackTrace();
        }
        if (date != null) {
            String formattedDate = writeFormat.format(date);
            return formattedDate
        }
        return null
    }
}
