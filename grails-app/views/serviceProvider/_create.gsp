<div class="container-fluid">
    <div class="row" id="providerRow">
        <div id="application_top_panel" class="panel panel-primary">
            <div class="panel-heading">
                <div class="panel-title">
                    Create Service Provider
                </div>
            </div>

            <g:form name='providerForm' id='providerForm' class="form-horizontal form-widgets" role="form">
                <div class="panel-body">
                    <input type="hidden" name="id" id="id" data-bind="value: serviceProvider.id"/>
                    <input type="hidden" name="version" id="version" data-bind="value: serviceProvider.version"/>

                    <div class="form-group">
                        <div class="col-md-6">
                            <div class="form-group">
                                <label class="col-md-2 control-label label-required" for="typeId">Type:</label>

                                <div class="col-md-6">
                                    <app:dropDownSystemEntity
                                            data_model_name="dropDownType"
                                            id="typeId" name="typeId" tabindex="1"
                                            class="kendo-drop-down" type="Service Provider"
                                            data-bind="value: serviceProvider.typeId"
                                            required="true" validationmessage="Required">
                                    </app:dropDownSystemEntity>
                                </div>

                                <div class="col-md-3 pull-left">
                                    <span class="k-invalid-msg" data-for="typeId"></span>
                                </div>
                            </div>

                            <div class="form-group">
                                <label class="col-md-2 control-label label-required" for="name">Name:</label>

                                <div class="col-md-6">
                                    <input type="text" class="form-control" id="name" name="name"
                                           placeholder="Full Name" required validationMessage="Required" tabindex="2"
                                           data-bind="value: serviceProvider.name"/>
                                </div>

                                <div class="col-md-3 pull-left">
                                    <span class="k-invalid-msg" data-for="name"></span>
                                </div>
                            </div>
                        </div>

                        <div class="col-md-6">
                            <div class="form-group">
                                <label class="col-md-3 control-label label-required" for="mobileNo">Mobile No:</label>

                                <div class="col-md-6">
                                    <input type="text" class="form-control" id="mobileNo" name="mobileNo"
                                           placeholder="Mobile No" required validationMessage="Required" tabindex="2"
                                           data-bind="value: serviceProvider.mobileNo"/>
                                </div>

                                <div class="col-md-3 pull-left">
                                    <span class="k-invalid-msg" data-for="mobileNo"></span>
                                </div>
                            </div>

                            <div class="form-group">
                                <div class="form-group">
                                    <label class="col-md-3 control-label label-optional"
                                           for="isActive">Is Active:</label>

                                    <div class="col-md-3">
                                        <g:checkBox class="form-control-static" name="isActive" tabindex="4"
                                                    data-bind="checked: serviceProvider.isActive"/>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>

                <div class="panel-footer">
                    <button id="create" name="create" type="submit" data-role="button"
                            class="k-button k-button-icontext"
                            role="button" tabindex="5"
                            aria-disabled="false"><span class="k-icon k-i-plus"></span>Save
                    </button>&nbsp;&nbsp;&nbsp;

                    <button id="clearFormButton" name="clearFormButton" type="button" data-role="button"
                            class="k-button k-button-icontext" role="button" tabindex="6"
                            aria-disabled="false" onclick='resetForm("hide");'><span
                            class="k-icon k-i-close"></span>Cancel
                    </button>
                </div>
            </g:form>
        </div>
    </div>

    <div class="row">
        <div id="gridServiceProvider"></div>
    </div>
</div>