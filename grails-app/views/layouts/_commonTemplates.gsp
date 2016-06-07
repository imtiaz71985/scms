<style type="text/css">
.k-notification-error.k-group {
    opacity: 0.92 !important;
}

.notification {
    padding: 14px 14px 14px 4px;
    width: 260px;
    display: table;
}

.notf-icon {
    vertical-align: middle;
}

.notf-message {
    display: table-cell;
    padding-left: 5px;
}
</style>
<script id="tmplKendoSuccess" type="text/x-kendo-template">
<div class="alert-success notification">
    <i class="glyphicon glyphicon-ok-circle fa-2x notf-icon"></i>
    <span class="notf-message">#= message #</span>
</div>
</script>
<script id="tmplKendoError" type="text/x-kendo-template">
<div class="alert-danger notification">
    <i class="glyphicon glyphicon-remove-circle fa-2x notf-icon"></i>
    <span class="notf-message">#= message #</span>
</div>
</script>
<script id="tmplKendoInfo" type="text/x-kendo-template">
<div class="alert-info notification">
    <i class="glyphicon glyphicon-exclamation-sign fa-2x notf-icon"></i>
    <span class="notf-message">#= message #</span>
</div>
</script>


<!-- Create New Year Calendar Modal -->
<div class="modal fade" id="createCalendarModal" tabindex="-1" role="dialog" aria-labelledby="createCalendarModalLabel">
    <div class="modal-dialog" role="document">
        <div class="modal-content">
            <div class="modal-header">
                <button type="button" class="close" data-dismiss="modal" aria-label="Close"
                        onclick="hideCalendarModal();"><span
                        aria-hidden="true">&times;</span></button>
                <h4 class="modal-title" id="createCalendarModalLabel">Are you sure you want to create New Calendar Year ?</h4>
            </div>

            <div class="modal-body">
                <form class="form-horizontal form-widgets" id="createCalendarForm" name="createCalendarForm">
                    <div class="form-group">
                        <label class="col-md-2 control-label label-required" for="calYearModal">Year:</label>

                        <div class="col-md-4">
                            <input type="text"
                                   id="calYearModal"
                                   name="calYearModal"
                                   required=""
                                   validationMessage="Required"
                                   tabindex="1"
                                   placeholder="Calendar Year"
                                   class="form-control">
                        </div>

                        <div class="col-md-3 pull-left">
                            <span class="k-invalid-msg" data-for="calYearModal"></span>
                        </div>
                    </div>
                </form>
            </div>

            <div class="modal-footer">
                <input class="btn btn-primary" type="button" value="Create" onclick="onClickCalendarModal();"
                       tabindex="2">
                <input class="btn btn-default" type="button" value="Close" onclick="hideCalendarModal();"
                       data-dismiss="modal" tabindex="3">
            </div>
        </div>
    </div>
</div>





