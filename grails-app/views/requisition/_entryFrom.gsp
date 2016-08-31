<div id="application_top_panel" class="panel panel-primary">
    <div class="panel-heading">
        <div class="panel-title">
            Medicine requisition
        </div>
    </div>

    <form id="frmRequisition" name="frmRequisition" class="form-horizontal form-widgets" role="form">
        <div class="panel-body">
                <div class="form-group">
                    <label class="col-md-2 control-label label-optional" for="requisitionNo">Requisition No:</label>

                    <div class="col-md-3">
                        <input type="text" class="form-control" id="requisitionNo" name="requisitionNo" readonly="true" />
                    </div>
                </div>
            <div class="form-group">
                <div id="gridMedicine"></div>
            </div>
        </div>

        <div class="panel-footer">
            <button id="create" name="create" type="button" data-role="button"
                    class="k-button k-button-icontext"
                    role="button" tabindex="1" onclick='onSubmitForm();'
                    aria-disabled="false"><span class="k-icon k-i-plus"></span>Save
            </button>&nbsp;&nbsp;&nbsp;

            <button id="clearFormButton" name="clearFormButton" type="button" data-role="button"
                    class="k-button k-button-icontext" role="button" tabindex="2"
                    aria-disabled="false" onclick='resetForm();'><span
                    class="k-icon k-i-close"></span>Cancel
            </button>
        </div>
    </form>
</div>