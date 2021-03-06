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
                        <div class="col-md-8">

                            <div class="form-group">
                                <label class="col-md-3 control-label label-required" >Login ID:</label>

                                <div class="col-md-6">
                                    <app:dropDownEmployee
                                            data_model_name="dropDownEmployee"
                                            placeholder="Login ID"  tabindex="1"
                                            required="false" class="kendo-drop-down"
                                            id="username" name="username"
                                            data-bind="value: secUser.username">
                                    </app:dropDownEmployee>
                                </div>

                                <div class="col-md-3 pull-left">
                                    <span class="k-invalid-msg" data-for="username"></span>
                                </div>
                            </div>
                            <div class="form-group">
                                <label class="col-md-3 control-label label-required" for="hospitalCode">Hospital:</label>

                                <div class="col-md-6">
                                    <app:dropDownHospital
                                            data_model_name="dropDownHospitalCode"
                                            required="true" tabindex="2"
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
                                <label id="lblPassword" class="col-md-3 control-label label-required"
                                       for="password">Password:</label>

                                <div class="col-md-6">
                                    <input type="password" class="form-control" id="password" name="password"
                                           placeholder="Letters,Numbers & Special Characters" required
                                           data-required-msg="Required" tabindex="3"
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
                                           validationMessage="Invalid Combination or Length" tabindex="4"/>
                                </div>

                                <div class="col-md-3 pull-left">
                                    <span class="k-invalid-msg" data-for="confirmPassword"></span>
                                </div>
                            </div>
                        </div>

                        <div class="col-md-4">
                            <div class="form-group">
                                <label class="col-md-6 control-label label-optional"
                                       for="enabled">Enabled:</label>

                                <div class="col-md-3">
                                    <g:checkBox class="form-control-static" name="enabled" tabindex="5"
                                                data-bind="checked: secUser.enabled"/>
                                </div>
                            </div>

                            <div class="form-group">
                                <label class="col-md-6 control-label label-optional"
                                       for="accountLocked">Account Locked:</label>

                                <div class="col-md-3">
                                    <g:checkBox class="form-control-static" name="accountLocked" tabindex="6"
                                                data-bind="checked: secUser.accountLocked"/>
                                </div>
                            </div>

                            <div class="form-group">
                                <label class="col-md-6 control-label label-optional"
                                       for="accountExpired">Account Expired:</label>

                                <div class="col-md-3">
                                    <g:checkBox class="form-control-static" name="accountExpired" tabindex="7"
                                                data-bind="checked: secUser.accountExpired"/>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>

                <div class="panel-footer">
                    <button id="create" name="create" type="submit" data-role="button"
                            class="k-button k-button-icontext"
                            role="button" tabindex="8"
                            aria-disabled="false"><span class="k-icon k-i-plus"></span>Save
                    </button>

                    <button id="clearFormButton" name="clearFormButton" type="button" data-role="button"
                            class="k-button k-button-icontext" role="button" tabindex="9"
                            aria-disabled="false" onclick='resetForm();'><span
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