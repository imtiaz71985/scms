package scms

import actions.DiseaseGroup.CreateDiseaseGroupActionService
import actions.DiseaseGroup.ListDiseaseGroupActionService
import actions.DiseaseGroup.UpdateDiseaseGroupActionService

class DiseaseGroupController extends BaseController {

    static allowedMethods = [
            show: "POST", create: "POST", update: "POST",delete: "POST", list: "POST"
    ]

    CreateDiseaseGroupActionService createDiseaseGroupActionService
    UpdateDiseaseGroupActionService updateDiseaseGroupActionService
    ListDiseaseGroupActionService listDiseaseGroupActionService

    def show() {
        render(view: "/diseaseGroup/show")
    }
    def create() {
        renderOutput(createDiseaseGroupActionService, params)

    }
    def update() {
        renderOutput(updateDiseaseGroupActionService, params)

    }
    def list() {
        renderOutput(listDiseaseGroupActionService, params)
    }
}
