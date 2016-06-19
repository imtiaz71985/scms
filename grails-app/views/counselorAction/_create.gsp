<div class="container-fluid">
    <div class="row" id="searchCriteriaRow">
        <div id="application_top_panel" class="panel panel-primary">
            <div class="panel-heading">
                <div class="panel-title">
                    Search Criteria
                </div>
            </div>

            <g:form name='searchByRegForm' id='searchByRegForm' class="form-horizontal form-widgets" role="form">
                <div class="panel-body">
                    <div>
                        <div class="form-group">
                            <div class="col-md-3" align="center">
                                <label class="control-label ">Registration No</label>
                            </div>

                            <div class="col-md-3"></div>

                            <div class="col-md-3" align="center">
                                <label class="control-label">Service Token No:</label>
                            </div>
                        </div>

                        <div class="form-group">
                            <div class="col-md-3">
                                <app:dropDownRegistrationNo
                                        data_model_name="dropDownRegistrationNo"
                                        id="regNoDDL" name="regNoDDL"
                                        class="kendo-drop-down">
                                </app:dropDownRegistrationNo>
                            </div>

                            <div class="col-md-2">

                                <button id="btnNewService" name="btnNewService" type="button"
                                        class="k-button"
                                        role="button" onclick="LoadDetailsByRegNo()"
                                        aria-disabled="false"><span
                                        class="k-icon k-i-plus"></span> Take New Service
                                </button>
                            </div>

                            <div class="col-md-1"></div>

                            <div class="col-md-3">
                                <app:dropDownServiceTokenNo
                                        data_model_name="dropDownServiceTokenNo"
                                        id="serviceTokenNoDDL" name="serviceTokenNoDDL"
                                        class="kendo-drop-down">
                                </app:dropDownServiceTokenNo>
                            </div>

                            <div class="col-md-2">

                                <button id="btnForCompleteAction" name="btnForCompleteAction" type="button"
                                        class="k-button"
                                        role="button" tabindex="4" onclick="LoadDetailsByTokenNo()"
                                        aria-disabled="false"><span
                                        class="fa fa-edit"></span>  Counselor Action
                                </button>
                            </div>
                        </div>
                    </div>
                </div>
            </g:form>
        </div>
    </div>

    <div class="row" id="counselorActionRow">
        <div id="application_top_panel1" class="panel panel-primary">
            <div class="panel-heading">
                <div class="panel-title">
                    Service Details
                </div>
            </div>

            <g:form name='counselorActionForm' id='counselorActionForm' class="form-horizontal form-widgets"
                    role="form">
                <div class="panel-body">
                    <input type="hidden" name="id" id="id" data-bind="value: counselorAction.serviceTokenNo"/>
                    <input type="hidden" id="regNo" name="regNo"/>
                    <input type="hidden" id="selectedChargeId" name="selectedChargeId"/>
                    <input type="hidden" id="selectedDiseaseCode" name="selectedDiseaseCode"/>

                    <div class="form-group">
                        <div class="col-md-6">
                            <div class="form-group">
                                <label class="col-md-3 control-label label-required"
                                       for="serviceTokenNo">Service No:</label>

                                <div class="col-md-6">
                                    <input type="text" readonly="true" class="form-control" id="serviceTokenNo"
                                           name="serviceTokenNo"
                                           required validationMessage="Required"
                                           data-bind="value: counselorAction.serviceTokenNo"/>
                                </div>

                                <div class="col-md-3 pull-left">
                                    <span class="k-invalid-msg" data-for="serviceTokenNo"></span>
                                </div>
                            </div>

                            <div class="form-group">
                                <label class="col-md-3 control-label label-required"
                                       for="serviceTypeId">Service Type:</label>

                                <div class="col-md-6">
                                    <app:dropDownServiceType
                                            data_model_name="dropDownServiceType"
                                            type="counselor"
                                            id="serviceTypeId" name="serviceTypeId" tabindex="1"
                                            class="kendo-drop-down" onchange="javascript: getServiceHeadInfo();"
                                            data-bind="value: counselorAction.serviceTypeId"
                                            required="true" validationmessage="Required">
                                    </app:dropDownServiceType>
                                </div>

                                <div class="col-md-3 pull-left">
                                    <span class="k-invalid-msg" data-for="serviceTypeId"></span>
                                </div>
                            </div>

                            <div class="form-group" id="divPrescriptionType" style="display:none;">
                                <label class="col-md-3 control-label label-required"
                                       for="prescriptionTypeId">Prescription Type:</label>

                                <div class="col-md-6">
                                    <app:dropDownSystemEntity
                                            data_model_name="dropDownPrescriptionType"
                                            id="prescriptionTypeId" name="prescriptionTypeId" tabindex="2"
                                            class="kendo-drop-down" type="Prescription Type"
                                            data-bind="value: counselorAction.prescriptionTypeId">
                                    </app:dropDownSystemEntity>
                                </div>
                            </div>

                            <div class="form-group">
                                <div class="col-md-3"></div>

                                <div class="col-md-6">
                                    <button id="btnPathologyService" name="btnPathologyService" type="button"
                                            class="k-button k-button-icontext" style="display:none;"
                                            role="button" tabindex="3" onclick='loadPathologyServicesToComplete();'
                                            aria-disabled="false">Pathology Services
                                    </button>
                                </div>
                            </div>
                        </div>

                        <div class="col-md-6" id="divCharges" style="display:none;">

                            <div class="form-group" id="divReferTo" style="display:none;">
                                <label class="col-md-3 control-label label-required" for="referToId">Refer To:</label>

                                <div class="col-md-6">
                                    <app:dropDownSystemEntity
                                            data_model_name="dropDownReferTo"
                                            id="referToId" name="referToId" tabindex="4"
                                            class="kendo-drop-down" type="Refer Type"
                                            data-bind="value: counselorAction.referToId">
                                    </app:dropDownSystemEntity>
                                </div>

                            </div>

                            <div class="form-group" id="divServiceCharges" style="display:none;">
                                <label class="col-md-3 control-label label-required">Service Charges:</label>

                                <div class="col-md-3">
                                    <input id="serviceCharges" name="serviceCharges" type="text" readonly="true"
                                           class="form-control"/>
                                </div>
                            </div>

                            <div class="form-group">
                                <div id="divSubsidy" style="display:none;">
                                    <label class="col-md-3 control-label label-required">Subsidy Amount:</label>

                                    <div class="col-md-3">
                                        <input id="subsidyAmount" name="subsidyAmount" type="number" tabindex="5"
                                               class="form-control" onchange="javascript: getPayableAmount();"/>
                                    </div>
                                </div>
                            </div>

                            <div class="form-group">
                                <div id="divPathology" style="display:none;">
                                    <label class="col-md-3 control-label label-required">Pathology Fees:</label>

                                    <div class="col-md-3">
                                        <input id="pathologyCharges" name="pathologyCharges" type="text" readonly="true"
                                               class="form-control" tabindex="6"/>
                                    </div>
                                </div>

                                <div style="display:none;" id="divPayable">
                                    <label class="col-md-3 control-label label-required">Total Payable:</label>

                                    <div class="col-md-3">
                                        <input id="payableAmount" name="payableAmount" type="text" readonly="true"
                                               class="form-control" tabindex="7"/>
                                    </div>
                                </div>
                            </div>


                            <div class="form-group " id="divDiseaseGroup" style="display:none;">
                                <label class="col-md-3 control-label label-required"
                                       for="diseaseGroupId">Disease Group:</label>

                                <div class="col-md-9">
                                    <app:dropDownDiseaseGroup
                                            data_model_name="dropDownDiseaseGroup" hints_text="All"
                                            id="diseaseGroupId" name="diseaseGroupId" tabindex="8"
                                            class="kendo-drop-down" onchange="loadDisease();">
                                    </app:dropDownDiseaseGroup>
                                </div>

                            </div>

                        </div>

                    </div>

                    <div class="form-group ">
                        <div class="col-md-5 " id="divServiceDetails" style="display:none;height: 200px;">
                            <div id="gridServiceHeadInfo"></div>
                        </div>

                        <div class="col-md-5 pull-right" id="divDiseaseDetails" style="display:none;height: 200px;">
                            <div id="gridDiseaseDetails"></div>
                        </div>
                    </div>

                </div>


                <div class="panel-footer">
                    <button id="create" name="create" type="submit" data-role="button"
                            class="k-button k-button-icontext"
                            role="button" tabindex="9"
                            aria-disabled="false"><span class="k-icon k-i-plus"></span>Save
                    </button>

                    <button id="clearFormButton" name="clearFormButton" type="button" data-role="button"
                            class="k-button k-button-icontext" role="button" tabindex="10"
                            aria-disabled="false" onclick='resetForm();'><span
                            class="k-icon k-i-close"></span>Cancel
                    </button>
                </div>
            </g:form>
        </div>
    </div>

    <div class="row" id="counselorActionGridRow">
        <div id="gridCounselorAction"></div>
    </div>
</div>