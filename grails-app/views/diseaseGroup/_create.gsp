<div class="container-fluid">
    <div class="row" id="diseaseGroupRow">
        <div id="application_top_panel" class="panel panel-primary">
            <div class="panel-heading">
                <div class="panel-title">
                    Create Disease Group
                </div>
            </div>

            <g:form name='diseaseGroupForm' id='diseaseGroupForm' class="form-horizontal form-widgets" role="form">
                <div class="panel-body">
                    <input type="hidden" name="id" id="id" data-bind="value: diseaseGroup.id"/>
                    <input type="hidden" name="version" id="version" data-bind="value: diseaseGroup.version"/>

                    <div class="form-group">
                        <div class="col-md-8">
                            <div class="form-group">
                                <label class="col-md-2 control-label label-required" for="name">Name:</label>

                                <div class="col-md-6">
                                    <input type="text" class="form-control" id="name" name="name"
                                           placeholder="Disease Group Name" required validationMessage="Required" tabindex="1"
                                           data-bind="value: diseaseGroup.name"/>
                                </div>

                                <div class="col-md-3 pull-left">
                                    <span class="k-invalid-msg" data-for="name"></span>
                                </div>
                            </div>
                            <div class="form-group">
                                <label class="col-md-2 control-label label-optional" >Description:</label>

                                <div class="col-md-6">
                                    <textarea class="form-control" id="description" name="description"
                                           placeholder="Short description" tabindex="3"
                                           data-bind="value: diseaseGroup.description"></textarea>
                                </div>


                            </div>
                        </div>

                        <div class="col-md-4">
                            <div class="form-group">
                                <label class="col-md-6 control-label label-optional"
                                       for="isActive">Is Active:</label>

                                <div class="col-md-3">
                                    <g:checkBox class="form-control-static" name="isActive" tabindex="2"
                                                data-bind="checked: diseaseGroup.isActive"/>
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
                    </button>

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
        <div id="gridDiseaseGroup"></div>
    </div>
</div>