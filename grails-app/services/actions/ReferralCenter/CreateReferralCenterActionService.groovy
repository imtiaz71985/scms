package actions.ReferralCenter

import com.model.ListReferralCenterActionServiceModel
import com.scms.ReferralCenter
import grails.plugin.springsecurity.SpringSecurityService
import grails.transaction.Transactional
import org.apache.log4j.Logger
import scms.ActionServiceIntf
import scms.BaseService

@Transactional
class CreateReferralCenterActionService extends BaseService implements ActionServiceIntf{

    private static final String SAVE_SUCCESS_MESSAGE = "Data has been saved successfully"
    private static final String ALREADY_EXIST = "Same center already exist"
    private static final String REFERRAL_CENTER = "referralcenter"

    SpringSecurityService springSecurityService
    private Logger log = Logger.getLogger(getClass())

    @Transactional(readOnly = true)
    public Map executePreCondition(Map params) {
        try {
            //Check parameters
            if (!params.name) {
                return super.setError(params, INVALID_INPUT_MSG)
            }
            int duplicateCount = ReferralCenter.countByName(params.name)
            if (duplicateCount > 0) {
                return super.setError(params, ALREADY_EXIST)
            }
            ReferralCenter referralCenter = buildObject(params)
            params.put(REFERRAL_CENTER, referralCenter)
            return params
        } catch (Exception ex) {
            log.error(ex.getMessage())
            throw new RuntimeException(ex)
        }
    }

    @Transactional
    public Map execute(Map result) {
        try {
            ReferralCenter referralCenter = (ReferralCenter) result.get(REFERRAL_CENTER)
            referralCenter.save()

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
        ReferralCenter referralCenter = (ReferralCenter) result.get(REFERRAL_CENTER)
        ListReferralCenterActionServiceModel model = ListReferralCenterActionServiceModel.read(referralCenter.id)
        result.put(REFERRAL_CENTER, model)
        return super.setSuccess(result, SAVE_SUCCESS_MESSAGE)
    }

    public Map buildFailureResultForUI(Map result) {
        return result
    }

    /**
     * Build ReferralCenter object
     * @param parameterMap -serialized parameters from UI
     * @return -new ReferralCenter object
     */
    private ReferralCenter buildObject(Map parameterMap) {
        ReferralCenter referralCenter = new ReferralCenter(parameterMap)
        referralCenter.isActive=true
        return referralCenter
    }
}
