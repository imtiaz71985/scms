<div class="panel panel-primary">
    <div class="panel-heading">
        <div class="panel-title">
            Medicine requisition
        </div>
    </div>

    <form id="frmRequisitionReceive" name="frmRequisitionReceive" class="form-horizontal form-widgets" role="form">
        <div class="panel-body">

            <div class="form-group">
                <div class="col-md-1" style="padding-right: 0px;">PR No:</div>
                <div class="col-md-2">
                    <input type="text" id="prNo" name="prNo" class="form-control" data-bind="value: receive.prNo">
                </div>
                <div class="col-md-1 label-required" style="padding-right: 0px;padding-left: 0px;" align="right">Chalan No:</div>
                <div class="col-md-2">
                    <input type="text" id="chalanNo" name="chalanNo" class="form-control" required="required" validationmessage="Required" data-bind="value: receive.chalanNo">
                </div>
                <div class="col-md-3 pull-left">
                    <span class="k-invalid-msg" data-for="chalanNo"></span>
                </div>
            </div>

            <div class="form-group">
                <div id="gridMedicine"></div>
            </div>
        </div>

        <div class="panel-footer">
            <button id="create" name="create" type="button" data-role="button"
                    class="k-button k-button-icontext"
                    role="button" tabindex="5" onclick='onSubmitForm();'
                    aria-disabled="false"><span class="k-icon k-i-plus"></span>Receive
            </button>&nbsp;&nbsp;&nbsp;

            <button id="clearFormButton" name="clearFormButton" type="button" data-role="button"
                    class="k-button k-button-icontext" role="button" tabindex="6"
                    aria-disabled="false" onclick='resetForm();'><span
                    class="k-icon k-i-close"></span>Cancel
            </button>
        </div>
    </form>
</div>