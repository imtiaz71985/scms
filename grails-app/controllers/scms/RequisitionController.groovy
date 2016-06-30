package scms

import actions.requisition.*
import com.scms.HospitalLocation
import com.scms.Requisition
import com.scms.SecUser
import grails.converters.JSON
import grails.plugin.springsecurity.SpringSecurityService
import groovy.sql.GroovyRowResult
import org.apache.commons.collections.map.HashedMap
import scms.utility.DateUtility
import service.RequisitionService

import java.text.SimpleDateFormat

class RequisitionController extends BaseController {

    SpringSecurityService springSecurityService
    RequisitionService requisitionService
    CreateRequisitionActionService createRequisitionActionService
    UpdateRequisitionActionService updateRequisitionActionService
    ListRequisitionActionService listRequisitionActionService
    SelectRequisitionActionService selectRequisitionActionService
    SendRequisitionRequestActionService sendRequisitionRequestActionService
    ListRequisitionHOActionService listRequisitionHOActionService
    ApproveRequisitionRequestActionService approveRequisitionRequestActionService
    AdjustmentRequisitionRequestActionService adjustmentRequisitionRequestActionService

    static allowedMethods = [
            show: "POST", create: "POST", update: "POST", select: "POST", list: "POST"
    ]

    def show() {
        render(view: "/requisition/show")
    }

    def showDetails() {
        String requisitionNo = generateRequisitionNo()
        render(view: "/requisition/create", model: [requisitionNo: requisitionNo])
    }

    def selectForEdit() {
        long id = Long.parseLong(params.id.toString())
        Requisition requisition = Requisition.read(id)
        render(view: "/requisition/create", model: [requisitionNo: requisition.reqNo, totalAmount: requisition.totalAmount])
    }

    def details() {
        String view = '/requisition/details'
        renderView(selectRequisitionActionService, params, view)
    }
    def detailsHO() {
        String view = '/requisition/detailsHO'
        renderView(selectRequisitionActionService, params, view)
    }

    def create() {
        renderOutput(createRequisitionActionService, params)
    }

    def update() {
        renderOutput(updateRequisitionActionService, params)
    }

    def list() {
        renderOutput(listRequisitionActionService, params)
    }

    def listOfMedicine() {
        String requisitionNo = params.requisitionNo
        List<GroovyRowResult> lst = requisitionService.listOfMedicine(requisitionNo)
        Map result = new HashedMap()
        result.put('list', lst)
        result.put('count', lst.size())
        render result as JSON
    }
    def listOfMedicineHO() {
        String requisitionNo = params.requisitionNo
        List<GroovyRowResult> lst = requisitionService.listOfMedicineHO(requisitionNo)
        Map result = new HashedMap()
        result.put('list', lst)
        result.put('count', lst.size())
        render result as JSON
    }

    private String generateRequisitionNo() {
        Date date = DateUtility.parseDateForDB(DateUtility.getDBDateFormatAsString(new Date()))
        String hospital_code = SecUser.read(springSecurityService.principal.id)?.hospitalCode
        int serial = Requisition.countByCreateDateAndHospitalCode(date, hospital_code)
        serial += 1
        String DATE_FORMAT = "ddMMyy";
        SimpleDateFormat sdf = new SimpleDateFormat(DATE_FORMAT);
        Calendar cal = Calendar.getInstance(); // today
        String requisitionNo = sdf.format(cal.getTime())
        String formatted = String.format("%02d", serial);
        requisitionNo = 'R' + hospital_code + requisitionNo + formatted
        return requisitionNo
    }

    def retrieveRequisitionNo() {
        String requisitionNo = generateRequisitionNo()
        Map result = new HashedMap()
        result.put('requisitionNo', requisitionNo)
        render result as JSON
    }

    def sendRequisition() {
        renderOutput(sendRequisitionRequestActionService, params)
    }

    def showHO() {
        render(view: "/requisition/showHO")
    }

    def listHO() {
        renderOutput(listRequisitionHOActionService, params)
    }

    def approveRequest() {
        renderOutput(approveRequisitionRequestActionService, params)
    }

    def selectHO() {
        String hospital_code = SecUser.read(springSecurityService.principal.id)?.hospitalCode
        HospitalLocation hospital = HospitalLocation.findByCode(hospital_code)
        long id = Long.parseLong(params.id.toString())
        Requisition requisition = Requisition.read(id)
        render(view: "/requisition/updateHO", model: [requisitionNo: requisition.reqNo,
                                                      totalAmount  : requisition.totalAmount,
                                                      hospitalName : hospital.name])

    }

    def updateHO() {
        renderOutput(adjustmentRequisitionRequestActionService, params)
    }
}
