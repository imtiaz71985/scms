<div class="container-fluid">
    <div class="row">
        <div id="application_top_panel" class="panel panel-primary">
            <div class="panel-heading">
                <div class="panel-title">
                    Create User Role
                </div>
            </div>

            <g:form name='userRoleForm' id='userRoleForm' class="form-horizontal form-widgets" role="form">
                <div class="panel-body">
                    <input type="hidden" name="id" id="id"/>
                    <input type="hidden" name="roleId" id="roleId"/>

                    <div class="form-group">
                        <label class="col-md-1 control-label label-required" for="userId">User:</label>

                        <div class="col-md-3">
                            <sec:dropDownAppUserRole
                                    role_id="${roleId}"
                                    data_model_name="dropDownSecUser"
                                    required="required"
                                    validationmessage="Required"
                                    url="${createLink(controller: 'secUser', action: 'reloadDropDown')}"
                                    class="kendo-drop-down"
                                    id="userId"
                                    name="userId">
                            </sec:dropDownAppUserRole>
                        </div>

                        <div class="col-md-2 pull-left">
                            <span class="k-invalid-msg" data-for="userId"></span>
                        </div>
                    </div>
                </div>

                <div class="panel-footer">
                    <button id="create" name="create" type="submit" data-role="button"
                            class="k-button k-button-icontext"
                            role="button" tabindex="2"
                            aria-disabled="false"><span class="k-icon k-i-plus"></span>Create
                    </button>

                    <button id="clearFormButton" name="clearFormButton" type="button" data-role="button"
                            class="k-button k-button-icontext" role="button" tabindex="3"
                            aria-disabled="false" onclick='resetForm();'><span
                            class="k-icon k-i-close"></span>Cancel
                    </button>
                </div>
            </g:form>
        </div>
    </div>

    <div class="row">
        <div id="gridUserRole"></div>
    </div>
</div>