package scms

import actions.requisition.*
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
    SelectForEditRequisitionActionService selectForEditRequisitionActionService
    SendRequisitionRequestActionService sendRequisitionRequestActionService
    ListRequisitionPRActionService listRequisitionPRActionService
    ApproveRequisitionRequestActionService approveRequisitionRequestActionService
    AdjustmentRequisitionRequestActionService adjustmentRequisitionRequestActionService
    SelectRequisitionPRActionService selectRequisitionPRActionService

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
    def selectForEdit(){
        String view = '/requisition/update'
        renderView(selectForEditRequisitionActionService, params, view)
    }
    def details(){
        String view = '/requisition/details'
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
        List<GroovyRowResult> lst=requisitionService.listOfMedicine()
        Map result=new HashedMap()
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
    def showPR() {
        render(view: "/requisition/showPR")
    }
    def listPR() {
        renderOutput(listRequisitionPRActionService, params)
    }
    def approveRequest() {
        renderOutput(approveRequisitionRequestActionService, params)
    }
    def selectPR(){
        String view = '/requisition/updatePR'
        renderView(selectRequisitionPRActionService, params, view)
    }
    def updatePR(){
        renderOutput(adjustmentRequisitionRequestActionService, params)
    }
}
