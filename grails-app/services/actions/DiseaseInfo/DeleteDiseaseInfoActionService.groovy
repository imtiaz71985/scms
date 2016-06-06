package actions.DiseaseInfo

import com.model.ListDiseaseInfoActionServiceModel
import com.scms.DiseaseInfo
import grails.plugin.springsecurity.SpringSecurityService
import grails.transaction.Transactional
import org.apache.log4j.Logger
import scms.ActionServiceIntf
import scms.BaseService
import scms.utility.DateUtility

@Transactional
class DeleteDiseaseInfoActionService  extends BaseService implements ActionServiceIntf{

    private Logger log = Logger.getLogger(getClass())

    private static final String DELETE_SUCCESS_MESSAGE = "Record has been deactivated successfully"
    private static final String NOT_FOUND = "Selected record does not exits"
    private static final String DISEASE_INFO = "diseaseInfo"
    SpringSecurityService springSecurityService

    @Transactional(readOnly = true)
    public Map executePreCondition(Map params) {
        try {
            String diseaseCode=params.diseaseCode.toString()
            DiseaseInfo oldDiseaseInfo = DiseaseInfo.findByDiseaseCode(diseaseCode)
            if(!oldDiseaseInfo){
                return super.setError(params, NOT_FOUND)
            }
            DiseaseInfo diseaseInfo = buildObject(oldDiseaseInfo)
            params.put(DISEASE_INFO, diseaseInfo)
            return params
        } catch (Exception ex) {
            log.error(ex.getMessage())
            throw new RuntimeException(ex)
        }
    }

    @Transactional
    public Map execute(Map result) {
        try {
            DiseaseInfo diseaseInfo = (DiseaseInfo) result.get(DISEASE_INFO)
            diseaseInfo.save()
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
        DiseaseInfo diseaseInfo = (DiseaseInfo) result.get(DISEASE_INFO)
        ListDiseaseInfoActionServiceModel model = ListDiseaseInfoActionServiceModel.findByDiseaseCode(diseaseInfo.diseaseCode)
        result.put(DISEASE_INFO, model)
        return super.setSuccess(result, DELETE_SUCCESS_MESSAGE)
    }

    public Map buildFailureResultForUI(Map params) {
        return params
    }

    private  DiseaseInfo buildObject(DiseaseInfo oldDiseaseInfo) {

        oldDiseaseInfo.modifyDate = DateUtility.getSqlDate(new Date())
        oldDiseaseInfo.modifyBy = springSecurityService.principal.id
        oldDiseaseInfo.isActive=false

        return oldDiseaseInfo
    }
}
