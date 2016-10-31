package scms

import actions.serviceHeadInfo.CreateServiceHeadInfoActionService
import actions.serviceHeadInfo.DeleteServiceHeadInfoActionService
import actions.serviceHeadInfo.UpdateServiceHeadInfoActionService
import com.scms.ServiceHeadInfo
import grails.converters.JSON
import grails.plugin.springsecurity.SpringSecurityService
import groovy.sql.GroovyRowResult
import org.apache.commons.collections.map.HashedMap
import service.ServiceHeadInfoService

class ServiceHeadInfoController extends BaseController{
    SpringSecurityService springSecurityService

    static allowedMethods = [
            show: "POST", create: "POST", update: "POST",delete: "POST", list: "POST"
    ]

    CreateServiceHeadInfoActionService createServiceHeadInfoActionService
    UpdateServiceHeadInfoActionService updateServiceHeadInfoActionService
    DeleteServiceHeadInfoActionService deleteServiceHeadInfoActionService
    ServiceHeadInfoService serviceHeadInfoService

    def show() {
        render(view: "/serviceHeadInfo/show")
    }
    def create() {
        renderOutput(createServiceHeadInfoActionService, params)

    }
    def update() {
        renderOutput(updateServiceHeadInfoActionService, params)

    }
    def delete() {
        renderOutput(deleteServiceHeadInfoActionService, params)

    }
    def list() {
        List<GroovyRowResult> lst=serviceHeadInfoService.serviceHeadInfoList(params)

        Map result=new HashedMap()
        result.put('list', lst)
        result.put('count', lst.size())
        render result as JSON
    }
    def retrieveServiceCode() {
        long serviceTypeId = Long.parseLong(params.serviceTypeId.toString())

        String typeId=(serviceTypeId<10? '0' : '')+serviceTypeId.toString()
        int c=ServiceHeadInfo.countByServiceTypeId(serviceTypeId)
        c+=1

        String serviceNo= (c<10? '000' :c<100? '00' :c<1000? '000' : '')+c.toString()
        String serviceCode=typeId+serviceNo
        Map result=new HashedMap()
        result.put('serviceCode', serviceCode)

        render result as JSON
    }
}
