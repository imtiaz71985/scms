<div class="container-fluid">
    <div class="row">
        <div id="application_top_panel" class="panel panel-primary">
            <div class="panel-heading">
                <div class="panel-title">
                    Medicine Price
                </div>
            </div>

            <g:form name='medicinePriceForm' id='medicinePriceForm' class="form-horizontal form-widgets" role="form">
                <div class="panel-body">
                    <input type="hidden" name="id" id="id"/>
                    <input type="hidden" name="medicineId" id="medicineId"/>
                    <div class="col-md-6">
                        <div class="form-group">
                            <label class="col-md-3 control-label label-optional">Medicine:</label>

                            <div class="col-md-6">
                                <input type="text" class="form-control" id="name" name="name" readonly="true"/>
                            </div>
                        </div>
                        <div class="form-group">
                            <label class="col-md-3 control-label label-required" for="mrpPrice">MRP Price:</label>

                            <div class="col-md-6">
                                <input type="text" class="form-control" id="mrpPrice" name="mrpPrice"
                                       placeholder="New MRP Price" required validationMessage="Required" tabindex="1"/>
                            </div>

                            <div class="col-md-3 pull-left">
                                <span class="k-invalid-msg" data-for="mrpPrice"></span>
                            </div>
                        </div>
                        <div class="form-group">
                            <label class="col-md-3 control-label label-required" for="start">Active Date:</label>

                            <div class="col-md-6">
                                <input type="text" id="start"
                                       name="start" required="true"
                                       placeholder="dd/MM/yyyy hh:mm:ss"
                                       validationMessage="Required"
                                       tabindex="2" class="kendo-date-picker" value=""/>
                            </div>

                            <div class="col-md-3 pull-left">
                                <span class="k-invalid-msg" data-for="start"></span>
                            </div>
                        </div>
                    </div>
                </div>

                <div class="panel-footer">
                    <button id="create" name="create" type="submit" data-role="button"
                            class="k-button k-button-icontext"
                            role="button" tabindex="3"
                            aria-disabled="false"><span class="k-icon k-i-plus"></span>Save
                    </button>

                    <button id="clearFormButton" name="clearFormButton" type="button" data-role="button"
                            class="k-button k-button-icontext" role="button" tabindex="4"
                            aria-disabled="false" onclick='resetForm();'><span
                            class="k-icon k-i-close"></span>Cancel
                    </button>
                </div>
            </g:form>
        </div>
    </div>

    <div class="row">
        <div id="gridMedicinePrice"></div>
    </div>
</div>