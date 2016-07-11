package scms

import actions.medicineInfo.CreateMedicineInfoActionService
import actions.medicineInfo.DeleteMedicineInfoActionService
import actions.medicineInfo.ListMedicineInfoActionService
import actions.medicineInfo.UpdateMedicineInfoActionService

class MedicineInfoController extends BaseController {

    CreateMedicineInfoActionService createMedicineInfoActionService
    UpdateMedicineInfoActionService updateMedicineInfoActionService
    DeleteMedicineInfoActionService deleteMedicineInfoActionService
    ListMedicineInfoActionService listMedicineInfoActionService

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
        render(view: "/medicineInfo/stock")
    }
}
