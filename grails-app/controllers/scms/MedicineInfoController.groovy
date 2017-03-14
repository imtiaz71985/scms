package scms

import actions.medicineInfo.CreateMedicineInfoActionService
import actions.medicineInfo.DeleteMedicineInfoActionService
import actions.medicineInfo.DownloadMedicineStockActionService
import actions.medicineInfo.ListMedicineInfoActionService
import actions.medicineInfo.ListMedicineStockActionService
import actions.medicineInfo.UpdateMedicineInfoActionService
import com.scms.HospitalLocation
import com.scms.SecUser
import grails.converters.JSON
import grails.plugin.springsecurity.SpringSecurityService
import groovy.sql.GroovyRowResult
import org.apache.commons.collections.map.HashedMap
import service.MedicineInfoService
import service.SecUserService

class MedicineInfoController extends BaseController {

    SpringSecurityService springSecurityService
    SecUserService secUserService
    MedicineInfoService medicineInfoService

    CreateMedicineInfoActionService createMedicineInfoActionService
    UpdateMedicineInfoActionService updateMedicineInfoActionService
    DeleteMedicineInfoActionService deleteMedicineInfoActionService
    ListMedicineInfoActionService listMedicineInfoActionService
    ListMedicineStockActionService listMedicineStockActionService
    DownloadMedicineStockActionService downloadMedicineStockActionService

    static allowedMethods = [
            show: "POST", create: "POST", update: "POST",delete: "POST", list: "POST"
    ]

    def show() {
        render(view: "/medicineInfo/show")
    }
    def create() {
        renderOutput(createMedicineInfoActionService, params)

    }
    def update() {
        renderOutput(updateMedicineInfoActionService, params)

    }
    def delete() {
        renderOutput(deleteMedicineInfoActionService, params)

    }
    def list() {
        renderOutput(listMedicineInfoActionService, params)
    }
    def stock() {
        SecUser user = SecUser.read(springSecurityService.principal.id)
        boolean isAdmin = secUserService.isLoggedUserAdmin(user.id)

        String hospitalCode = HospitalLocation.findByCode(user.hospitalCode).code
        render(view: "/medicineInfo/stock", model: [isAdmin:isAdmin,hospitalCode:hospitalCode])
    }
    def shortageInStock() {
        SecUser user = SecUser.read(springSecurityService.principal.id)
        boolean isAdmin = secUserService.isLoggedUserAdmin(user.id)

        String hospitalCode = user.hospitalCode
        render(view: "/medicineInfo/shortageInStock", model: [isAdmin:isAdmin,hospitalCode:hospitalCode])
    }
    def listMedicineStock() {
        renderOutput(listMedicineStockActionService, params)
    }
    def downloadMedicineStock() {
        Map result = (Map) getReportResponse(downloadMedicineStockActionService, params).report
        renderOutputStream(result.report.toByteArray(), result.format, result.reportFileName)
    }
    def listMedicineShortageStock() {
        String hospitalCode = ''
        try {
            hospitalCode = params.hospitalCode
        } catch (Exception ex) {
        }
        List<GroovyRowResult> lst = medicineInfoService.listOfMedicineShortageInStock(hospitalCode)

        Map result = new HashedMap()
        result.put('list', lst)
        result.put('count', lst.size())
        render result as JSON
    }
}
