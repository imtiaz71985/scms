package service

import com.scms.SecUser
import com.scms.SystemEntity
import grails.transaction.Transactional
import groovy.sql.GroovyRowResult
import scms.BaseService
import scms.utility.DateUtility

@Transactional
class SystemEntityService extends BaseService {

    public SystemEntity read(long id){
        return SystemEntity.read(id)
    }

    public int countByNameIlikeAndType(String name,String type){
        int count = SystemEntity.countByNameIlikeAndType(name,type)
        return count
    }

    public int countByNameIlikeAndTypeAndIdNotEqual(String name,String type,long id){
        int count = SystemEntity.countByNameIlikeAndTypeAndIdNotEqual(name,type, id)
        return count
    }
}
