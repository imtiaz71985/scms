<div class="panel panel-primary">
    <div class="panel-heading">
        <div class="panel-title">
            Requisition receive details
        </div>
    </div>

    <div class="panel-body">
        <div class="form-group">
            <div class="form-group">
                <label>Requisition No : <label id="reqNo"></label></label>
            </div>
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
        dataSource = new kendo.data.DataSource({data: ${gridModelMedicine}});
        dataSource.group({field: "receiveDate" });
        initRequisitionGrid();
        requisitionNo = '${requisitionNo}';
        $("#reqNo").text(requisitionNo);
        $("#gridMedicine").data("kendoGrid").hideColumn("receiveDate");
        defaultPageTile("Receive details", 'requisitionReceive/showList');
    });

    function initRequisitionGrid() {
        $("#gridMedicine").kendoGrid({
            dataSource: dataSource,
            height: $("#page-wrapper").height() - 150,
            selectable: true,
            sortable: true,
            resizable: true,
            reorderable: true,
            pageable: false,
            columns: [
                {
                    field: "receiveDate",
                    title: "Received Date",
                    width: 30,
                    sortable: false,
                    filterable: false
                },                {
                    field: "type",
                    title: "Type",
                    width: 30,
                    sortable: false,
                    filterable: false
                },
                {
                    field: "genericName",
                    title: "Generic Name",
                    width: 50,
                    sortable: false,
                    filterable: false
                },                {
                    field: "medicineName",
                    title: "Medicine Name",
                    width: 80,
                    sortable: false,
                    filterable: false
                },
                {
                    field: "vendor",
                    title: "Vendor",
                    width: 60,
                    sortable: false,
                    filterable: false
                },
                {
                    field: "receiveQty", title: "Receive Qty", width: 30,
                    attributes: {style: setAlignRight()},
                    headerAttributes: {style: setAlignRight()},
                    sortable: false, filterable: false
                }
            ],filterable: false
        });
        gridMedicine = $("#gridMedicine").data("kendoGrid");
    }

    function resetForm() {
        $("#create").hide();
        var loc = "${createLink(controller: 'requisitionReceive', action: 'showList')}";
        router.navigate(formatLink(loc));
    }

</script>