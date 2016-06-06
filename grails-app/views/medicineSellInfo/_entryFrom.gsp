<div id="application_top_panel" class="panel panel-primary">
    <div class="panel-heading">
        <div class="panel-title">
            Sale Medicine
        </div>
    </div>

    <form id="frmMedicine" name="frmMedicine" class="form-horizontal form-widgets" role="form">
        <div class="panel-body">
            <div class="col-md-6">

                <div class="form-group">
                    <label class="col-md-3 control-label label-optional" for="voucherNo">Voucher No:</label>

                    <div class="col-md-6">
                        <input type="text" class="form-control" id="voucherNo" name="voucherNo" readonly="true" />
                    </div>
                </div>

                <div class="form-group">
                    <label class="col-md-3 control-label label-required" for="medicineId">Medicine Name:</label>

                    <div class="col-md-6">
                        <app:dropDownMedicineList
                                data_model_name="dropDownMedicine"
                                id="medicineId" name="medicineId" tabindex="1"
                                class="kendo-drop-down" onchange="javascript: getMedicinePrice();"
                                data-bind="value: medicineSell.medicineId"
                                required="true" validationmessage="Required">
                        </app:dropDownMedicineList>
                    </div>
                    <div class="col-md-3 pull-left">
                        <span class="k-invalid-msg" data-for="medicineId"></span>
                    </div>
                </div>
            </div>

            <div class="col-md-6">
                <div class="form-group">
                    <label class="col-md-3 control-label label-required" for="quantity">Quantity:</label>

                    <div class="col-md-4">
                        <input type="text" class="form-control" id="quantity" name="quantity"
                               placeholder="Quantity" required validationMessage="Required" tabindex="3"
                               onKeyUp="javascript: calculateTotalPrice();"
                               data-bind="value: medicineSell.quantity"/>
                    </div>

                    <div class="col-md-2">
                        <span id="unit"></span>
                    </div>
                    <div class="col-md-3 pull-left">
                        <span class="k-invalid-msg" data-for="quantity"></span>
                    </div>
                </div>

                <div class="form-group">
                    <label class="col-md-3 control-label label-optional">Amount:</label>

                    <div class="col-md-4">
                        <input type="text" class="form-control" id="amount" name="amount"
                               placeholder="Total amount (৳)" readonly="true"
                               data-bind="value: medicineSell.amount"/>
                    </div>
                </div>

            </div>

            <div class="form-group">
                <div class="col-md-3">&nbsp;</div>

                <div class="col-md-6">
                    <button id="addMedicine" name="addMedicine" data-role="button" class="k-button"
                            style="width: inherit;"
                            role="button" onclick='return addMedicineToGrid();' tabindex="3"
                            aria-disabled="false"><span class="fa fa-shopping-cart"></span>&nbsp; Add
                    </button>
                </div>
            </div>

            <div class="form-group" style="height: 350px;">
                <div id="gridMedicine"></div>
            </div>
        </div>

        <div class="panel-footer">
            <button id="create" name="create" type="submit" data-role="button"
                    class="k-button k-button-icontext"
                    role="button" tabindex="4"
                    aria-disabled="false"><span class="k-icon k-i-plus"></span>Sale
            </button>

            <button id="clearFormButton" name="clearFormButton" type="button" data-role="button"
                    class="k-button k-button-icontext" role="button" tabindex="5"
                    aria-disabled="false" onclick='resetForm();'><span
                    class="k-icon k-i-close"></span>Cancel
            </button>
        </div>
    </form>
</div>