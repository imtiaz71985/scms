package scms

import actions.serviceType.CreateServiceTypeActionService
import actions.serviceType.DeleteServiceTypeActionService
import actions.serviceType.ListServiceTypeActionService
import actions.serviceType.UpdateServiceTypeActionService

class ServiceTypeController extends BaseController {

    static allowedMethods = [
            show: "POST", create: "POST", update: "POST",delete: "POST", list: "POST"
    ]

    CreateServiceTypeActionService createServiceTypeActionService
    UpdateServiceTypeActionService updateServiceTypeActionService
    DeleteServiceTypeActionService deleteServiceTypeActionService
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
    def delete() {
        renderOutput(deleteServiceTypeActionService, params)

    }
    def list() {
        renderOutput(listServiceTypeActionService, params)
    }
}
