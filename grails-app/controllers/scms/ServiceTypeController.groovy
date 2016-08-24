package scms

import actions.serviceType.CreateServiceTypeActionService
import actions.serviceType.ListServiceTypeActionService
import actions.serviceType.UpdateServiceTypeActionService

class ServiceTypeController extends BaseController {

    static allowedMethods = [
            show: "POST", create: "POST", update: "POST",delete: "POST", list: "POST"
    ]

    CreateServiceTypeActionService createServiceTypeActionService
    UpdateServiceTypeActionService updateServiceTypeActionService
    ListServiceTypeActionService listServiceTypeActionService

    def show() {
        render(view: "/serviceType/show")
    }
    def create() {
        renderOutput(createServiceTypeActionService, params)

    }
    def update() {
        renderOutput(updateServiceTypeActionService, params)

    }
    def list() {
        renderOutput(listServiceTypeActionService, params)
    }
}
