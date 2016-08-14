package actions.serviceProvider

import com.scms.ServiceProvider
import grails.transaction.Transactional
import org.apache.log4j.Logger
import scms.ActionServiceIntf
import scms.BaseService

@Transactional
class DeleteServiceProviderActionService extends BaseService implements ActionServiceIntf {

    private Logger log = Logger.getLogger(getClass())

    private static final String DELETE_SUCCESS_MESSAGE = "Service provider has been deleted successfully"
    private static final String NOT_FOUND = "Selected provider does not exits"

    @Override
    protected Map getSearchResult(Map parameterMap, Class domainClass, Closure additionalFilter) {
        return super.getSearchResult(parameterMap, domainClass, additionalFilter)
    }
    private static final String SERVICE_PROVIDER = "serviceProvider"

    @Transactional(readOnly = true)
    public Map executePreCondition(Map params) {
        long id = Long.parseLong(params.id.toString())
        ServiceProvider provider = ServiceProvider.read(id)
        if(!provider){
            return super.setError(params, NOT_FOUND)
        }
        params.put(SERVICE_PROVIDER, provider)
        return params
    }

    @Transactional
    public Map execute(Map result) {
        try {
            ServiceProvider serviceProvider = (ServiceProvider) result.get(SERVICE_PROVIDER)
            serviceProvider.delete()
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
