package scms

import actions.ServiceTokenInfo.CreateServiceTokenInfoActionService
import actions.ServiceTokenInfo.DeleteServiceTokenInfoActionService
import com.scms.DiseaseInfo
import com.scms.SecUser
import com.scms.ServiceTokenInfo
import grails.converters.JSON
import grails.plugin.springsecurity.SpringSecurityService
import groovy.sql.GroovyRowResult
import org.apache.commons.collections.map.HashedMap
import scms.utility.DateUtility
import service.RegistrationInfoService
import service.SecUserService
import service.ServiceChargesService
import service.ServiceHeadInfoService
import service.ServiceTokenRelatedInfoService

import java.sql.Timestamp
import java.text.SimpleDateFormat

class CounselorActionController extends BaseController {
    SpringSecurityService springSecurityService
    SecUserService secUserService
    ServiceChargesService serviceChargesService
    static allowedMethods = [
            show: "POST", create: "POST", update: "POST", delete: "POST", list: "POST"
    ]

    CreateServiceTokenInfoActionService createServiceTokenInfoActionService
    DeleteServiceTokenInfoActionService deleteServiceTokenInfoActionService
    ServiceTokenRelatedInfoService serviceTokenRelatedInfoService
    ServiceHeadInfoService serviceHeadInfoService
    BaseService baseService
    RegistrationInfoService registrationInfoService

    def show() {
        String hospital_code = SecUser.read(springSecurityService.principal.id)?.hospitalCode
        Date fromDate,toDate
            fromDate=DateUtility.getSqlFromDateWithSeconds(new Date())
            toDate=DateUtility.getSqlToDateWithSeconds(new Date())
        List<GroovyRowResult> lst = registrationInfoService.listOfPatientAndService(hospital_code,fromDate,toDate)
        String msg='Registered: '+lst[0].total_patient+'; Served: '+lst[0].total_served
        render(view: "/counselorAction/show", model: [patientServed:msg])
    }
    def showConsultancy() {
        render(view: "/counselorAction/showConsultancy", model: [hospitalCode:params.hospitalCode,dateField:params.dateField])
    }
    def showSubsidy() {
        render(view: "/counselorAction/showSubsidy", model: [hospitalCode:params.hospitalCode,dateField:params.dateField])
    }
    def showDiagnosis() {
        render(view: "/counselorAction/showDiagnosis", model: [hospitalCode:params.hospitalCode,dateField:params.dateField])
    }

    def consultancyList() {
        Date dateField = DateUtility.parseDateForDB(params.dateField)
        Date start = DateUtility.getSqlFromDateWithSeconds(dateField)
        Date end = DateUtility.getSqlToDateWithSeconds(dateField)
        String hospital_code = params.hospitalCode
        List<GroovyRowResult> lst = serviceTokenRelatedInfoService.dateWiseConsultancyDetails(start, end, hospital_code)

        Map result = new HashedMap()
        result.put('list', lst)
        result.put('count', lst.size())
        render result as JSON
    }

    def subsidyList() {
        Date dateField = DateUtility.parseDateForDB(params.dateField)
        Date start = DateUtility.getSqlFromDateWithSeconds(dateField)
        Date end = DateUtility.getSqlToDateWithSeconds(dateField)
        String hospital_code = params.hospitalCode
        List<GroovyRowResult> lst = serviceTokenRelatedInfoService.dateWiseSubsidyDetails(start, end, hospital_code)

        Map result = new HashedMap()
        result.put('list', lst)
        result.put('count', lst.size())
        render result as JSON
    }
    def diagnosisList() {
        Date dateField = DateUtility.parseDateForDB(params.dateField)
        Date start = DateUtility.getSqlFromDateWithSeconds(dateField)
        Date end = DateUtility.getSqlToDateWithSeconds(dateField)
        String hospital_code = params.hospitalCode
        List<GroovyRowResult> lst = serviceTokenRelatedInfoService.dateWiseDiagnosisDetails(start, end, hospital_code)

        Map result = new HashedMap()
        result.put('list', lst)
        result.put('count', lst.size())
        render result as JSON
    }

    def create() {
        renderOutput(createServiceTokenInfoActionService, params)
    }
    def delete() {
        renderOutput(deleteServiceTokenInfoActionService, params)
    }

    def list() {
        Date start = DateUtility.getSqlFromDateWithSeconds(new Date())
        Date end = DateUtility.getSqlToDateWithSeconds(new Date())

        String hospital_code = ""
        if (secUserService.isLoggedUserAdmin(springSecurityService.principal.id)) {
            hospital_code = SecUser.read(springSecurityService.principal.id)?.hospitalCode
        }
        List<GroovyRowResult> lst = serviceTokenRelatedInfoService.RegAndServiceDetails(start, end, hospital_code)

        Map result = new HashedMap()
        result.put('list', lst)
        result.put('count', lst.size())
        render result as JSON
    }

    def showServiceList() {
        render(view: "/counselorAction/serviceList")
    }

