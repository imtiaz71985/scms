<div class="panel panel-primary">
    <div class="panel-heading">
        <div class="panel-title">
            Medicine requisition
        </div>
    </div>

    <form id="frmRequisitionReceive" name="frmRequisitionReceive" class="form-horizontal form-widgets" role="form">
        <div class="panel-body">

            <div class="form-group">
                <div class="col-md-1">PR No:</div>
                <div class="col-md-2">
                    <input type="text" id="prNo" name="prNo" class="form-control" data-bind="value: receive.prNo">
                </div>
                <div class="col-md-2" align="right">Chalan No:</div>
                <div class="col-md-2">
                    <input type="text" id="chalanNo" name="chalanNo" class="form-control" data-bind="value: receive.chalanNo">
                </div>

                <div class="radio col-md-3 pull-right">
                    <label><input type="radio" id="rbComplete" name="requisitionStatus" value="Complete"
                                  tabindex="3">Complete</label>
                    &nbsp;&nbsp;
                    <label><input type="radio" id="rbNotComplete" name="requisitionStatus" value="Not Complete"
                                  tabindex="4">Not Complete</label>
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
                    aria-disabled="false"><span class="k-icon k-i-plus"></span>Save
            </button>

            <button id="clearFormButton" name="clearFormButton" type="button" data-role="button"
                    class="k-button k-button-icontext" role="button" tabindex="6"
                    aria-disabled="false" onclick='resetForm();'><span
                    class="k-icon k-i-close"></span>Cancel
            </button>
        </div>
    </form>
</div>