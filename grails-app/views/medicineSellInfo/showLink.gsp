<script type="text/x-kendo-template" id="gridToolbar">
<ul id="menuGrid" class="kendoGridMenu">
    <li onclick="historyBack();"><i class="fa fa-backward"></i>Back to previous page</li>
    <sec:access url="/medicineSellInfo/update">
        <li onclick="viewDetails();"><i class="fa fa-file"></i>View Details</li>
    </sec:access>
</ul>
</script>
<div class="container-fluid">
    <div class="row">
        <div id="gridMedicineSellInfo"></div>
    </div>
</div>
<script language="javascript">
    var gridMedicineSellInfo, dataSource,dateField,rowNumber=1;

    $(document).ready(function () {
        defaultPageTile("Sale Medicine", "reports/showMonthlyStatus");
        dateField = '${dateField}';
        initMedicineSellInfoGrid();
    });

    function initDataSource() {
        dataSource = new kendo.data.DataSource({
            transport: {
                read: {
                    url: "${createLink(controller: 'medicineSellInfo', action: 'list')}?dateField="+dateField,
                    dataType: "json",
                    type: "post"
                }
            },
            schema: {
                type: 'json',
                data: "list", total: "count",
                model: {
                    fields: {
                        id: {type: "number"},
                        version: {type: "number"},
                        voucherNo: {type: "string"},
                        seller: {type: "string"},
                        totalAmount: {type: "number"},
                        sellDate: {type: "date"}
                    }
                },
                parse: function (data) {
                    checkIsErrorGridKendo(data);
                    return data;
                }
            },
            aggregate: [
                {field: "totalAmount", aggregate: "sum" }
            ],
            pageSize: false,
            serverPaging: true,
            serverFiltering: true,
            serverSorting: true
        });
    }

    function initMedicineSellInfoGrid() {
        initDataSource();
        $("#gridMedicineSellInfo").kendoGrid({
            dataSource: dataSource,
            height: getGridHeightKendo(),
            selectable: true,
            sortable: true,
            resizable: true,
            reorderable: true,
            dataBound: gridDataBound,
            pageable: false,
            columns: [
                {title: "SL#", width: 15, sortable: false, filterable: false,template:"#= rowNumber++ #"},
                {
                    field: "sellDate", title: "Date", width: 100, sortable: false,
                    filterable: {cell: {template: formatFilterableDate, showOperators:false}},
                    attributes: {style: setAlignCenter()}, headerAttributes: {style: setAlignCenter()},
                    footerAttributes: {style: setAlignCenter()},
                    template: "#=kendo.toString(kendo.parseDate(sellDate, 'yyyy-MM-dd'), 'dd-MM-yyyy')#",
                    footerTemplate: "Total"
                },
                {
                    field: "voucherNo",
                    title: "Voucher No",
                    width: 100,
                    sortable: false,
                    filterable: kendoCommonFilterable(97),
                    footerTemplate: ""
                },
                {
                    field: "totalAmount",
                    title: "Total Amount",
                    width: 50,
                    attributes: {style: setAlignRight()},
                    headerAttributes: {style: setAlignRight()},
                    template: "#=formatAmount(formatCeilAmount(totalAmount))#",
                    sortable: false,filterable: false,
                    footerAttributes: {style: setAlignRight()},
                    footerTemplate: "#=formatCeilAmount(sum)#"
                }
            ],
            filterable: {
                mode: "row"
            },
            toolbar: kendo.template($("#gridToolbar").html())
        });
        gridMedicineSellInfo = $("#gridMedicineSellInfo").data("kendoGrid");
        $("#menuGrid").kendoMenu();
    }
    function viewDetails() {
        if (executeCommonPreConditionForSelectKendo(gridMedicineSellInfo, 'voucher') == false) {
            return;
        }
        showLoadingSpinner(true);
        var id = getSelectedIdFromGridKendo(gridMedicineSellInfo);
        var loc = "${createLink(controller: 'medicineSellInfo', action: 'select')}?id=" + id;
        router.navigate(formatLink(loc));
        return false;
    }

</script>