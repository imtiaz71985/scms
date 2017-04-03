<div class="container-fluid">
    <div class="row">
        <div class="panel panel-primary">
            <div class="panel-heading">
                <div class="panel-title">
                    Return Medicine
                </div>
            </div>

            <div class="panel-body">
                <div class="form-group">
                    <label class="col-md-2 control-label label-optional" for="voucherNo">Voucher No:</label>

                    <div class="col-md-3">
                        <app:dropDownSellVoucherNo
                                data_model_name="dropDownVoucherNo"
                                id="voucherNo" name="voucherNo" tabindex="1"
                                class="kendo-drop-down">
                        </app:dropDownSellVoucherNo>
                    </div>

                    <div class="col-md-2">

                        <button id="btnNewService" name="btnNewService" type="button"
                                class="k-button" tabindex="2"
                                role="button" onclick="viewSellDetails();"
                                aria-disabled="false"><span
                                class="k-icon k-i-plus"></span> View
                        </button>
                    </div>
                    <label class="col-md-2 control-label label-required" for="returnTypeId">Return Type:</label>
                    <div class="col-md-3">
                        <app:dropDownSystemEntity
                                data_model_name="dropDownReturnType"
                                hints_text="" show_hints="false"
                                id="returnTypeId" name="returnTypeId" tabindex="3"
                                class="kendo-drop-down" type="Return Type"
                                required="true" validationmessage="Required">
                        </app:dropDownSystemEntity>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <div class="row" id="medicineReturnRow">
        <div id="application_top_panel" class="panel panel-primary">
            <form id="frmMedicineReturn" name="frmMedicineReturn" class="form-horizontal form-widgets" role="form">
                <div class="panel-body">

                    <div class="form-group" style="height: 420px;">
                        <div id="gridMedicineReturn"></div>
                    </div>
                </div>

                <div class="panel-footer">
                    <button id="create" name="create" type="submit" data-role="button"
                            class="k-button k-button-icontext"
                            role="button" tabindex="4" onclick='onSubmitForm();'
                            aria-disabled="false"><span class="k-icon k-i-plus"></span>Return
                    </button>&nbsp;&nbsp;&nbsp;

                    <button id="clearFormButton" name="clearFormButton" type="button" data-role="button"
                            class="k-button k-button-icontext" role="button" tabindex="5"
                            aria-disabled="false" onclick='resetForm();'><span
                            class="k-icon k-i-close"></span>Cancel
                    </button>
                </div>
            </form>
        </div>
    </div>
</div>