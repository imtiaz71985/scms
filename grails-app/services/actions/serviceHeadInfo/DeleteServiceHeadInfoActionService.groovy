package actions.serviceHeadInfo

import com.model.ListServiceHeadInfoActionServiceModel
import com.scms.ServiceHeadInfo
import grails.plugin.springsecurity.SpringSecurityService
import grails.transaction.Transactional
import org.apache.log4j.Logger
import scms.ActionServiceIntf
import scms.BaseService
import scms.utility.DateUtility
import service.RegistrationInfoService

@Transactional
class DeleteServiceHeadInfoActionService  extends BaseService implements ActionServiceIntf{
    private Logger log = Logger.getLogger(getClass())

    private static final String DELETE_SUCCESS_MESSAGE = "Record has been deactivated successfully"
    private static final String NOT_FOUND = "Selected record does not exits"
    private static final String SERVICE_HEAD_INFO = "serviceHeadInfo"
    SpringSecurityService springSecurityService
    RegistrationInfoService registrationInfoService

    @Transactional(readOnly = true)
    public Map executePreCondition(Map params) {
        try {
            String serviceCode=params.serviceCode.toString()
            ServiceHeadInfo oldServiceHeadInfo = ServiceHeadInfo.findByServiceCode(serviceCode)
            if(!oldServiceHeadInfo){
                return super.setError(params, NOT_FOUND)
            }
            ServiceHeadInfo serviceHeadInfo = buildObject(oldServiceHeadInfo)
            params.put(SERVICE_HEAD_INFO, serviceHeadInfo)
            return params
        } catch (Exception ex) {
            log.error(ex.getMessage())
            throw new RuntimeException(ex)
        }
    }

    @Transactional
    public Map execute(Map result) {
        try {
            ServiceHeadInfo serviceHeadInfo = (ServiceHeadInfo) result.get(SERVICE_HEAD_INFO)
            serviceHeadInfo.save()
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
        ServiceHeadInfo serviceHeadInfo = (ServiceHeadInfo) result.get(SERVICE_HEAD_INFO)
        ListServiceHeadInfoActionServiceModel model = ListServiceHeadInfoActionServiceModel.findByServiceCode(serviceHeadInfo.serviceCode)
        result.put(SERVICE_HEAD_INFO, model)
        return super.setSuccess(result, DELETE_SUCCESS_MESSAGE)
    }

    public Map buildFailureResultForUI(Map params) {
        return params
    }

    private  ServiceHeadInfo buildObject(ServiceHeadInfo oldServiceHeadInfo) {

        oldServiceHeadInfo.modifyDate = DateUtility.getSqlDate(new Date())
        oldServiceHeadInfo.modifyBy = springSecurityService.principal.id
        oldServiceHeadInfo.isActive=false

        return oldServiceHeadInfo
    }
}
