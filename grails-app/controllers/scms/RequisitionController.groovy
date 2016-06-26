package scms

import actions.requisition.CreateRequisitionActionService
import actions.requisition.ListRequisitionActionService
import actions.requisition.SelectRequisitionActionService
import actions.requisition.SendRequisitionRequestActionService
import actions.requisition.UpdateRequisitionActionService
import com.scms.Requisition
import com.scms.SecUser
import grails.converters.JSON
import grails.plugin.springsecurity.SpringSecurityService
import org.apache.commons.collections.map.HashedMap
import scms.utility.DateUtility

import java.text.SimpleDateFormat

class RequisitionController extends BaseController {

    SpringSecurityService springSecurityService
    CreateRequisitionActionService createRequisitionActionService
    UpdateRequisitionActionService updateRequisitionActionService
    ListRequisitionActionService listRequisitionActionService
    SelectRequisitionActionService selectRequisitionActionService
    SendRequisitionRequestActionService sendRequisitionRequestActionService

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
    def select(){
        String view = '/requisition/update'
        renderView(selectRequisitionActionService, params, view)
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
    def sendRequest() {
        renderOutput(sendRequisitionRequestActionService, params)
    }
}
