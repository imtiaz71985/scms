<script type="text/x-kendo-template" id="gridToolbar">
<ul id="menuGrid" class="kendoGridMenu">
    <sec:access url="/medicineReturn/showSellReturn">
        <li onclick="newRecord();"><i class="fa fa-plus-square"></i>New</li>
    </sec:access>
</ul>
</script>
<script language="javascript">
    var gridMedicineSellReturnInfo, dataSource;

    $(document).ready(function () {
        onLoadMedicineSellReturnPage();
        initMedicineSellReturnGrid();
    });

    function onLoadMedicineSellReturnPage() {
        defaultPageTile("Medicine return", null);
    }

    function initDataSource() {
        dataSource = new kendo.data.DataSource({
            transport: {
                read: {
                    url: "${createLink(controller: 'medicineReturn', action: 'list')}",
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
                        traceNo: {type: "string"},
                        returnBy: {type: "string"},
                        hospitalCode: {type: "string"},
                        totalAmount: {type: "number"},
                        returnDate: {type: "date"}
                    }
                },
                parse: function (data) {
                    checkIsErrorGridKendo(data);
                    return data;
                }
            },
            pageSize: getDefaultPageSize(),
            serverPaging: true,
            serverFiltering: true,
            serverSorting: true
        });
    }

    function initMedicineSellReturnGrid() {
        initDataSource();
        $("#gridMedicineSellReturnInfo").kendoGrid({
            dataSource: dataSource,
            height: getGridHeightKendo(),
            selectable: true,
            sortable: true,
            resizable: true,
            reorderable: true,
            dataBound: gridDataBound,
            pageable: {
                refresh: true,
                pageSizes: getDefaultPageSizes(),
                buttonCount: 4
            },
            columns: [
                {
                    field: "traceNo",
                    title: "Voucher No",
                    width: 100,
                    sortable: false,
                    filterable: kendoCommonFilterable(97)
                },
                {
                    field: "totalAmount",
                    title: "Total Amount",
                    width: 50,
                    attributes: {style: setAlignRight()},
                    headerAttributes: {style: setAlignRight()},
                    template: "#=formatAmount(formatCeilAmount(totalAmount))#",
                    sortable: false,
                    filterable: false
                },
                {
                    field: "returnDate", title: "Return Date", width: 100, sortable: false,
                    filterable: {cell: {template: formatFilterableDate}},
                    attributes: {style: setAlignCenter()}, headerAttributes: {style: setAlignCenter()},
                    template: "#=kendo.toString(kendo.parseDate(returnDate, 'yyyy-MM-dd'), 'dd-MM-yyyy')#"
                }
            ],
            filterable: {
                mode: "row"
            },
            toolbar: kendo.template($("#gridToolbar").html())
        });
        gridMedicineSellReturnInfo = $("#gridMedicineSellReturnInfo").data("kendoGrid");
        $("#menuGrid").kendoMenu();
    }
    function newRecord() {
        showLoadingSpinner(true);
        var loc = "${createLink(controller: 'medicineReturn', action: 'showSellReturn')}";
        router.navigate(formatLink(loc));
        return false;
    }
</script>