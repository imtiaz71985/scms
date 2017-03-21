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
                                class="kendo-drop-down" type="Counselor">
                        </app:dropDownRegistrationNo>
                    </div>

                    <div class="col-md-4">

                        <button id="btnNewService" name="btnNewService" type="button"
                                class="k-button" tabindex="2"
                                role="button" onclick="LoadDetailsByRegNo()"
                                aria-disabled="false"><span
                                class="k-icon k-i-plus"></span> New Service
                        </button>
                        <button id="btnFollowupService" name="btnFollowupService" type="button"
                                class="k-button" tabindex="2"
                                role="button" onclick="loadFormForFollowup()"
                                aria-disabled="false"><span
                                class="k-icon k-i-plus"></span> Follow-up Service
                        </button>
                    </div>
            <div class="col-md-3 pull-right" id="divPatientServed">
                <input type="text" readonly="true" id="lblPatientServed" class="form-control" style="font-size: medium; font-weight: bold; text-align: center;" >
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
                <input type="hidden" id="selectedConsultancyId" name="selectedConsultancyId"/>
                <input type="hidden" id="diseaseCodeForChargeFree" name="diseaseCodeForChargeFree"/>
                <input type="hidden" id="isUndiagnosed" name="isUndiagnosed"/>
                <input type="hidden" id="groupServiceCharge" name="groupServiceCharge"/>

                <div class="form-group">
                    <div class="col-md-6" style=" padding-bottom: 0px;">
                        <div class="form-group">
                            <label class="col-md-3 control-label label-optional"
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

                        <div class="form-group" id="divServiceProvider">
                            <label class="col-md-3 control-label label-optional"
                                   for="serviceProviderId">Service Provider:</label>

                            <div class="col-md-6">
                                <app:dropDownServiceProvider
                                        data_model_name="dropDownServiceProvider"
                                        id="serviceProviderId" name="serviceProviderId" tabindex="7"
                                        class="kendo-drop-down">
                                </app:dropDownServiceProvider>
                            </div>
                        </div>

                        <div class="form-group" id="divServiceType">
                            <label class="col-md-3 control-label label-optional"
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
                        <div id="divCharges">
                            <div class="form-group" id="divReferenceServiceNo" style="display:none;">
                                <label class="col-md-3 control-label label-optional"
                                       style="padding-right: 0px;">Reference Token No:</label>

                                <div class="col-md-9">
                                    <select id="referenceServiceNoDDL"
                                            name="referenceServiceNoDDL"
                                            class="kendo-drop-down"
                                            onchange="javascript: getReferenceNoWiseDisease();">
                                    </select>
                                </div>
                            </div>

                            <div class="form-group" id="divTakenService"  style="display:none;">
                                <label class="col-md-3 control-label label-optional" for="diseaseGroupId">Taken Service:</label>

                                <div class="col-md-9">
                                    <app:dropDownDiseaseGroup
                                            data_model_name="dropDownDiseaseGroup"
                                            id="diseaseGroupId" name="diseaseGroupId" tabindex="12"
                                            class="kendo-drop-down"
                                            onchange="javascript: getConsultationFees();">
                                    </app:dropDownDiseaseGroup>
                                </div>

                            </div>
                            <div id="divSelectedDisease" style="display:none;">
                                <div class="form-group ">
                                    <label class="col-md-3 control-label">Disease:</label>
                                    <div class="col-md-9">
                                        <select id="diseaseCode" name="diseaseCode" tabindex="13"
                                                onchange="javascript:checkIsChargeApply();"
                                                class="kendo-drop-down">
                                        </select>
                                    </div>
                                </div>

                            </div>
                            <div class="form-group" id="divServiceCharges" style="display:none;">
                                <label class="col-md-3 control-label label-optional"
                                       style="padding-right: 0px;">Service Charges:</label>

                                <div class="col-md-3">
                                    <input id="serviceCharges" name="serviceCharges" type="text" readonly="true"
                                           class="form-control"/>
                                </div>

                                <div id="divSubsidy" style="display:none;">
                                    <label class="col-md-3 control-label label-optional"
                                           style="padding-right: 0px;">Subsidy Amount:</label>

                                    <div class="col-md-3">
                                        <input id="subsidyAmount" name="subsidyAmount" type="number" tabindex="8"
                                               class="form-control" onchange="javascript: getPayableAmount();"/>
                                    </div>
                                </div>
                            </div>
                            <div class="form-group"  style="padding-bottom: 0px;">
                                <div id="divPathology" style="display:none;">
                                    <label class="col-md-3 control-label label-optional"
                                           style="padding-right: 0px;">Pathology Fees:</label>

                                    <div class="col-md-3">
                                        <input id="pathologyCharges" name="pathologyCharges" type="text" readonly="true"
                                               class="form-control" value="0"/>
                                    </div>
                                </div>

                                <div style="display:none;" id="divPayable">
                                    <label class="col-md-3 control-label label-optional"
                                           style="padding-right: 0px;">Total Payable:</label>

                                    <div class="col-md-3">
                                        <input id="payableAmount" name="payableAmount" type="text" readonly="true"
                                               class="form-control"/>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>

                    <div class="col-md-6" style=" padding-bottom: 0px;">
                        <div class="form-group" id="divReferralCenter" style="display: none;">
                            <label class="col-md-2 control-label label-optional"
                                   for="referralCenterId">Refer To:</label>

                            <div class="col-md-6" style=" padding-left: 0px;padding-right: 0px;">
                                <app:dropDownReferralCenter
                                        data_model_name="dropDownReferralCenter"
                                        type="counselor"
                                        id="referralCenterId" name="referralCenterId" tabindex="4"
                                        class="kendo-drop-down"
                                        data-bind="value: counselorAction.referralCenterId">
                                </app:dropDownReferralCenter>
                            </div>
                        </div>

                        <div class="form-group" id="divPrescriptionType">
                            <label class="col-md-2 control-label label-optional">Prescription:</label>

                            <div class="col-md-10" style="padding-top: 0px; padding-left: 0px;padding-right: 0px;">
                                <input type="checkbox" value="" id="chkboxMedicine" name="chkboxMedicine">&nbsp;Medicine
                                <input type="checkbox" value="" id="chkboxPathology" name="chkboxPathology"
                                       onclick="loadPathologyServicesToComplete();">&nbsp;Pathology Test
                                <input type="checkbox" value="" id="chkboxDocReferral" name="chkboxDocReferral"
                                       onclick="loadReferralCenter();">&nbsp;Doctors Referral
                                <input type="checkbox" value="" id="chkboxFollowupNeeded" name="chkboxFollowupNeeded"
                                       onclick="unLoadReferralCenter();">&nbsp;Follow-up Needed

                            </div>
                        </div>
                        <div  class="form-group" style=" padding-bottom: 0px;">
                            <div class="col-md-1 "></div>
                            <div class="col-md-10 " id="divServiceDetails" style="display:none;height: 350px; padding-left: 0px; padding-bottom: 0px;">
                                <div id="gridServiceHeadInfo"></div>
                            </div>
                        </div>



                    </div>

                </div>
            </div>


            <div class="panel-footer">
                <button id="create" name="create" type="submit" data-role="button"
                        class="k-button k-button-icontext"
                        role="button" tabindex="10"
                        aria-disabled="false"><span class="k-icon k-i-plus"></span>Save
                </button>&nbsp;&nbsp;&nbsp;

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
