package actions.serviceProvider

import com.model.ListServiceProviderActionServiceModel
import com.scms.ServiceProvider
import grails.transaction.Transactional
import org.apache.log4j.Logger
import scms.ActionServiceIntf
import scms.BaseService
import service.SecRoleService

@Transactional
class UpdateServiceProviderActionService extends BaseService implements ActionServiceIntf {

    private static final String UPDATE_SUCCESS_MESSAGE = "Service provider has been updated successfully"
    private static final String ALREADY_EXIST = "Same provider already exist"
    private static final String SERVICE_PROVIDER = "serviceProvider"

    SecRoleService secRoleService

    private Logger log = Logger.getLogger(getClass())

    public Map executePreCondition(Map params) {
        try {
            //Check parameters
            if ((!params.id) || (!params.name)) {
                return super.setError(params, INVALID_INPUT_MSG)
            }
            long id = Long.parseLong(params.id.toString())
            ServiceProvider oldProvider = ServiceProvider.read(id)
            String name = params.name.toString()
            int duplicateCount = ServiceProvider.countByNameIlikeAndIdNotEqual(name, id)
            if (duplicateCount > 0) {
                return super.setError(params, ALREADY_EXIST)
            }
            ServiceProvider serviceProvider = buildObject(params, oldProvider)
            params.put(SERVICE_PROVIDER, serviceProvider)
            return params
        } catch (Exception ex) {
            log.error(ex.getMessage())
            throw new RuntimeException(ex)
        }
    }

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
     * @param result - map received from execute method
     * @return - map with success message
     */
    public Map buildSuccessResultForUI(Map result) {
        ServiceProvider serviceProvider = (ServiceProvider) result.get(SERVICE_PROVIDER)
        ListServiceProviderActionServiceModel model = ListServiceProviderActionServiceModel.read(serviceProvider.id)
        result.put(SERVICE_PROVIDER, model)
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

    private static ServiceProvider buildObject(Map parameterMap, ServiceProvider oldObject) {
        ServiceProvider role = new ServiceProvider(parameterMap)
        oldObject.typeId = role.typeId
        oldObject.name = role.name
        oldObject.isActive = role.isActive
        oldObject.mobileNo = role.mobileNo
        return oldObject
    }
}
