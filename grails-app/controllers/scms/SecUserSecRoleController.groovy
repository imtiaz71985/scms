package scms

import actions.secUserSecRole.CreateSecUserSecRoleActionService
import actions.secUserSecRole.DeleteSecUserSecRoleActionService
import actions.secUserSecRole.DownloadSecUserSecRoleActionService
import actions.secUserSecRole.ListSecUserSecRoleActionService
import actions.secUserSecRole.UpdateSecUserSecRoleActionService

class SecUserSecRoleController extends BaseController {

    static allowedMethods = [
            show: "POST", create: "POST", update: "POST",delete: "POST", list: "POST"
    ]

    CreateSecUserSecRoleActionService createSecUserSecRoleActionService
    UpdateSecUserSecRoleActionService updateSecUserSecRoleActionService
    DeleteSecUserSecRoleActionService deleteSecUserSecRoleActionService
    ListSecUserSecRoleActionService listSecUserSecRoleActionService
    DownloadSecUserSecRoleActionService downloadSecUserSecRoleActionService

    def show() {
        render(view: "/secUserSecRole/show", model:[roleId:params.roleId])
    }
    def create() {
        renderOutput(createSecUserSecRoleActionService, params)

    }
    def update() {
        renderOutput(updateSecUserSecRoleActionService, params)

    }
    def delete() {
        renderOutput(deleteSecUserSecRoleActionService, params)

    }
    def list() {
        renderOutput(listSecUserSecRoleActionService, params)
    }
    def report() {
        Map result = (Map) getReportResponse(downloadSecUserSecRoleActionService, params).report
        renderOutputStream(result.report.toByteArray(), result.format, result.reportFileName)
    }
}
