<script language="javascript">
    var voucherNo,quantity,gridMedicineReturnInfo, dataSource, totalAmount = 0;

    $(document).ready(function () {
        voucherNo = '${traceNo}';
        totalAmount = ${totalAmount};
        $("#voucherNo").text(voucherNo);
        $("#dateStr").text(moment('${returnDate}').format('DD-MM-YYYY'));
        initMedicineRetrunInfoGrid();
        gridMedicineReturnInfo.setDataSource(new kendo.data.DataSource({data: ${gridModelMedicine}}));
        $("#footerSpan").text(formatCeilAmount(totalAmount));
        $('#gridMedicine  > .k-grid-content').height(410);
        defaultPageTile("Medicine return details", "medicineReturn/show");

    });
    function  resetForm(){
        window.history.back();
    }
    function initMedicineRetrunInfoGrid() {
        $("#gridMedicine").kendoGrid({
            dataSource  : getBlankDataSource,
            height      : 470,
            selectable  : true,
            sortable    : true,
            resizable   : true,
            reorderable : true,
            pageable    : false,
            columns: [
                {
                    field: "medicineName",
                    title: "Medicine Name",
                    width: 100,
                    sortable: false,
                    filterable: false
                },
                {
                    field: "quantity",
                    title: "Return Quantity",
                    width: 50,
                    sortable: false,
                    filterable: false
                },
                {
                    field: "amount",
                    title: "Return Amount",
                    attributes: {style: setAlignRight()},
                    headerAttributes: {style: setAlignRight()},
                    template: "#=formatFloorAmount(amount)#",
                    sortable: false,filterable: false,width: 50,
                    footerTemplate:"<div style='text-align: right'>Total amount : <span id='footerSpan'>#=formatFloorAmount(0)#</span></div>"
                }
            ],
            filterable: false

        });
        gridMedicineReturnInfo = $("#gridMedicine").data("kendoGrid");
        $('#gridMedicine  > .k-grid-content').height(410);
    }
</script>