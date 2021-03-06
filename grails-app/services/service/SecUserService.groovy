package service

import com.scms.SecRole
import com.scms.SecUser
import com.scms.SecUserSecRole
import grails.plugin.springsecurity.SpringSecurityService
import groovy.sql.GroovyRowResult
import scms.BaseService

class SecUserService extends BaseService {

    SpringSecurityService springSecurityService

    public boolean isLoggedUserAdmin(long userId) {
        SecUser user = SecUser.read(userId)
        List<SecRole> roleAdmin = SecRole.findAllByAuthorityOrAuthorityOrAuthority("ROLE_SCMS_ADMIN", "ROLE_SCMS_REPORT_VIEWER", "ROLE_SCMS_HO_ADMIN")
        //SecRole roleHOSup = SecRole.findByAuthorityOrAuthority("ROLE_REPORT_VIEWER","ROLE_HO_ADMIN")
        int count =0
        for (SecRole secRole : roleAdmin) {

            count = SecUserSecRole.countBySecRoleAndSecUser(secRole, user)
            if(count>0)
                break;
        }
       // int count2 = SecUserSecRole.countBySecRoleAndSecUser(roleHOSup, user)
        //return count>0||count2 >0
        return count>0
    }

    public String retrieveHospitalCode(){
        return SecUser.read(springSecurityService.principal.id)?.hospitalCode
    }

    public SecUser read(long id) {
       return SecUser.read(id)
    }

    public int countByUsernameIlike(String username){
        return SecUser.countByUsernameIlike(username)
    }

    public int countByUsernameIlikeAndIdNotEqual(String username, long id){
        return SecUser.countByUsernameIlikeAndIdNotEqual(username, id)
    }

    public List<GroovyRowResult> getGeneralUsers() {
        String queryStr = """
            SELECT u.* FROM sec_user u
            WHERE u.enabled = true
            AND id !=1
        """
        List<GroovyRowResult> result = executeSelectSql(queryStr)
        return result
    }
}
