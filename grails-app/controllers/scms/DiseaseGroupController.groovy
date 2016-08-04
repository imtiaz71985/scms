package scms

import actions.DiseaseGroup.CreateDiseaseGroupActionService
import actions.DiseaseGroup.ListDiseaseGroupActionService
import actions.DiseaseGroup.UpdateDiseaseGroupActionService
import grails.converters.JSON
import groovy.sql.GroovyRowResult
import org.apache.commons.collections.map.HashedMap
import service.ServiceChargesService

class DiseaseGroupController extends BaseController {

    static allowedMethods = [
            show: "POST", create: "POST", update: "POST",delete: "POST", list: "POST"
    ]

    CreateDiseaseGroupActionService createDiseaseGroupActionService
    UpdateDiseaseGroupActionService updateDiseaseGroupActionService
    ServiceChargesService serviceChargesService

    def show() {
        render(view: "/diseaseGroup/show")
    }
    def create() {
        renderOutput(createDiseaseGroupActionService, params)

    }
    def update() {
        renderOutput(updateDiseaseGroupActionService, params)

    }
    def list() {
        List<GroovyRowResult> lst=serviceChargesService.DiseaseInfoList()

        Map result=new HashedMap()
        result.put('list', lst)
        result.put('count', lst.size())
        render result as JSON
    }
}
