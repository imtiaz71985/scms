package scms

import actions.registrationInfo.CreateRegistrationInfoActionService
import actions.registrationInfo.DeleteRegistrationInfoActionService
import actions.registrationInfo.ListRegistrationInfoActionService
import actions.registrationInfo.ReIssueRegistrationNoActionService
import actions.registrationInfo.UpdateRegistrationInfoActionService
import com.scms.RegistrationInfo
import com.scms.SecUser
import com.scms.StUnion
import com.scms.Upazila
import com.scms.Village
import grails.converters.JSON
import grails.plugin.springsecurity.SpringSecurityService
import groovy.sql.GroovyRowResult
import org.apache.commons.collections.map.HashedMap

import java.text.SimpleDateFormat

class RegistrationInfoController extends BaseController {
    SpringSecurityService springSecurityService
    BaseService baseService
    static allowedMethods = [
            show: "POST", create: "POST", update: "POST",delete: "POST", list: "POST"
    ]

    CreateRegistrationInfoActionService createRegistrationInfoActionService
    UpdateRegistrationInfoActionService updateRegistrationInfoActionService
    DeleteRegistrationInfoActionService deleteRegistrationInfoActionService
    ListRegistrationInfoActionService listRegistrationInfoActionService
    ReIssueRegistrationNoActionService reIssueRegistrationNoActionService

    def show() {
        List<Village> lstVillage = Village.list([sort: "name",order: "ASC"])
        lstVillage = baseService.listForKendoDropdown(lstVillage, null, null)
        render(view: "/registrationInfo/show", model:[lstVillage: lstVillage as JSON])
    }
    def create() {
        renderOutput(createRegistrationInfoActionService, params)

    }
    def update() {
        renderOutput(updateRegistrationInfoActionService, params)

    }
    def delete() {
        renderOutput(deleteRegistrationInfoActionService, params)

    }
    def reIssue() {
        renderOutput(reIssueRegistrationNoActionService, params)

    }
    def list() {
        renderOutput(listRegistrationInfoActionService, params)
    }
    def retrieveRegNo() {
        String hospital_code= SecUser.read(springSecurityService.principal.id)?.hospitalCode
        int c=RegistrationInfo.countByCreateDateAndHospitalCode(new Date(),hospital_code)
        c+=1
        String DATE_FORMAT = "ddMMyy";
        SimpleDateFormat sdf = new SimpleDateFormat(DATE_FORMAT);
        Calendar c1 = Calendar.getInstance(); // today
        String regNo=sdf.format(c1.getTime())
        String patientNo= (c<10? '00' : c<100? '0' : '')+c.toString()
        regNo=hospital_code+regNo+patientNo
        Map result=new HashedMap()
        result.put('regNo', regNo)
        render result as JSON
    }
    def upazilaListByDistrictId() {
        long districtId = Long.parseLong(params.districtId.toString())
        List<Upazila> lstUpazila = Upazila.findAllByDistrictId(districtId, [sort: "name",order: "ASC"])
        lstUpazila = baseService.listForKendoDropdown(lstUpazila, null, null)
        Map result = [lstUpazila: lstUpazila]
        render result as JSON
    }
    def unionListByUpazilaId() {
        long upazilaId = Long.parseLong(params.upazilaId.toString())
        List<StUnion> lstUnion = StUnion.findAllByUpazilaId(upazilaId, [sort: "name",order: "ASC"])
        lstUnion = baseService.listForKendoDropdown(lstUnion, null, null)
        Map result = [lstUnion: lstUnion]
        render result as JSON
    }
    def addressByVillage() {
        long villageId = Long.parseLong(params.villageId.toString())
        LinkedHashMap resultMap = getAddressDetails(villageId)

        Map result = [address: resultMap.address]
        render result as JSON
    }
    private Map getAddressDetails(long villageId) {

        String queryStr = """
            SELECT CONCAT('Vill:',COALESCE(v.name,''),', Union:',COALESCE(u.name,''),', Upazila:',COALESCE(up.name,''),', Dist:',COALESCE(d.name,'')) AS address
              FROM village v
              LEFT JOIN st_union u ON v.union_id=u.id
                      LEFT JOIN upazila up ON u.upazila_id=up.id
                      LEFT JOIN district d ON up.district_id=d.id
                      WHERE v.id=${villageId};
        """

        List<GroovyRowResult> rowResults = baseService.executeSelectSql(queryStr)
        return [address: rowResults[0].address]
    }
}
