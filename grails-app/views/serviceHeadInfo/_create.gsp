<div class="container-fluid">
    <div class="row" id="serviceHeadInfoRow">
        <div id="application_top_panel" class="panel panel-primary">
            <div class="panel-heading">
                <div class="panel-title">
                    Create Service Head
                </div>
            </div>

            <g:form name='serviceHeadInfoForm' id='serviceHeadInfoForm' class="form-horizontal form-widgets" role="form">
                <div class="panel-body">
                    <input type="hidden" name="id" id="id" data-bind="value: serviceHeadInfo.serviceCode"/>

                    <div class="form-group">
                        <div class="col-md-6">
                            <div class="form-group">
                                <label class="col-md-3 control-label label-required" for="serviceCode">Service Code:</label>

                                <div class="col-md-6">
                                    <input type="text" readonly="true" class="form-control" id="serviceCode" name="serviceCode"
                                           placeholder="Select service type" required validationMessage="Required"
                                           tabindex="2"
                                           data-bind="value: serviceHeadInfo.serviceCode"/>
                                </div>

                                <div class="col-md-3 pull-left">
                                    <span class="k-invalid-msg" data-for="serviceCode"></span>
                                </div>
                            </div>
                            <div class="form-group">
                                <label class="col-md-3 control-label label-required" for="serviceTypeId">Type:</label>

                                <div class="col-md-6">
                                    <app:dropDownServiceType
                                            data_model_name="dropDownServiceType"
                                            type="all"
                                            id="serviceTypeId" name="serviceTypeId" tabindex="1"
                                            class="kendo-drop-down" onchange="javascript: getServiceCode();"
                                            data-bind="value: serviceHeadInfo.serviceTypeId"
                                            required="true" validationmessage="Required">
                                    </app:dropDownServiceType>
                                </div>

                                <div class="col-md-3 pull-left">
                                    <span class="k-invalid-msg" data-for="serviceTypeId"></span>
                                </div>
                            </div>
                            <div class="form-group">
                                <label class="col-md-3 control-label label-required" for="name">Name:</label>

                                <div class="col-md-6">
                                    <input type="text" class="form-control" id="name" name="name"
                                           placeholder="Service Name" required validationMessage="Required" tabindex="1"
                                           data-bind="value: serviceHeadInfo.name"/>
                                </div>

                                <div class="col-md-3 pull-left">
                                    <span class="k-invalid-msg" data-for="name"></span>
                                </div>
                            </div>

                        </div>
                        <div class="col-md-6">

                        <div class="form-group">
                            <label class="col-md-3 control-label label-optional"
                                   for="isActive">Is Active:</label>

                            <div class="col-md-3">
                                <g:checkBox class="form-control-static" id="isActive" name="isActive" tabindex="2" disabled="true"
                                            data-bind="checked: serviceHeadInfo.isActive"/>
                            </div>
                        </div>
                            <div class="form-group">
                                <label class="col-md-3 control-label label-required" for="chargeAmount">Fees:</label>

                                <div class="col-md-6">
                                    <input type="number" class="form-control" id="chargeAmount" name="chargeAmount"
                                           placeholder="Service Charge" required validationMessage="Required" tabindex="1"
                                           data-bind="value: serviceHeadInfo.chargeAmount"/>
                                </div>

                                <div class="col-md-3 pull-left">
                                    <span class="k-invalid-msg" data-for="chargeAmount"></span>
                                </div>
                            </div>
                        <div class="form-group">
                            <label class="col-md-3 control-label label-required" for="activationDate">Fees Activation Date:</label>

                            <div class="col-md-6">
                                <input type="text" name="activationDate" id="activationDate"
                                                 required="true" validationMessage="Required"
                                                 tabindex="2" class="form-control"
                                                 data-bind="value: serviceHeadInfo.activationDate"/>

                            </div>

                            <div class="col-md-3 pull-left">
                                <span class="k-invalid-msg" data-for="activationDate"></span>
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
        <div id="gridServiceHeadInfo"></div>
    </div>
</div>