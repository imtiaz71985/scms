package service

import com.scms.SystemEntity
import grails.transaction.Transactional

@Transactional
class SystemEntityService {

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
