package actions.serviceType

import com.model.ListServiceTypeActionServiceModel
import com.scms.ServiceType
import grails.transaction.Transactional
import org.apache.log4j.Logger
import scms.ActionServiceIntf
import scms.BaseService
import service.ServiceTypeService

@Transactional
class CreateServiceTypeActionService extends BaseService implements ActionServiceIntf {

    private static final String SAVE_SUCCESS_MESSAGE = "Service type has been saved successfully"
    private static final String ALREADY_EXIST = "Same service type already exist"
    private static final String SERVICE_TYPE = "serviceType"

    ServiceTypeService serviceTypeService

    private Logger log = Logger.getLogger(getClass())

    @Transactional(readOnly = true)
    public Map executePreCondition(Map params) {
        try {
            //Check parameters
            if (!params.name) {
                return super.setError(params, INVALID_INPUT_MSG)
            }
            int duplicateCount = serviceTypeService.countByNameIlike(params.name)
            if (duplicateCount > 0) {
                return super.setError(params, ALREADY_EXIST)
            }
            ServiceType serviceType = buildObject(params)
            params.put(SERVICE_TYPE, serviceType)
            return params
        } catch (Exception ex) {
            log.error(ex.getMessage())
            throw new RuntimeException(ex)
        }
    }

    @Transactional
    public Map execute(Map result) {
        try {
            ServiceType serviceType = (ServiceType) result.get(SERVICE_TYPE)
            serviceType.save()
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
        ServiceType serviceType = (ServiceType) result.get(SERVICE_TYPE)
        ListServiceTypeActionServiceModel model = ListServiceTypeActionServiceModel.read(serviceType.id)
        result.put(SERVICE_TYPE, model)
        return super.setSuccess(result, SAVE_SUCCESS_MESSAGE)
    }

    public Map buildFailureResultForUI(Map result) {
        return result
    }

    /**
     * Build ServiceType object
     * @param parameterMap -serialized parameters from UI
     * @return -new ServiceType object
     */
    private ServiceType buildObject(Map parameterMap) {
        ServiceType serviceType = new ServiceType(parameterMap)
        return serviceType
    }
}
