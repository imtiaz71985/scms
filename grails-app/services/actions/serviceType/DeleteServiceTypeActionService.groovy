package actions.serviceType

import com.scms.ServiceType
import grails.transaction.Transactional
import org.apache.log4j.Logger
import scms.ActionServiceIntf
import scms.BaseService
import service.ServiceTypeService

@Transactional
class DeleteServiceTypeActionService extends BaseService implements ActionServiceIntf {

    private Logger log = Logger.getLogger(getClass())

    private static final String DELETE_SUCCESS_MESSAGE = "Service Type has been deleted successfully"
    private static final String NOT_FOUND = "Selected service type does not exits"
    private static final String UNABLE_TO_CHANGE = "Unable to make changes"
    private static final String SERVICE_TYPE = "serviceType"

    ServiceTypeService serviceTypeService

    @Transactional(readOnly = true)
    public Map executePreCondition(Map params) {
        long id = Long.parseLong(params.id)
        ServiceType serviceType = serviceTypeService.read(id)
        if(!serviceType){
            return super.setError(params, NOT_FOUND)
        }
/*        int count = SecUserSecRole.countBySecRole(role)
        if(count>0){
            return super.setError(params, count + UNABLE_TO_CHANGE)
        }*/

        params.put(SERVICE_TYPE, serviceType)
        return params
    }

    @Transactional
    public Map execute(Map result) {
        try {
            ServiceType serviceType = (ServiceType) result.get(SERVICE_TYPE)
            serviceType.delete()
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
