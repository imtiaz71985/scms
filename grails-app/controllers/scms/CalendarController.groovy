package scms

import actions.calendar.CreateCalenderActionService
import actions.calendar.CreateNewYearRecordsActionService
import actions.calendar.ListCalenderActionService
import actions.calendar.UpdateCalenderActionService

class CalendarController  extends BaseController {

    CreateCalenderActionService createCalenderActionService
    CreateNewYearRecordsActionService createNewYearRecordsActionService
    UpdateCalenderActionService updateCalenderActionService
    ListCalenderActionService listCalenderActionService

    def show() {
        render(view: "/calendar/show")
    }

    def create() {
        renderOutput(createCalenderActionService, params)
    }
    def update() {
        renderOutput(updateCalenderActionService, params)
    }
    def list() {
        renderOutput(listCalenderActionService, params)
    }
    def newYearRecords() {
        renderOutput(createNewYearRecordsActionService, params)
    }
}
