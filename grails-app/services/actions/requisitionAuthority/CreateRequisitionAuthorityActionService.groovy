package actions.requisitionAuthority

import com.scms.RequisitionAuthority
import grails.transaction.Transactional
import org.apache.log4j.Logger
import scms.ActionServiceIntf
import scms.BaseService

@Transactional
class CreateRequisitionAuthorityActionService extends BaseService implements ActionServiceIntf {

    private static final String SAVE_SUCCESS_MESSAGE = "Record has been saved successfully"
    private static final String AUTHORITY = "authority"

    private Logger log = Logger.getLogger(getClass())

    /**
     * 1. input validation check
     * 2. duplicate check for user-name
     * @param params - receive user object from controller
     * @return - map.
     */
    @Transactional(readOnly = true)
    public Map executePreCondition(Map params) {
        try {
            //Check parameters
            if (!params.name||!params.designation||!params.locationCode||!params.rightsId) {
                return super.setError(params, INVALID_INPUT_MSG)
            }
            RequisitionAuthority authority = buildObject(params)
            params.put(AUTHORITY, authority)
            return params
        } catch (Exception ex) {
            log.error(ex.getMessage())
            throw new RuntimeException(ex)
        }
    }
    /**
     * 1. receive user object from pre execute method
     * 2. create new user
     * This method is in transactional block and will roll back in case of any exception
     * @param result - map received from pre execute method
     * @return - map.
     */
    @Transactional
    public Map execute(Map result) {
        try {
            RequisitionAuthority authority = (RequisitionAuthority) result.get(AUTHORITY)
            try{
                if(authority.isActive){
                    RequisitionAuthority au1 = RequisitionAuthority.findByRightsIdAndIsActive(authority.rightsId, Boolean.TRUE)
                    au1.isActive = Boolean.FALSE
                    au1.save()
                }
            }catch (Exception e){

            }
            authority.save()
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
     * Build RequisitionAuthority object
     * @param parameterMap -serialized parameters from UI
     * @return -new RequisitionAuthority object
     */
    private RequisitionAuthority buildObject(Map parameterMap) {
        RequisitionAuthority authority = new RequisitionAuthority(parameterMap)
        authority.rightsId = Long.parseLong(parameterMap.rightsId)
        return authority
    }
}
