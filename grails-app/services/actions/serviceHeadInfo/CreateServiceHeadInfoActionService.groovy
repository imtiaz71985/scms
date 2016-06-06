package actions.serviceHeadInfo

import com.model.ListServiceHeadInfoActionServiceModel
import com.scms.ServiceCharges
import com.scms.ServiceHeadInfo
import grails.plugin.springsecurity.SpringSecurityService
import grails.transaction.Transactional
import org.apache.log4j.Logger
import scms.ActionServiceIntf
import scms.BaseService
import scms.utility.DateUtility
import service.ServiceHeadInfoService

@Transactional
class CreateServiceHeadInfoActionService extends BaseService implements ActionServiceIntf {

    SpringSecurityService springSecurityService
    private static final String SAVE_SUCCESS_MESSAGE = "Data saved successfully"
    private static final String ALREADY_EXIST = "Name & type already exist"
    private static final String SERVICE_HEAD_INFO = "serviceHeadInfo"
    private Logger log = Logger.getLogger(getClass())

    ServiceHeadInfoService serviceHeadInfoService

    @Transactional
    public Map executePreCondition(Map params){
        try {
            //Check parameters

            if (!params.serviceCode||!params.serviceTypeId||!params.name||!params.chargeAmount||!params.activationDate) {
                return super.setError(params, INVALID_INPUT_MSG)
            }
            int duplicateCount = serviceHeadInfoService.countByNameIlikeAndServiceTypeId(params.name,params.serviceTypeId)
            if (duplicateCount > 0) {
                return super.setError(params, ALREADY_EXIST)
            }
            ServiceHeadInfo serviceHeadInfo = buildObject(params)
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

            ServiceCharges serviceCharges=new ServiceCharges()
            serviceCharges.serviceCode=serviceHeadInfo.serviceCode
            serviceCharges.chargeAmount=Double.parseDouble(result.chargeAmount)
            serviceCharges.activationDate=DateUtility.getSqlDate(DateUtility.parseMaskedDate(result.activationDate))
            serviceCharges.createDate=DateUtility.getSqlDate(new Date())
            serviceCharges.createdBy = springSecurityService.principal.id
            serviceCharges.save()

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
        return super.setSuccess(result, SAVE_SUCCESS_MESSAGE)
    }

    public Map buildFailureResultForUI(Map result) {
        return result
    }

    /**
     * Build systemEntity object
     * @param parameterMap -serialized parameters from UI
     * @return -new systemEntity object
     /*    */
    private ServiceHeadInfo buildObject(Map parameterMap) {
        ServiceHeadInfo serviceHeadInfo = new ServiceHeadInfo(parameterMap)
        serviceHeadInfo.createDate=DateUtility.getSqlDate(new Date())
        serviceHeadInfo.createdBy= springSecurityService.principal.id
        serviceHeadInfo.isActive=true

        return serviceHeadInfo
    }
}
