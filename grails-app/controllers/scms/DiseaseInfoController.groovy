package scms

import actions.DiseaseGroup.CreateDiseaseGroupActionService
import actions.DiseaseGroup.ListDiseaseGroupActionService
import actions.DiseaseGroup.UpdateDiseaseGroupActionService
import actions.DiseaseInfo.CreateDiseaseInfoActionService
import actions.DiseaseInfo.DeleteDiseaseInfoActionService
import actions.DiseaseInfo.ListDiseaseInfoActionService
import actions.DiseaseInfo.UpdateDiseaseInfoActionService
import actions.serviceHeadInfo.CreateServiceHeadInfoActionService
import actions.serviceHeadInfo.DeleteServiceHeadInfoActionService
import actions.serviceHeadInfo.ListServiceHeadInfoActionService
import actions.serviceHeadInfo.UpdateServiceHeadInfoActionService
import com.scms.DiseaseInfo
import com.scms.ServiceHeadInfo
import grails.converters.JSON
import grails.plugin.springsecurity.SpringSecurityService
import org.apache.commons.collections.map.HashedMap

class DiseaseInfoController extends BaseController {

    SpringSecurityService springSecurityService
    BaseService baseService
    static allowedMethods = [
            show: "POST", create: "POST", update: "POST",delete: "POST", list: "POST"
    ]

    CreateDiseaseInfoActionService createDiseaseInfoActionService
    UpdateDiseaseInfoActionService updateDiseaseInfoActionService
    DeleteDiseaseInfoActionService deleteDiseaseInfoActionService
    ListDiseaseInfoActionService listDiseaseInfoActionService

    def show() {
        render(view: "/diseaseInfo/show")
    }
    def create() {
        renderOutput(createDiseaseInfoActionService, params)

    }
    def update() {
        renderOutput(updateDiseaseInfoActionService, params)

    }
    def delete() {
        renderOutput(deleteDiseaseInfoActionService, params)

    }
    def list() {
        renderOutput(listDiseaseInfoActionService, params)
    }
    def retrieveDiseaseCode() {
        long diseaseGroupId = Long.parseLong(params.diseaseGroupId.toString())

        String groupId=(diseaseGroupId<10? '0' : '')+diseaseGroupId.toString()
        int c=DiseaseInfo.countByDiseaseGroupId(diseaseGroupId)
        c+=1

        String diseaseNo= (c<10? '000' :c<100? '00' :c<1000? '000' : '')+c.toString()
        String diseaseCode=groupId+diseaseNo
        // def result = [:]
        Map result=new HashedMap()
        result.put('diseaseCode', diseaseCode)

        render result as JSON
        //render(view: "/registrationInfo/show", model: [key:'value'])
    }
}
