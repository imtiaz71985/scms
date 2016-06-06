package service

import com.scms.SecUser
import groovy.sql.GroovyRowResult
import scms.BaseService

class SecUserService extends BaseService {

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
