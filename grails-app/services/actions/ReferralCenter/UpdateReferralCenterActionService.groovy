package actions.ReferralCenter

import com.model.ListReferralCenterActionServiceModel
import com.scms.ReferralCenter
import grails.plugin.springsecurity.SpringSecurityService
import grails.transaction.Transactional
import org.apache.log4j.Logger
import scms.ActionServiceIntf
import scms.BaseService

@Transactional
class UpdateReferralCenterActionService extends BaseService implements ActionServiceIntf {

    private static final String UPDATE_SUCCESS_MESSAGE = "Data has been updated successfully"
    private static final String ROLE_ALREADY_EXIST = "Same Center already exist"
    private static final String REFERRAL_CENTER = "referralcenter"

    SpringSecurityService springSecurityService
    private Logger log = Logger.getLogger(getClass())

    public Map executePreCondition(Map params) {
        try {
            if ((!params.id) || (!params.name)) {
                return super.setError(params, INVALID_INPUT_MSG)
            }
            long id = Long.parseLong(params.id.toString())
            ReferralCenter oldReferralCenter = (ReferralCenter) ReferralCenter.read(id)
            String name = params.name.toString()
            int duplicateCount = ReferralCenter.countByNameIlikeAndIdNotEqual(name, id)
            if (duplicateCount > 0) {
                return super.setError(params, ROLE_ALREADY_EXIST)
            }
            ReferralCenter referralCenter = buildObject(params, oldReferralCenter)
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
        return super.setSuccess(result, UPDATE_SUCCESS_MESSAGE)
    }

    public Map buildFailureResultForUI(Map params) {
        return params
    }

    private static ReferralCenter buildObject(Map parameterMap, ReferralCenter oldReferralCenter) {
        ReferralCenter referralCenter = new ReferralCenter(parameterMap)
        oldReferralCenter.name = referralCenter.name
        oldReferralCenter.address = referralCenter.address
        oldReferralCenter.isActive = referralCenter.isActive
        return oldReferralCenter
    }
}
