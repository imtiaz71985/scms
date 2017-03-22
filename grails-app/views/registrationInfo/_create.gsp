<div class="container-fluid">
    <div class="row" id="registrationInfoRow">
        <div id="application_top_panel" class="panel panel-primary">
            <div class="panel-heading">
                <div class="panel-title">
                    Registration Information
                </div>
            </div>

            <g:form name='registrationInfoForm' id='registrationInfoForm' class="form-horizontal form-widgets"
                    role="form">
                <div class="panel-body">
                    <input type="hidden" name="id" id="id" data-bind="value: registrationInfo.regNo"/>

                    <div class="form-group">
                        <div class="col-md-6">
                            <div class="form-group">
                                <label class="col-md-3 control-label label-optional"
                                       for="regNo">Registration No:</label>

                                <div class="col-md-6">
                                    <input type="text" readonly="true" class="form-control" id="regNo" name="regNo"
                                           required validationMessage="Required"
                                           data-bind="value: registrationInfo.regNo"/>
                                </div>

                                <div class="col-md-3 pull-left">
                                    <span class="k-invalid-msg" data-for="regNo"></span>
                                </div>
                            </div>

                            <div class="form-group">
                                <label class="col-md-3 control-label label-required" for="patientName">Patient Name:</label>

                                <div class="col-md-6">
                                    <input type="text" class="form-control" id="patientName" name="patientName"
                                           placeholder="Patient Name" required="true" validationMessage="Required"
                                           tabindex="1"
                                           data-bind="value: registrationInfo.patientName"/>
                                </div>

                                <div class="col-md-3 pull-left">
                                    <span class="k-invalid-msg" data-for="patientName"></span>
                                </div>
                            </div>

                            <div class="form-group">
                                <label class="col-md-3 control-label label-required"
                                       for="fatherOrMotherName">Father/ Mother:</label>

                                <div class="col-md-6">
                                    <input type="text" class="form-control" id="fatherOrMotherName"
                                           name="fatherOrMotherName" required="true" validationMessage="Required"
                                           placeholder="Father or Mother Name" tabindex="2"
                                           data-bind="value: registrationInfo.fatherOrMotherName"/>
                                </div>

                                <div class="col-md-3 pull-left">
                                    <span class="k-invalid-msg" data-for="fatherOrMotherName"></span>
                                </div>
                            </div>

                            <div class="form-group">
                                <label class="col-md-3 control-label label-required"
                                       for="dateOfBirth">Date of Birth:</label>

                                <div class="col-md-6">
                                    <app:dateControl name="dateOfBirth"
                                                     required="true" validationMessage="Required"
                                                     tabindex="3" class="form-control"
                                                     data-bind="value: registrationInfo.dateOfBirth">
                                    </app:dateControl>
                                </div>

                                <div class="col-md-3 pull-left">
                                    <span class="k-invalid-msg" data-for="dateOfBirth"></span>
                                </div>
                            </div>

                            <div class="form-group">
                                <label class="col-md-3 control-label label-required" for="sexId">Sex :</label>

                                <div class="col-md-6">
                                    <app:dropDownSystemEntity
                                            data_model_name="dropDownSex"
                                            id="sexId" name="sexId" tabindex="4"
                                            class="kendo-drop-down" type="Sex"
                                            data-bind="value: registrationInfo.sexId"
                                            required="true" validationmessage="Required">
                                    </app:dropDownSystemEntity>
                                </div>

                                <div class="col-md-3 pull-left">
                                    <span class="k-invalid-msg" data-for="sexId"></span>
                                </div>
                            </div>

                            <div class="form-group">
                                <label class="col-md-3 control-label label-required"
                                       for="maritalStatusId">Marital Status :</label>

                                <div class="col-md-6">
                                    <app:dropDownSystemEntity
                                            data_model_name="dropDownMaritalStatus"
                                            id="maritalStatusId" name="maritalStatusId" tabindex="5"
                                            class="kendo-drop-down" type="Marital Status"
                                            data-bind="value: registrationInfo.maritalStatusId"
                                            required="true" validationmessage="Required">
                                    </app:dropDownSystemEntity>
                                </div>

                                <div class="col-md-3 pull-left">
                                    <span class="k-invalid-msg" data-for="maritalStatusId"></span>
                                </div>
                            </div>

                        </div>

                        <div class="col-md-6">
                            <div class="form-group">
                                <label class="col-md-2 control-label label-optional">Fees:</label>

                                <div class="col-md-6">
                                    <input id="regFees" type="text" readonly="true" class="form-control" id="fee"
                                           value="10 tk"/>
                                </div>

                            </div>

                            <div class="form-group">
                                <label class="col-md-2 control-label label-optional" for="mobileNo">Mobile No:</label>

                                <div class="col-md-6">
                                    <input type="text" class="form-control" data-role='maskedtextbox' pattern="\d{11}"
                                           data-bind="value: registrationInfo.mobileNo" tabindex="6"
                                           id="mobileNo" name="mobileNo" validationmessage="Invalid Number"
                                           onKeyPress="return allowOnlyNumeric(event)"/>
                                </div>

                                <div class="col-md-4 pull-left">
                                    <span class="k-invalid-msg" data-for="mobileNo"></span>
                                </div>
                            </div>

                            <div class="form-group">
                                <label class="col-md-2 control-label label-required" for="village">Village :</label>

                                <div class="col-md-6">
                                    <app:dropDownVillage
                                            data_model_name="dropDownVillage"
                                            required="true" validationmessage="Required"
                                            url="${createLink(controller: 'registrationInfo', action: 'reloadDropDown')}"
                                            onchange="javascript:populateAddress();"
                                            data-bind="value: registrationInfo.village"
                                            placeholder="Write/Select one..." tabindex="7"
                                            class="kendo-drop-down" type="Village"
                                            id="village" name="village">
                                    </app:dropDownVillage>
                                </div>

                                <div class="col-md-3 pull-left">
                                    <span class="k-invalid-msg" data-for="village"></span>
                                </div>
                            </div>

                            <div class="form-group">
                                <label class="col-md-2 control-label label-required"
                                       for="districtId">District :</label>

                                <div class="col-md-6">
                                    <app:dropDownDistrict
                                            data_model_name="dropDownDistrict"
                                            required="true" validationmessage="Required"
                                            id="districtId" name="districtId" tabindex="8"
                                            class="kendo-drop-down" type="District"
                                            onchange="javascript:populateUpazilaList();"
                                            data-bind="value: registrationInfo.districtId">
                                    </app:dropDownDistrict>
                                </div>

                                <div class="col-md-3 pull-left">
                                    <span class="k-invalid-msg" data-for="districtId"></span>
                                </div>
                            </div>

                            <div class="form-group">
                                <label class="col-md-2 control-label label-required"
                                       for="upazilaId">Upazila :</label>

                                <div class="col-md-6">
                                    <select id="upazilaId" name="upazilaId"
                                            tabindex="9" required="required" validationmessage="Required"
                                            onchange="javascript:populateUnionList();"
                                            data-bind="value: registrationInfo.upazilaId"
                                            class="kendo-drop-down">
                                    </select>
                                </div>

                                <div class="col-md-3 pull-left">
                                    <span class="k-invalid-msg" data-for="upazilaId"></span>
                                </div>
                            </div>

                            <div class="form-group">
                                <label class="col-md-2 control-label label-required" for="unionId">Union :</label>

                                <div class="col-md-6">
                                    <select id="unionId" name="unionId"
                                            tabindex="10" required="required" validationmessage="Required"
                                            data-bind="value: registrationInfo.unionId"
                                            class="kendo-drop-down">
                                    </select>
                                </div>

                                <div class="col-md-3 pull-left">
                                    <span class="k-invalid-msg" data-for="unionId"></span>
                                </div>
                            </div>
                        </div>

                    </div>
                </div>

                <div class="panel-footer">
                    <button id="create" name="create" type="submit" data-role="button"
                            class="k-button k-button-icontext"
                            role="button" tabindex="12"
                            aria-disabled="false"><span class="k-icon k-i-plus"></span>Save
                    </button>&nbsp;&nbsp;&nbsp;
                    <button id="clearFormButton" name="clearFormButton" type="button" data-role="button"
                            class="k-button k-button-icontext" role="button" tabindex="13"
                            aria-disabled="false" onclick='resetForm();'><span
                            class="k-icon k-i-close"></span>Cancel
                    </button>
                </div>
            </g:form>
        </div>
    </div>

    <div class="row">
        <div id="gridRegistrationInfo"></div>
    </div>
</div>