package scms

import actions.hospitalLocation.CreateHospitalLocationActionService
import actions.hospitalLocation.DeleteHospitalLocationActionService
import actions.hospitalLocation.ListHospitalLocationActionService
import actions.hospitalLocation.UpdateHospitalLocationActionService

class HospitalLocationController extends BaseController {

    static allowedMethods = [
            show: "POST", create: "POST", update: "POST",delete: "POST", list: "POST"
    ]

    CreateHospitalLocationActionService createHospitalLocationActionService
    UpdateHospitalLocationActionService updateHospitalLocationActionService
    DeleteHospitalLocationActionService deleteHospitalLocationActionService
    ListHospitalLocationActionService listHospitalLocationActionService

    def show() {
        render(view: "/hospitalLocation/show")
    }
    def create() {
        renderOutput(createHospitalLocationActionService, params)

    }
    def update() {
        renderOutput(updateHospitalLocationActionService, params)

    }
    def delete() {
        renderOutput(deleteHospitalLocationActionService, params)

    }
    def list() {
        renderOutput(listHospitalLocationActionService, params)
    }
}
