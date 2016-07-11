package scms

import actions.requisition.*
import actions.requisitionReceive.CreateRequisitionReceiveActionService
import com.scms.Requisition
import com.scms.SecUser
import grails.converters.JSON
import grails.plugin.springsecurity.SpringSecurityService
import groovy.sql.GroovyRowResult
import org.apache.commons.collections.map.HashedMap
import service.RequisitionService

class RequisitionReceiveController extends BaseController {

    SpringSecurityService springSecurityService
    CreateRequisitionReceiveActionService createRequisitionReceiveActionService
    RequisitionService requisitionService

    static allowedMethods = [
            show: "POST", create: "POST", update: "POST", select: "POST", list: "POST"
    ]

    def show() {
        render(view: "/requisitionReceive/show")
    }

    def selectForEdit(){
        long id = Long.parseLong(params.id.toString())
        Requisition requisition = Requisition.read(id)
        render(view: "/requisitionReceive/create", model: [requisitionNo: requisition.reqNo])

    }
    def create() {
        renderOutput(createRequisitionReceiveActionService, params)// need to work
    }

    def list() {
        String hospital_code = SecUser.read(springSecurityService.principal.id)?.hospitalCode
        List<GroovyRowResult> lst=requisitionService.listOfDeliveredMedicine(hospital_code)
        Map result=new HashedMap()
        result.put('list', lst)
        result.put('count', lst.size())
        render result as JSON
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
