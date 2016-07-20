<div class="container-fluid">
    <div class="row">
        <div id="gridRequisitionHO"></div>
    </div>
</div>


<script type="text/x-kendo-template" id="gridToolbar">
<ul id="menuGrid" class="kendoGridMenu">
    <sec:access url="/requisition/updateHO">
        <li onclick="editRecord();"><i class="fa fa-check-circle-o"></i>Adjustment</li>
    </sec:access>
%{--    <sec:access url="/requisition/approveRequest">
        <li onclick="approveRequest();"><i class="fa fa-check-circle-o"></i>Approve</li>
    </sec:access>--}%
</ul>
</script>

<script language="javascript">
    var gridRequisitionHO, dataSource;

    $(document).ready(function () {
        onLoadgRequisitionHOPage();
        initRequisitionPRGrid();
    });

    function onLoadgRequisitionHOPage() {
        defaultPageTile("Requisition Request", null);
    }

    function initDataSource() {
        dataSource = new kendo.data.DataSource({
            transport: {
                read: {
                    url: "${createLink(controller: 'requisition', action: 'listHO')}",
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
                        approvedAmount: {type: "number"},
                        requisitionDate: {type: "date"},
                        isApproved: {type: "boolean"},
                        isReceived: {type: "boolean"},
                        receiveInProcess: {type: "boolean"}
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
        $("#gridRequisitionHO").kendoGrid({
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
                    width: 50, sortable: false,
                    filterable: kendoCommonFilterable(97)
                },
                {
                    field: "requisitionBy",
                    title: "Requisition Details",
                    width: 100, sortable: false,
                    template: "#=hospitalName # --(By #= requisitionBy# )"
                },
                {
                    field: "requisitionDate", title: "Requisition Date", width: 50, sortable: false,
                    filterable: false,
                    attributes: {style: setAlignCenter()}, headerAttributes: {style: setAlignCenter()},
                    template: "#=kendo.toString(kendo.parseDate(requisitionDate, 'yyyy-MM-dd'), 'dd-MM-yyyy')#"
                },
                {
                    field: "totalAmount",
                    title: "Req Amount",
                    width: 40,
                    attributes: {style: setAlignRight()},
                    headerAttributes: {style: setAlignRight()},
                    template: "#=formatAmount(totalAmount)#",
                    sortable: false, filterable: false
                },
                {
                    field: "approvedDate", title: "Approved Date", width: 40, sortable: false,
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
                    sortable: false, filterable: false
                },
                {
                    field: "isApproved",
                    title: "Approved",
                    width: 30,
                    attributes: {style: setAlignCenter()},
                    headerAttributes: {style: setAlignCenter()},
                    template: "#=isApproved?'YES':'NO'#",
                    sortable: false, filterable: false
                },
                {
                    field: "isReceived",
                    title: "Received",
                    width: 30,
                    attributes: {style: setAlignCenter()},
                    headerAttributes: {style: setAlignCenter()},
                    template: "#=isReceived?'YES':receiveInProcess?'Partial Receive':'NO'#",
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
        gridRequisitionHO = $("#gridRequisitionHO").data("kendoGrid");
        $("#menuGrid").kendoMenu();
    }
    function showDetails(e) {
        var dataItem = this.dataItem($(e.currentTarget).closest("tr"));
        var loc = "${createLink(controller: 'requisition', action: 'detailsHO')}?id=" + dataItem.id;
        router.navigate(formatLink(loc));
        return false;
    }

    function editRecord() {
        if (executeCommonPreConditionForSelectKendo(gridRequisitionHO, 'requisition') == false) {
            return;
        }
        var obj = getSelectedObjectFromGridKendo(gridRequisitionHO);
        if (obj.isApproved) {
            showError('Approved requisition could not be updated.');
            return false;
        }
        showLoadingSpinner(true);
        var loc = "${createLink(controller: 'requisition', action: 'selectHO')}?id=" + obj.id;
        router.navigate(formatLink(loc));
        return false;
    }
    function approveRequest() {
        if (executeCommonPreConditionForSelectKendo(gridRequisitionHO, 'requisition') == false) {
            return;
        }
        var obj = getSelectedObjectFromGridKendo(gridRequisitionHO);
        if (obj.isApproved) {
            showError('Already approve this requisition');
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
            var selectedRow = gridRequisitionHO.select();
            var allItems = gridRequisitionHO.items();
            var selectedIndex = allItems.index(selectedRow);
            gridRequisitionHO.removeRow(selectedRow);
            gridRequisitionHO.dataSource.insert(selectedIndex, newEntry);
            showSuccess(result.message);
        }
    }

</script>
