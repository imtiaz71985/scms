<div class="container-fluid">
    <div class="row">
        <div id="gridRequisitionPR"></div>
    </div>
</div>


<script type="text/x-kendo-template" id="gridToolbar">
<ul id="menuGrid" class="kendoGridMenu">
    <sec:access url="/requisition/update">
        <li onclick="editRecord();"><i class="fa fa-edit"></i>Adjustment</li>
    </sec:access>
    <sec:access url="/requisition/sendRequest">
        <li onclick="sendRequest();"><i class="fa fa-check-circle-o"></i>Approve</li>
    </sec:access>
</ul>
</script>

<script language="javascript">
    var gridRequisitionPR, dataSource;

    $(document).ready(function () {
        onLoadgRequisitionPRPage();
        initRequisitionPRGrid();
    });

    function onLoadgRequisitionPRPage() {
        defaultPageTile("Requisition Request", null);
    }

    function initDataSource() {
        dataSource = new kendo.data.DataSource({
            transport: {
                read: {
                    url: "${createLink(controller: 'requisition', action: 'listPR')}",
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
                        hospitalName: {type: "string"},
                        totalAmount: {type: "number"},
                        requisitionDate: {type: "date"},
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

    function initRequisitionPRGrid() {
        initDataSource();
        $("#gridRequisitionPR").kendoGrid({
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
                    width: 60,
                    sortable: false,
                    filterable: kendoCommonFilterable(97)
                },
                {
                    field: "requisitionBy",
                    title: "Requisition Details",
                    width: 100,
                    sortable: false,
                    template: "#=hospitalName # --(By #= requisitionBy# )"
                },
                {
                    field: "requisitionDate", title: "Requisition Date", width: 100, sortable: false,
                    filterable: {cell: {template: formatFilterableDate}},
                    attributes: {style: setAlignCenter()}, headerAttributes: {style: setAlignCenter()},
                    template: "#=kendo.toString(kendo.parseDate(requisitionDate, 'yyyy-MM-dd'), 'dd-MM-yyyy')#"
                },
                {
                    field: "totalAmount",
                    title: "Total Amount",
                    width: 50,
                    attributes: {style: setAlignRight()},
                    headerAttributes: {style: setAlignRight()},
                    template: "#=formatAmount(totalAmount)#",
                    sortable: false,
                    filterable: false
                },
                {
                    field: "isApproved",
                    title: "Approved",
                    width: 30,
                    attributes: {style: setAlignCenter()},
                    headerAttributes: {style: setAlignCenter()},
                    template: "#=isApproved?'YES':'NO'#",
                    sortable: false,
                    filterable: false
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
        gridRequisitionPR = $("#gridRequisitionPR").data("kendoGrid");
        $("#menuGrid").kendoMenu();
    }
    function showDetails(e) {
        var dataItem = this.dataItem($(e.currentTarget).closest("tr"));
        var loc = "${createLink(controller: 'requisition', action: 'details')}?id=" + dataItem.id;
        router.navigate(formatLink(loc));
        return false;
    }

    function editRecord() {
        if (executeCommonPreConditionForSelectKendo(gridRequisitionPR, 'requisition') == false) {
            return;
        }
        showLoadingSpinner(true);
        var id = getSelectedIdFromGridKendo(gridRequisitionPR);
        var loc = "${createLink(controller: 'requisition', action: 'selectPR')}?id=" + id;
        router.navigate(formatLink(loc));
        return false;
    }
    function sendRequest() {
        if (executeCommonPreConditionForSelectKendo(gridRequisitionPR, 'requisition') == false) {
            return;
        }
        var obj = getSelectedObjectFromGridKendo(gridRequisitionPR);
        if (obj.isSend) {
            showError('Already send this requisition');
            return false;
        }
        showLoadingSpinner(true);
        var actionUrl = "${createLink(controller: 'requisition', action: 'approveRequest')}?id=" + obj.id;
        jQuery.ajax({
            type: 'post',
            url: actionUrl,
            success: function (data, textStatus) {
                executePostCondition(data);
            },
            error: function (XMLHttpRequest, textStatus, errorThrown) {
            },
            complete: function (XMLHttpRequest, textStatus) {
                showLoadingSpinner(false);
            },
            dataType: 'json'
        });
        return false;
    }


    function executePostCondition(result) {
        if (result.isError) {
            showError(result.message);
            showLoadingSpinner(false);
        } else {
            var newEntry = result.requisition;
            var selectedRow = gridRequisitionPR.select();
            var allItems = gridRequisitionPR.items();
            var selectedIndex = allItems.index(selectedRow);
            gridRequisitionPR.removeRow(selectedRow);
            gridRequisitionPR.dataSource.insert(selectedIndex, newEntry);
            showSuccess(result.message);
        }
    }

</script>
