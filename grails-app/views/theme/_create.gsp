<div class="container-fluid">
    <div class="row">
        <div id="application_top_panel" class="panel panel-primary">
            <div class="panel-heading">
                <div class="panel-title">
                    Update Theme
                </div>
            </div>

            <g:form name='themeForm' id='themeForm' class="form-horizontal form-widgets" role="form">
                <div class="panel-body">
                    <input type="hidden" name="id" id="id" data-bind="value: theme.id"/>
                    <input type="hidden" name="version" id="version" data-bind="value: theme.version"/>

                    <div class="form-group">
                        <label class="col-md-1 control-label label-required" for="name">Key:</label>

                        <div class="col-md-8">
                            <input type="text" class="form-control" id="name" name="name"
                                   placeholder="Theme Key" required validationMessage="Required"
                                   tabindex="1" data-bind="value: theme.name"/>
                        </div>

                        <div class="col-md-2 pull-left">
                            <span class="k-invalid-msg" data-for="name"></span>
                        </div>
                    </div>

                    <div class="form-group">
                        <label class="col-md-1 control-label label-required" for="value">Value:</label>

                        <div class="col-md-8">
                            <textarea id="value" name="value" rows="5"
                                      tabindex="2" class="form-control"
                                      data-bind="value: theme.value"
                                      required validationMessage="Required"
                                      placeholder="Theme Value" class="kendo-drop-down"></textarea>
                        </div>

                        <div class="col-md-2 pull-left">
                            <span class="k-invalid-msg" data-for="value"></span>
                        </div>
                    </div>
                </div>

                <div class="panel-footer">
                    <button id="create" name="create" type="submit" data-role="button"
                            class="k-button k-button-icontext"
                            role="button" tabindex="3"
                            aria-disabled="false"><span class="k-icon k-i-plus"></span>Update
                    </button>

                    <button id="clearFormButton" name="clearFormButton" type="button" data-role="button"
                            class="k-button k-button-icontext" role="button" tabindex="4"
                            aria-disabled="false" onclick='resetForm();'><span
                            class="k-icon k-i-close"></span>Cancel
                    </button>
                </div>
            </g:form>
        </div>
    </div>

    <div class="row">
        <div id="gridTheme"></div>
    </div>
</div>