package service

import com.scms.ServiceHeadInfo
import grails.transaction.Transactional
import groovy.sql.GroovyRowResult
import scms.BaseService

@Transactional
class ServiceHeadInfoService extends  BaseService {

    public int countByNameIlikeAndServiceTypeId(String name,String typeIdStr){
        long typeId = Long.parseLong(typeIdStr)
        int count = ServiceHeadInfo.countByNameIlikeAndServiceTypeId(name,typeId)
        return count
    }
    public long serviceChargeIdByServiceType(long typeId){
        String queryStr = """
            SELECT sc.id AS chargeId FROM service_head_info sh LEFT JOIN service_charges sc ON  sh.service_code=sc.service_code
                WHERE sh.service_type_id=${typeId} AND sh.is_active=TRUE AND sc.last_active_date IS NULL
        """
        List<GroovyRowResult> result = executeSelectSql(queryStr)
        long chargeId=(long)result[0].chargeId
        return chargeId
    }
}
