package service

import com.scms.SecRole
import com.scms.SecUser
import com.scms.SecUserSecRole
import groovy.sql.GroovyRowResult
import scms.BaseService

class SecUserService extends BaseService {

    public boolean isLoggedUserAdmin(long userId) {
        SecUser user = SecUser.read(userId)
        SecRole roleAdmin = SecRole.findByAuthority("ROLE_ADMIN")
        SecRole roleHOAdmin = SecRole.findByAuthority("ROLE_Clinic Administration HO")
        SecRole roleSup = SecRole.findByAuthority("ROLE_SUPERVISOR")
        int count = SecUserSecRole.countBySecRoleAndSecUser(roleAdmin, user)
        int count2 = SecUserSecRole.countBySecRoleAndSecUser(roleHOAdmin, user)
        int count3 = SecUserSecRole.countBySecRoleAndSecUser(roleSup, user)
        return count>0||count2 >0||count3 >0
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
