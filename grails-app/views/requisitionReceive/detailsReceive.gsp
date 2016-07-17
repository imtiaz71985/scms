<div id="application_top_panel" class="panel panel-primary">
    <div class="panel-heading">
        <div class="panel-title">
            Requisition receive details
        </div>
    </div>

    <div class="panel-body">
        <div class="form-group">
            <div id="gridMedicine"></div>
        </div>
    </div>

    <div class="panel-footer">
        <button id="clearFormButton" name="clearFormButton" type="button" data-role="button"
                class="k-button k-button-icontext" role="button" tabindex="1"
                aria-disabled="false" onclick='resetForm();'>
            <span class="k-icon k-i-close"></span>Close
        </button>
    </div>
</div>

<script language="javascript">
    var gridMedicine, dataSource, requisitionNo;

    $(document).ready(function () {
        initRequisitionGrid();
        requisitionNo = '${requisitionNo}';
        gridMedicine.setDataSource(new kendo.data.DataSource({data: ${gridModelMedicine}}));
        $("#footerSpanApvd").text(formatAmount(${apvdAmount}));
        defaultPageTile("Receive details", 'requisitionReceive/showList');
    });

    function initRequisitionGrid() {
        $("#gridMedicine").kendoGrid({
            dataSource: getBlankDataSource,
            height: $("#page-wrapper").height() - 120,
            selectable: true,
            sortable: true,
            resizable: true,
            reorderable: true,
            pageable: false,
            columns: [
                {
                    field: "type",
                    title: "Type",
                    width: 30,
                    sortable: false,
                    filterable: false
                },
                {
                    field: "genericName",
                    title: "Generic Name",
                    width: 60,
                    sortable: false,
                    filterable: false
                },
                {
                    field: "medicineName",
                    title: "Medicine Name",
                    width: 90,
                    sortable: false,
                    filterable: false
                },
                {
                    field: "unitPrice",
                    title: "Unit Price",
                    attributes: {style: setAlignRight()},
                    headerAttributes: {style: setAlignRight()},
                    template: "#=formatAmount(unitPrice)#",
                    sortable: false, filterable: false, width: 30
                },
                {
                    title: "Approved", headerAttributes: {style: setAlignCenter()},
                    columns: [
                        {
                            field: "apvdQty", title: "Qty", width: 30,
                            attributes: {style: setAlignRight()},
                            headerAttributes: {style: setAlignRight()},
                            sortable: false, filterable: false
                        },
                        {
                            field: "apvdAmount", title: "Amount",
                            attributes: {style: setAlignRight()},
                            headerAttributes: {style: setAlignRight()},
                            template: "#=formatAmount(apvdAmount)#",
                            sortable: false, filterable: false, width: 50,
                            footerTemplate: "<div style='text-align: right'>Total : <span id='footerSpanApvd'>#=formatAmount(0)#</span></div>"
                        }
                    ]
                },
                {
                    title: "Received", headerAttributes: {style: setAlignCenter()},
                    columns: [
                        {
                            field: "recvdQty",
                            title: "Qty",
                            width: 30,
                            attributes: {style: setAlignRight()},
                            headerAttributes: {style: setAlignRight()},
                            sortable: false,
                            filterable: false
                        },
                        {
                            field: "recvdAmount",
                            title: "Amount",
                            attributes: {style: setAlignRight()},
                            headerAttributes: {style: setAlignRight()},
                            template: "#=formatAmount(recvdAmount)#",
                            sortable: false, filterable: false, width: 50,
                            footerTemplate: "<div style='text-align: right'>Total : #=formatAmount(0)#</div>"
                        }
                    ]
                },
                {
                    title: "Remaining", headerAttributes: {style: setAlignCenter()},
                    columns: [
                        {
                            field: "recvdQty",
                            title: "Qty",
                            width: 30,
                            attributes: {style: setAlignRight()},
                            headerAttributes: {style: setAlignRight()},
                            sortable: false,
                            filterable: false
                        },
                        {
                            field: "recvdAmount",
                            title: "Amount",
                            attributes: {style: setAlignRight()},
                            headerAttributes: {style: setAlignRight()},
                            template: "#=formatAmount(recvdAmount)#",
                            sortable: false, filterable: false, width: 50,
                            footerTemplate: "<div style='text-align: right'>Total : #=formatAmount(0)#</div>"
                        }
                    ]
                }
            ],
            filterable: false
        });
        gridMedicine = $("#gridMedicine").data("kendoGrid");
    }

    function resetForm() {
        window.history.back();
    }
</script>