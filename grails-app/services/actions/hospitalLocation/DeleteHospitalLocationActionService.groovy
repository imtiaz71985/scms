package actions.hospitalLocation

import com.scms.HospitalLocation
import com.scms.SecUser
import grails.transaction.Transactional
import org.apache.log4j.Logger
import scms.ActionServiceIntf
import scms.BaseService

@Transactional
class DeleteHospitalLocationActionService extends BaseService implements ActionServiceIntf {

    private Logger log = Logger.getLogger(getClass())

    private static final String DELETE_SUCCESS_MESSAGE = "Hospital has been deleted successfully"
    private static final String RELATED_FEATURE_FOUND = " different user associated with this hospital"
    private static final String HOSPITAL = "hospitalLocation"

    @Transactional(readOnly = true)
    public Map executePreCondition(Map params) {
        long id = Long.parseLong(params.id)
        HospitalLocation hospitalLocation = HospitalLocation.read(id)
        int count = SecUser.countByHospitalCode(hospitalLocation.code)
        if(count>0){
            return super.setError(params, count + RELATED_FEATURE_FOUND)
        }
        params.put(HOSPITAL, hospitalLocation)
        return params
    }

    @Transactional
    public Map execute(Map result) {
        try {
            HospitalLocation hospitalLocation = (HospitalLocation) result.get(HOSPITAL)
            hospitalLocation.delete()
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
