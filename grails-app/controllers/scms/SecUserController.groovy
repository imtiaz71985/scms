package scms

import actions.secuser.CreateSecUserActionService
import actions.secuser.DeleteSecUserActionService
import actions.secuser.ListSecUserActionService
import actions.secuser.ResetSecUserPasswordActionService
import actions.secuser.UpdateSecUserActionService
import grails.converters.JSON
import groovy.sql.GroovyRowResult
import service.SecUserService

class SecUserController extends BaseController {

    static allowedMethods = [
            show: "POST", create: "POST", update: "POST",delete: "POST", list: "POST"
    ]
    SecUserService secUserService
    CreateSecUserActionService createSecUserActionService
    UpdateSecUserActionService updateSecUserActionService
    DeleteSecUserActionService deleteSecUserActionService
    ListSecUserActionService listSecUserActionService
    ResetSecUserPasswordActionService resetSecUserPasswordActionService

    def show() {
        render(view: "/secUser/show")
    }
    def create() {
        renderOutput(createSecUserActionService, params)

    }
    def update() {
        renderOutput(updateSecUserActionService, params)

    }
    def list() {
        renderOutput(listSecUserActionService, params)
    }
    def generalUser() {
        List<GroovyRowResult> lstUser = secUserService.getGeneralUsers()
        Map result = [lstUser: lstUser,count: lstUser.size()]
        render result as JSON
    }

    def reloadDropDown() {
        render sec.dropDownAppUserRole(params)
    }

    def resetPassword(){
        renderOutput(resetSecUserPasswordActionService, params)
    }
}
