package service

import com.scms.SecRole
import com.scms.SecUser
import com.scms.SecUserSecRole
import grails.transaction.Transactional
import scms.BaseService

@Transactional
class SecUserSecRoleService extends BaseService{

    public SecUserSecRole read(long id) {
        return SecUserSecRole.read(id)
    }

    public SecUserSecRole findBySecRoleAndSecUser(SecUser user, SecRole role) {
        return SecUserSecRole.findBySecRoleAndSecUser(role, user)
    }
}
