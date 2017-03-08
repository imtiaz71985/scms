package scms

import actions.medicineSellInfo.*
import com.scms.HospitalLocation
import com.scms.MedicineInfo
import com.scms.MedicineSellInfo
import com.scms.MedicineStock
import com.scms.SecUser
import com.scms.SystemEntity
import grails.converters.JSON
import grails.plugin.springsecurity.SpringSecurityService
import org.apache.commons.collections.map.HashedMap
import scms.utility.DateUtility

import java.text.SimpleDateFormat

class MedicineSellInfoController extends BaseController {

    SpringSecurityService springSecurityService
    CreateMedicineSellInfoActionService createMedicineSellInfoActionService
    UpdateMedicineSellInfoActionService updateMedicineSellInfoActionService
    DeleteMedicineSellInfoActionService deleteMedicineSellInfoActionService
    ListMedicineSellInfoActionService listMedicineSellInfoActionService
    SelectMedicineSellInfoActionService selectMedicineSellInfoActionService

    static allowedMethods = [
            show: "POST", create: "POST", update: "POST",delete: "POST", list: "POST"
    ]

    def show() {
        render(view: "/medicineSellInfo/show")
    }
    def showDetails() {
        String voucherNo = generateVoucherNo(new Date())
        render(view: "/medicineSellInfo/showDetails",model: [voucherNo: voucherNo])
    }
    def showLink(){
        render(view: "/medicineSellInfo/showLink",model: [dateField: params.dateField])
    }
    def select(){
        String view = '/medicineSellInfo/update'
        renderView(selectMedicineSellInfoActionService, params, view)
    }
    def create() {
        renderOutput(createMedicineSellInfoActionService, params)

    }
    def update() {
        renderOutput(updateMedicineSellInfoActionService, params)

    }
    def delete() {
        renderOutput(deleteMedicineSellInfoActionService, params)

    }
    def list() {
        renderOutput(listMedicineSellInfoActionService, params)
    }

    def retrieveMedicinePrice() {
        SecUser user = SecUser.read(springSecurityService.principal.id)
        String hospitalCode = HospitalLocation.findByCode(user.hospitalCode).code

        long medicineId = Long.parseLong(params.medicineId.toString())
        MedicineInfo medicineInfo = MedicineInfo.read(medicineId)
        MedicineStock medicineStock = MedicineStock.findByMedicineIdAndHospitalCode(medicineId, hospitalCode)
        SystemEntity medicineType = SystemEntity.read(medicineInfo.type)
        Map result = new HashedMap()
        if(medicineInfo.strength){
            result.put('name', medicineInfo.brandName + ' (' + medicineInfo.strength + ')' + ' - ' + medicineType.name)
        }else{
            result.put('name', medicineInfo.brandName + ' - ' + medicineType.name)
        }
        if(medicineInfo.unitType){
            result.put('unitPriceTxt', medicineInfo.unitPrice+' /'+medicineInfo.unitType)
        }else{
            result.put('unitPriceTxt', medicineInfo.unitPrice)
        }
        result.put('unitPrice', medicineInfo.unitPrice)
        result.put('unitType', medicineInfo.unitType)
        result.put('amount', medicineInfo.unitPrice)
        result.put('stockQty', medicineStock.stockQty)
        render result as JSON
    }

    def retrieveVoucherNo() {
        Date date=DateUtility.parseDateForDB(params.creatingDate)
        String voucherNo = generateVoucherNo(date)
        Map result = new HashedMap()
        result.put('voucherNo', voucherNo)
        render result as JSON
    }

    private String generateVoucherNo(Date date){
        Date sellDate = DateUtility.parseDateForDB(DateUtility.getDBDateFormatAsString(date))
        String hospital_code= SecUser.read(springSecurityService.principal.id)?.hospitalCode
        int serial = MedicineSellInfo.countBySellDateAndHospitalCode(sellDate,hospital_code)
        serial+=1
        String DATE_FORMAT = "ddMMyy";
        SimpleDateFormat sdf = new SimpleDateFormat(DATE_FORMAT);
        //Calendar cal = Calendar.getInstance(); // today
        //String voucherNo=sdf.format(cal.getTime())
        String voucherNo=sdf.format(date)
        String formatted = String.format("%04d", serial);
        voucherNo='V'+hospital_code+voucherNo+formatted
        return voucherNo
    }



}
