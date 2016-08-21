package scms

import actions.ServiceTokenInfo.CreateServiceTokenInfoActionService
import com.scms.DiseaseInfo
import com.scms.SecUser
import com.scms.ServiceTokenInfo
import grails.converters.JSON
import grails.plugin.springsecurity.SpringSecurityService
import groovy.sql.GroovyRowResult
import org.apache.commons.collections.map.HashedMap
import scms.utility.DateUtility
import scms.utility.Tools
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
    ServiceTokenRelatedInfoService serviceTokenRelatedInfoService
    ServiceHeadInfoService serviceHeadInfoService
    BaseService baseService

    def show() {

        render(view: "/counselorAction/show")
    }

    def create() {
        renderOutput(createServiceTokenInfoActionService, params)
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
        // renderOutput(listServiceTokenInfoActionService, params)
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
        List<ServiceTokenInfo> lst = ServiceTokenInfo.findAllByRegNoAndServiceDateBetween(regNo, fromDate, toDate, [sort: "serviceDate", order: "DESC"])
        lst = baseService.listForKendoDropdown(lst, 'serviceTokenNo', null)
        Map result = [lstTokenNo: lst]
        render result as JSON
    }

    def getTotalServiceChargesByDiseaseCode() {
        String diseaseCodes = params.diseaseCodes
        double totalCharge = 0
        String groupCode = ''
        List<GroovyRowResult> lstOfCharges

        if (diseaseCodes.length() > 0) {
            List<String> lst = Arrays.asList(diseaseCodes.split("\\s*,\\s*"));
            for (int i = 0; i < lst.size(); i++) {
                groupCode = groupCode + Long.parseLong(lst.get(i).substring(0, 2)).toString()
                if ((i + 1) < lst.size())
                    groupCode = groupCode + ','
            }
            Set set = new HashSet()
            List<String> lstGroupCode = Arrays.asList(groupCode.split("\\s*,\\s*"));
            set.addAll(lstGroupCode)

            String strIds =''
            for (int i = 0; i < set.size(); i++) {
                strIds = strIds + set[i]
                if ((i + 1) < set.size()) strIds = strIds + ','
            }
            lstOfCharges = serviceChargesService.getTotalChargeByListOfDiseaseCode(strIds)
        }
        String chargeIds=''
        for(int i=0;i<lstOfCharges.size();i++) {
            chargeIds = chargeIds + lstOfCharges[i].id
            if ((i + 1) < lstOfCharges.size()) chargeIds = chargeIds + ','
            totalCharge=totalCharge+ lstOfCharges[i].chargeAmount
        }
        Map result = new HashedMap()
        result.put('totalCharge', totalCharge)
        result.put('chargeIds', chargeIds)

        render result as JSON
    }
}
