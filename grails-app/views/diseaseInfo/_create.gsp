<div class="container-fluid">
    <div class="row" id="diseaseInfoRow">
        <div id="application_top_panel" class="panel panel-primary">
            <div class="panel-heading">
                <div class="panel-title">
                    Create Disease
                </div>
            </div>

            <g:form name='diseaseInfoForm' id='diseaseInfoForm' class="form-horizontal form-widgets" role="form">
                <div class="panel-body">
                    <input type="hidden" name="id" id="id" data-bind="value: diseaseInfo.diseaseCode"/>

                    <div class="form-group">
                        <div class="col-md-6">
                            <div class="form-group">
                                <label class="col-md-3 control-label label-required" for="diseaseCode">Disease Code:</label>

                                <div class="col-md-6">
                                    <input type="text" readonly="true" class="form-control" id="diseaseCode" name="diseaseCode"
                                           placeholder="Select disease group" required validationMessage="Required"
                                           tabindex="2"
                                           data-bind="value: diseaseInfo.diseaseCode"/>
                                </div>

                                <div class="col-md-3 pull-left">
                                    <span class="k-invalid-msg" data-for="diseaseCode"></span>
                                </div>
                            </div>
                            <div class="form-group">
                                <label class="col-md-3 control-label label-required" for="diseaseGroupId">Disease Group:</label>

                                <div class="col-md-6">
                                    <app:dropDownDiseaseGroup
                                            data_model_name="dropDownDiseaseGroup"
                                            id="diseaseGroupId" name="diseaseGroupId" tabindex="1"
                                            class="kendo-drop-down" onchange="javascript: getDiseaseCode();"
                                            data-bind="value: diseaseInfo.diseaseGroupId"
                                            required="true" validationmessage="Required">
                                    </app:dropDownDiseaseGroup>
                                </div>

                                <div class="col-md-3 pull-left">
                                    <span class="k-invalid-msg" data-for="diseaseGroupId"></span>
                                </div>
                            </div>
                            <div class="form-group">
                                <label class="col-md-3 control-label label-required" for="name">Name:</label>

                                <div class="col-md-6">
                                    <input type="text" class="form-control" id="name" name="name"
                                           placeholder="disease Name" required validationMessage="Required" tabindex="1"
                                           data-bind="value: diseaseInfo.name"/>
                                </div>

                                <div class="col-md-3 pull-left">
                                    <span class="k-invalid-msg" data-for="name"></span>
                                </div>
                            </div>

                        </div>
                        <div class="col-md-6">

                        <div class="form-group">
                            <label class="col-md-2 control-label label-optional"
                                   for="isActive">Is Active:</label>

                            <div class="col-md-3">
                                <g:checkBox class="form-control-static" name="isActive" tabindex="2"
                                            data-bind="checked: diseaseInfo.isActive"/>
                            </div>
                        </div>
                            <div class="form-group">
                                <label class="col-md-2 control-label label-required">Description:</label>

                                <div class="col-md-8">
                                    <textarea class="form-control" id="description" name="description"
                                           placeholder="Short Description" tabindex="1"
                                           data-bind="value: diseaseInfo.description"/>
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
        <div id="gridDiseaseInfo"></div>
    </div>
</div>