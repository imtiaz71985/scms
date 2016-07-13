<div id="application_top_panel" class="panel panel-primary">
    <div class="panel-heading">
        <div class="panel-title">
            Medicine requisition details
        </div>
    </div>

    <div class="panel-body">
        <div class="form-group">
            <div id="gridMedicine"></div>
        </div>
    </div>

    <div class="panel-footer">
        <button id="create" name="create" type="button" data-role="button"
                class="k-button k-button-icontext" role="button" tabindex="1"
                onclick='generatePR();' aria-disabled="false">
            <span class="k-icon k-i-plus"></span>Generate PR
        </button>
        <button id="clearFormButton" name="clearFormButton" type="button" data-role="button"
                class="k-button k-button-icontext" role="button" tabindex="2"
                aria-disabled="false" onclick='resetForm();'>
            <span class="k-icon k-i-close"></span>Close
        </button>
    </div>
</div>

<script language="javascript">
    var gridRequisition, dataSource, requisitionNo,isApplicable = false;

    $(document).ready(function () {
        initRequisitionGrid();
        requisitionNo = '${requisitionNo}';
        if(!${requisition.isReceived}){
            isApplicable = true;
        }
        gridRequisition.setDataSource(new kendo.data.DataSource({data: ${gridModelMedicine}}));
        $("#footerSpan").text(formatAmount(${totalAmount}));
        $("#footerSpanApvd").text(formatAmount(${apvdAmount}));
        defaultPageTile("Requisition details", 'requisition/showHO');
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
                    width: 70,
                    sortable: false,
                    filterable: false
                },
                {
                    field: "medicineName",
                    title: "Medicine Name",
                    width: 100,
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
                    title: "Requisition", headerAttributes: {style: setAlignCenter()},
                    columns: [
                        {
                            field: "quantity",
                            title: "Qty",
                            width: 30,
                            attributes: {style: setAlignRight()},
                            headerAttributes: {style: setAlignRight()},
                            sortable: false,
                            filterable: false
                        },
                        {
                            field: "amount",
                            title: "Amount",
                            attributes: {style: setAlignRight()},
                            headerAttributes: {style: setAlignRight()},
                            template: "#=formatAmount(amount)#",
                            sortable: false, filterable: false, width: 50,
                            footerTemplate: "<div style='text-align: right'>Total : <span id='footerSpan'>#=formatAmount(0)#</span></div>"
                        }
                    ]
                },
                {
                    title: "Approved", headerAttributes: {style: setAlignCenter()},
                    columns: [
                        {
                            field: "apvdQty",
                            title: "Qty",
                            width: 30,
                            attributes: {style: setAlignRight()},
                            headerAttributes: {style: setAlignRight()},
                            sortable: false,
                            filterable: false
                        },
                        {
                            field: "apvdAmount",
                            title: "Amount",
                            attributes: {style: setAlignRight()},
                            headerAttributes: {style: setAlignRight()},
                            template: "#=formatAmount(apvdAmount)#",
                            sortable: false, filterable: false, width: 50,
                            footerTemplate: "<div style='text-align: right'>Total : <span id='footerSpanApvd'>#=formatAmount(0)#</span></div>"
                        }
                    ]
                }
            ],
            filterable: false
        });
        gridRequisition = $("#gridMedicine").data("kendoGrid");
    }

    function resetForm() {
        isApplicable = false;
        window.history.back();
    }

    function generatePR() {
        if(isApplicable){
            showLoadingSpinner(true);
            var msg = 'Do you want to generate PR now?',
                    url = "${createLink(controller: 'requisition', action: 'generatePR')}?requisitionNo=" + requisitionNo;
            confirmDownload(msg, url);
        }else{
            showError("Could not generate PR for this Requisition");
        }
    }
</script>