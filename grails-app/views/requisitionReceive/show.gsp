<div class="container-fluid">
    <div class="row" id="application_top_panel">
        <div class="panel panel-primary">
            <div class="panel-heading">
                <div class="panel-title">
                    Search Criteria
                </div>
            </div>

            <g:form name='searchByRegForm' id='searchByRegForm' class="form-horizontal form-widgets" role="form">
                <div class="panel-body">
                    <div>
                        <div class="form-group">
                            <div class="col-md-1" align="center">
                                <label class="control-label">Vendor:</label>
                            </div>

                            <div class="col-md-3">
                                <app:dropDownVendor
                                        data_model_name="dropDownVendor"
                                        id="vendorDDL" name="vendorDDL"
                                        tabindex="1" class="kendo-drop-down"
                                        onchange="javascript:populateDDLRequisitionNo();">
                                </app:dropDownVendor>
                            </div>

                            <div class="col-md-1"></div>

                            <div class="col-md-2" align="center">
                                <label class="control-label ">Requisition No:</label>
                            </div>

                            <div class="col-md-3">
                                <select id="ddlRequisition"
                                        name="ddlRequisition"
                                        tabindex="2"
                                        onchange="javascript:editRecord();"
                                        class="kendo-drop-down">
                                </select>
                            </div>
                        </div>
                    </div>
                </div>

            </g:form>
        </div>
    </div>

    <div class="row">
        <g:render template='/requisitionReceive/entryFrom'/>
    </div>
</div>
<g:render template='/requisitionReceive/scriptEntryForm'/>


