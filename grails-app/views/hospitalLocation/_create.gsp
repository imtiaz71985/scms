<div class="container-fluid">
    <div class="row" id="hospitalLocationRow">
        <div id="application_top_panel" class="panel panel-primary">
            <div class="panel-heading">
                <div class="panel-title">
                    Create Clinic
                </div>
            </div>

            <g:form name='hospitalLocationForm' id='hospitalLocationForm' class="form-horizontal form-widgets"
                    role="form">
                <div class="panel-body">
                    <input type="hidden" name="id" id="id" data-bind="value: hospitalLocation.id"/>
                    <input type="hidden" name="version" id="version" data-bind="value: hospitalLocation.version"/>

                    <div class="form-group">
                        <div class="col-md-6">
                            <div class="form-group">
                                <label class="col-md-2 control-label label-required" for="name">Name:</label>

                                <div class="col-md-6">
                                    <input type="text" class="form-control" id="name" name="name"
                                           placeholder="Hospital Name" required validationMessage="Required"
                                           tabindex="1"
                                           data-bind="value: hospitalLocation.name"/>
                                </div>

                                <div class="col-md-3 pull-left">
                                    <span class="k-invalid-msg" data-for="name"></span>
                                </div>
                            </div>

                            <div class="form-group">
                                <label class="col-md-2 control-label label-required">Address:</label>

                                <div class="col-md-6">
                                    <textarea class="form-control" id="address" name="address"
                                              placeholder="Short address" tabindex="2"
                                              required validationMessage="Required"
                                              data-bind="value: hospitalLocation.address"></textarea>
                                </div>

                                <div class="col-md-3 pull-left">
                                    <span class="k-invalid-msg" data-for="address"></span>
                                </div>
                            </div>
                        </div>

                        <div class="col-md-4">
                            <div class="form-group">
                                <label class="col-md-6 control-label label-optional"
                                       for="isClinic">Clinic:</label>

                                <div class="col-md-3">
                                    <g:checkBox class="form-control-static" name="isClinic" tabindex="3"
                                                data-bind="checked: hospitalLocation.isClinic"/>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>

                <div class="panel-footer">
                    <button id="create" name="create" type="submit" data-role="button"
                            class="k-button k-button-icontext"
                            role="button" tabindex="4"
                            aria-disabled="false"><span class="k-icon k-i-plus"></span>Save
                    </button>&nbsp;&nbsp;&nbsp;

                    <button id="clearFormButton" name="clearFormButton" type="button" data-role="button"
                            class="k-button k-button-icontext" role="button" tabindex="5"
                            aria-disabled="false" onclick='resetForm();'><span
                            class="k-icon k-i-close"></span>Cancel
                    </button>
                </div>
            </g:form>
        </div>
    </div>

    <div class="row">
        <div id="gridHospitalLocation"></div>
    </div>
</div>