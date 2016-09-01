<div class="container-fluid">
    <div class="row">
        <div id="application_top_panel" class="panel panel-primary">
            <div class="panel-heading">
                <div class="panel-title">
                    Official Calendar
                </div>
            </div>

            <g:form name='calendarForm' id='calendarForm' class="form-horizontal form-widgets" role="form">
                <div class="panel-body">
                    <input type="hidden" name="id" id="id" data-bind="value: calendar.id"/>
                    <input type="hidden" name="version" id="version" data-bind="value: calendar.version"/>

                    <div class="form-group">
                        <div class="col-md-6">
                            <div class="form-group">
                                <label class="col-md-2 control-label label-optional" for="dateField">Date:</label>

                                <div class="col-md-6">
                                    <app:dateControl class="form-control" name="dateField" tabindex="1" placeholder="Date"
                                          disabled="true" data-bind="value: calendar.dateField"/>
                                </div>
                                <label class="col-md-2 control-label label-optional"
                                       for="isHoliday">Holiday:</label>

                                <div class="col-md-1">
                                    <g:checkBox class="form-control-static" name="isHoliday" tabindex="2"
                                                data-bind="checked: calendar.isHoliday"/>
                                </div>
                            </div>
                        </div>
                        <div class="col-md-6">
                            <div class="form-group">
                                <label class="col-md-2 control-label label-optional" for="holidayStatus">Status:</label>

                                <div class="col-md-6">
                                    <input type="text" class="form-control" id="holidayStatus" name="holidayStatus"
                                           placeholder="Official Day Status"
                                           tabindex="3" data-bind="value: calendar.holidayStatus"/>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>

                <div class="panel-footer">
                    <button id="create" name="create" type="submit" data-role="button"
                            class="k-button k-button-icontext"
                            role="button" tabindex="4"
                            aria-disabled="false"><span class="k-icon k-i-plus"></span>Update
                    </button>&nbsp;&nbsp;&nbsp;

                    <button id="clearFormButton" name="clearFormButton" type="button" data-role="button"
                            class="k-button k-button-icontext" role="button" tabindex="5"
                            aria-disabled="false" onclick='resetForm();'><span
                            class="k-icon k-i-close"></span>Cancel
                    </button>
                    <div class="col-md-2 pull-right">
                        <input type="text"
                           id="calenderYear"
                           name="calenderYear">
                    </div>
                </div>
            </g:form>
        </div>
    </div>

    <div class="row">
        <div id="gridCalendar"></div>
    </div>
</div>