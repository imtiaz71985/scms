<div class="container-fluid">
    <div class="row">
        <div id="application_top_panel" class="panel panel-primary">
            <div class="panel-heading">
                <div class="panel-title">
                    Monthly Summary
                </div>
            </div>

            <g:form name='detailsForm' id='detailsForm' class="form-horizontal form-widgets" role="form">
                <div class="panel-body">
                    <div class="form-group">
                        <label class="col-md-1 control-label label-optional" for="from">From:</label>

                        <div class="col-md-2">
                            <input type='text' tabindex="1" required="required" onkeydown="return false;"
                                   class="kendo-date-picker" id="from" name="from"
                                   placeholder="Month" validationMessage="Required"/>
                        </div>
                        <label class="col-md-1 control-label label-optional" for="to">To:</label>

                        <div class="col-md-2">
                            <input type='text' tabindex="1" required="required" onkeydown="return false;"
                                   class="kendo-date-picker" id="to" name="to"
                                   placeholder="Month" validationMessage="Required"/>
                        </div>
                        <label class="col-md-1 control-label label-optional" for="hospitalCode">Hospital:</label>

                        <div class="col-md-3">
                            <app:dropDownHospital
                                    data_model_name="dropDownHospitalCode"
                                    tabindex="2"
                                    class="kendo-drop-down"
                                    show_hints="true"
                                    hints_text="ALL"
                                    is_clinic="true"
                                    id="hospitalCode"
                                    name="hospitalCode">
                            </app:dropDownHospital>
                        </div>
                    </div>

                </div>

                <div class="panel-footer">
                    <button id="create" name="create" type="submit" data-role="button"
                            class="k-button k-button-icontext"
                            role="button" tabindex="3"
                            aria-disabled="false"><span class="k-icon k-i-search"></span>View Result
                    </button>
%{--                    <button id="download" name="download" type="button" data-role="button"
                            class="k-button k-button-icontext pull-right" role="button"
                            onclick="downloadMonthlyDetails()"
                            aria-disabled="false"><span class="fa fa-file-pdf-o"></span> &nbsp;Download
                    </button>--}%
                </div>
            </g:form>
        </div>
    </div>

    <div class="row">
        <div id="gridDetails"></div>
    </div>
</div>