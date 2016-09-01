<div class="container-fluid">
    <div class="row" id="systemEntityRow">
        <div id="application_top_panel" class="panel panel-primary">
            <div class="panel-heading">
                <div class="panel-title">
                    Create System Entity
                </div>
            </div>

            <g:form name='systemEntityForm' id='systemEntityForm' class="form-horizontal form-widgets" role="form">
                <div class="panel-body">
                    <input type="hidden" name="id" id="id" data-bind="value: systemEntity.id"/>
                    <input type="hidden" name="version" id="version" data-bind="value: systemEntity.version"/>

                    <div class="form-group">
                        <div class="col-md-8">
                            <div class="form-group">
                                <label class="col-md-2 control-label label-required" for="type">Type:</label>

                                <div class="col-md-6">
                                    <app:dropDownSystemEntityType
                                            data_model_name="dropDownSystemEntityType"
                                            id="type" name="type" tabindex="1"
                                            class="kendo-drop-down"
                                            data-bind="value: systemEntity.type"
                                            required="true" validationmessage="Required">
                                    </app:dropDownSystemEntityType>
                                </div>

                                <div class="col-md-3 pull-left">
                                    <span class="k-invalid-msg" data-for="type"></span>
                                </div>
                            </div>

                            <div class="form-group">
                                <label class="col-md-2 control-label label-required" for="name">Name:</label>

                                <div class="col-md-6">
                                    <input type="text" class="form-control" id="name" name="name"
                                           placeholder="System Entity Name" required validationMessage="Required"
                                           tabindex="2"
                                           data-bind="value: systemEntity.name"/>
                                </div>

                                <div class="col-md-3 pull-left">
                                    <span class="k-invalid-msg" data-for="name"></span>
                                </div>
                            </div>

                            <div class="form-group">
                                <label class="col-md-2 control-label label-optional" for="name">Description:</label>

                                <div class="col-md-6">
                                    <textarea class="form-control" id="description" name="description"
                                              placeholder="Short description" tabindex="3"
                                              data-bind="value: systemEntity.description"></textarea>
                                </div>

                                <div class="col-md-3 pull-left">
                                    <span class="k-invalid-msg" data-for="description"></span>
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
        <div id="gridSystemEntity"></div>
    </div>
</div>