    def serviceList() {
        Date start = DateUtility.getSqlFromDateWithSeconds(new Date(2016 - 01 - 01))
        Date end = DateUtility.getSqlToDateWithSeconds(new Date())

        String hospital_code = ""
        if (secUserService.isLoggedUserAdmin(springSecurityService.principal.id)) {
            hospital_code = SecUser.read(springSecurityService.principal.id)?.hospitalCode
        }
        List<GroovyRowResult> lst = serviceTokenRelatedInfoService.RegAndServiceDetails(start, end, hospital_code)

        Map result = new HashedMap()
        result.put('list', lst)
        result.put('count', lst.size())
        render result as JSON
    }

    def diseaseListByGroup() {
        long diseaseGroupId = 0
        List<GroovyRowResult> lst

        lst = DiseaseInfo.findAllByIsActive(true)

        Map result = new HashedMap()
        result.put('list', lst)
        result.put('count', lst.size())
        render result as JSON
    }

    def serviceHeadInfoListByType() {
        long serviceTypeId = 0
        try {
            serviceTypeId = Long.parseLong(params.serviceTypeId)
        } catch (Exception ex) {
        }
        List<GroovyRowResult> lst = serviceHeadInfoService.serviceHeadInfoByType(serviceTypeId)

        Map result = new HashedMap()
        result.put('list', lst)
        result.put('count', lst.size())
        render result as JSON
    }

    def createServiceTokenNo() {
        String hospital_code = SecUser.read(springSecurityService.principal.id)?.hospitalCode
        Date start = DateUtility.getSqlFromDateWithSeconds(new Date())
        Date end = DateUtility.getSqlToDateWithSeconds(new Date())
        int c = ServiceTokenInfo.countByServiceDateBetween(start, end)
        c += 1
        String DATE_FORMAT = "ddMMyy";
        SimpleDateFormat sdf = new SimpleDateFormat(DATE_FORMAT);
        Calendar c1 = Calendar.getInstance(); // today
        String tokenNo = sdf.format(c1.getTime())
        String serviceNo = (c < 10 ? '00' : c < 100 ? '0' : '') + c.toString()
        tokenNo = 'S' + hospital_code + tokenNo + serviceNo
        // def result = [:]
        Map result = new HashedMap()
        result.put('tokenNo', tokenNo)

        render result as JSON
    }

    def retrieveServiceTokenNo() {
        String regNo = params.regNo.toString()
        String tokenNo = serviceTokenRelatedInfoService.findLastTokenNoByRegNoAndIsExit(regNo, false)
        List<GroovyRowResult> lst = serviceTokenRelatedInfoService.getTotalHealthServiceCharge(tokenNo)
        Map result = new HashedMap()
        result.put('serviceTokenNo', tokenNo)
        result.put('totalHealthCharge', lst[0].totalHealthCharge)
        result.put('serviceTypeId', lst[0].service_type_id)

        render result as JSON
    }

    def retrieveDataByTokenNo() {
        String tokenNo = params.tokenNo.toString()
        List<GroovyRowResult> lst = serviceTokenRelatedInfoService.getTotalHealthServiceCharge(tokenNo)
        Map result = new HashedMap()
        if (!lst[0].isExit) {
            result.put('regNo', lst[0].reg_no)
        } else {
            result.put('regNo', '')
        }
        result.put('totalHealthCharge', lst[0].totalHealthCharge)
        result.put('serviceTypeId', lst[0].service_type_id)

        render result as JSON
    }

    def retrieveTokenNoByRegNo() {
        String regNo = params.regNo.toString()
        Timestamp toDate = DateUtility.getSqlToDateWithSeconds(new Date())
        Calendar calNow = Calendar.getInstance()
        calNow.add(Calendar.MONTH, -3);
        Date dateBeforeAMonth = calNow.getTime();
        Timestamp fromDate = DateUtility.getSqlToDateWithSeconds(dateBeforeAMonth)
        // List<ServiceTokenInfo> lst = ServiceTokenInfo.findAllByRegNoAndServiceDateBetween(regNo, fromDate, toDate, [sort: "serviceDate", order: "DESC"])
        List<GroovyRowResult> lst = serviceTokenRelatedInfoService.getReferenceTokenForFollowup(regNo, fromDate, toDate)
        lst = baseService.listForKendoDropdown(lst, 'serviceTokenNo', null)
        Map result = [lstTokenNo: lst]
        render result as JSON
    }

    def getTotalServiceChargesByDiseaseCode() {
        long diseaseId = Long.parseLong(params.diseaseId)
        List<GroovyRowResult> lstOfCharges

        lstOfCharges = serviceChargesService.getTotalChargeByListOfDiseaseCode(diseaseId.toString())
        Map result = new HashedMap()
        result.put('totalCharge', lstOfCharges[0].chargeAmount)
        result.put('chargeIds', lstOfCharges[0].id)

        render result as JSON
    }

    def retrieveDiseaseOfReferenceTokenNo() {
        String tokenNo = params.tokenNo.toString()
        String diseaseInfo = serviceTokenRelatedInfoService.getDiseaseOfReferenceTokenNo(tokenNo)
        Map result = new HashedMap()

        result.put('diseaseInfo', diseaseInfo)

        render result as JSON
    }

    def serviceDetails() {
        String tokenNo = params.tokenNo.toString()
        List<GroovyRowResult> lst = serviceTokenRelatedInfoService.getTokenDetails(tokenNo)
        Map result = new HashedMap()
        result.put('details', lst[0])
        render result as JSON
    }
}
