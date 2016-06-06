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
            String fromDate = DateUtility.getDBDateFormatAsString(c.getTime())
            String toDate = DateUtility.getDBDateFormatAsString(new Date())

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
                    SELECT id, version,sell_date, SUM(total_amount) AS total_amount
                        FROM medicine_sell_info
                            WHERE sell_date BETWEEN :fromDate AND :toDate
                        GROUP BY sell_date
                    LIMIT :resultPerPage OFFSET :start;
        """

        String queryCount = """
                    SELECT COUNT(tmp.sell_date) AS count
                    FROM (SELECT sell_date FROM medicine_sell_info
                        WHERE sell_date BETWEEN :fromDate AND :toDate
                        GROUP BY sell_date) tmp
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
