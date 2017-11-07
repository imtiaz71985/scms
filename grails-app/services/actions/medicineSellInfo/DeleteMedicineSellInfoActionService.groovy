package actions.medicineSellInfo

import com.scms.MedicineReturn
import com.scms.MedicineSellInfo
import com.scms.MedicineSellInfoDetails
import com.scms.MedicineStock
import grails.transaction.Transactional
import org.apache.log4j.Logger
import scms.ActionServiceIntf
import scms.BaseService

@Transactional
class DeleteMedicineSellInfoActionService extends BaseService implements ActionServiceIntf {

    private Logger log = Logger.getLogger(getClass())

    private static final String DELETE_SUCCESS_MESSAGE = "Record has been deleted successfully"
    private static final String NOT_FOUND = "Selected record does not exits"
    private static final String RECORDS_EXISTS = "Sale details exists"
    private static final String MEDICINE_SELL_INFO = "medicineSellInfo"


    @Transactional(readOnly = true)
    public Map executePreCondition(Map params) {
        long id = Long.parseLong(params.id)
        MedicineSellInfo medicineSellInfo = MedicineSellInfo.findById(id)
        if(!medicineSellInfo){
            return super.setError(params, NOT_FOUND)
        }
        int count = MedicineReturn.countByTraceNo(medicineSellInfo.voucherNo)
        if (count > 0) {
            return super.setError(params, 'Sorry! Please delete return info for this voucher.')
        }
        medicineSellInfo.isDelete=true
        params.put(MEDICINE_SELL_INFO, medicineSellInfo)
        return params
    }

    @Transactional
    public Map execute(Map result) {
        try {
            MedicineSellInfo medicineSellInfo = (MedicineSellInfo) result.get(MEDICINE_SELL_INFO)
            medicineSellInfo.save()
            List<MedicineSellInfoDetails> lstDetails = MedicineSellInfoDetails.findAllByVoucherNo(medicineSellInfo.voucherNo)
            if (lstDetails.size() > 0) {
                for (int i = 0; i < lstDetails.size(); i++) {

                    MedicineStock stock = MedicineStock.findByMedicineIdAndHospitalCode(lstDetails[i].medicineId, medicineSellInfo.hospitalCode)
                    stock.stockQty += lstDetails[i].quantity
                    stock.save()
                }
            }
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
