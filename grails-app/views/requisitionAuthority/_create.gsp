<div class="container-fluid">
    <div class="row" id="authorityRow">
        <div id="application_top_panel" class="panel panel-primary">
            <div class="panel-heading">
                <div class="panel-title">
                    Create Requisition Authority
                </div>
            </div>

            <g:form name='authorityForm' id='authorityForm' class="form-horizontal form-widgets" role="form">
                <div class="panel-body">
                    <input type="hidden" name="id" id="id" data-bind="value: authority.id"/>
                    <input type="hidden" name="version" id="version" data-bind="value: authority.version"/>

                    <div class="form-group">
                        <div class="col-md-6">

                            <div class="form-group">
                                <label class="col-md-3 control-label label-required" for="name">Name:</label>

                                <div class="col-md-6">
                                    <input type="text" class="form-control" id="name" name="name" maxlength="255"
                                           placeholder="Employee Name" required validationMessage="Required"
                                           tabindex="2" data-bind="value: authority.name"/>
                                </div>

                                <div class="col-md-3 pull-left">
                                    <span class="k-invalid-msg" data-for="name"></span>
                                </div>
                            </div>

                            <div class="form-group">
                                <label class="col-md-3 control-label label-required"
                                       for="designation">Designation:</label>

                                <div class="col-md-6">
                                    <input type="text" class="form-control" id="designation" name="designation" maxlength="255"
                                           placeholder="Designation" required validationMessage="Required" tabindex="2"
                                           data-bind="value: authority.designation"/>
                                </div>

                                <div class="col-md-3 pull-left">
                                    <span class="k-invalid-msg" data-for="designation"></span>
                                </div>
                            </div>
                            <div class="form-group">
                                <label class="col-md-3 control-label label-optional"
                                       for="isActive">Enabled:</label>

                                <div class="col-md-3">
                                    <g:checkBox class="form-control-static" name="isActive" tabindex="3"
                                               data-bind="checked: authority.isActive"/>
                                </div>
                            </div>
                        </div>

                        <div class="col-md-6">
                            <div class="form-group">
                                <label class="col-md-3 control-label label-required" for="locationCode">Location:</label>

                                <div class="col-md-6">
                                    <app:dropDownHospital
                                            data_model_name="dropDownLocation"
                                            required="true"
                                            validationmessage="Required"
                                            class="kendo-drop-down" tabindex="4"
                                            data-bind="value: authority.locationCode"
                                            id="locationCode" name="locationCode">
                                    </app:dropDownHospital>
                                </div>

                                <div class="col-md-3 pull-left">
                                    <span class="k-invalid-msg" data-for="locationCode"></span>
                                </div>
                            </div>

                            <div class="form-group">
                                <label class="col-md-3 control-label label-required" for="rightsId">Rights:</label>

                                <div class="col-md-6">
                                    <app:dropDownSystemEntity
                                            data_model_name="dropDownRights"
                                            required="true"
                                            validationmessage="Required"
                                            type="Requisition authority"
                                            class="kendo-drop-down" tabindex="5"
                                            data-bind="value: authority.rightsId"
                                            id="rightsId" name="rightsId">
                                    </app:dropDownSystemEntity>
                                </div>

                                <div class="col-md-3 pull-left">
                                    <span class="k-invalid-msg" data-for="rightsId"></span>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>

                <div class="panel-footer">
                    <button id="create" name="create" type="submit" data-role="button"
                            class="k-button k-button-icontext"
                            role="button" tabindex="6"
                            aria-disabled="false"><span class="k-icon k-i-plus"></span>Create
                    </button>

                    <button id="clearFormButton" name="clearFormButton" type="button" data-role="button"
                            class="k-button k-button-icontext" role="button" tabindex="7"
                            aria-disabled="false" onclick='resetForm("hide");'><span
                            class="k-icon k-i-close"></span>Cancel
                    </button>
                </div>
            </g:form>
        </div>
    </div>

    <div class="row">
        <div id="gridAuthority"></div>
    </div>
</div>