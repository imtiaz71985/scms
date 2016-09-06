<script type="text/x-kendo-template" id="gridToolbar">
<ul id="menuGrid" class="kendoGridMenu">
    <sec:access url="/medicineReturn/showSellReturn">
        <li onclick="newRecord();"><i class="fa fa-plus-square"></i>New</li>
    </sec:access>
    <sec:access url="/medicineSellInfo/update">
        <li onclick="editRecord();"><i class="fa fa-file"></i>View Details</li>
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
                    template: "#=formatAmount(formatFloorAmount(totalAmount))#",
                    sortable: false,
                    filterable: false
                },
                {
                    field: "returnDate", title: "Return Date", width: 100, sortable: false,
                    filterable: {cell: {template: formatFilterableDate,showOperators: false}},
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
    function editRecord() {
        if (executeCommonPreConditionForSelectKendo(gridMedicineSellReturnInfo, 'voucher') == false) {
            return;
        }
        showLoadingSpinner(true);
        var id = getSelectedIdFromGridKendo(gridMedicineSellReturnInfo);
        var loc = "${createLink(controller: 'medicineReturn', action: 'details')}?id=" + id;
        router.navigate(formatLink(loc));
        return false;
    }
</script>