package scms

import actions.requisitionAuthority.CreateRequisitionAuthorityActionService
import actions.requisitionAuthority.ListRequisitionAuthorityActionService
import actions.requisitionAuthority.UpdateRequisitionAuthorityActionService

class RequisitionAuthorityController extends BaseController {

    static allowedMethods = [
            show: "POST", create: "POST", update: "POST", list: "POST"
    ]

    CreateRequisitionAuthorityActionService createRequisitionAuthorityActionService
    UpdateRequisitionAuthorityActionService updateRequisitionAuthorityActionService
    ListRequisitionAuthorityActionService listRequisitionAuthorityActionService

    def show() {
        render(view: "/requisitionAuthority/show")
    }
    def create() {
        renderOutput(createRequisitionAuthorityActionService, params)

    }
    def update() {
        renderOutput(updateRequisitionAuthorityActionService, params)

    }
    def list() {
        renderOutput(listRequisitionAuthorityActionService, params)
    }
}
