<script language="javascript">
    var voucherNo,quantity,gridMedicineSellInfo, dataSource, dropDownMedicine,
            medicineName, unitPrice = 0, totalAmount = 0, availableStock = 0;

    $(document).ready(function () {
        voucherNo = '${voucherNo}';
        totalAmount = ${totalAmount};
        $("#voucherNo").text(voucherNo);
        $("#dateStr").text('${sellDate}');
        initMedicineSellInfoGrid();
        gridMedicineSellInfo.setDataSource(new kendo.data.DataSource({data: ${gridModelMedicine}}));
        $("#footerSpan").text(formatCeilAmount(totalAmount));
        $('#gridMedicine  > .k-grid-content').height(410);
        defaultPageTile("Sale details", "medicineSellInfo/show");

    });
    function  resetForm(){
        window.history.back();
    }
    function initMedicineSellInfoGrid() {
        $("#gridMedicine").kendoGrid({
            dataSource: getBlankDataSource,
            height: 470,
            selectable: true,
            sortable: true,
            resizable: true,
            reorderable: true,
            pageable: false,
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
                    title: "Quantity",
                    width: 50,
                    sortable: false,
                    filterable: false
                },
                {
                    field: "unitPriceTxt",
                    title: "Price/Unit",
                    width: 50,
                    sortable: false,
                    filterable: false
                },
                {
                    field: "amount",
                    title: "Amount",
                    attributes: {style: setAlignRight()},
                    headerAttributes: {style: setAlignRight()},
                    template: "#=formatAmount(amount)#",
                    sortable: false,filterable: false,width: 50,
                    footerTemplate:"<div style='text-align: right'>Total amount : <span id='footerSpan'>#=formatCeilAmount(0)#</span></div>"
                }
            ],
            filterable: false

        });
        gridMedicineSellInfo = $("#gridMedicine").data("kendoGrid");
        $('#gridMedicine  > .k-grid-content').height(410);
    }
</script>