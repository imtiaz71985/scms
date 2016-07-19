package scms

import actions.requisitionReceive.CreateRequisitionReceiveActionService
import actions.requisitionReceive.DownloadPurchaseReceiveActionService
import actions.requisitionReceive.ListRequisitionReceiveActionService
import actions.requisitionReceive.SelectRequisitionAcknowledgementActionService
import actions.requisitionReceive.SelectRequisitionReceiveActionService
import com.scms.Requisition
import com.scms.SecUser
import grails.converters.JSON
import grails.plugin.springsecurity.SpringSecurityService
import groovy.sql.GroovyRowResult
import org.apache.commons.collections.map.HashedMap
import org.h2.util.MathUtils
import service.RequisitionService

class RequisitionReceiveController extends BaseController {

    BaseService baseService
    SpringSecurityService springSecurityService
    RequisitionService requisitionService
    CreateRequisitionReceiveActionService createRequisitionReceiveActionService
    ListRequisitionReceiveActionService listRequisitionReceiveActionService
    SelectRequisitionReceiveActionService selectRequisitionReceiveActionService
    SelectRequisitionAcknowledgementActionService selectRequisitionAcknowledgementActionService
    DownloadPurchaseReceiveActionService downloadPurchaseReceiveActionService

    static allowedMethods = [
            show: "POST", create: "POST", update: "POST", select: "POST", list: "POST"
    ]

    def show() {
        render(view: "/requisitionReceive/show")
    }

    def requisitionByVendorId(){
        String vendorId = params.id.toString()
        String hospital_code = SecUser.read(springSecurityService.principal.id)?.hospitalCode
        List<GroovyRowResult> lst = requisitionService.listRequisitionNoForReceive(hospital_code,vendorId)
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
        if(!requisitionNo.equals("")){

           double totalAmount=0.00
            for(int i=0;i<lst.size();i++){
                totalAmount+=lst[i]["amount"]
            }
            result.put('totalAmount', totalAmount)
        }
        render result as JSON
    }

    def showList() {
        render(view: "/requisitionReceive/showList")
    }
    def list() {
        renderOutput(listRequisitionReceiveActionService, params)
    }
    def acknowledgement() {
        String view = '/requisitionReceive/acknowledgement'
        renderView(selectRequisitionAcknowledgementActionService, params, view)
    }
    def detailsReceive() {
        String view = '/requisitionReceive/detailsReceive'
        renderView(selectRequisitionReceiveActionService, params, view)
    }
    def downloadReqReceive(){
        Map result = (Map) getReportResponse(downloadPurchaseReceiveActionService, params).report
        renderOutputStream(result.report.toByteArray(), result.format, result.reportFileName)
    }
}
