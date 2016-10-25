package scms

import actions.ServiceChargeFreeDays.CreateServiceChargeFreeDaysActionService
import actions.ServiceChargeFreeDays.ListServiceChargeFreeDaysActionService
import grails.converters.JSON
import grails.plugin.springsecurity.SpringSecurityService
import groovy.sql.GroovyRowResult
import org.apache.commons.collections.map.HashedMap

class ServiceChargeFreeDaysController extends BaseController {
    SpringSecurityService springSecurityService
    static allowedMethods = [
            show: "POST", create: "POST", update: "POST",delete: "POST", list: "POST"
    ]
    CreateServiceChargeFreeDaysActionService createServiceChargeFreeDaysActionService

    ListServiceChargeFreeDaysActionService listServiceChargeFreeDaysActionService

    def show() {
        render(view: "/serviceChargeFreeDays/show")
    }
    def create() {
        renderOutput(createServiceChargeFreeDaysActionService, params)

    }
    def update() {
        renderOutput(createServiceChargeFreeDaysActionService, params)

    }

    def list() {
        renderOutput(listServiceChargeFreeDaysActionService, params)
    }
}
