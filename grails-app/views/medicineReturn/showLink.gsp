<div class="container-fluid">
    <div class="row">
        <div id="gridMedicineSellReturnInfo"></div>
    </div>
</div>
<script type="text/x-kendo-template" id="gridToolbar">
<ul id="menuGrid" class="kendoGridMenu">
    <li onclick="historyBack();"><i class="fa fa-backward"></i>Back to previous page</li>
    <sec:access url="/medicineSellInfo/update">
        <li onclick="viewDetails();"><i class="fa fa-file"></i>View Details</li>
    </sec:access>
</ul>
</script>
<script language="javascript">
    var gridMedicineSellReturnInfo, dataSource,dateField;

    $(document).ready(function () {
        defaultPageTile("Medicine return", "medicineReturn/show");
        dateField = '${dateField}';
        initMedicineSellReturnGrid();
    });

    function initDataSource() {
        dataSource = new kendo.data.DataSource({
            transport: {
                read: {
                    url: "${createLink(controller: 'medicineReturn', action: 'list')}?dateField="+dateField,
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
            aggregate: [
                {field: "totalAmount", aggregate: "sum" }
            ],
            pageSize: false,
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
            pageable: false,
            columns: [
                {
                    field: "returnDate", title: "Return Date", width: 100, sortable: false,
                    filterable: {cell: {template: formatFilterableDate,showOperators: false}},
                    attributes: {style: setAlignCenter()}, headerAttributes: {style: setAlignCenter()},
                    footerAttributes: {style: setAlignCenter()},footerTemplate: "",
                    template: "#=kendo.toString(kendo.parseDate(returnDate, 'yyyy-MM-dd'), 'dd-MM-yyyy')#"
                },
                {
                    field: "traceNo",
                    title: "Voucher No",
                    width: 100, sortable: false,
                    footerAttributes: {style: setAlignRight()},
                    footerTemplate: "",
                    filterable: kendoCommonFilterable(97)
                },
                {
                    field: "totalAmount",
                    title: "Total Amount",
                    width: 50,
                    attributes: {style: setAlignRight()},
                    headerAttributes: {style: setAlignRight()},
                    footerAttributes: {style: setAlignRight()},
                    template: "#=formatAmount(formatFloorAmount(totalAmount))#",
                    footerTemplate: "#=formatCeilAmount(sum)#",
                    sortable: false,filterable: false
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

    function viewDetails() {
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
