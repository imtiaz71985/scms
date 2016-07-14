package scms

import actions.requisition.*
import actions.requisitionReceive.CreateRequisitionReceiveActionService
import com.scms.Requisition
import com.scms.SecUser
import com.scms.Upazila
import grails.converters.JSON
import grails.plugin.springsecurity.SpringSecurityService
import groovy.sql.GroovyRowResult
import org.apache.commons.collections.map.HashedMap
import service.RequisitionService

class RequisitionReceiveController extends BaseController {

    SpringSecurityService springSecurityService
    CreateRequisitionReceiveActionService createRequisitionReceiveActionService
    RequisitionService requisitionService
    BaseService baseService

    static allowedMethods = [
            show: "POST", create: "POST", update: "POST", select: "POST", list: "POST"
    ]

    def show() {
        render(view: "/requisitionReceive/show")
    }

    def requisitionByVendorId(){
        String vendorId = params.id.toString()
        String hospital_code = SecUser.read(springSecurityService.principal.id)?.hospitalCode
        List<Requisition> lst = requisitionService.listRequisitionNoForReceive(hospital_code,vendorId)
        lst = baseService.listForKendoDropdown(lst, null, null)
        Map result = [lst: lst]
        render result as JSON

    }
    def create() {
        renderOutput(createRequisitionReceiveActionService, params)// need to work
    }

    def listOfMedicine() {
        String requisitionNo = params.requisitionNo
        List<GroovyRowResult> lst=requisitionService.listOfRegMedicineForReceive(requisitionNo)
        Map result=new HashedMap()
        result.put('list', lst)
        result.put('count', lst.size())
        render result as JSON
    }
}
