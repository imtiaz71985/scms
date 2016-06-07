package actions.calendar

import com.model.ListCalendarActionServiceModal
import com.scms.Calendar
import grails.transaction.Transactional
import org.apache.log4j.Logger
import scms.ActionServiceIntf
import scms.BaseService

@Transactional
class UpdateCalenderActionService extends BaseService implements ActionServiceIntf {

    private static final String UPDATE_SUCCESS_MESSAGE = "Date has been updated successfully"
    private static final String CALENDAR_OBJ = "calendar"

    private Logger log = Logger.getLogger(getClass())

    public Map executePreCondition(Map params) {
        try {
            //Check parameters
            if (!params.id ) {
                return super.setError(params, INVALID_INPUT_MSG)
            }
            long id = Long.parseLong(params.id.toString())

            //Check existing of Obj and version matching
            Calendar oldCalendar = (Calendar) Calendar.read(id)

            Calendar calendar = buildObject(params, oldCalendar)
            params.put(CALENDAR_OBJ, calendar)
            return params
        } catch (Exception ex) {
            log.error(ex.getMessage())
            throw new RuntimeException(ex)
        }
    }

    @Transactional
    public Map execute(Map result) {
        try {
            Calendar calendar = (Calendar) result.get(CALENDAR_OBJ)
            calendar.save()
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
     * @param result - map received from execute method
     * @return - map with success message
     */
    public Map buildSuccessResultForUI(Map result) {
        Calendar calendar = (Calendar) result.get(CALENDAR_OBJ)
        ListCalendarActionServiceModal model = ListCalendarActionServiceModal.read(calendar.id)
        result.put(CALENDAR_OBJ, model)
        return super.setSuccess(result, UPDATE_SUCCESS_MESSAGE)
    }

    /**
     *
     * @param result - map received from previous method
     * @return - map
     */
    public Map buildFailureResultForUI(Map params) {
        return params
    }

    private static Calendar buildObject(Map parameterMap, Calendar oldCalendar) {
        Calendar calendar = new Calendar(parameterMap)
        oldCalendar.isHoliday = calendar.isHoliday
        oldCalendar.holidayStatus = calendar.holidayStatus
        return oldCalendar
    }
}
