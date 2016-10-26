package actions.ServiceChargeFreeDays

import com.scms.ServiceChargeFreeDays
import grails.plugin.springsecurity.SpringSecurityService
import grails.transaction.Transactional
import org.apache.log4j.Logger
import scms.ActionServiceIntf
import scms.BaseService
import scms.utility.DateUtility

@Transactional
class CreateServiceChargeFreeDaysActionService extends BaseService implements ActionServiceIntf {

    SpringSecurityService springSecurityService
    private static final String SAVE_SUCCESS_MESSAGE = "Data saved successfully"
    private static final String ALREADY_EXIST = "Service type already exist"
    private static final String SERVICE_CHARGE_FREE_DAYS = "serviceChargeFreeDays"
    private Logger log = Logger.getLogger(getClass())


    @Transactional
    public Map executePreCondition(Map params){
        try {
            //Check parameters

            if (!params.serviceTypeId||!params.daysForFree||!params.activationDate) {
                return super.setError(params, INVALID_INPUT_MSG)
            }           
            ServiceChargeFreeDays serviceChargeFreeDays = buildObject(params)
            params.put(SERVICE_CHARGE_FREE_DAYS, serviceChargeFreeDays)
            return params
        } catch (Exception ex) {
            log.error(ex.getMessage())
            throw new RuntimeException(ex)
        }

    }

    @Transactional
    public Map execute(Map result) {
        try {

            ServiceChargeFreeDays serviceChargeFreeDays = (ServiceChargeFreeDays) result.get(SERVICE_CHARGE_FREE_DAYS)

            ServiceChargeFreeDays oldServiceHeadInfo = ServiceChargeFreeDays.findByServiceTypeIdAndIsActive(serviceChargeFreeDays.serviceTypeId,true)
            if(oldServiceHeadInfo!=null) {
                oldServiceHeadInfo.isActive = false
                oldServiceHeadInfo.save()
            }
            serviceChargeFreeDays.save()

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
    private ServiceChargeFreeDays buildObject(Map parameterMap) {
        parameterMap.activationDate=DateUtility.parseMaskedDate(parameterMap.activationDate)
        ServiceChargeFreeDays serviceChargeFreeDays = new ServiceChargeFreeDays(parameterMap)
        serviceChargeFreeDays.activationDate=DateUtility.getSqlDate(parameterMap.activationDate)
        serviceChargeFreeDays.createDate=DateUtility.getSqlDate(new Date())
        serviceChargeFreeDays.createdBy= springSecurityService.principal.id
        return serviceChargeFreeDays
    }
}
