<div id="application_top_panel" class="panel panel-primary">
    <div class="panel-heading">
        <div class="panel-title">
            Search By Role
        </div>
    </div>

    <form id="frmSearchRole" name="frmSearchRole" class="form-horizontal form-widgets" role="form">
        <div class="panel-body">
            <g:hiddenField name="hidRole"/>

            <div class="form-group">
                <label class="col-md-1 control-label label-required">Role:</label>

                <div class="col-md-3">
                    <sec:dropDownRole
                            class="kendo-drop-down"
                            dataModelName="dropDownRole"
                            validationMessage="Required"
                            required="true"
                            name="roleId"
                            tabindex="1">
                    </sec:dropDownRole>
                </div>

                <div class="col-md-2 pull-left">
                    <span class="k-invalid-msg" data-for="roleId"></span>
                </div>
            </div>
        </div>

        <div class="panel-footer">
            <sec:access url="/featureManagement/update">
                <button id="create" name="create" type="submit" data-role="button"
                        class="k-button k-button-icontext"
                        role="button" tabindex="3"
                        aria-disabled="false"><span class="k-icon k-i-search"></span>Search
                </button>
            </sec:access>
        </div>
    </form>
</div>

