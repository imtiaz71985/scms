package actions.calendar

import grails.transaction.Transactional
import com.scms.Calendar
import org.apache.log4j.Logger
import scms.ActionServiceIntf
import scms.BaseService
import scms.utility.DateUtility

@Transactional
class CreateNewYearRecordsActionService extends BaseService implements ActionServiceIntf {

    private static final String SAVE_SUCCESS_MESSAGE = "New records has been saved successfully"
    private static final String RECORDS_ALREADY_EXIST = "This year records already exist"
    private static final String FROM_DATE = "fromDate"
    private static final String TO_DATE = "toDate"

    private Logger log = Logger.getLogger(getClass())


    @Transactional(readOnly = true)
    public Map executePreCondition(Map params) {
        try {
            if (!params.calYearModal) {
                return super.setError(params, INVALID_INPUT_MSG)
            }
            int dateInt = Integer.parseInt(params.calYearModal.toString())
            java.util.Calendar cal = java.util.Calendar.getInstance();
            cal.set(java.util.Calendar.YEAR, dateInt);
            cal.set(java.util.Calendar.DAY_OF_YEAR, 1);
            Date start = cal.getTime();

            cal.set(java.util.Calendar.YEAR, dateInt);
            cal.set(java.util.Calendar.MONTH, 11);
            cal.set(java.util.Calendar.DAY_OF_MONTH, 31);

            Date end = cal.getTime();

            Date fromDate = DateUtility.getSqlFromDateWithSeconds(start)
            Date toDate = DateUtility.getSqlToDateWithSeconds(end)

            int calendar = Calendar.countByDateFieldBetween(fromDate, toDate)
            if(calendar > 0) return super.setError(params, RECORDS_ALREADY_EXIST)

            params.put(FROM_DATE, fromDate)
            params.put(TO_DATE, toDate)
            return params
        } catch (Exception ex) {
            log.error(ex.getMessage())
            throw new RuntimeException(ex)
        }
    }

    @Transactional
    public Map execute(Map result) {
        try {
            Date fromDate = (Date) result.get(FROM_DATE)
            Date toDate = (Date) result.get(TO_DATE)

            boolean actionResult = fillFullYearDates(fromDate, toDate)
            return result
        } catch (Exception ex) {
            log.error(ex.getMessage())
            throw new RuntimeException(ex)
        }
    }
    /**
     *
     * @param result - map received from execute method
     * @return - map
     */
    public Map executePostCondition(Map result) {
        return result
    }
    /**
     *
     * @param result - map received from executePost method
     * @return - map containing success message
     */
    public Map buildSuccessResultForUI(Map result) {
        return super.setSuccess(result, SAVE_SUCCESS_MESSAGE)
    }
    /**
     *
     * @param result - map received from previous method
     * @return - map
     */
    public Map buildFailureResultForUI(Map result) {
        return result
    }

    private boolean fillFullYearDates(Date start,Date end) {

        String queryStr = """
           CALL fill_calendar(:start, :end);
        """

        Map queryParams = [
                start                : start,
                end                  : end,
                holiday_status       : 'Weekly Holiday',
                is_holiday           : Boolean.TRUE
        ]
        boolean actionResult = executeSql(queryStr, queryParams)

        String updateWeekDay = """
        UPDATE calendar SET holiday_status = :holiday_status, is_holiday = :is_holiday, version=0
        WHERE WEEKDAY(date_field) in (4)
        AND date_field between :start and :end
        """
        boolean actionResult2 = executeSql(updateWeekDay, queryParams)

        return actionResult
    }
}
