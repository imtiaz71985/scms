<div class="container-fluid">
    <div class="row">
        <div class="panel panel-primary">
            <div class="panel-heading">
                <div class="panel-title">
                    Return Medicine
                </div>
            </div>

            <div class="form-group">
                <label class="col-md-3 control-label label-optional" for="voucherNo">Voucher No:</label>

                <div class="col-md-6">
                    <app:dropDownSellVoucherNo
                            data_model_name="dropDownVoucherNo"
                            id="voucherNo" name="voucherNo" tabindex="1"
                            class="kendo-drop-down">
                    </app:dropDownSellVoucherNo>
                </div>
                <div class="col-md-2">

                    <button id="btnNewService" name="btnNewService" type="button"
                            class="k-button" tabindex="2"
                            role="button" onclick="editRecord();"
                            aria-disabled="false"><span
                            class="k-icon k-i-plus"></span> Return
                    </button>
                </div>
            </div>
        </div>
    </div>

    <div class="row" id="medicineReturnRow">
        <div id="application_top_panel" class="panel panel-primary">
            <form id="frmMedicine" name="frmMedicine" class="form-horizontal form-widgets" role="form">
                <div class="panel-body">

                    <div class="form-group" style="height: 340px;">
                        <div id="gridMedicine"></div>
                    </div>
                </div>

                <div class="panel-footer">
                    <button id="create" name="create" type="submit" data-role="button"
                            class="k-button k-button-icontext"
                            role="button" tabindex="4"
                            aria-disabled="false"><span class="k-icon k-i-plus"></span>Return Receive
                    </button>

                    <button id="clearFormButton" name="clearFormButton" type="button" data-role="button"
                            class="k-button k-button-icontext" role="button" tabindex="5"
                            aria-disabled="false" onclick='resetForm();'><span
                            class="k-icon k-i-close"></span>Cancel
                    </button>
                </div>
            </form>
        </div>
    </div>

    <div class="row" id="medicineReturnListGrid">
        <div id="gridMedicineSellReturnInfo"></div>
    </div>
</div>