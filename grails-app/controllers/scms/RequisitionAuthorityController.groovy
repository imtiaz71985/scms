package scms

import actions.requisitionAuthority.CreateRequisitionAuthorityActionService
import actions.requisitionAuthority.ListRequisitionAuthorityActionService
import actions.requisitionAuthority.UpdateRequisitionAuthorityActionService
import com.scms.HospitalLocation
import com.scms.SystemEntity
import service.SecUserService

class RequisitionAuthorityController extends BaseController {

    SecUserService secUserService

    static allowedMethods = [
            show: "POST", create: "POST", update: "POST", list: "POST"
    ]

    CreateRequisitionAuthorityActionService createRequisitionAuthorityActionService
    UpdateRequisitionAuthorityActionService updateRequisitionAuthorityActionService
    ListRequisitionAuthorityActionService listRequisitionAuthorityActionService

    def show() {
        String hospitalCode = secUserService.retrieveHospitalCode()
        boolean isClinic = HospitalLocation.findByCode(hospitalCode).isClinic
        SystemEntity rights= SystemEntity.findByTypeAndNameIlike('Requisition authority','Prepared by')
        render(view: "/requisitionAuthority/show", model: [isClinic: isClinic,hospitalCode:hospitalCode, rightsId:rights.id])
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
