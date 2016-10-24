<div class="container-fluid">
    <div class="row" id="serviceChargeFreeDaysRow">
        <div id="application_top_panel" class="panel panel-primary">
            <div class="panel-heading">
                <div class="panel-title">
                    Service Charge Free Days Setup
                </div>
            </div>

            <g:form name='serviceChargeFreeDaysForm' id='serviceChargeFreeDaysForm' class="form-horizontal form-widgets" role="form">
                <div class="panel-body">
                    <input type="hidden" name="id" id="id" data-bind="value: serviceChargeFreeDays.id"/>
                    <input type="hidden" name="version" id="version" data-bind="value: serviceChargeFreeDays.version"/>

                    <div class="form-group">
                        <div class="col-md-7">
                            <div class="form-group">
                                <label class="col-md-2 control-label label-required" for="serviceTypeId">Service Type:</label>

                                <div class="col-md-6">
                                    <app:dropDownServiceType
                                            data_model_name="dropDownServiceType"
                                            type="all"
                                            id="serviceTypeId" name="serviceTypeId" tabindex="1"
                                            class="kendo-drop-down" onchange="javascript: getServiceCode();"
                                            data-bind="value: serviceHeadInfo.serviceTypeId"
                                            required="true" validationmessage="Required">
                                    </app:dropDownServiceType>
                                </div>

                                <div class="col-md-3 pull-left">
                                    <span class="k-invalid-msg" data-for="serviceTypeId"></span>
                                </div>
                            </div>
                            <div class="form-group">
                                <label class="col-md-2 control-label label-optional" >Description:</label>

                                <div class="col-md-6">
                                    <textarea class="form-control" id="description" name="description"
                                           placeholder="Short description" tabindex="5"
                                           data-bind="value: serviceChargeFreeDays.description"></textarea>
                                </div>


                            </div>
                        </div>

                        <div class="col-md-5">
                            <div class="form-group">
                                <label class="col-md-3 control-label label-optional"
                                       for="isActive">Is Active:</label>

                                <div class="col-md-3">
                                    <g:checkBox class="form-control-static" name="isActive" tabindex="2"
                                                data-bind="checked: serviceChargeFreeDays.isActive"/>
                                </div>
                            </div>
                            <div class="form-group">
                                <label class="col-md-3 control-label label-required"
                                       for="daysForFree">Days:</label>

                                <div class="col-md-6">
                                    <input id="daysForFree" name="daysForFree" type="number" tabindex="3" validationMessage="Required"
                                           class="form-control" data-bind="value: serviceChargeFreeDays.daysForFree"/>
                                </div>
                                <div class="col-md-3 pull-left">
                                    <span class="k-invalid-msg" data-for="daysForFree"></span>
                                </div>
                            </div>
                            <div class="form-group">
                                <label class="col-md-3 control-label label-required" for="activationDate">Activation Date:</label>

                                <div class="col-md-6">
                                    <input type="text" name="activationDate" id="activationDate"
                                           required="true" validationMessage="Required"
                                           tabindex="4" class="form-control" data-bind="value: serviceChargeFreeDays.activationDate"/>

                                </div>

                                <div class="col-md-3 pull-left">
                                    <span class="k-invalid-msg" data-for="activationDate"></span>
                                </div>
                            </div>
                        </div>

                    </div>
                </div>

                <div class="panel-footer">
                    <button id="create" name="create" type="submit" data-role="button"
                            class="k-button k-button-icontext"
                            role="button" tabindex="6"
                            aria-disabled="false"><span class="k-icon k-i-plus"></span>Save
                    </button>&nbsp;&nbsp;&nbsp;

                    <button id="clearFormButton" name="clearFormButton" type="button" data-role="button"
                            class="k-button k-button-icontext" role="button" tabindex="7"
                            aria-disabled="false" onclick='resetForm();'><span
                            class="k-icon k-i-close"></span>Cancel
                    </button>
                </div>
            </g:form>
        </div>
    </div>

    <div class="row">
        <div id="gridServiceChargeFreeDays"></div>
    </div>
</div>