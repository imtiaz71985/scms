package scms

import actions.medicinePrice.CreateMedicinePriceActionService
import actions.medicinePrice.ListMedicinePriceActionService
import com.scms.MedicineInfo

class MedicinePriceController extends BaseController {

    CreateMedicinePriceActionService createMedicinePriceActionService
    ListMedicinePriceActionService listMedicinePriceActionService

    static allowedMethods = [
            show: "POST", create: "POST", list: "POST"
    ]

    def show() {
        MedicineInfo medicineInfo = MedicineInfo.read(params.medicineId)
        String name = ''
        if(medicineInfo.strength!=''){
            name = medicineInfo.brandName+' ('+medicineInfo.strength+')'
        }else{
            name = medicineInfo.brandName
        }
        render(view: "/medicinePrice/show", model: [medicineId:params.medicineId, name:name])
    }
    def create() {
        renderOutput(createMedicinePriceActionService, params)

    }
    def list() {
        renderOutput(listMedicinePriceActionService, params)

    }
}
