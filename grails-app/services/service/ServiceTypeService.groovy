package service

import com.scms.ServiceType
import grails.transaction.Transactional

@Transactional
class ServiceTypeService {

    public ServiceType read(long id){
        return ServiceType.read(id)
    }

    public int countByNameIlike(String name){
        int count = ServiceType.countByNameIlike(name)
        return count
    }

    public int countByNameIlikeAndIdNotEqual(String name,long id){
        int count = ServiceType.countByNameIlikeAndIdNotEqual(name, id)
        return count
    }
}
