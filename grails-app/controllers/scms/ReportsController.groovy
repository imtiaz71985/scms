package scms

import actions.reports.DownloadMonthlyDetailsActionService
import actions.reports.ListMonthlyDetailsActionService
import actions.reports.ListSummaryActionService
import com.scms.HospitalLocation
import com.scms.SecUser
import grails.converters.JSON
import grails.plugin.springsecurity.SpringSecurityService
import groovy.sql.GroovyRowResult
import org.apache.commons.collections.map.HashedMap
import scms.utility.DateUtility
import service.MedicineInfoService
import service.SecUserService

class ReportsController extends BaseController {

    SpringSecurityService springSecurityService
    ListMonthlyDetailsActionService listMonthlyDetailsActionService
    DownloadMonthlyDetailsActionService downloadMonthlyDetailsActionService
    SecUserService secUserService
    ListSummaryActionService listSummaryActionService
    MedicineInfoService medicineInfoService


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
    def showSummary() {
        SecUser user = SecUser.read(springSecurityService.principal.id)
        boolean isAdmin = secUserService.isLoggedUserAdmin(user.id)

        String hospitalCode = HospitalLocation.findByCode(user.hospitalCode).code
        render(view: "/reports/summary/show", model: [isAdmin:isAdmin,hospitalCode:hospitalCode])
    }
    def listSummary() {
        renderOutput(listSummaryActionService, params)
    }
    def showMedicineSales() {
        SecUser user = SecUser.read(springSecurityService.principal.id)
        boolean isAdmin = secUserService.isLoggedUserAdmin(user.id)

        String hospitalCode = HospitalLocation.findByCode(user.hospitalCode).code
        render(view: "/reports/medicineSales/show", model: [isAdmin:isAdmin,hospitalCode:hospitalCode])
    }
    def listOfMedicineWiseSalesWithStock() {

        String hospitalCode = ''
        Date fromDate,toDate
        try {
            fromDate=DateUtility.getSqlDate(DateUtility.parseMaskedDate(params.fromDate))
            toDate=DateUtility.getSqlDate(DateUtility.parseMaskedDate(params.toDate))
            hospitalCode = params.hospitalCode
        } catch (Exception ex) {
        }

        List<GroovyRowResult> lst = medicineInfoService.listOfMedicineWiseSalesWithStock(hospitalCode,fromDate,toDate)

        Map result = new HashedMap()
        result.put('list', lst)
        result.put('count', lst.size())
        render result as JSON
    }
}
