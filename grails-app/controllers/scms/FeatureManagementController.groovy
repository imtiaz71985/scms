package scms

import actions.featureManagement.ListAssignedRoleActionService
import actions.featureManagement.ListAvailableRoleActionService
import actions.featureManagement.UpdateFeatureManagementActionService
import grails.converters.JSON

class FeatureManagementController extends BaseController {

    static allowedMethods = [show             : "POST", update: "POST",
                             listAvailableRole: "POST", listAssignedRole: "POST"]

    UpdateFeatureManagementActionService updateFeatureManagementActionService
    ListAvailableRoleActionService listAvailableRoleActionService
    ListAssignedRoleActionService listAssignedRoleActionService


    def show() {
        render(view: '/featureManagement/show')
    }

    def update() {
        Map result = this.getServiceResponse(updateFeatureManagementActionService, params)
        String output = result as JSON
        render output
    }


    def listAvailableRole() {
        renderOutput(listAvailableRoleActionService, params)
    }

    def listAssignedRole() {
        renderOutput(listAssignedRoleActionService, params)
    }
}
