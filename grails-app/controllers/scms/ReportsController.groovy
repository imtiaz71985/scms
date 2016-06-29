package scms

import actions.reports.DownloadMonthlyDetailsActionService
import actions.reports.ListMonthlyDetailsActionService

class ReportsController extends BaseController {

    ListMonthlyDetailsActionService listMonthlyDetailsActionService
    DownloadMonthlyDetailsActionService downloadMonthlyDetailsActionService


    def showMonthlyStatus() {
        render(view: "/reports/monthlyDetails/show")
    }
    def listMonthlyStatus() {
        renderOutput(listMonthlyDetailsActionService, params)
    }
    def downloadMonthlyDetails() {
        Map result = (Map) getReportResponse(downloadMonthlyDetailsActionService, params).report
        renderOutputStream(result.report.toByteArray(), result.format, result.reportFileName)
    }
}
