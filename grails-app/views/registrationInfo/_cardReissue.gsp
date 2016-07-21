<div class="container-fluid">
    <div class="row" id="registrationInfoRow">
        <div id="application_top_panel" class="panel panel-primary">
            <div class="panel-heading">
                <div class="panel-title">
                    Registration Information
                </div>
            </div>

            <g:form name='regReIssueInfoForm' id='regReIssueInfoForm' class="form-horizontal form-widgets"
                    role="form">
                <div class="panel-body">

                    <div class="form-group">
                        <div class="col-md-6">
                            <div class="form-group">
                                <label class="col-md-3 control-label " for="regNo">Reg No:</label>

                                <div class="col-md-6">
                                    <input type="text" readonly="true" class="form-control" id="regNo" name="regNo"
                                           required validationMessage="Required"
                                           data-bind="value: registrationInfo.regNo"/>
                                </div>


                            </div>

                            <div class="form-group">
                                <label class="col-md-3 control-label label-required" for="patientName">Name:</label>

                                <div class="col-md-6">
                                    <input type="text" class="form-control" id="patientName" name="patientName"
                                           readonly="true"
                                           tabindex="1"
                                           data-bind="value: registrationInfo.patientName"/>
                                </div>


                            </div>

                            <div class="form-group">
                                <label class="col-md-3 control-label label-required"
                                       for="fatherOrMotherName">Father/ Mother Name:</label>

                                <div class="col-md-6">
                                    <input type="text" class="form-control" id="fatherOrMotherName"
                                           name="fatherOrMotherName" readonly="true"
                                           data-bind="value: registrationInfo.fatherOrMotherName"/>
                                </div>

                            </div>

                            <div class="form-group">
                                <label class="col-md-3 control-label">Date of Birth:</label>

                                <div class="col-md-6">
                                    <input id="dateOfBirth" type="text" readonly="true" class="form-control" />
                                </div>


                            </div>

                            <div class="form-group">
                                <label class="col-md-3 control-label label-required" for="sexId">Sex :</label>

                                <div class="col-md-6">
                                    <input id="sexId" type="text" readonly="true" class="form-control"/>
                                </div>

                            </div>

                            <div class="form-group">
                                <label class="col-md-3 control-label label-required">Marital Status :</label>

                                <div class="col-md-6">
                                    <input id="maritalStatus" type="text" readonly="true" class="form-control" />
                                </div>

                            </div>

                        </div>

                        <div class="col-md-6">
                            <div class="form-group">
                                <label class="col-md-2 control-label label-required">Fees:</label>

                                <div class="col-md-6">
                                    <input id="regFees" type="text" readonly="true" class="form-control" value="10 tk"/>
                                </div>

                            </div>

                            <div class="form-group">
                                <label class="col-md-2 control-label" for="mobileNo">Mobile No:</label>

                                <div class="col-md-6">
                                    <input type="text" class="form-control" id="mobileNo" name="mobileNo"
                                           placeholder="Mobile no" readonly="true"/>
                                </div>

                                <div class="col-md-3 pull-left">
                                    <span class="k-invalid-msg" data-for="mobileNo"></span>
                                </div>
                            </div>

                            <div class="form-group" id="divAddress">
                                <label class="col-md-2 control-label label-required">Address :</label>

                                <div class="col-md-6">
                                    <textarea readonly="true" id="addressDetails" style="width:100%" tabindex="11"></textarea>
                                </div>
                            </div>

                        </div>

                    </div>
                </div>

                <div class="panel-footer">
                    <button id="create" name="create" type="submit" data-role="button"
                            class="k-button k-button-icontext"
                            role="button" tabindex="12" onclick="saveReIssueRegNo();"
                            aria-disabled="false"><span class="k-icon k-i-plus"></span>Re Issue
                    </button>
                    <button id="clearFormButton" name="clearFormButton" type="button" data-role="button"
                            class="k-button k-button-icontext" role="button" tabindex="13"
                            aria-disabled="false" onclick='resetForm();'><span
                            class="k-icon k-i-close"></span>Cancel
                    </button>
                </div>
            </g:form>
        </div>
    </div>
</div>