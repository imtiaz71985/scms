package scms

import actions.registrationInfo.CreateRegistrationInfoActionService
import actions.registrationInfo.CustomListRegistrationInfoActionService
import actions.registrationInfo.DeleteRegistrationInfoActionService
import actions.registrationInfo.ListRegistrationInfoActionService
import actions.registrationInfo.ReIssueListRegistrationInfoActionService
import actions.registrationInfo.ReIssueRegistrationNoActionService
import actions.registrationInfo.UpdateRegistrationInfoActionService
import actions.revisitPatient.CreateRevisitPatientActionService
import com.model.ListReIssueRegistrationInfoActionServiceModel
import com.scms.RegistrationInfo
import com.scms.SecUser
import com.scms.StUnion
import com.scms.Upazila
import com.scms.Village
import grails.converters.JSON
import grails.plugin.springsecurity.SpringSecurityService
import groovy.sql.GroovyRowResult
import org.apache.commons.collections.map.HashedMap
import org.hibernate.ejb.criteria.expression.function.AggregationFunction
import scms.utility.DateUtility
import service.RegistrationInfoService
import service.SecUserService

import java.sql.Timestamp
import java.text.SimpleDateFormat

class RegistrationInfoController extends BaseController {
    BaseService baseService
    SpringSecurityService springSecurityService
    RegistrationInfoService registrationInfoService
    SecUserService secUserService

    static allowedMethods = [
            show: "POST", create: "POST", update: "POST",delete: "POST", list: "POST"
    ]

    CreateRegistrationInfoActionService createRegistrationInfoActionService
    UpdateRegistrationInfoActionService updateRegistrationInfoActionService
    DeleteRegistrationInfoActionService deleteRegistrationInfoActionService
    ListRegistrationInfoActionService listRegistrationInfoActionService
    CustomListRegistrationInfoActionService customListRegistrationInfoActionService
    ReIssueListRegistrationInfoActionService reIssueListRegistrationInfoActionService
    ReIssueRegistrationNoActionService reIssueRegistrationNoActionService
    CreateRevisitPatientActionService createRevisitPatientActionService

    def showNew() {
        String regNo = registrationInfoService.retrieveRegNo(new Date())
        render(view: "/registrationInfo/showNew", model: [regNo: regNo])
    }
    def show() {
        String msg = registrationInfoService.patientServed(new Date())
        List<GroovyRowResult> dropDownCreatingDate=registrationInfoService.listUnclosedTransactionDate()
        List<GroovyRowResult> lstValues= baseService.listForKendoDropdown(dropDownCreatingDate, null, null)
        lstValues.remove(0)
        render(view: "/registrationInfo/show", model: [patientServed:msg,dropDownVals:lstValues as JSON])
    }
    def showMonthlyPatient(){
        String viewStr = "/registrationInfo/showDailyPatient"
        if(params.visitType=='followup'){
            viewStr = "/registrationInfo/showOthers"
        }
        if(params.visitType=='reissue'){
            viewStr = "/registrationInfo/showReIssue"
        }
        render(view: viewStr, model: [dateField: params.dateField,visitType:params.visitType])
    }
    def reloadDropDown() {
        render app.dropDownVillage(params)
    }
    def create() {
        renderOutput(createRegistrationInfoActionService, params)

    }
    def update() {
        renderOutput(updateRegistrationInfoActionService, params)

    }
    def delete() {
        renderOutput(deleteRegistrationInfoActionService, params)

    }
    def reIssue() {
        renderOutput(reIssueRegistrationNoActionService, params)

    }
    def revisitPatientInfoEntry() {
        renderOutput(createRevisitPatientActionService, params)
    }
    def list() {
        String visitType = params.visitType
        if (visitType.equals("revisit")) {
            String hospitalCode =''
            Date dateField = DateUtility.parseDateForDB(params.dateField)
            if (!secUserService.isLoggedUserAdmin(springSecurityService.principal.id)){
                hospitalCode= SecUser.read(springSecurityService.principal.id)?.hospitalCode
            }
            List<GroovyRowResult> lst=registrationInfoService.listOfRevisitPatient(hospitalCode, DateUtility.getSqlFromDateWithSeconds(dateField), DateUtility.getSqlToDateWithSeconds(dateField))

            Map result = new HashedMap()
            result.put("list", lst)
            result.put("count", lst.size())
            render result as JSON
        }
        else {
            renderOutput(listRegistrationInfoActionService, params)
        }
    }
    def customList() {
        renderOutput(customListRegistrationInfoActionService, params)
    }
    def reissueList() {
        renderOutput(reIssueListRegistrationInfoActionService, params)
    }

    def upazilaListByDistrictId() {
        long districtId = Long.parseLong(params.districtId.toString())
        List<Upazila> lstUpazila = Upazila.findAllByDistrictId(districtId, [sort: "name",order: "ASC"])
        lstUpazila = baseService.listForKendoDropdown(lstUpazila, null, null)
        Map result = [lstUpazila: lstUpazila]
        render result as JSON
    }
    def unionListByUpazilaId() {
        long upazilaId = Long.parseLong(params.upazilaId.toString())
        List<StUnion> lstUnion = StUnion.findAllByUpazilaId(upazilaId, [sort: "name",order: "ASC"])
        lstUnion = baseService.listForKendoDropdown(lstUnion, null, null)
        Map result = [lstUnion: lstUnion]
        render result as JSON
    }
    def addressByVillage() {
        long villageId = Long.parseLong(params.villageId.toString())
        LinkedHashMap resultMap = registrationInfoService.getAddressDetails(villageId)

        Map result = [unionId: resultMap.unionId,upazilaId: resultMap.upazilaId,districtId: resultMap.districtId]
        render result as JSON
    }
    def retrieveRegNo() {
        Date date=DateUtility.parseDateForDB(params.creatingDate)
        String regNo = registrationInfoService.retrieveRegNo(date)
        Map result = new HashedMap()
        result.put('regNo', regNo)
        render result as JSON
    }
    def retrievePatientCountSummary() {
        Date date=DateUtility.parseDateForDB(params.creatingDate)
        String msg = registrationInfoService.patientServed(date)
        Map result = new HashedMap()
        result.put('patientServed', msg)
        render result as JSON
    }
}
