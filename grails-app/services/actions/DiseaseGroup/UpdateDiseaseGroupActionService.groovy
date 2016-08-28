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
class UpdateDiseaseGroupActionService extends BaseService implements ActionServiceIntf {

    private static final String UPDATE_SUCCESS_MESSAGE = "Service Type has been updated successfully"
    private static final String ROLE_ALREADY_EXIST = "Same Type already exist"
    private static final String DISEASE_GROUP = "diseaseGroup"

    SpringSecurityService springSecurityService
    private Logger log = Logger.getLogger(getClass())

    public Map executePreCondition(Map params) {
        try {
            if ((!params.id) || (!params.name|| !params.chargeAmount || !params.activationDate)) {
                return super.setError(params, INVALID_INPUT_MSG)
            }
            long id = Long.parseLong(params.id.toString())
            DiseaseGroup oldDiseaseGroup = (DiseaseGroup) DiseaseGroup.read(id)
            String name = params.name.toString()
            int duplicateCount = DiseaseGroup.countByNameIlikeAndIdNotEqual(name, id)
            if (duplicateCount > 0) {
                return super.setError(params, ROLE_ALREADY_EXIST)
            }
            DiseaseGroup diseaseGroup = buildObject(params, oldDiseaseGroup)
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
            String groupCode='02D'+diseaseGroup.id.toString()
            ServiceCharges serviceCharges = ServiceCharges.findByServiceCodeAndLastActiveDate(groupCode,null)

            Date d=DateUtility.parseMaskedDate(result.activationDate)
            d=d.minus(1)
            boolean newEntry=true
            if(serviceCharges!=null) {

                if(serviceCharges.activationDate>DateUtility.getSqlFromDateWithSeconds(new Date())) {
                    serviceCharges.chargeAmount = Double.parseDouble(result.chargeAmount)
                    serviceCharges.activationDate = DateUtility.getSqlDate(DateUtility.parseMaskedDate(result.activationDate))
                    serviceCharges.createDate = DateUtility.getSqlDate(new Date())
                    serviceCharges.createdBy = springSecurityService.principal.id
                    newEntry=false
                }
                else {
                    serviceCharges.lastActiveDate = DateUtility.getSqlDate(d)
                }
                serviceCharges.save()
                if(!newEntry) {
                    ServiceCharges serviceCharges3 = ServiceCharges.findByServiceCodeAndLastActiveDateIsNotNull(groupCode,[sort:'id',order:'desc',limit: 1 ])
                    if(serviceCharges3!=null){
                        serviceCharges3.lastActiveDate = DateUtility.getSqlDate(d)
                        serviceCharges3.save();
                    }
                }
            }

            if(diseaseGroup.isActive && newEntry) {
                ServiceCharges serviceCharges2 = new ServiceCharges()
                serviceCharges2.serviceCode = groupCode
                serviceCharges2.chargeAmount = Double.parseDouble(result.chargeAmount)
                serviceCharges2.activationDate = DateUtility.getSqlDate(DateUtility.parseMaskedDate(result.activationDate))
                serviceCharges2.createDate = DateUtility.getSqlDate(new Date())
                serviceCharges2.createdBy = springSecurityService.principal.id
                serviceCharges2.save()
            }
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
        return super.setSuccess(result, UPDATE_SUCCESS_MESSAGE)
    }

    public Map buildFailureResultForUI(Map params) {
        return params
    }

    private static DiseaseGroup buildObject(Map parameterMap, DiseaseGroup oldDiseaseGroup) {
        DiseaseGroup diseaseGroup = new DiseaseGroup(parameterMap)
        oldDiseaseGroup.name = diseaseGroup.name
        oldDiseaseGroup.description = diseaseGroup.description
        oldDiseaseGroup.isActive = diseaseGroup.isActive
        return oldDiseaseGroup
    }
}
