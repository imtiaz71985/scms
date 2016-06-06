package scms

import actions.systemEntity.CreateSystemEntityActionService
import actions.systemEntity.DeleteSystemEntityActionService
import actions.systemEntity.ListSystemEntityActionService
import actions.systemEntity.UpdateSystemEntityActionService

class SystemEntityController extends BaseController {

    static allowedMethods = [
            show: "POST", create: "POST", update: "POST",delete: "POST", list: "POST"
    ]

    CreateSystemEntityActionService createSystemEntityActionService
    UpdateSystemEntityActionService updateSystemEntityActionService
    DeleteSystemEntityActionService deleteSystemEntityActionService
    ListSystemEntityActionService listSystemEntityActionService

    def show() {
        render(view: "/systemEntity/show")
    }
   def create() {
        renderOutput(createSystemEntityActionService, params)

    }
    def update() {
        renderOutput(updateSystemEntityActionService, params)

    }
    def delete() {
        renderOutput(deleteSystemEntityActionService, params)

    }
    def list() {
        renderOutput(listSystemEntityActionService, params)
    }
}
