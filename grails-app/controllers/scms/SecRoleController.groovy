package scms

import actions.secRole.CreateSecRoleActionService
import actions.secRole.DeleteSecRoleActionService
import actions.secRole.ListSecRoleActionService
import actions.secRole.UpdateSecRoleActionService

class SecRoleController extends BaseController {

    static allowedMethods = [
            show: "POST", create: "POST", update: "POST",delete: "POST", list: "POST"
    ]

    CreateSecRoleActionService createSecRoleActionService
    UpdateSecRoleActionService updateSecRoleActionService
    DeleteSecRoleActionService deleteSecRoleActionService
    ListSecRoleActionService listSecRoleActionService

    def show() {
        render(view: "/secRole/show")
    }
    def create() {
        renderOutput(createSecRoleActionService, params)

    }
    def update() {
        renderOutput(updateSecRoleActionService, params)

    }
    def delete() {
        renderOutput(deleteSecRoleActionService, params)

    }
    def list() {
        renderOutput(listSecRoleActionService, params)
    }
}
