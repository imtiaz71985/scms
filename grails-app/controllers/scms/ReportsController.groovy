package scms

import actions.reports.DownloadMonthlyDetailsActionService
import actions.reports.ListMonthlyDetailsActionService
import com.scms.HospitalLocation
import com.scms.SecUser
import grails.plugin.springsecurity.SpringSecurityService
import service.SecUserService

class ReportsController extends BaseController {

    SpringSecurityService springSecurityService
    ListMonthlyDetailsActionService listMonthlyDetailsActionService
    DownloadMonthlyDetailsActionService downloadMonthlyDetailsActionService
    SecUserService secUserService


    def showMonthlyStatus() {
        SecUser user = SecUser.read(springSecurityService.principal.id)
        boolean isAdmin = secUserService.isLoggedUserAdmin(user.id)

        String hospitalCode = HospitalLocation.findByCode(user.hospitalCode).code
        render(view: "/reports/monthlyDetails/show", model: [isAdmin:isAdmin,hospitalCode:hospitalCode])
    }
    def listMonthlyStatus() {
        renderOutput(listMonthlyDetailsActionService, params)
    }
    def downloadMonthlyDetails() {
        Map result = (Map) getReportResponse(downloadMonthlyDetailsActionService, params).report
        renderOutputStream(result.report.toByteArray(), result.format, result.reportFileName)
    }
}
