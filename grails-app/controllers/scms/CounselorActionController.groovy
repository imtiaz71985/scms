package scms

import actions.ServiceTokenInfo.CreateServiceTokenInfoActionService
import actions.ServiceTokenInfo.DeleteServiceTokenInfoActionService
import com.scms.SecUser
import com.scms.ServiceChargeFreeDays
import com.scms.ServiceTokenInfo
import grails.converters.JSON
import grails.plugin.springsecurity.SpringSecurityService
import groovy.sql.GroovyRowResult
import org.apache.commons.collections.map.HashedMap
import scms.utility.DateUtility
import service.*

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
        String msg = registrationInfoService.patientServed(new Date())
        render(view: "/counselorAction/show", model: [patientServed:msg])
    }
    def showConsultancy() {
        render(view: "/counselorAction/showConsultancy", model: [hospitalCode:params.hospitalCode,dateField:params.dateField])
    }
    def showSubsidy() {
        render(view: "/counselorAction/showSubsidy", model: [hospitalCode:params.hospitalCode,dateField:params.dateField])
    }
    def showDiagnosis() {
        render(view: "/counselorAction/showDiagnosis", model: [hospitalCode:params.hospitalCode,dateField:params.dateField,pathologyCount:params.serviceCount])
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
        List<GroovyRowResult> listAll = serviceTokenRelatedInfoService.dateWiseDiagnosisDetails(start, end, hospital_code)

        int count = serviceTokenRelatedInfoService.countUniqueDateWiseDiagnosis(start, end, hospital_code)
        Map result = new HashedMap()
        result.put('list', listAll)
        result.put('count', count)

        render result as JSON
    }

    def create() {
        renderOutput(createServiceTokenInfoActionService, params)
    }
    def delete() {
        renderOutput(deleteServiceTokenInfoActionService, params)
    }

    def list() {
        Date createDate =new Date()
        if(params.createDate){
            createDate = DateUtility.parseDateForDB(params.createDate)
        }
        Date start = DateUtility.getSqlFromDateWithSeconds(createDate)
        Date end = DateUtility.getSqlToDateWithSeconds(createDate)

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
        long diseaseGroupId =0
        try {
            diseaseGroupId = Long.parseLong(params.diseaseGroupId)
        }catch (ex){}
        List<GroovyRowResult> lst

       // lst = DiseaseInfo.findAllByIsActiveAndDiseaseGroupId(true,diseaseGroupId)
        lst=serviceTokenRelatedInfoService.getDiseaseByGroupIdForDDL(diseaseGroupId)
      lst= baseService.listForKendoDropdown(lst, null, null)
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
        Date createDate = DateUtility.parseDateForDB(params.createDate)
        Date start = DateUtility.getSqlFromDateWithSeconds(createDate)
        Date end = DateUtility.getSqlToDateWithSeconds(createDate)
        int c = ServiceTokenInfo.countByServiceDateBetween(start, end)
        c += 1
        String DATE_FORMAT = "ddMMyy";
        SimpleDateFormat sdf = new SimpleDateFormat(DATE_FORMAT);
        String tokenNo = sdf.format(createDate)
        String serviceNo = (c < 10 ? '00' : c < 100 ? '0' : '') + c.toString()
        tokenNo = 'S' + hospital_code + tokenNo + serviceNo
        // def result = [:]
        Map result = new HashedMap()
        result.put('tokenNo', tokenNo)

        render result as JSON
    }
    def retrieveServiceTokenNo() {
        String regNo = params.regNo.toString()
        String tokenNo = serviceTokenRelatedInfoService.findLastTokenNoByRegNo(regNo)
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
            result.put('regNo', lst[0].reg_no)

        result.put('totalHealthCharge', lst[0].totalHealthCharge)
        result.put('serviceTypeId', lst[0].service_type_id)

        render result as JSON
    }
    def retrieveTokenNoByRegNo() {
        String regNo = params.regNo.toString()
        Date serviceDate=DateUtility.getSqlDate(new Date())
        try {
            if (params.serviceDate) {
                Date d = DateUtility.parseDateForDB(params.serviceDate)
                serviceDate = DateUtility.getSqlToDateWithSeconds(d)
            }
        }catch(ex){}
        List<ServiceTokenInfo> lst = ServiceTokenInfo.findAllByRegNoAndIsDeletedAndIsFollowupNeededAndServiceDateLessThan(regNo, false,true,serviceDate, [sort: "serviceDate", order: "DESC"])

        lst = baseService.listForKendoDropdown(lst, 'serviceTokenNo', null)
        Map result = [lstTokenNo: lst]
        render result as JSON
    }
    def getTotalServiceChargesByGroupId() {
        long diseaseId = Long.parseLong(params.groupId)
        List<GroovyRowResult> lstOfCharges
        Date serviceDate=DateUtility.getSqlDate(new Date())
        try {
            if (params.serviceDate) {
                Date d = DateUtility.parseDateForDB(params.serviceDate)
                serviceDate = DateUtility.getSqlDate(d)
            }
        }catch(ex){}
        lstOfCharges = serviceChargesService.getTotalChargeByListOfDiseaseGroupId(serviceDate, diseaseId.toString())
        Map result = new HashedMap()
        if(lstOfCharges.size()>0) {
        result.put('totalCharge', lstOfCharges[0].chargeAmount)
        result.put('chargeIds', lstOfCharges[0].id)
        }
        else{
            result.put('totalCharge', 0)
            result.put('chargeIds', '')
        }

        render result as JSON
    }
    def getTotalServiceChargesByDiseaseCode() {

        List<GroovyRowResult> lstOfCharges
        Date serviceDate=DateUtility.getSqlDate(new Date())
        try {
            if (params.serviceDate) {
                Date d = DateUtility.parseDateForDB(params.serviceDate)
                serviceDate = DateUtility.getSqlDate(d)
            }
        }catch(ex){}
        lstOfCharges = serviceChargesService.getTotalChargeByDiseaseCode(serviceDate, params.diseaseCode)
        Map result = new HashedMap()

            result.put('totalCharge', lstOfCharges[0].chargeAmount)
            result.put('chargeIds', lstOfCharges[0].id)


        render result as JSON
    }
    def retrieveDiseaseOfReferenceTokenNo() {
        String tokenNo = params.tokenNo.toString()
        List<GroovyRowResult> lstDiseaseInfo = serviceTokenRelatedInfoService.getDiseaseOfReferenceTokenNo(tokenNo)
        Date serveDate=ServiceTokenInfo.findByServiceTokenNo(tokenNo).serviceDate
        Date fromDate=DateUtility.getSqlDate(serveDate)
        boolean isChargeApply=true
        boolean isUndiagnosed=false

            long d = DateUtility.getDaysDifference(fromDate, new Date())
            long days = ServiceChargeFreeDays.findByServiceTypeId(5).daysForFree
            if (d <= days) {
                isChargeApply = false
                if(lstDiseaseInfo[0].groupId==13) {
                    isUndiagnosed = true
                }
            }

        Map result = new HashedMap()

        result.put('lstDiseaseInfo', lstDiseaseInfo)
        result.put('isChargeApply',isChargeApply)
        result.put('isUndiagnosed',isUndiagnosed)

        render result as JSON
    }
    def serviceDetails() {
        String tokenNo = params.tokenNo.toString()
        List<GroovyRowResult> lst = serviceTokenRelatedInfoService.getTokenDetails(tokenNo)
        Map result = new HashedMap()
        result.put('details', lst[0])
        render result as JSON
    }
    def retrieveRegNoByDate() {
        Date createDate = DateUtility.parseDateForDB(params.createDate)
       String  hospitalCode= SecUser.read(springSecurityService.principal.id)?.hospitalCode
        Date fromDate=DateUtility.getSqlFromDateWithSeconds(createDate)
        Date toDate=DateUtility.getSqlToDateWithSeconds(createDate)
        List<GroovyRowResult> lstRegNo = registrationInfoService.listOfRegNoByDate(hospitalCode,fromDate,toDate)
        lstRegNo = baseService.listForKendoDropdown(lstRegNo, null, null)
        Map result = [lstRegNo: lstRegNo]
        render result as JSON
    }

}
