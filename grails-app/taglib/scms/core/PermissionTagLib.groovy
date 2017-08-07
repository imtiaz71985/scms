package scms.core

import com.scms.HospitalLocation
import com.scms.SecUser
import grails.plugin.springsecurity.SpringSecurityService

class PermissionTagLib {

    SpringSecurityService springSecurityService

    static namespace = "sec"

    def ifAnyUrls = { attrs, body ->
        List<String> urls = attrs.remove('urls').split(',')
        Boolean hasAccess = Boolean.FALSE
        for (int i = 0; i < urls.size(); i++) {
            hasAccess = sec.access(url: urls.get(i).trim()) { Boolean.TRUE }
            if (hasAccess) {
                out << body()
                break
            }
        }
    }

    def isInitialPassword = { attrs, body ->
        String password = SecUser.read(springSecurityService.principal.id).password
        if (password == 'a665a45920422f9d417e4867efdc4fb8a04a1f3fff1fa07e998e86f7f7a27ae3') {
            String message = '<div style="color:red">' +
                    '<h3><center>For security reason, it\'s essential to change your initial password.<br/>' +
                    'So click the link to change your password for further access of this application.<br/>' +
                    '<a href="#login/resetPassword">Change password</a></center></h3>' +
                    '</div>'
            return out << message
        } else {
            out << body()
        }
    }
    def hospitalName = { attrs ->
        String hospitalCode = SecUser.read(springSecurityService.principal.id)?.hospitalCode
        String hospitalName = HospitalLocation.findByCode(hospitalCode)?.name
        return out << hospitalName
    }


    def userName = { attrs ->
        String employeeName = SecUser.read(springSecurityService.principal.id)?.employeeName
        out << employeeName
    }
}
