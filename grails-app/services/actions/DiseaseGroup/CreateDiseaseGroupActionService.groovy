package actions.DiseaseGroup

import com.model.ListDiseaseGroupActionServiceModel
import com.scms.DiseaseGroup
import com.scms.ServiceCharges
import grails.plugin.springsecurity.SpringSecurityService
import grails.transaction.Transactional
import org.apache.log4j.Logger
import scms.ActionServiceIntf
import scms.BaseService
import scms.utility.DateUtility

@Transactional
class CreateDiseaseGroupActionService  extends BaseService implements ActionServiceIntf{

    private static final String SAVE_SUCCESS_MESSAGE = "Data has been saved successfully"
    private static final String ALREADY_EXIST = "Same group already exist"
    private static final String DISEASE_GROUP = "diseaseGroup"

    SpringSecurityService springSecurityService
    private Logger log = Logger.getLogger(getClass())

    @Transactional(readOnly = true)
    public Map executePreCondition(Map params) {
        try {
            //Check parameters
            if (!params.name||!params.chargeAmount|| !params.activationDate) {
                return super.setError(params, INVALID_INPUT_MSG)
            }
            int duplicateCount = DiseaseGroup.countByName(params.name)
            if (duplicateCount > 0) {
                return super.setError(params, ALREADY_EXIST)
            }
            DiseaseGroup diseaseGroup = buildObject(params)
            params.put(DISEASE_GROUP, diseaseGroup)
            return params
        } catch (Exception ex) {
            log.error(ex.getMessage())
            throw new RuntimeException(ex)
        }
    }

    @Transactional
    public Map execute(Map result) {
        try {
            DiseaseGroup diseaseGroup = (DiseaseGroup) result.get(DISEASE_GROUP)
            diseaseGroup.save()

            ServiceCharges serviceCharges=new ServiceCharges()
            serviceCharges.serviceCode=diseaseGroup.id.toString()
            serviceCharges.chargeAmount=Double.parseDouble(result.chargeAmount)
            serviceCharges.activationDate=DateUtility.getSqlDate(DateUtility.parseMaskedDate(result.activationDate))
            serviceCharges.createDate=DateUtility.getSqlDate(new Date())
            serviceCharges.createdBy = springSecurityService.principal.id
            serviceCharges.save()

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
        DiseaseGroup diseaseGroup = (DiseaseGroup) result.get(DISEASE_GROUP)
        ListDiseaseGroupActionServiceModel model = ListDiseaseGroupActionServiceModel.read(diseaseGroup.id)
        result.put(DISEASE_GROUP, model)
        return super.setSuccess(result, SAVE_SUCCESS_MESSAGE)
    }

    public Map buildFailureResultForUI(Map result) {
        return result
    }

    /**
     * Build DiseaseGroup object
     * @param parameterMap -serialized parameters from UI
     * @return -new DiseaseGroup object
     */
    private DiseaseGroup buildObject(Map parameterMap) {
        DiseaseGroup diseaseGroup = new DiseaseGroup(parameterMap)
        diseaseGroup.isActive=true
        return diseaseGroup
    }
}
