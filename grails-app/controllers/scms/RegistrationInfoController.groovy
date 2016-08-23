package scms

import actions.registrationInfo.CreateRegistrationInfoActionService
import actions.registrationInfo.DeleteRegistrationInfoActionService
import actions.registrationInfo.ListRegistrationInfoActionService
import actions.registrationInfo.ReIssueRegistrationNoActionService
import actions.registrationInfo.UpdateRegistrationInfoActionService
import com.scms.RegistrationInfo
import com.scms.SecUser
import com.scms.StUnion
import com.scms.Upazila
import com.scms.Village
import grails.converters.JSON
import grails.plugin.springsecurity.SpringSecurityService
import groovy.sql.GroovyRowResult
import org.apache.commons.collections.map.HashedMap
import scms.utility.DateUtility
import service.RegistrationInfoService

import java.sql.Timestamp
import java.text.SimpleDateFormat

class RegistrationInfoController extends BaseController {
    BaseService baseService
    SpringSecurityService springSecurityService
    RegistrationInfoService registrationInfoService

    static allowedMethods = [
            show: "POST", create: "POST", update: "POST",delete: "POST", list: "POST"
    ]

    CreateRegistrationInfoActionService createRegistrationInfoActionService
    UpdateRegistrationInfoActionService updateRegistrationInfoActionService
    DeleteRegistrationInfoActionService deleteRegistrationInfoActionService
    ListRegistrationInfoActionService listRegistrationInfoActionService
    ReIssueRegistrationNoActionService reIssueRegistrationNoActionService

    def showNew() {
        String regNo = registrationInfoService.retrieveRegNo()
        render(view: "/registrationInfo/showNew", model: [regNo: regNo])
    }
    def show() {
        render(view: "/registrationInfo/show")
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
    def list() {
        renderOutput(listRegistrationInfoActionService, params)
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

        Map result = [address: resultMap.address]
        render result as JSON
    }

}
