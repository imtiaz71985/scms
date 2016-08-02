package scms

import actions.medicineInfo.CreateMedicineInfoActionService
import actions.medicineInfo.DeleteMedicineInfoActionService
import actions.medicineInfo.ListMedicineInfoActionService
import actions.medicineInfo.ListMedicineStockActionService
import actions.medicineInfo.UpdateMedicineInfoActionService
import com.scms.HospitalLocation
import com.scms.SecUser
import grails.plugin.springsecurity.SpringSecurityService
import service.SecUserService

class MedicineInfoController extends BaseController {

    SpringSecurityService springSecurityService
    SecUserService secUserService

    CreateMedicineInfoActionService createMedicineInfoActionService
    UpdateMedicineInfoActionService updateMedicineInfoActionService
    DeleteMedicineInfoActionService deleteMedicineInfoActionService
    ListMedicineInfoActionService listMedicineInfoActionService
    ListMedicineStockActionService listMedicineStockActionService

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
    def listMedicineStock() {
        renderOutput(listMedicineStockActionService, params)
    }
}
