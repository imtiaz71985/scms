package scms

import actions.DiseaseInfo.CreateDiseaseInfoActionService
import actions.DiseaseInfo.DeleteDiseaseInfoActionService
import actions.DiseaseInfo.ListDiseaseInfoActionService
import actions.DiseaseInfo.UpdateDiseaseInfoActionService
import com.scms.DiseaseInfo
import com.scms.ServiceCharges
import grails.converters.JSON
import grails.plugin.springsecurity.SpringSecurityService
import groovy.sql.GroovyRowResult
import org.apache.commons.collections.map.HashedMap
import service.ServiceChargesService

class DiseaseInfoController extends BaseController {

    SpringSecurityService springSecurityService
    BaseService baseService
    ServiceChargesService serviceChargesService
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

        String diseaseNo= (c<10? '0' : '')+c.toString()
        String diseaseCode=groupId+diseaseNo
        double chargeAmount=serviceChargesService.chargeInfoByDiseaseGroupId(diseaseGroupId)
        // def result = [:]
        Map result=new HashedMap()
        result.put('diseaseCode', diseaseCode)
        result.put('chargeAmount', chargeAmount)

        render result as JSON
        //render(view: "/registrationInfo/show", model: [key:'value'])
    }
}
