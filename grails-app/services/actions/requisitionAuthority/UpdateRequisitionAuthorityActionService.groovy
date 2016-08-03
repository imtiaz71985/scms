package actions.requisitionAuthority

import com.scms.RequisitionAuthority
import grails.transaction.Transactional
import org.apache.log4j.Logger
import scms.ActionServiceIntf
import scms.BaseService
import service.SecUserService

@Transactional
class UpdateRequisitionAuthorityActionService extends BaseService implements ActionServiceIntf {

    SecUserService secUserService

    private static final String UPDATE_SUCCESS_MESSAGE = "Records has been updated successfully"
    private static final String AUTHORITY = "authority"

    private Logger log = Logger.getLogger(getClass())

    public Map executePreCondition(Map params) {
        try {
            if ((!params.id) || (!params.name)) {
                return super.setError(params, INVALID_INPUT_MSG)
            }
            long id = Long.parseLong(params.id.toString())
            RequisitionAuthority oldAuthority = RequisitionAuthority.read(id)
            RequisitionAuthority authority = buildObject(params, oldAuthority)
            params.put(AUTHORITY, authority)
            return params
        } catch (Exception ex) {
            log.error(ex.getMessage())
            throw new RuntimeException(ex)
        }
    }

    @Transactional
    public Map execute(Map result) {
        try {
            RequisitionAuthority authority = (RequisitionAuthority) result.get(AUTHORITY)
            String hospitalCode = secUserService.retrieveHospitalCode()
            try{
                if(authority.isActive){
                    RequisitionAuthority au1 = RequisitionAuthority.findByRightsIdAndLocationCodeAndIsActive(authority.rightsId,hospitalCode, Boolean.TRUE)
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
     * @param result - map received from execute method
     * @return - map with success message
     */
    public Map buildSuccessResultForUI(Map result) {
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

    /**
     * Build RequisitionAuthority object
     * @param parameterMap -serialized parameters from UI
     * @param oldAuthority -object of RequisitionAuthority
     * @return -new RequisitionAuthority object
     */
    private RequisitionAuthority buildObject(Map parameterMap, RequisitionAuthority oldAuthority) {
        RequisitionAuthority authority = new RequisitionAuthority(parameterMap)
        oldAuthority.isActive = authority.isActive
        oldAuthority.name = authority.name
        oldAuthority.designation = authority.designation
        oldAuthority.locationCode = authority.locationCode
        oldAuthority.rightsId = Long.parseLong(parameterMap.rightsId)
        return oldAuthority
    }
}
