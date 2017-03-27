package actions.medicineReturn

import com.scms.MedicineReturn
import com.scms.MedicineReturnDetails
import com.scms.MedicineSellInfo
import com.scms.MedicineSellInfoDetails
import com.scms.MedicineStock
import com.scms.SecUser
import grails.converters.JSON
import grails.plugin.springsecurity.SpringSecurityService
import grails.transaction.Transactional
import org.apache.log4j.Logger
import org.codehaus.groovy.grails.web.json.JSONElement
import scms.ActionServiceIntf
import scms.BaseService
import scms.utility.DateUtility

@Transactional
class CreateMedicineReturnSellActionService extends BaseService implements ActionServiceIntf {

    SpringSecurityService springSecurityService
    private static final String SAVE_SUCCESS_MESSAGE = "Data saved successfully"
    private static final String MEDICINE_RETURN = "medicineReturn"
    private static final String RETURN_DETAILS = "medicineReturnDetails"
    private Logger log = Logger.getLogger(getClass())

    @Transactional
    public Map executePreCondition(Map params) {
        try {
            if (!params.voucherNo) {
                return super.setError(params, INVALID_INPUT_MSG)
            }
            MedicineReturn medicineReturn = buildReturnObject(params)
            List<MedicineReturnDetails> lstDetails = buildReturnDetailsMap(params)
            if(lstDetails.size()<=0)
                return super.setError(params, INVALID_INPUT_MSG)
            else{
                for (int i = 0; i < lstDetails.size(); i++) {
                   MedicineSellInfoDetails medicineSellInfoDetails =MedicineSellInfoDetails.findByMedicineIdAndVoucherNo(lstDetails[i].medicineId,medicineReturn.traceNo)
                    if(lstDetails[i].quantity>medicineSellInfoDetails.quantity)
                        return super.setError(params, 'Sorry! Invalid return quantity.')
                }
            }
            params.put(MEDICINE_RETURN, medicineReturn)
            params.put(RETURN_DETAILS, lstDetails)
            return params
        } catch (Exception ex) {
            log.error(ex.getMessage())
            throw new RuntimeException(ex)
        }
    }

    @Transactional
    public Map execute(Map result) {
        try {
            String hospitalCode = SecUser.read(springSecurityService.principal.id)?.hospitalCode
            double totalAmt=0

            MedicineReturn medicineReturn = (MedicineReturn) result.get(MEDICINE_RETURN)
            List<MedicineReturnDetails> lstDetails = (List<MedicineReturnDetails>) result.get(RETURN_DETAILS)
            if (lstDetails.size() > 0) {
                for (int i = 0; i < lstDetails.size(); i++) {

                    MedicineStock stock = MedicineStock.findByMedicineIdAndHospitalCode(lstDetails[i].medicineId, hospitalCode)
                    stock.stockQty += lstDetails[i].quantity
                    stock.save()

                    totalAmt+=lstDetails[i].amount
                    lstDetails[i].traceNo = medicineReturn.traceNo
                    lstDetails[i].save()

                }
            }
            medicineReturn.totalAmount=Math.floor(totalAmt)
            medicineReturn.save()
            MedicineSellInfo medicineSellInfo=MedicineSellInfo.findByVoucherNo(medicineReturn.traceNo)
            medicineSellInfo.isReturn=true
            medicineSellInfo.save()
            return result
        } catch (Exception ex) {
            log.error(ex.getMessage())
            throw new RuntimeException(ex)
        }
    }

    public Map executePostCondition(Map result) {
        return result
    }

    public Map buildSuccessResultForUI(Map result) {
        return super.setSuccess(result, SAVE_SUCCESS_MESSAGE)
    }

    public Map buildFailureResultForUI(Map result) {
        return result
    }

    private static List<MedicineReturnDetails> buildReturnDetailsMap(Map parameterMap) {
        List<MedicineReturnDetails> lstMedicine = []
        JSONElement gridModelMedicine = JSON.parse(parameterMap.gridModelMedicine.toString())
        List lstRowsMedicine = (List) gridModelMedicine
        for (int i = 0; i < lstRowsMedicine.size(); i++) {
            if((int)lstRowsMedicine[i].rtnQuantity>0) {
                MedicineReturnDetails details = new MedicineReturnDetails()
                details.traceNo = ''
                details.medicineId = (long) lstRowsMedicine[i].medicineId
                details.quantity = (int) lstRowsMedicine[i].rtnQuantity
                details.amount = details.quantity*(double) lstRowsMedicine[i].unitPrice

                MedicineReturnDetails medicine = details
                lstMedicine.add(medicine)
            }
        }
        return lstMedicine
    }


    private MedicineReturn buildReturnObject(Map params) {
        String hospital_code = SecUser.read(springSecurityService.principal.id)?.hospitalCode
        MedicineReturn medicineReturn = new MedicineReturn(params)
        medicineReturn.traceNo = params.voucherNo
        medicineReturn.hospitalCode = hospital_code
        medicineReturn.returnDate = DateUtility.getSqlDate(new Date())
        medicineReturn.returnBy = springSecurityService.principal.id
        medicineReturn.returnTypeId = 1   // To-do fix return type

        return medicineReturn
    }
}
