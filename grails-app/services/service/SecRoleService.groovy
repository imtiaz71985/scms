package service

import com.scms.SecRole
import grails.transaction.Transactional
import scms.BaseService

@Transactional
class SecRoleService extends BaseService {

    public SecRole read(long id) {
        return SecRole.read(id)
    }

    public int countByNameIlike(String name){
        return SecRole.countByNameIlike(name)
    }
    public int countByNameIlikeAndIdNotEqual(String name, long id){
        return SecRole.countByNameIlikeAndIdNotEqual(name, id)
    }
    public int countByAuthorityLike(String authority){
        return SecRole.countByAuthorityLike(authority)
    }

    public int countByAuthorityLikeAndIdNotEqual(String authority, long id){
        return SecRole.countByAuthorityLikeAndIdNotEqual(authority, id)
    }
}
