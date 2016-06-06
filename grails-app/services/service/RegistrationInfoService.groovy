package service

import com.scms.RegistrationInfo
import grails.transaction.Transactional

@Transactional
class RegistrationInfoService {
    public RegistrationInfo read(String regNo){
        return RegistrationInfo.read(regNo)
    }
    def serviceMethod() {

    }
}
