
<div class="panel panel-primary">
    <div class="panel-heading">
        <div class="panel-title">
            Assign Right(s) to Role
        </div>
    </div>

    <div>
        <div class="panel-body" style="background-color: #f5f5f5;">
            <div class="form-group">
                <div class="col-md-5" style="padding: 0">
                    <label class="control-label">Available Right(s):</label>
                </div>

                <div class="col-md-5  col-md-offset-2" style="padding:0">
                    <label class="control-label">Assigned Right(s):</label>
                </div>
            </div>

            <div class="form-group">
                <div class="col-md-6" style="padding: 0">
                    <div id="gridAvailableRole"></div>
                </div>

                <div class="col-md-1" style="padding-top: 7%">
                    <div class="form-group">
                        <button style="width: 100%" id="addSingle" name="addSingle" data-role="button" class="k-button"
                                onclick='return addDataToSelectedRole();' title="Add Selected Right"
                                role="button" tabindex="7"><span class="k-icon k-i-arrow-e"></span>
                        </button>
                    </div>

                    <div class="form-group">
                        <button style="width: 100%" id="addAll" name="addAll" data-role="button" class="k-button"
                                onclick='return addAllDataToSelectedRole();' title="Add All Rights"
                                role="button" tabindex="7"><span class="k-icon k-i-seek-e"></span>
                        </button>
                    </div>

                    <div class="form-group">
                        <button style="width: 100%" id="removeSingle" name="removeSingle" data-role="button"
                                class="k-button" onclick='return removeDataFromSelectedRole();'
                                title="Remove Selected Right"
                                role="button" tabindex="7"><span class="k-icon k-i-arrow-w"></span>
                        </button>
                    </div>

                    <div class="form-group">
                        <button style="width: 100%" id="removeAll" name="removeAll" data-role="button" class="k-button"
                                onclick='return removeAllDataFromSelectedRole();' title="Remove All Rights"
                                role="button" tabindex="7"><span class="k-icon k-i-seek-w"></span>
                        </button>
                    </div>
                </div>

                <div class="col-md-5" style="padding: 0">
                    <div id="gridAssignedRole"></div>
                </div>
            </div>
        </div>

        <div class="panel-footer">
            <sec:access url="/featureManagement/update">
                <button id="assign" name="assign" data-role="button"
                        class="k-button k-button-icontext"
                        role="button" tabindex="7" onclick="saveRequestMapAttributes();"
                        aria-disabled="false"><span class="k-icon k-i-plus"></span>Save
                </button>
            </sec:access>
            <button id="clear" name="clear" data-role="button" class="k-button k-button-icontext"
                    role="button" tabindex="8" onclick='discardChanges();'
                    aria-disabled="false"><span class="k-icon k-i-cancel"></span>Discard Changes
            </button>
        </div>
    </div>
</div>