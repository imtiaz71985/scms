<div id="application_top_panel" class="panel panel-primary">
    <div class="panel-heading">
        <div class="panel-title">
            Sale Medicine
        </div>
    </div>

    <g:form id="frmMedicine" name="frmMedicine" class="form-horizontal form-widgets" role="form">
        <div class="panel-body">
            <div class="form-group">
                <label class="col-md-2 control-label label-optional" for="voucherNo">Voucher No:</label>

                <div class="col-md-3">
                    <input type="text" class="form-control" id="voucherNo" name="voucherNo" readonly="true" />
                </div>
                <label class="col-md-2 control-label label-optional">Reference :</label>

                <div class="col-md-3">
                    <app:dropDownServiceTokenNo
                            data_model_name="dropDownTokenId"
                            type="Last Three Month Token"
                            id="refTokenNo" name="refTokenNo" tabindex="1"
                            class="kendo-drop-down">
                    </app:dropDownServiceTokenNo>
                </div>
            </div>

            <hr>

            <div class="col-md-6">
                <div class="form-group">
                    <label class="col-md-2 control-label label-required" for="medicineId">Medicine :</label>

                    <div class="col-md-6">
                        <app:dropDownMedicineList
                                data_model_name="dropDownMedicine"
                                id="medicineId" name="medicineId" tabindex="2"
                                class="kendo-drop-down" onchange="javascript: getMedicinePrice();"
                                required="true" validationmessage="Required">
                        </app:dropDownMedicineList>
                    </div>
                    <div class="col-md-3 pull-left">
                        <span class="k-invalid-msg" data-for="medicineId"></span>
                    </div>
                </div>
                <div class="form-group">
                    <label class="col-md-2 control-label label-required" for="quantity">Quantity:</label>

                    <div class="col-md-6">
                        <input type="text" class="form-control" id="quantity" name="quantity"
                               placeholder="Quantity" tabindex="3"
                               onKeyUp="javascript: calculateTotalPrice();"/>
                    </div>
                    <div class="col-md-3">
                        <b>out of <span id="stockQty"></span></b>
                    </div>
                </div>
            </div>

            <div class="col-md-6">

                <div class="form-group">
                    <label class="col-md-3 control-label label-optional">Unit Price:</label>

                    <div class="col-md-4">
                        <input type="text" class="form-control" id="unitPriceTxt" name="unitPriceTxt"
                               placeholder="Unit Price (৳)" readonly="true"/>
                    </div>
                </div>
                <div class="form-group">
                    <label class="col-md-3 control-label label-optional">Amount:</label>

                    <div class="col-md-4">
                        <input type="text" class="form-control" id="amount" name="amount"
                               placeholder="Total amount (৳)" readonly="true"/>
                    </div>
                </div>
            </div>

            <div class="form-group">
                <div class="col-md-7">
                    <button id="addMedicine" name="addMedicine" data-role="button" class="k-button"
                            style="width: inherit;"
                            role="button" onclick='return addMedicineToGrid();' tabindex="4"
                            aria-disabled="false"><span class="fa fa-shopping-cart"></span>&nbsp; Add
                    </button>
                </div>
            </div>

            <div class="form-group" style="height: 285px;">
                <div id="gridMedicine"></div>
            </div>
        </div>

        <div class="panel-footer">
            <button id="create" name="create" type="submit" data-role="button"
                    class="k-button k-button-icontext"
                    role="button" tabindex="5"
                    aria-disabled="false"><span class="k-icon k-i-plus"></span>Sale
            </button>

            <button id="clearFormButton" name="clearFormButton" type="button" data-role="button"
                    class="k-button k-button-icontext" role="button" tabindex="6"
                    aria-disabled="false" onclick='resetForm();'><span
                    class="k-icon k-i-close"></span>Cancel
            </button>
        </div>
    </g:form>
</div>