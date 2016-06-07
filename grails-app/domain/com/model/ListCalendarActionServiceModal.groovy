package com.model

class ListCalendarActionServiceModal {

    public static final String MODEL_NAME = 'list_calendar_action_service_modal'
    public static final String SQL_LIST_CALENDAR_MODEL = """
              CREATE OR REPLACE VIEW list_calendar_action_service_modal AS
                     SELECT id, version, date_field, holiday_status, is_holiday
                     FROM calendar;
    """

    long id
    long version
    Date dateField
    String holidayStatus
    Boolean isHoliday
}
