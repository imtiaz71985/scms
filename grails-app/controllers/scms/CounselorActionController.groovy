package scms

import actions.ServiceTokenInfo.CreateServiceTokenInfoActionService
import actions.ServiceTokenInfo.UpdateServiceTokenInfoActionService
import actions.registrationInfo.ListRegistrationInfoActionService
import com.scms.SecUser
import com.scms.ServiceTokenInfo
import grails.converters.JSON
import grails.plugin.springsecurity.SpringSecurityService
import groovy.sql.GroovyRowResult
import org.apache.commons.collections.map.HashedMap
import scms.utility.DateUtility
import service.ServiceTokenRelatedInfoService

import java.text.SimpleDateFormat

class CounselorActionController extends BaseController {
    SpringSecurityService springSecurityService
    static allowedMethods = [
            show: "POST", create: "POST", update: "POST",delete: "POST", list: "POST"
    ]

    CreateServiceTokenInfoActionService createServiceTokenInfoActionService
    UpdateServiceTokenInfoActionService updateServiceTokenInfoActionService
    ServiceTokenRelatedInfoService serviceTokenRelatedInfoService


    def show() {
        render(view: "/counselorAction/show")
    }
    def create() {
        renderOutput(createServiceTokenInfoActionService, params)
    }

    def update() {
        renderOutput(updateServiceTokenInfoActionService, params)
    }

    def list() {
        Date start = DateUtility.getSqlFromDateWithSeconds(new Date())
        Date end = DateUtility.getSqlToDateWithSeconds(new Date())
        List<GroovyRowResult> lst=serviceTokenRelatedInfoService.RegAndServiceDetails(start,end)

        Map result=new HashedMap()
        result.put('list', lst)
        result.put('count', lst.size())
        render result as JSON
       // renderOutput(listServiceTokenInfoActionService, params)
    }

    def createServiceTokenNo() {
        String hospital_code= SecUser.read(springSecurityService.principal.id)?.hospitalCode
        Date start = DateUtility.getSqlFromDateWithSeconds(new Date())
        Date end = DateUtility.getSqlToDateWithSeconds(new Date())
        int c=ServiceTokenInfo.countByServiceDateBetween(start, end)
        c+=1
        String DATE_FORMAT = "ddMMyy";
        SimpleDateFormat sdf = new SimpleDateFormat(DATE_FORMAT);
        Calendar c1 = Calendar.getInstance(); // today
        String tokenNo=sdf.format(c1.getTime())
        String serviceNo= (c<10? '00' : c<100? '0' : '')+c.toString()
        tokenNo='S'+hospital_code+tokenNo+serviceNo
        // def result = [:]
        Map result=new HashedMap()
        result.put('tokenNo', tokenNo)

        render result as JSON
    }
    def retrieveServiceTokenNo() {
        String regNo=params.regNo.toString()
        String tokenNo=serviceTokenRelatedInfoService.findLastTokenNoByRegNoAndIsExit(regNo,false)
        List<GroovyRowResult> lst=serviceTokenRelatedInfoService.getTotalHealthServiceCharge(tokenNo)
        Map result=new HashedMap()
        result.put('serviceTokenNo', tokenNo)
        result.put('totalHealthCharge', lst[0].totalHealthCharge)
        result.put('serviceTypeId', lst[0].service_type_id)

        render result as JSON
    }
    def retrieveDataByTokenNo() {
        String tokenNo=params.tokenNo.toString()
        List<GroovyRowResult> lst=serviceTokenRelatedInfoService.getTotalHealthServiceCharge(tokenNo)
        Map result=new HashedMap()
        if(!lst[0].isExit) {
            result.put('regNo', lst[0].reg_no)
        }
        else
        {
            result.put('regNo','')
        }
        result.put('totalHealthCharge', lst[0].totalHealthCharge)
        result.put('serviceTypeId', lst[0].service_type_id)

        render result as JSON
    }
}
