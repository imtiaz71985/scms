package actions.serviceType

import com.model.ListServiceTypeActionServiceModel
import com.scms.ServiceType
import grails.transaction.Transactional
import org.apache.log4j.Logger
import scms.ActionServiceIntf
import scms.BaseService
import service.ServiceTypeService

@Transactional
class UpdateServiceTypeActionService extends BaseService implements ActionServiceIntf {

    private static final String UPDATE_SUCCESS_MESSAGE = "Service Type has been updated successfully"
    private static final String ROLE_ALREADY_EXIST = "Same Type already exist"
    private static final String SERVICE_TYPE = "serviceType"

    ServiceTypeService serviceTypeService

    private Logger log = Logger.getLogger(getClass())

    public Map executePreCondition(Map params) {
        try {
            if ((!params.id) || (!params.name)) {
                return super.setError(params, INVALID_INPUT_MSG)
            }
            long id = Long.parseLong(params.id.toString())
            ServiceType oldServiceType = (ServiceType) serviceTypeService.read(id)
            String name = params.name.toString()
            int duplicateCount = serviceTypeService.countByNameIlikeAndIdNotEqual(name, id)
            if (duplicateCount > 0) {
                return super.setError(params, ROLE_ALREADY_EXIST)
            }
            ServiceType serviceType = buildObject(params, oldServiceType)
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
        return super.setSuccess(result, UPDATE_SUCCESS_MESSAGE)
    }

    public Map buildFailureResultForUI(Map params) {
        return params
    }

    private static ServiceType buildObject(Map parameterMap, ServiceType oldServiceType) {
        ServiceType serviceType = new ServiceType(parameterMap)
        oldServiceType.name = serviceType.name
        oldServiceType.description = serviceType.description
        oldServiceType.isActive = serviceType.isActive
        oldServiceType.isForCounselor=serviceType.isForCounselor
        return oldServiceType
    }
}
