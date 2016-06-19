package actions.medicineInfo

import com.scms.MedicineInfo
import com.scms.MedicinePrice
import com.scms.MedicineSellInfoDetails
import grails.transaction.Transactional
import org.apache.log4j.Logger
import scms.ActionServiceIntf
import scms.BaseService

@Transactional
class DeleteMedicineInfoActionService extends BaseService implements ActionServiceIntf {

    private Logger log = Logger.getLogger(getClass())

    private static final String DELETE_SUCCESS_MESSAGE = "Medicine has been deleted successfully"
    private static final String RELATED_FEATURE_FOUND = " different records associated with this medicine"
    private static final String MEDICINE_INFO = "medicineInfo"

    @Transactional(readOnly = true)
    public Map executePreCondition(Map params) {
        long id = Long.parseLong(params.id)
        MedicineInfo medicineInfo = MedicineInfo.read(id)
        int count = MedicineSellInfoDetails.countByMedicineId(medicineInfo.id)
        if(count>0){
            return super.setError(params, count + RELATED_FEATURE_FOUND)
        }
        params.put(MEDICINE_INFO, medicineInfo)
        return params
    }

    @Transactional
    public Map execute(Map result) {
        try {
            MedicineInfo medicineInfo = (MedicineInfo) result.get(MEDICINE_INFO)
            List<MedicinePrice> lstMedicinePrice=MedicinePrice.findAllByMedicineId(medicineInfo.id)
            for (int i=0; i<lstMedicinePrice.size();i++){
                lstMedicinePrice[i].delete()
            }
            medicineInfo.delete()

            return result
        } catch (Exception ex) {
            log.error(ex.getMessage())
            throw new RuntimeException(ex)
        }
    }

    /**
     * There is no postCondition, so return the same map as received
     *
     * @param result - resulting map from execute
     * @return - same map of input-parameter containing isError(true/false)
     */
    public Map executePostCondition(Map result) {
        return result
    }

    /**
     * 1. put success message
     *
     * @param result - map from execute/executePost method
     * @return - same map of input-parameter containing isError(true/false)
     */
    public Map buildSuccessResultForUI(Map result) {
        return super.setSuccess(result, DELETE_SUCCESS_MESSAGE)
    }

    /**
     * The input-parameter Map must have "isError:true" with corresponding message
     *
     * @param result - map returned from previous methods
     * @return - same map of input-parameter containing isError(true/false)
     */
    public Map buildFailureResultForUI(Map result) {
        return result
    }
}
