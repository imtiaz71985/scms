<div class="container-fluid">
    <div class="row">
        <div id="gridRequisition"></div>
    </div>
</div>


<script type="text/x-kendo-template" id="gridToolbar">
<ul id="menuGrid" class="kendoGridMenu">
    <sec:access url="/requisition/create">
        <li onclick="newRecord();"><i class="fa fa-plus-square"></i>New</li>
    </sec:access>
    <sec:access url="/requisition/update">
        <li onclick="editRecord();"><i class="fa fa-edit"></i>Edit</li>
    </sec:access>
    <sec:access url="/requisition/sendRequisition">
        <li onclick="sendRequisition();"><i class="fa fa-mail-forward"></i>Send</li>
    </sec:access>
</ul>
</script>

<script language="javascript">
    var gridRequisition, dataSource;

    $(document).ready(function () {
        onLoadRequisitionPage();
        initRequisitionGrid();
    });

    function newRecord() {
        showLoadingSpinner(true);
        var loc = "${createLink(controller: 'requisition', action: 'showDetails')}";
        router.navigate(formatLink(loc));
        return false;
    }
    function onLoadRequisitionPage() {
        defaultPageTile("Medicine Requisition", null);
    }

    function initDataSource() {
        dataSource = new kendo.data.DataSource({
            transport: {
                read: {
                    url: "${createLink(controller: 'requisition', action: 'list')}",
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
                        totalAmount: {type: "number"},
                        requisitionDate: {type: "date"},
                        isSend: {type: "boolean"},
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
                    field: "requisitionBy",
                    title: "Requisition By",
                    width: 100,
                    sortable: false,
                    filterable: kendoCommonFilterable(97)
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
                    field: "isSend",
                    title: "Send",
                    width: 20,
                    attributes: {style: setAlignCenter()},
                    headerAttributes: {style: setAlignCenter()},
                    template: "#=isSend?'YES':'NO'#",
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
        gridRequisition = $("#gridRequisition").data("kendoGrid");
        $("#menuGrid").kendoMenu();
    }
    function showDetails(e) {
        var dataItem = this.dataItem($(e.currentTarget).closest("tr"));
        var loc = ''
        if(dataItem.isApproved){
            loc = "${createLink(controller: 'requisition', action: 'detailsHO')}?id=" + dataItem.id;
        }else{
            loc = "${createLink(controller: 'requisition', action: 'details')}?id=" + dataItem.id;
        }
        router.navigate(formatLink(loc));
        return false;
    }

    function editRecord() {
        if (executeCommonPreConditionForSelectKendo(gridRequisition, 'requisition') == false) {
            return;
        }
        var obj = getSelectedObjectFromGridKendo(gridRequisition);
        if (obj.isSend) {
            showError('Could not update this requisition');
            return false;
        }
        showLoadingSpinner(true);
        var loc = "${createLink(controller: 'requisition', action: 'selectForEdit')}?id=" + obj.id;
        router.navigate(formatLink(loc));
        return false;
    }
    function sendRequisition() {
        if (executeCommonPreConditionForSelectKendo(gridRequisition, 'requisition') == false) {
            return;
        }
        var obj = getSelectedObjectFromGridKendo(gridRequisition);
        if (obj.isSend) {
            showError('Already send this requisition');
            return false;
        }
        showLoadingSpinner(true);
        var actionUrl = "${createLink(controller: 'requisition', action: 'sendRequisition')}?id=" + obj.id;
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
            var selectedRow = gridRequisition.select();
            var allItems = gridRequisition.items();
            var selectedIndex = allItems.index(selectedRow);
            gridRequisition.removeRow(selectedRow);
            gridRequisition.dataSource.insert(selectedIndex, newEntry);
            showSuccess(result.message);
        }
    }

</script>
