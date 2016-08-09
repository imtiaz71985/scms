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
                <div class="form-group">
                    <div class="col-md-2" align="center">
                        <label class="control-label ">Registration No:</label>
                    </div>

                    <div class="col-md-3">
                        <app:dropDownRegistrationNo
                                data_model_name="dropDownRegistrationNo"
                                id="regNoDDL" name="regNoDDL" tabindex="1"
                                class="kendo-drop-down">
                        </app:dropDownRegistrationNo>
                    </div>

                    <div class="col-md-2">

                        <button id="btnNewService" name="btnNewService" type="button"
                                class="k-button" tabindex="2"
                                role="button" onclick="LoadDetailsByRegNo()"
                                aria-disabled="false"><span
                                class="k-icon k-i-plus"></span> Take New Service
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
                <input type="hidden" id="regNo" name="regNo"/>
                <input type="hidden" id="selectedChargeId" name="selectedChargeId"/>
                <input type="hidden" id="selectedDiseaseCode" name="selectedDiseaseCode"/>
                <input type="hidden" id="selectedConsultancyId" name="selectedConsultancyId"/>

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

                        <div class="form-group" id="divReferTo">
                            <label class="col-md-3 control-label label-required"
                                   for="referToId">Refer To:</label>

                            <div class="col-md-6">
                                <app:dropDownSystemEntity
                                        data_model_name="dropDownReferTo"
                                        id="referToId" name="referToId" tabindex="7"
                                        class="kendo-drop-down" type="Refer Type"
                                        data-bind="value: counselorAction.referToId">
                                </app:dropDownSystemEntity>
                            </div>

                        </div>
                        <div class="form-group" id="divReferenceServiceNo" style="display:none;">
                            <label class="col-md-3 control-label label-required"
                                   style="padding-right: 0px;">Reference Service No:</label>

                            <div class="col-md-6">
                                <select id="referenceServiceNoDDL"
                                        name="referenceServiceNoDDL"
                                        class="kendo-drop-down">
                                </select>
                            </div>
                        </div>
                        <div class="form-group">
                            <label class="col-md-3 control-label label-required"
                                   for="serviceTypeId">Service Type:</label>

                            <div class="col-md-6">
                                <app:dropDownServiceType
                                        data_model_name="dropDownServiceType"
                                        type="counselor"
                                        id="serviceTypeId" name="serviceTypeId" tabindex="4"
                                        class="kendo-drop-down" onchange="javascript: getServiceHeadInfo();"
                                        data-bind="value: counselorAction.serviceTypeId">
                                </app:dropDownServiceType>
                            </div>


                        </div>

                        <div class="form-group" id="divPrescriptionType">
                            <label class="col-md-3 control-label label-required"
                                   style="padding-top: 0px;">Prescription:</label>

                            <div class="col-md-9" style="padding-top: 0px;">
                                <input type="checkbox" value="" id="chkboxMedicine" name="chkboxMedicine">&nbsp;Medicine
                                <input type="checkbox" value="" id="chkboxPathology" name="chkboxPathology"
                                       onclick="loadPathologyServicesToComplete();">&nbsp;Pathology Test
                                <input type="checkbox" value="" id="chkboxDocReferral" name="chkboxDocReferral">&nbsp;Doctors Referral

                            </div>
                        </div>
                        <div  class="form-group">
                            <div class="col-md-1 "></div>
                        <div class="col-md-10 " id="divServiceDetails" style="display:none;height: 300px; padding-left: 0px;">
                            <div id="gridServiceHeadInfo"></div>
                        </div>
                            </div>
                    </div>

                    <div class="col-md-6" id="divCharges">

                        <div class="form-group" id="divServiceCharges" style="display:none;">
                            <label class="col-md-3 control-label label-required"
                                   style="padding-right: 0px;">Service Charges:</label>

                            <div class="col-md-3">
                                <input id="serviceCharges" name="serviceCharges" type="text" readonly="true"
                                       class="form-control"/>
                            </div>

                            <div id="divSubsidy" style="display:none;">
                                <label class="col-md-3 control-label label-required"
                                       style="padding-right: 0px;">Subsidy Amount:</label>

                                <div class="col-md-3">
                                    <input id="subsidyAmount" name="subsidyAmount" type="number" tabindex="8"
                                           class="form-control" onchange="javascript: getPayableAmount();"/>
                                </div>
                            </div>
                        </div>

                        <div class="form-group">
                            <div id="divPathology" style="display:none;">
                                <label class="col-md-3 control-label label-required"
                                       style="padding-right: 0px;">Pathology Fees:</label>

                                <div class="col-md-3">
                                    <input id="pathologyCharges" name="pathologyCharges" type="text" readonly="true"
                                           class="form-control" value="0"/>
                                </div>
                            </div>

                            <div style="display:none;" id="divPayable">
                                <label class="col-md-3 control-label label-required"
                                       style="padding-right: 0px;">Total Payable:</label>

                                <div class="col-md-3">
                                    <input id="payableAmount" name="payableAmount" type="text" readonly="true"
                                           class="form-control"/>
                                </div>
                            </div>
                        </div>


                        <div class="form-group " id="divSelectedDisease" style="display:none;">
                            <label class="col-md-3 control-label" style="padding-right: 0px;">Disease:</label>

                            <div class="col-md-9">
                                <textarea readonly="true" id="selectedDiseaseTxt" style="width:100%"></textarea>
                            </div>

                        </div>
                        <div class="form-group col-md-10 pull-right" id="divDiseaseDetails" style="display:none;height: 300px; padding-left: 0px;">
                            <div id="gridDiseaseDetails"></div>
                        </div>
                    </div>

                </div>


            </div>


            <div class="panel-footer">
                <button id="create" name="create" type="submit" data-role="button"
                        class="k-button k-button-icontext"
                        role="button" tabindex="10"
                        aria-disabled="false"><span class="k-icon k-i-plus"></span>Save
                </button>

                <button id="clearFormButton" name="clearFormButton" type="button" data-role="button"
                        class="k-button k-button-icontext" role="button" tabindex="11"
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