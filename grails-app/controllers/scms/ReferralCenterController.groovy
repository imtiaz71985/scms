package scms

import actions.ReferralCenter.CreateReferralCenterActionService
import actions.ReferralCenter.ListReferralCenterActionService
import actions.ReferralCenter.UpdateReferralCenterActionService

class ReferralCenterController extends BaseController {

    static allowedMethods = [
            show: "POST", create: "POST", update: "POST",delete: "POST", list: "POST"
    ]

    CreateReferralCenterActionService createReferralCenterActionService
    UpdateReferralCenterActionService updateReferralCenterActionService
    ListReferralCenterActionService listReferralCenterActionService

    def show() {
        render(view: "/referralCenter/show")
    }
    def create() {
        renderOutput(createReferralCenterActionService, params)

    }
    def update() {
        renderOutput(updateReferralCenterActionService, params)

    }
    def list() {
        renderOutput(listReferralCenterActionService, params)
    }
}
