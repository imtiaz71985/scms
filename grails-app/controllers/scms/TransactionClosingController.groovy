package scms

import actions.transactionClosing.CreateTransactionClosingActionService
import actions.transactionClosing.ListTransactionClosingActionService
import actions.transactionClosing.UpdateTransactionClosingActionService
import com.scms.SecUser
import grails.plugin.springsecurity.SpringSecurityService
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
}
