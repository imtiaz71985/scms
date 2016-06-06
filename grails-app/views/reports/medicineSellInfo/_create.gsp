<div class="container-fluid">
    <div class="row">
        <div id="application_top_panel" class="panel panel-primary">
            <div class="panel-heading">
                <div class="panel-title">
                    Month wise medicine sale Report
                </div>
            </div>

            <g:form name='monthWiseSellForm' id='monthWiseSellForm' class="form-horizontal form-widgets" role="form">
                <div class="panel-body">
                    <div class="form-group">
                        <label class="col-md-1 control-label label-required" for="month">From:</label>

                        <div class="col-md-3">
                            <input type='text' tabindex="2" required="required" onkeydown="return false;"
                                   class="kendo-date-picker" id="month" name="month"
                                   placeholder="Month" validationMessage="Required"/>
                        </div>

                        <div class="col-md-2 pull-left">
                            <span class="k-invalid-msg" data-for="month"></span>
                        </div>

                    </div>
                </div>

                <div class="panel-footer">
                    <button id="create" name="create" type="submit" data-role="button"
                            class="k-button k-button-icontext"
                            role="button" tabindex="3"
                            aria-disabled="false"><span class="k-icon k-i-search"></span>View Result
                    </button>
                </div>
            </g:form>
        </div>
    </div>

    <div class="row">
        <div id="gridSellReportInfo"></div>
    </div>
</div>