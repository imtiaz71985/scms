package actions.serviceHeadInfo

import com.scms.ServiceCharges
import com.scms.ServiceHeadInfo
import grails.plugin.springsecurity.SpringSecurityService
import grails.transaction.Transactional
import org.apache.log4j.Logger
import scms.ActionServiceIntf
import scms.BaseService
import scms.utility.DateUtility

@Transactional
class UpdateServiceHeadInfoActionService extends BaseService implements ActionServiceIntf {

    SpringSecurityService springSecurityService
    private static final String UPDATE_SUCCESS_MESSAGE = "Data has been updated successfully"
    private static final String SERVICE_HEAD_INFO = "serviceHeadInfo"


    private Logger log = Logger.getLogger(getClass())

    public Map executePreCondition(Map params) {
        try {

            if (!params.serviceCode || !params.name || !params.chargeAmount || !params.activationDate) {
                return super.setError(params, INVALID_INPUT_MSG)
            }

            ServiceHeadInfo oldServiceHeadInfo = ServiceHeadInfo.findByServiceCode(params.serviceCode.toString())

            ServiceHeadInfo serviceHeadInfo = buildObject(params, oldServiceHeadInfo)
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

            ServiceCharges serviceCharges = ServiceCharges.findByServiceCodeAndLastActiveDate(serviceHeadInfo.serviceCode,null)

            Date d=DateUtility.parseMaskedDate(result.activationDate)
            d=d.minus(1)
            boolean newEntry=true
           if(serviceCharges!=null) {
               if(serviceCharges.activationDate>DateUtility.getSqlFromDateWithSeconds(new Date())) {
                   serviceCharges.chargeAmount = Double.parseDouble(result.chargeAmount)
                   serviceCharges.activationDate = DateUtility.getSqlDate(DateUtility.parseMaskedDate(result.activationDate))
                   serviceCharges.createDate = DateUtility.getSqlDate(new Date())
                   serviceCharges.createdBy = springSecurityService.principal.id
                   newEntry=false
               }
               else {
                   serviceCharges.lastActiveDate = DateUtility.getSqlDate(d)
               }
               serviceCharges.save()
               if(!newEntry) {
                   ServiceCharges serviceCharges3 = ServiceCharges.findByServiceCodeAndLastActiveDateIsNotNull(serviceHeadInfo.serviceCode,[sort:'id',order:'desc',limit: 1 ])
                   //ServiceCharges serviceCharges3 = ServiceCharges.findByServiceCodeAndLastActiveDateGreaterThan(serviceHeadInfo.serviceCode,DateUtility.getSqlFromDateWithSeconds(d))
                   if(!serviceCharges3){
                       serviceCharges3.lastActiveDate = DateUtility.getSqlDate(d)
                       serviceCharges3.save();
                   }
               }
           }

            if(serviceHeadInfo.isActive && newEntry) {
                ServiceCharges serviceCharges2 = new ServiceCharges()
                serviceCharges2.serviceCode = serviceHeadInfo.serviceCode
                serviceCharges2.chargeAmount = Double.parseDouble(result.chargeAmount)
                serviceCharges2.activationDate = DateUtility.getSqlDate(DateUtility.parseMaskedDate(result.activationDate))
                serviceCharges2.createDate = DateUtility.getSqlDate(new Date())
                serviceCharges2.createdBy = springSecurityService.principal.id
                serviceCharges2.save()
            }

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
        /*ServiceHeadInfo serviceHeadInfo = (ServiceHeadInfo) result.get(SERVICE_HEAD_INFO)
        ListServiceHeadInfoActionServiceModel model = ListServiceHeadInfoActionServiceModel.findByServiceCode(serviceHeadInfo.serviceCode)
        result.put(SERVICE_HEAD_INFO, model)*/
        return super.setSuccess(result, UPDATE_SUCCESS_MESSAGE)
    }

    public Map buildFailureResultForUI(Map params) {
        return params
    }

    private ServiceHeadInfo buildObject(Map parameterMap, ServiceHeadInfo oldServiceHeadInfo) {

        ServiceHeadInfo serviceHeadInfo = new ServiceHeadInfo(parameterMap)
        oldServiceHeadInfo.isActive = serviceHeadInfo.isActive
        oldServiceHeadInfo.name = serviceHeadInfo.name
        oldServiceHeadInfo.modifyDate = DateUtility.getSqlDate(new Date())
        oldServiceHeadInfo.modifyBy = springSecurityService.principal.id

        return oldServiceHeadInfo
    }
}
