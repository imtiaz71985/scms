package actions.hospitalLocation

import com.model.ListHospitalLocationActionServiceModel
import com.scms.HospitalLocation
import grails.transaction.Transactional
import org.apache.log4j.Logger
import scms.ActionServiceIntf
import scms.BaseService

@Transactional
class CreateHospitalLocationActionService extends BaseService implements ActionServiceIntf{

    private static final String SAVE_SUCCESS_MESSAGE = "Data has been saved successfully"
    private static final String ALREADY_EXIST = "Same name already exist"
    private static final String HOSPITAL = "hospitalLocation"


    private Logger log = Logger.getLogger(getClass())

    @Transactional(readOnly = true)
    public Map executePreCondition(Map params) {
        try {
            //Check parameters
            if (!params.name) {
                return super.setError(params, INVALID_INPUT_MSG)
            }
            int duplicateCount = HospitalLocation.countByName(params.name)
            if (duplicateCount > 0) {
                return super.setError(params, ALREADY_EXIST)
            }
            HospitalLocation hospitalLocation = buildObject(params)
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
        return super.setSuccess(result, SAVE_SUCCESS_MESSAGE)
    }

    public Map buildFailureResultForUI(Map result) {
        return result
    }

    /**
     * Build HospitalLocation object
     * @param parameterMap -serialized parameters from UI
     * @return -new HospitalLocation object
     */
    private HospitalLocation buildObject(Map parameterMap) {
        int serial = HospitalLocation.count()
        serial+=1
        String formatted = String.format("%02d", serial);
        HospitalLocation hospitalLocation = new HospitalLocation(parameterMap)
        hospitalLocation.code = formatted
        return hospitalLocation
    }
}
