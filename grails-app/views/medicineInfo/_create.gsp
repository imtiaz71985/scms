<div class="container-fluid">
    <div class="row" id="medicineInfoRow">
        <div id="application_top_panel" class="panel panel-primary">
            <div class="panel-heading">
                <div class="panel-title">
                    Create Medicine
                </div>
            </div>

            <g:form name='medicineForm' id='medicineForm' class="form-horizontal form-widgets" role="form">
                <div class="panel-body">
                    <input type="hidden" name="id" id="id" data-bind="value: medicineInfo.id"/>
                    <input type="hidden" name="version" id="version" data-bind="value: medicineInfo.version"/>

                    <div class="col-md-6">
                        <div class="form-group">
                            <label class="col-md-3 control-label label-required" for="typeId">Type:</label>

                            <div class="col-md-6">
                                <app:dropDownSystemEntity
                                        data_model_name="dropDownType"
                                        id="typeId" name="typeId" tabindex="1"
                                        class="kendo-drop-down" type="Medicine Type"
                                        data-bind="value: medicineInfo.typeId"
                                        required="true" validationmessage="Required">
                                </app:dropDownSystemEntity>
                            </div>

                            <div class="col-md-3 pull-left">
                                <span class="k-invalid-msg" data-for="typeId"></span>
                            </div>
                        </div>
                        <div class="form-group">
                            <label class="col-md-3 control-label label-required" for="genericName">Generic Name:</label>

                            <div class="col-md-6">
                                <input type="text" class="form-control" id="genericName" name="genericName"
                                       placeholder="Generic Name" required validationMessage="Required" tabindex="2"
                                       data-bind="value: medicineInfo.genericName"/>
                            </div>

                            <div class="col-md-3 pull-left">
                                <span class="k-invalid-msg" data-for="genericName"></span>
                            </div>
                        </div>
                        <div class="form-group">
                            <label class="col-md-3 control-label label-required" for="brandName">Brand Name:</label>

                            <div class="col-md-6">
                                <input type="text" class="form-control" id="brandName" name="brandName"
                                       placeholder="Brand Name" required validationMessage="Required" tabindex="3"
                                       data-bind="value: medicineInfo.brandName"/>
                            </div>

                            <div class="col-md-3 pull-left">
                                <span class="k-invalid-msg" data-for="brandName"></span>
                            </div>
                        </div>
                        <div class="form-group">
                            <label class="col-md-3 control-label label-optional" for="strength">Strength:</label>

                            <div class="col-md-6">
                                <input type="text" class="form-control" id="strength" name="strength"
                                       placeholder="Strength" tabindex="4"
                                       data-bind="value: medicineInfo.strength"/>
                            </div>

                            <div class="col-md-3 pull-left">
                                <span class="k-invalid-msg" data-for="strength"></span>
                            </div>
                        </div>
                        <div class="form-group">
                            <label class="col-md-3 control-label label-required" for="vendorId">Vendor Name:</label>

                            <div class="col-md-6">
                                <app:dropDownVendor
                                        data_model_name="dropDownVendor"
                                        id="vendorId" name="vendorId" tabindex="5"
                                        class="kendo-drop-down" type="Vendor Name"
                                        data-bind="value: medicineInfo.vendorId"
                                        required="true" validationmessage="Required">
                                </app:dropDownVendor>
                            </div>

                            <div class="col-md-3 pull-left">
                                <span class="k-invalid-msg" data-for="vendorId"></span>
                            </div>
                        </div>

                    </div>

                    <div class="col-md-6">

                        <div class="form-group">
                            <label class="col-md-3 control-label label-required" for="unitType">Unit Type:</label>

                            <div class="col-md-6">
                                <input type="text" class="form-control" id="unitType" name="unitType"
                                       placeholder="Unit Type" required validationMessage="Required" tabindex="6"
                                       data-bind="value: medicineInfo.unitType"/>
                            </div>

                            <div class="col-md-3 pull-left">
                                <span class="k-invalid-msg" data-for="unitType"></span>
                            </div>
                        </div>
                        <div class="form-group">
                            <label class="col-md-3 control-label label-required" for="unitPrice">Unit Price:</label>

                            <div class="col-md-6">
                                <input type="text" class="form-control" id="unitPrice" name="unitPrice"
                                       placeholder="Unit Price" required validationMessage="Required" tabindex="7"
                                       data-bind="value: medicineInfo.unitPrice"/>
                            </div>

                            <div class="col-md-3 pull-left">
                                <span class="k-invalid-msg" data-for="unitPrice"></span>
                            </div>
                        </div>
                        <div class="form-group">
                            <label class="col-md-3 control-label label-required" for="mrpPrice">MRP Price:</label>

                            <div class="col-md-6">
                                <input type="text" class="form-control" id="mrpPrice" name="mrpPrice"
                                       placeholder="MRP Price" required validationMessage="Required" tabindex="8"
                                       data-bind="value: medicineInfo.mrpPrice"/>
                            </div>

                            <div class="col-md-3 pull-left">
                                <span class="k-invalid-msg" data-for="unitPrice"></span>
                            </div>
                        </div>
                        <div class="form-group">
                            <label class="col-md-3 control-label label-optional" for="boxSize">Box size:</label>

                            <div class="col-md-6">
                                <input type="text" class="form-control" id="boxSize" name="boxSize"
                                       placeholder="Box size" tabindex="9"
                                       data-bind="value: medicineInfo.boxSize"/>
                            </div>

                            <div class="col-md-3 pull-left">
                                <span class="k-invalid-msg" data-for="boxSize"></span>
                            </div>
                        </div>
                        <div class="form-group">
                            <label class="col-md-3 control-label label-optional" for="boxRate">Box Price:</label>

                            <div class="col-md-6">
                                <input type="text" class="form-control" id="boxRate" name="boxRate"
                                       placeholder="Box Price" tabindex="10"
                                       data-bind="value: medicineInfo.boxRate"/>
                            </div>

                            <div class="col-md-3 pull-left">
                                <span class="k-invalid-msg" data-for="boxRate"></span>
                            </div>
                        </div>
                        <div class="form-group">
                            <label class="col-md-3 control-label label-optional" for="warnQty">Warn Qty:</label>

                            <div class="col-md-6">
                                <input type="text" class="form-control" id="warnQty" name="warnQty"
                                       placeholder="Warn Qty" tabindex="11"
                                       data-bind="value: medicineInfo.warnQty"/>
                            </div>

                            <div class="col-md-3 pull-left">
                                <span class="k-invalid-msg" data-for="warnQty"></span>
                            </div>
                        </div>

                    </div>
                </div>

                <div class="panel-footer">
                    <button id="create" name="create" type="submit" data-role="button"
                            class="k-button k-button-icontext"
                            role="button" tabindex="12"
                            aria-disabled="false"><span class="k-icon k-i-plus"></span>Save
                    </button>

                    <button id="clearFormButton" name="clearFormButton" type="button" data-role="button"
                            class="k-button k-button-icontext" role="button" tabindex="13"
                            aria-disabled="false" onclick='resetForm("hide");'><span
                            class="k-icon k-i-close"></span>Cancel
                    </button>
                </div>
            </g:form>
        </div>
    </div>

    <div class="row">
        <div id="gridMedicine"></div>
    </div>
</div>