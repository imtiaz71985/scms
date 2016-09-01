<div class="container-fluid">
    <div class="row" id="userRow">
        <div id="application_top_panel" class="panel panel-primary">
            <div class="panel-heading">
                <div class="panel-title">
                    Create User
                </div>
            </div>

            <g:form name='userForm' id='userForm' class="form-horizontal form-widgets" role="form">
                <div class="panel-body">
                    <input type="hidden" name="id" id="id" data-bind="value: secUser.id"/>
                    <input type="hidden" name="version" id="version" data-bind="value: secUser.version"/>

                    <div class="form-group">
                        <div class="col-md-6">

                            <div class="form-group">
                                <label class="col-md-3 control-label label-required" for="username">Login ID:</label>

                                <div class="col-md-6">
                                    <input type="text" class="form-control" id="username" name="username" maxlength="255"
                                           placeholder="Login ID" required validationMessage="Required" tabindex="1"
                                           data-bind="value: secUser.username"/>
                                </div>

                                <div class="col-md-3 pull-left">
                                    <span class="k-invalid-msg" data-for="username"></span>
                                </div>
                            </div>

                            <div class="form-group">
                                <label id="lblPassword" class="col-md-3 control-label label-required"
                                       for="password">Password:</label>

                                <div class="col-md-6">
                                    <input type="password" class="form-control" id="password" name="password"
                                           placeholder="Insert password" required
                                           data-required-msg="Required" tabindex="2"
                                           validationMessage="Invalid Combination or Length"/>
                                </div>

                                <div class="col-md-3 pull-left">
                                    <span class="k-invalid-msg" data-for="password"></span>
                                </div>
                            </div>

                            <div class="form-group">
                                <label id="lblConfirmPassword" class="col-md-3 control-label label-required"
                                       for="confirmPassword">Confirm Password:</label>

                                <div class="col-md-6">
                                    <input type="password" class="form-control" id="confirmPassword" name="confirmPassword"
                                           placeholder="Confirm password" required data-required-msg="Required"
                                           validationMessage="Invalid Combination or Length" tabindex="3"/>
                                </div>

                                <div class="col-md-3 pull-left">
                                    <span class="k-invalid-msg" data-for="confirmPassword"></span>
                                </div>
                            </div>
                        </div>

                        <div class="col-md-6">
                            <div class="form-group">
                                <label class="col-md-2 control-label label-required" for="fullName">Name:</label>

                                <div class="col-md-6">
                                    <input type="text" class="form-control" id="fullName" name="fullName" maxlength="255"
                                           placeholder="User Name" required validationMessage="Required" tabindex="4"
                                           data-bind="value: secUser.fullName"/>
                                </div>

                                <div class="col-md-3 pull-left">
                                    <span class="k-invalid-msg" data-for="fullName"></span>
                                </div>
                            </div>

                            <div class="form-group">
                                <label class="col-md-2 control-label label-required" for="hospitalCode">Hospital:</label>

                                <div class="col-md-6">
                                    <app:dropDownHospital
                                            data_model_name="dropDownHospitalCode"
                                            required="true" tabindex="5"
                                            validationmessage="Required"
                                            class="kendo-drop-down"
                                            data-bind="value: secUser.hospitalCode"
                                            id="hospitalCode" name="hospitalCode">
                                    </app:dropDownHospital>
                                </div>

                                <div class="col-md-3 pull-left">
                                    <span class="k-invalid-msg" data-for="hospitalCode"></span>
                                </div>
                            </div>
                            <div class="form-group">
                                <label class="col-md-2 control-label label-optional"
                                       for="enabled">Enabled:</label>

                                <div class="col-md-2">
                                    <g:checkBox class="form-control-static" name="enabled" tabindex="6"
                                                data-bind="checked: secUser.enabled"/>
                                </div>
                                <label class="col-md-2 control-label label-optional"
                                       for="accountLocked">Locked:</label>

                                <div class="col-md-2">
                                    <g:checkBox class="form-control-static" name="accountLocked" tabindex="7"
                                                data-bind="checked: secUser.accountLocked"/>
                                </div>
                                <label class="col-md-2 control-label label-optional"
                                       for="accountExpired">Expired:</label>

                                <div class="col-md-2">
                                    <g:checkBox class="form-control-static" name="accountExpired" tabindex="8"
                                                data-bind="checked: secUser.accountExpired"/>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>

                <div class="panel-footer">
                    <button id="create" name="create" type="submit" data-role="button"
                            class="k-button k-button-icontext"
                            role="button" tabindex="9"
                            aria-disabled="false"><span class="k-icon k-i-plus"></span>Create
                    </button>&nbsp;&nbsp;&nbsp;

                    <button id="clearFormButton" name="clearFormButton" type="button" data-role="button"
                            class="k-button k-button-icontext" role="button" tabindex="10"
                            aria-disabled="false" onclick='resetForm("hide");'><span
                            class="k-icon k-i-close"></span>Cancel
                    </button>
                </div>
            </g:form>
        </div>
    </div>

    <div class="row">
        <div id="gridSecUser"></div>
    </div>
</div>