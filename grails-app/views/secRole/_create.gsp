<div class="container-fluid">
    <div class="row" id="roleRow">
        <div id="application_top_panel" class="panel panel-primary">
            <div class="panel-heading">
                <div class="panel-title">
                    Create Role
                </div>
            </div>

            <g:form name='roleForm' id='roleForm' class="form-horizontal form-widgets" role="form">
                <div class="panel-body">
                    <input type="hidden" name="id" id="id" data-bind="value: secRole.id"/>
                    <input type="hidden" name="version" id="version" data-bind="value: secRole.version"/>

                    <div class="form-group">
                        <label class="col-md-1 control-label label-required" for="name">Role:</label>

                        <div class="col-md-3">
                            <input type="text" class="form-control" id="name" name="name"
                                   placeholder="Role Name" required validationMessage="Required" tabindex="1"
                                   data-bind="value: secRole.name"/>
                        </div>

                        <div class="col-md-2 pull-left">
                            <span class="k-invalid-msg" data-for="name"></span>
                        </div>
                    </div>
                </div>

                <div class="panel-footer">
                    <button id="create" name="create" type="submit" data-role="button"
                            class="k-button k-button-icontext"
                            role="button" tabindex="2"
                            aria-disabled="false"><span class="k-icon k-i-plus"></span>Save
                    </button>

                    <button id="clearFormButton" name="clearFormButton" type="button" data-role="button"
                            class="k-button k-button-icontext" role="button" tabindex="3"
                            aria-disabled="false" onclick='resetForm("hide");'><span
                            class="k-icon k-i-close"></span>Cancel
                    </button>
                </div>
            </g:form>
        </div>
    </div>

    <div class="row">
        <div id="gridSecRole"></div>
    </div>
</div>