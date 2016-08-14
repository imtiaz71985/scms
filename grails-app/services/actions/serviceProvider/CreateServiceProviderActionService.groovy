package actions.serviceProvider

import com.model.ListServiceProviderActionServiceModel
import com.scms.ServiceProvider
import grails.transaction.Transactional
import org.apache.log4j.Logger
import scms.ActionServiceIntf
import scms.BaseService

class CreateServiceProviderActionService extends BaseService implements ActionServiceIntf {

    private static final String SAVE_SUCCESS_MESSAGE = "Service provider has been saved successfully"
    private static final String ALREADY_EXIST = "Same provider already exist"
    private static final String SERVICE_PROVIDER = "serviceProvider"

    private Logger log = Logger.getLogger(getClass())

    /**
     * 1. input validation check
     * 2. duplicate check for role-name
     * @param params - receive role object from controller
     * @return - map.
     */
    @Transactional(readOnly = true)
    public Map executePreCondition(Map params) {
        try {
            //Check parameters
            if (!params.name) {
                return super.setError(params, INVALID_INPUT_MSG)
            }
            int duplicateCount = ServiceProvider.countByNameIlike(params.name)
            if (duplicateCount > 0) {
                return super.setError(params, ALREADY_EXIST)
            }
            ServiceProvider serviceProvider = buildObject(params)
            params.put(SERVICE_PROVIDER, serviceProvider)
            return params
        } catch (Exception ex) {
            log.error(ex.getMessage())
            throw new RuntimeException(ex)
        }
    }
    /**
     * 1. receive role object from pre execute method
     * 2. create new role
     * This method is in transactional block and will roll back in case of any exception
     * @param result - map received from pre execute method
     * @return - map.
     */
    @Transactional
    public Map execute(Map result) {
        try {
            ServiceProvider serviceProvider = (ServiceProvider) result.get(SERVICE_PROVIDER)
            serviceProvider.save()
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
        ServiceProvider serviceProvider = (ServiceProvider) result.get(SERVICE_PROVIDER)
        ListServiceProviderActionServiceModel model = ListServiceProviderActionServiceModel.read(serviceProvider.id)
        result.put(SERVICE_PROVIDER, model)
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

    /**
     * Build role object
     * @param parameterMap -serialized parameters from UI
     * @return -new role object
     */
    private ServiceProvider buildObject(Map parameterMap) {
        ServiceProvider serviceProvider = new ServiceProvider(parameterMap)
        return serviceProvider
    }
}
