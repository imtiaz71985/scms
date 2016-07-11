<div class="container-fluid">
    <div class="row">
        <div id="gridRequisition"></div>
    </div>
</div>


<script type="text/x-kendo-template" id="gridToolbar">
<ul id="menuGrid" class="kendoGridMenu">
    <sec:access url="/requisitionReceive/update">
        <li onclick="editRecord();"><i class="fa fa-edit"></i>Receive</li>
    </sec:access>
</ul>
</script>

<script language="javascript">
    var gridRequisition, dataSource;

    $(document).ready(function () {
        onLoadRequisitionPage();
        initRequisitionGrid();
    });


    function onLoadRequisitionPage() {
        defaultPageTile("Medicine Requisition", null);
    }

    function initDataSource() {
        dataSource = new kendo.data.DataSource({
            transport: {
                read: {
                    url: "${createLink(controller: 'requisitionReceive', action: 'list')}",
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
                        requisitionBy: {type: "string"},
                        reqAmount: {type: "number"},
                        approvedAmount: {type: "number"},
                        requisitionDate: {type: "date"},
                        approvedDate: {type: "date"},
                        deliveryDate: {type: "date"},
                        isApproved: {type: "boolean"}
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

    function initRequisitionGrid() {
        initDataSource();
        $("#gridRequisition").kendoGrid({
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
                    field: "requisitionNo",
                    title: "Requisition No",
                    width: 100,
                    sortable: false,
                    filterable: kendoCommonFilterable(97)
                },
                {
                    field: "requisitionDate", title: "Requisition Date", width: 60, sortable: false,
                    filterable: false,
                    attributes: {style: setAlignCenter()}, headerAttributes: {style: setAlignCenter()},
                    template: "#=kendo.toString(kendo.parseDate(requisitionDate, 'yyyy-MM-dd'), 'dd-MM-yyyy')#"
                },
                {
                    field: "reqAmount",
                    title: "Req Amount",
                    width: 50,
                    attributes: {style: setAlignRight()},
                    headerAttributes: {style: setAlignRight()},
                    template: "#=formatAmount(reqAmount)#",
                    sortable: false,
                    filterable: false
                },
                {
                    field: "approvedDate", title: "Approved Date", width: 50, sortable: false,
                    filterable: false,
                    attributes: {style: setAlignCenter()}, headerAttributes: {style: setAlignCenter()},
                    template: "#=approvedDate?kendo.toString(kendo.parseDate(approvedDate, 'yyyy-MM-dd'), 'dd-MM-yyyy'):''#"
                },
                {
                    field: "approvedAmount",
                    title: "Apvd Amount",
                    width: 40,
                    attributes: {style: setAlignRight()},
                    headerAttributes: {style: setAlignRight()},
                    template: "#=formatAmount(approvedAmount)#",
                    sortable: false,
                    filterable: false
                },
                {
                    field: "deliveryDate", title: "Delivery Date", width: 50, sortable: false,
                    filterable: false,
                    attributes: {style: setAlignCenter()}, headerAttributes: {style: setAlignCenter()},
                    template: "#=deliveryDate?kendo.toString(kendo.parseDate(deliveryDate, 'yyyy-MM-dd'), 'dd-MM-yyyy'):''#"
                },
                {
                    command: {
                        text: " ",
                        click: showDetails,
                        className: "fa fa-search-plus fa-2x"
                    }, width: 30
                }
            ],
            filterable: {
                mode: "row"
            },
            toolbar: kendo.template($("#gridToolbar").html())
        });
        gridRequisition = $("#gridRequisition").data("kendoGrid");
        $("#menuGrid").kendoMenu();
    }
    function showDetails(e) {
        var dataItem = this.dataItem($(e.currentTarget).closest("tr"));
        var loc = "${createLink(controller: 'requisition', action: 'details')}?id=" + dataItem.id;
        router.navigate(formatLink(loc));
        return false;
    }

    function editRecord() {
        if (executeCommonPreConditionForSelectKendo(gridRequisition, 'requisition') == false) {
            return;
        }
        showLoadingSpinner(true);
        var id = getSelectedIdFromGridKendo(gridRequisition);
        var loc = "${createLink(controller: 'requisitionReceive', action: 'selectForEdit')}?id=" + id;
        router.navigate(formatLink(loc));
        return false;
    }

    function executePostCondition(result) {
        if (result.isError) {
            showError(result.message);
            showLoadingSpinner(false);
        } else {
            var newEntry = result.requisition;
            var selectedRow = gridRequisition.select();
            var allItems = gridRequisition.items();
            var selectedIndex = allItems.index(selectedRow);
            gridRequisition.removeRow(selectedRow);
            gridRequisition.dataSource.insert(selectedIndex, newEntry);
            showSuccess(result.message);
        }
    }

</script>
