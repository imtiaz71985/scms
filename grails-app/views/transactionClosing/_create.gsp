<div class="container-fluid">
    <div class="row" id="transactionClosingRow">
        <div id="application_top_panel" class="panel panel-primary">
            <div class="panel-heading">
                <div class="panel-title">
                    Transaction Closing
                </div>
            </div>

            <g:form name='transactionClosingForm' id='transactionClosingForm' class="form-horizontal form-widgets" role="form">
                <div class="panel-body">
                    <input type="hidden" name="id" id="id" data-bind="value: transactionClosing.id"/>
                    <input type="hidden" name="version" id="version" data-bind="value: transactionClosing.version"/>

                    <div class="form-group">

                            <div class="form-group">
                                <label class="col-md-2 control-label label-required" for="closingDate">Date:</label>

                                <div class="col-md-4">
                                    <app:dropDownIncompleteServiceDate
                                            data_model_name="dropDownClosingDate"
                                            id="closingDate" name="closingDate" tabindex="1"
                                            class="kendo-drop-down"  type="complete">
                                    </app:dropDownIncompleteServiceDate>
                                </div>

                                <div class="col-md-3 pull-left">
                                    <span class="k-invalid-msg" data-for="closingDate"></span>
                                </div>
                            </div>
                            %{--<div class="form-group">
                                <label class="col-md-2 control-label label-required" for="isTransactionClosed">Is Transaction Closed:</label>

                                <div class="col-md-4">
                                    <g:checkBox class="form-control-static" name="isTransactionClosed" tabindex="2"
                                                data-bind="checked: transactionClosing.isTransactionClosed"/>
                                </div>

                                <div class="col-md-3 pull-left">
                                    <span class="k-invalid-msg" data-for="isTransactionClosed"></span>
                                </div>
                            </div>--}%
                            <div class="form-group">
                                <label class="col-md-2 control-label label-optional" for="remarks">Remarks:</label>

                                <div class="col-md-4">
                                    <textarea class="form-control" id="remarks" name="remarks"
                                              placeholder="Short description" tabindex="3"
                                              data-bind="value: transactionClosing.remarks"></textarea>
                                </div>

                            </div>


                    </div>
                </div>

                <div class="panel-footer">
                    <button id="create" name="create" type="submit" data-role="button"
                            class="k-button k-button-icontext"
                            role="button" tabindex="4"
                            aria-disabled="false"><span class="k-icon k-i-upload"></span>Close Transaction
                    </button>&nbsp;&nbsp;&nbsp;

                    <button id="clearFormButton" name="clearFormButton" type="button" data-role="button"
                            class="k-button k-button-icontext" role="button" tabindex="5"
                            aria-disabled="false" onclick='resetForm();'><span
                            class="k-icon k-i-close"></span>Cancel
                    </button>
                </div>
            </g:form>
        </div>
    </div>

    <div class="row">
        <div id="gridTransactionClosing"></div>
    </div>
</div>