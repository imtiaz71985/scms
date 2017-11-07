<div class="container-fluid">
    <div class="row">
        <div id="application_top_panel" class="panel panel-primary">
            <div class="panel-heading">
                <div class="panel-title">
                    Disease Group Wise Summary
                </div>
            </div>

            <g:form name='returnSummaryRptForm' id='returnSummaryRptForm' class="form-horizontal form-widgets" role="form">
                <div class="panel-body">
                    <div class="form-group">
                        <label class="col-md-1 control-label label-required" for="diseaseGroupId" style="padding-left: 0px; padding-right: 0px;">Disease Group:</label>
                        <div class="col-md-2">
                            <app:dropDownDiseaseGroup
                                    data_model_name="dropDownDiseaseGroup"
                                    id="diseaseGroupId" name="diseaseGroupId" tabindex="1"
                                    class="kendo-drop-down">
                            </app:dropDownDiseaseGroup>
                        </div>
                        <label class="col-md-1 control-label label-required" for="fromDateTxt"  style="padding-left: 0px; padding-right: 0px;">From Date:</label>

                        <div class="col-md-2"  style="padding-right: 0px;">
                            <input type='text' tabindex="2" required="required" onkeydown="return false;"
                                   class="kendo-date-picker" id="fromDateTxt" name="fromDateTxt"
                                   placeholder="dd/mm/yyyy" validationMessage="Required"/>
                            <span class="k-invalid-msg" data-for="fromDateTxt"></span>
                        </div>
                        <label class="col-md-1 control-label label-required" for="toDateTxt"  style="padding-left: 0px; padding-right: 0px;">To Date:</label>

                        <div class="col-md-2"  style="padding-right: 0px;">
                            <input type='text' tabindex="3" required="required" onkeydown="return false;"
                                   class="kendo-date-picker" id="toDateTxt" name="toDateTxt"
                                   placeholder="dd/mm/yyyy" validationMessage="Required"/>
                            <span class="k-invalid-msg" data-for="toDateTxt"></span>
                        </div>
                        <label class="col-md-1 control-label label-optional" style="padding-left: 0px; padding-right: 0px;" for="hospitalCode">Hospital:</label>

                        <div class="col-md-2"  style="padding-right: 0px;">
                            <app:dropDownHospital
                                    data_model_name="dropDownHospitalCode"
                                    tabindex="4"
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
                            role="button" tabindex="5"
                            aria-disabled="false"><span class="k-icon k-i-search"></span>View Result
                    </button>
                </div>
            </g:form>
        </div>
    </div>

    <div class="row">
        <div id="gridMedicineSellReturnRpt"></div>
    </div>
</div>