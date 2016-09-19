package actions.registrationInfo

import com.model.ListRegistrationInfoActionServiceModel
import com.model.ListServiceTokenInfoWithRegInfoActionServiceModel
import com.scms.SecUser
import grails.plugin.springsecurity.SpringSecurityService
import grails.transaction.Transactional
import org.apache.log4j.Logger
import scms.ActionServiceIntf
import scms.BaseService
import scms.utility.DateUtility
import service.SecUserService

@Transactional
class CustomListRegistrationInfoActionService extends BaseService implements ActionServiceIntf {

    SecUserService secUserService
    SpringSecurityService springSecurityService
    private Logger log = Logger.getLogger(getClass())

    /**
     * No pre conditions required for searching project domains
     *
     * @param params - Request parameters
     * @return - same map of input-parameter containing isError(true/false)
     */
    public Map executePreCondition(Map params) {
        return params
    }

    /**
     * 1. initialize params for pagination of list
     *
     * 2. pull all patient list from database (if no criteria)
     *
     * 3. pull filtered result from database (if given criteria)
     *
     * @param result - parameter from pre-condition
     * @return - same map of input-parameter containing isError(true/false)
     */
    @Transactional(readOnly = true)
    public Map execute(Map result) {
        try {
            Map resultMap
            Date dateField = DateUtility.parseDateForDB(result.dateField)
            String visitType = result.visitType
            long visitTypeId = 1L
            if (visitType.equals("revisit")) {
                visitTypeId = 2L
            } else if (visitType.equals("followup")) {
                visitTypeId = 3L
            }
            Date fromDate = DateUtility.getSqlFromDateWithSeconds(dateField)
            Date toDate = DateUtility.getSqlToDateWithSeconds(dateField)
            if (secUserService.isLoggedUserAdmin(springSecurityService.principal.id)) {
                Closure param = {
                    'eq'('visitTypeId', visitTypeId)
                    'between'('serviceDate', fromDate,toDate)
                }
                resultMap = super.getSearchResult(result, ListServiceTokenInfoWithRegInfoActionServiceModel.class, param)
            } else {
                String hospitalCode = SecUser.read(springSecurityService.principal.id)?.hospitalCode
                Closure param = {
                    'eq'('hospitalCode', hospitalCode)
                    'eq'('visitTypeId', visitTypeId)
                    'between'('serviceDate', fromDate,toDate)
                }
                resultMap = super.getSearchResult(result, ListServiceTokenInfoWithRegInfoActionServiceModel.class, param)
            }

            result.put(LIST, resultMap.list)
            result.put(COUNT, resultMap.count)
            return result
        } catch (Exception e) {
            log.error(e.getMessage())
            throw new RuntimeException(e)
        }
    }

    /**
     * There is no postCondition, so return the same map as received
     *
     * @param result - resulting map from execute
     * @return - same map of input-parameter containing isError(true/false)
     */
    public Map executePostCondition(Map result) {
        return result
    }

    /**
     * Since there is no success message return the same map
     * @param result -map from execute/executePost method
     * @return - same map of input-parameter containing isError(true/false)
     */
    public Map buildSuccessResultForUI(Map result) {
        return result
    }

    /**
     * The input-parameter Map must have "isError:true" with corresponding message
     * @param result -map returned from previous methods
     * @return - same map of input-parameter containing isError(true/false)
     */
    public Map buildFailureResultForUI(Map result) {
        return result
    }
}
