package actions.hospitalLocation

import com.model.ListHospitalLocationActionServiceModel
import com.scms.HospitalLocation
import com.scms.MedicineStock
import grails.transaction.Transactional
import org.apache.log4j.Logger
import scms.ActionServiceIntf
import scms.BaseService

@Transactional
class UpdateHospitalLocationActionService extends BaseService implements ActionServiceIntf {

    private static final String UPDATE_SUCCESS_MESSAGE = "Hospital has been updated successfully"
    private static final String ROLE_ALREADY_EXIST = "Same name already exist"
    private static final String HOSPITAL = "hospitalLocation"


    private Logger log = Logger.getLogger(getClass())

    public Map executePreCondition(Map params) {
        try {
            if ((!params.id) || (!params.name)) {
                return super.setError(params, INVALID_INPUT_MSG)
            }
            long id = Long.parseLong(params.id.toString())
            HospitalLocation oldHospitalLocation = (HospitalLocation) HospitalLocation.read(id)
            String name = params.name.toString()
            int duplicateCount = HospitalLocation.countByNameIlikeAndIdNotEqual(name, id)
            if (duplicateCount > 0) {
                return super.setError(params, ROLE_ALREADY_EXIST)
            }
            HospitalLocation hospitalLocation = buildObject(params, oldHospitalLocation)
            params.put(HOSPITAL, hospitalLocation)
            return params
        } catch (Exception ex) {
            log.error(ex.getMessage())
            throw new RuntimeException(ex)
        }
    }

    @Transactional
    public Map execute(Map result) {
        try {
            HospitalLocation hospitalLocation = (HospitalLocation) result.get(HOSPITAL)
            hospitalLocation.save()
            if(hospitalLocation.isClinic){
                int count = MedicineStock.countByHospitalCode(hospitalLocation.code)
                if (count==0){
                    setMedicineStock(hospitalLocation.code)
                }
            }
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
        HospitalLocation hospitalLocation = (HospitalLocation) result.get(HOSPITAL)
        ListHospitalLocationActionServiceModel model = ListHospitalLocationActionServiceModel.read(hospitalLocation.id)
        result.put(HOSPITAL, model)
        return super.setSuccess(result, UPDATE_SUCCESS_MESSAGE)
    }

    public Map buildFailureResultForUI(Map params) {
        return params
    }

    private static HospitalLocation buildObject(Map parameterMap, HospitalLocation oldHospitalLocation) {
        HospitalLocation hospitalLocation = new HospitalLocation(parameterMap)
        oldHospitalLocation.name = hospitalLocation.name
        oldHospitalLocation.address = hospitalLocation.address
        oldHospitalLocation.isClinic = hospitalLocation.isClinic
        return oldHospitalLocation
    }

    public void setMedicineStock(String code) {
        String str = """
           INSERT INTO medicine_stock (version, medicine_id, stock_qty,hospital_code)
                SELECT 0,id,0, ${code} FROM medicine_info;
    """
        executeInsertSql(str)
    }
}
