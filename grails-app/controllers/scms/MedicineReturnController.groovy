package scms

import actions.medicineReturn.CreateMedicineReturnSellActionService
import actions.medicineReturn.ListMedicineReturnSellActionService
import actions.medicineReturn.MedicineSellReturnDetailsActionService
import actions.medicineReturn.SelectMedicineSellReturnActionService
import com.scms.MedicineSellInfo

class MedicineReturnController extends BaseController {

    ListMedicineReturnSellActionService listMedicineReturnSellActionService
    SelectMedicineSellReturnActionService selectMedicineSellReturnActionService
    CreateMedicineReturnSellActionService createMedicineReturnSellActionService
    MedicineSellReturnDetailsActionService medicineSellReturnDetailsActionService

    def show() {
        render(view: "/medicineReturn/show")
    }
    def list() {
        renderOutput(listMedicineReturnSellActionService, params)
    }
    def create() {
        renderOutput(createMedicineReturnSellActionService, params)
    }
    def showSellReturn() {
        render(view: "/medicineReturn/showSellReturn")
    }
    def showLink(){
        render(view: "/medicineReturn/showLink",model: [dateField: params.dateField])
    }
    def retrieveMedicineDetails() {
        MedicineSellInfo medicineSellInfo = MedicineSellInfo.findByVoucherNo(params.voucherNo)
        params.id = medicineSellInfo.id
        renderOutput(selectMedicineSellReturnActionService, params)
    }
    def details(){
        String view = '/medicineReturn/details'
        renderView(medicineSellReturnDetailsActionService, params, view)
    }
}
