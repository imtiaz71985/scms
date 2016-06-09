package actions.medicineSellInfo

import grails.transaction.Transactional
import groovy.sql.GroovyRowResult
import org.apache.log4j.Logger
import org.codehaus.groovy.grails.web.servlet.mvc.GrailsParameterMap
import scms.ActionServiceIntf
import scms.BaseService
import scms.utility.DateUtility

import java.text.DateFormat
import java.text.SimpleDateFormat

@Transactional
class ListMonthWiseMedicineSellInfoActionService extends BaseService implements ActionServiceIntf {

    private Logger log = Logger.getLogger(getClass())

    public Map executePreCondition(Map params) {
        return params
    }

    @Transactional(readOnly = true)
    public Map execute(Map result) {
        try {
            String dateStr = result.month.toString()
            Calendar c = Calendar.getInstance();
            DateFormat originalFormat = new SimpleDateFormat("MMMM yyyy", Locale.ENGLISH);
            Date date = originalFormat.parse(dateStr);
            c.setTime(date);
            Calendar ce = Calendar.getInstance();
            ce.setTime(date);
            ce.set(Calendar.DAY_OF_MONTH, c.getActualMaximum(Calendar.DAY_OF_MONTH));

            String fromDate = DateUtility.getDBDateFormatAsString(c.getTime())
            String toDate = DateUtility.getDBDateFormatAsString(ce.getTime())

            GrailsParameterMap parameterMap = (GrailsParameterMap) result
            initListing(parameterMap)

            LinkedHashMap resultMap = getMonthlyStatus(fromDate, toDate)
            List<GroovyRowResult> lst = resultMap.rowResults
            result.put(LIST, lst)
            result.put(COUNT, resultMap.count)
            return result
        } catch (Exception e) {
            log.error(e.getMessage())
            throw new RuntimeException(e)
        }
    }

    private  LinkedHashMap getMonthlyStatus(String fromDate, String toDate) {

        String queryStr = """
            SELECT c.id, c.version,c.date_field,c.is_holiday,c.holiday_status, COALESCE((SELECT SUM(msi.total_amount) FROM
            medicine_sell_info msi WHERE msi.sell_date = c.date_field GROUP BY msi.sell_date ),0) AS medicine_sales,
                COALESCE(SUM(sc.charge_amount),0) AS registration_amount,
                        COALESCE((SELECT SUM(sc4.charge_amount) FROM registration_reissue rr
                        LEFT JOIN service_charges sc4 ON sc4.id = rr.service_charge_id
                        WHERE DATE_FORMAT(rr.create_date,'%Y-%m-%d') = c.date_field
                        GROUP BY DATE_FORMAT(rr.create_date,'%Y-%m-%d')),0) AS re_registration_amount,

                COALESCE((SELECT SUM(sc2.charge_amount) FROM token_and_charge_mapping tcm2
                LEFT JOIN service_charges sc2 ON sc2.id = tcm2.service_charge_id AND SUBSTRING(sc2.service_code, 1,2) = '02'
                WHERE DATE_FORMAT(tcm2.create_date,'%Y-%m-%d') = c.date_field
                GROUP BY DATE_FORMAT(tcm2.create_date,'%Y-%m-%d')),0) AS consultation_amount,

                COALESCE((SELECT SUM(sti.subsidy_amount)
                FROM service_token_info sti
                        WHERE DATE_FORMAT(sti.service_date,'%Y-%m-%d') = c.date_field
                        GROUP BY DATE_FORMAT(sti.service_date,'%Y-%m-%d')),0) AS subsidy_amount,
                COALESCE((SELECT SUM(sc3.charge_amount)
                         FROM token_and_charge_mapping tcm3
                        LEFT JOIN service_charges sc3 ON sc3.id = tcm3.service_charge_id AND SUBSTRING(sc3.service_code, 1,2) = '03'
                        WHERE DATE_FORMAT(tcm3.create_date,'%Y-%m-%d') = c.date_field
                        GROUP BY DATE_FORMAT(tcm3.create_date,'%Y-%m-%d')),0) AS pathology_amount

                FROM calendar c
                LEFT JOIN registration_info ri ON ri.create_date = c.date_field
                LEFT JOIN service_charges sc ON sc.id = ri.service_charge_id
            WHERE c.date_field BETWEEN :fromDate AND :toDate
            GROUP BY c.date_field
            LIMIT :resultPerPage OFFSET :start;
        """

        String queryCount = """
            SELECT COUNT(c.id) AS count
                FROM calendar c
            WHERE c.date_field BETWEEN :fromDate AND :toDate
        """

        Map queryParams = [
                fromDate      : fromDate,
                toDate        : toDate,
                resultPerPage : resultPerPage,
                start         : start
        ]

        List<GroovyRowResult> rowResults = executeSelectSql(queryStr, queryParams)
        List countResults = executeSelectSql(queryCount, queryParams)
        int count = countResults[0].count
        return [rowResults: rowResults, count: count]
    }
    /**
     * There is no postCondition, so return the same map as received
     *
     * @param result - resulting map from execute
     * @return - same map of input-parameter containing isError(true/false)
     */
    public Map executePostCondition(Map result) {
        return result
    }

    /**
     * Since there is no success message return the same map
     * @param result -map from execute/executePost method
     * @return - same map of input-parameter containing isError(true/false)
     */
    public Map buildSuccessResultForUI(Map result) {
        return result
    }

    /**
     * The input-parameter Map must have "isError:true" with corresponding message
     * @param result -map returned from previous methods
     * @return - same map of input-parameter containing isError(true/false)
     */
    public Map buildFailureResultForUI(Map result) {
        return result
    }
}
