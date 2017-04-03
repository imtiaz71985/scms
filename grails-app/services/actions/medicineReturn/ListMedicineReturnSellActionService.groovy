package actions.medicineReturn

import com.model.ListMedicineReturnSellActionServiceModel
import com.model.ListMedicineSellInfoActionServiceModel
import com.scms.SecUser
import grails.plugin.springsecurity.SpringSecurityService
import grails.transaction.Transactional
import org.apache.log4j.Logger
import scms.ActionServiceIntf
import scms.BaseService
import scms.utility.DateUtility
import service.SecUserService

@Transactional
class ListMedicineReturnSellActionService extends BaseService implements ActionServiceIntf {

    private Logger log = Logger.getLogger(getClass())
    SecUserService secUserService
    SpringSecurityService springSecurityService

    public Map executePreCondition(Map params) {
        return params
    }

    @Transactional(readOnly = true)
    public Map execute(Map result) {
        try {
            Map resultMap
            if(!result.isReport) {
                if (result.dateField) {
                    Date dateField = DateUtility.parseDateForDB(result.dateField)
                    Date fromDate = DateUtility.getSqlFromDateWithSeconds(dateField)
                    Date toDate = DateUtility.getSqlToDateWithSeconds(dateField)
                    Closure param
                    if (secUserService.isLoggedUserAdmin(springSecurityService.principal.id)) {
                        param = {
                            'between'('returnDate', fromDate, toDate)
                        }
                    }
                    else {
                        String hospitalCode = SecUser.read(springSecurityService.principal.id)?.hospitalCode
                        param = {
                            'and' {
                                'eq'('hospitalCode', hospitalCode)
                                'between'('returnDate', fromDate, toDate)
                            }
                        }
                    }
                    resultMap = super.getSearchResult(result, ListMedicineReturnSellActionServiceModel.class, param)
                } else {
                    Closure param
                    if (secUserService.isLoggedUserAdmin(springSecurityService.principal.id)) {
                        resultMap = super.getSearchResult(result, ListMedicineReturnSellActionServiceModel.class)
                    }
                    else {
                        String hospitalCode = SecUser.read(springSecurityService.principal.id)?.hospitalCode
                        param = {
                                'eq'('hospitalCode', hospitalCode)
                             }
                        resultMap = super.getSearchResult(result, ListMedicineReturnSellActionServiceModel.class)
                    }
                }
            }
            else{
                Date fDate = DateUtility.parseMaskedDate(result.fromDate)
                Date fromDate = DateUtility.getSqlFromDateWithSeconds(fDate)
                Date tDate = DateUtility.parseMaskedDate(result.toDate)
                Date toDate = DateUtility.getSqlToDateWithSeconds(tDate)
                String hospitalCode=result.hospitalCode
                long retTypeId=Long.parseLong(result.returnType)
                Closure param
                if(Long.parseLong(hospitalCode)>0) {
                    param = {
                        'and' {
                            'eq'('hospitalCode', hospitalCode)
                            'eq'('returnTypeId', retTypeId)
                            'between'('returnDate', fromDate, toDate)
                        }
                    }
                }
                else{
                    param = {
                        'and' {
                            'eq'('returnTypeId', retTypeId)
                            'between'('returnDate', fromDate, toDate)
                        }
                    }
                }

                resultMap = super.getSearchResult(result, ListMedicineReturnSellActionServiceModel.class, param)
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
