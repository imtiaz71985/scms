package scms

import actions.transactionClosing.CreateTransactionClosingActionService
import actions.transactionClosing.ListTransactionClosingActionService
import actions.transactionClosing.UpdateTransactionClosingActionService
import com.scms.SecUser
import grails.converters.JSON
import grails.plugin.springsecurity.SpringSecurityService
import groovy.sql.GroovyRowResult
import org.apache.commons.collections.map.HashedMap
import scms.utility.DateUtility
import service.RegistrationInfoService
import service.SecUserService


class TransactionClosingController extends BaseController {

    static allowedMethods = [
            show: "POST", create: "POST", update: "POST",delete: "POST", list: "POST"
    ]

    CreateTransactionClosingActionService createTransactionClosingActionService
    ListTransactionClosingActionService listTransactionClosingActionService
    UpdateTransactionClosingActionService updateTransactionClosingActionService
    SecUserService secUserService
    SpringSecurityService springSecurityService
    RegistrationInfoService registrationInfoService

    def show() {
        SecUser user = SecUser.read(springSecurityService.principal.id)
        boolean isAdmin = secUserService.isLoggedUserAdmin(user.id)
        render(view: "/transactionClosing/show", model: [isAdmin:isAdmin])
    }
    def create() {
        renderOutput(createTransactionClosingActionService, params)

    }

    def list() {
        renderOutput(listTransactionClosingActionService, params)
    }
    def unlock() {
        renderOutput(updateTransactionClosingActionService, params)
    }
    def retrieveServedAndTotalPatient() {
        Date date=DateUtility.parseDateForDB(params.closingDate)
        String hospital_code = ""
        if (!secUserService.isLoggedUserAdmin(springSecurityService.principal.id)) {
            hospital_code = SecUser.read(springSecurityService.principal.id)?.hospitalCode
        }
        List<GroovyRowResult> lst=registrationInfoService.listOfPatientServedSummary(hospital_code,DateUtility.getSqlFromDateWithSeconds(date),DateUtility.getSqlToDateWithSeconds(date))
        Map result = new HashedMap()
        result.put('totalPatient', lst[0].total_patient)
        result.put('totalServed', lst[0].total_served)

        render result as JSON
    }
}
