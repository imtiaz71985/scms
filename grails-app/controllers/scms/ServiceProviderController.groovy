package scms

import actions.serviceProvider.CreateServiceProviderActionService
import actions.serviceProvider.ListServiceProviderActionService
import actions.serviceProvider.UpdateServiceProviderActionService

class ServiceProviderController extends BaseController {

    static allowedMethods = [
            show: "POST", create: "POST", update: "POST",delete: "POST", list: "POST"
    ]

    CreateServiceProviderActionService createServiceProviderActionService
    UpdateServiceProviderActionService updateServiceProviderActionService
    ListServiceProviderActionService listServiceProviderActionService

    def show() {
        render(view: "/serviceProvider/show")
    }
    def create() {
        renderOutput(createServiceProviderActionService, params)

    }
    def update() {
        renderOutput(updateServiceProviderActionService, params)

    }
    def delete() {
        renderOutput(deleteServiceProviderActionService, params)

    }
    def list() {
        renderOutput(listServiceProviderActionService, params)
    }
}
