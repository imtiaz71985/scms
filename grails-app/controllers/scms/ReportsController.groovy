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
import service.RegistrationInfoService
import service.SecUserService

class ReportsController extends BaseController {

    SpringSecurityService springSecurityService
    ListMonthlyDetailsActionService listMonthlyDetailsActionService
    DownloadMonthlyDetailsActionService downloadMonthlyDetailsActionService
    SecUserService secUserService
    ListSummaryActionService listSummaryActionService
    MedicineInfoService medicineInfoService
    RegistrationInfoService registrationInfoService


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
    def showPatientServiceComparison() {
        SecUser user = SecUser.read(springSecurityService.principal.id)
        boolean isAdmin = secUserService.isLoggedUserAdmin(user.id)

        String hospitalCode = HospitalLocation.findByCode(user.hospitalCode).code
        render(view: "/reports/PatientServiceComparison/show", model: [isAdmin:isAdmin,hospitalCode:hospitalCode])
    }
    def listOfPatientAndService() {

        String hospitalCode = ''
        Date fromDate,toDate
        try {
            fromDate=DateUtility.getSqlFromDateWithSeconds(DateUtility.parseMaskedDate(params.fromDate))
            toDate=DateUtility.getSqlToDateWithSeconds(DateUtility.parseMaskedDate(params.toDate))
            hospitalCode = params.hospitalCode
        } catch (Exception ex) {
        }

       // List<GroovyRowResult> lst = medicineInfoService.listOfMedicineWiseSalesWithStock(hospitalCode,fromDate,toDate)
        List<GroovyRowResult> lst = registrationInfoService.listOfPatientAndService(hospitalCode,fromDate,toDate)

        Map result = new HashedMap()
        result.put('list', lst)
        result.put('count', lst.size())
        render result as JSON
    }

}
