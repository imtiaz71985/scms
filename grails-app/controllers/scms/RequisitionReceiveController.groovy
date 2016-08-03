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
import service.SecUserService

class RequisitionReceiveController extends BaseController {

    BaseService baseService
    SpringSecurityService springSecurityService
    SecUserService secUserService
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
        String hospital_code = secUserService.retrieveHospitalCode()
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
        long vendorId=0
        if(params.vendorId)
             vendorId= Long.parseLong(params.vendorId)
        List<GroovyRowResult> lst=requisitionService.listOfMedicineForReceive(requisitionNo,vendorId)
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
        boolean isAdmin = secUserService.isLoggedUserAdmin(springSecurityService.principal.id)
        render(view: "/requisitionReceive/showList",model: [isAdmin:isAdmin])
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
