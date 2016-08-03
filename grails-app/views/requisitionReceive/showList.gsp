<script type="text/x-kendo-template" id="gridToolbar">
<ul id="menuGrid" class="kendoGridMenu">
    <sec:access url="/requisitionReceive/acknowledgement">
        <li onclick="acknowledgement();"><i class="fa fa-certificate fa-2x"></i>Acknowledgement</li>
    </sec:access>
</ul>
</script>
<div class="container-fluid">
    <div class="row">
        <div id="gridRequisitionReceive"></div>
    </div>
</div>

<script language="javascript">
    var gridRequisitionReceive, dataSource;

    $(document).ready(function () {
        onLoadRequisitionPage();
        initRequisitionGrid();
    });

    function onLoadRequisitionPage() {
        defaultPageTile("Requisition receive", null);
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
                        requisitionDate: {type: "date"},
                        approvedDate: {type: "date"},
                        isActionComplete: {type: "boolean"},
                        receiveInProcess: {type: "boolean"}
                    }
                },
                parse: function (data) {
                    checkIsErrorGridKendo(data);
                    return data;
                }
            },
            pageSize: getDefaultPageSize(),
            sort: {field: 'isActionComplete', dir: 'asc'},
            serverPaging: true,
            serverFiltering: true,
            serverSorting: true
        });
    }

    function initRequisitionGrid() {
        initDataSource();
        $("#gridRequisitionReceive").kendoGrid({
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
                    field: "requisitionDate", title: "Requisition Date", width: 80, sortable: false,filterable: false,
                    attributes: {style: setAlignCenter()}, headerAttributes: {style: setAlignCenter()},
                    template: "#=kendo.toString(kendo.parseDate(requisitionDate, 'yyyy-MM-dd'), 'dd-MM-yyyy')#  (by - #=requisitionBy #)"
                },
                {
                    field: "approvedDate", title: "Approved Date", width: 50, sortable: false,filterable: false,
                    attributes: {style: setAlignCenter()}, headerAttributes: {style: setAlignCenter()},
                    template: "#=approvedDate?kendo.toString(kendo.parseDate(approvedDate, 'yyyy-MM-dd'), 'dd-MM-yyyy'):''#"
                },
                {
                    field: "isActionComplete", title: "Transaction Completed",
                    attributes: {style: setAlignCenter()},
                    headerAttributes: {style: setAlignCenter()},
                    template: "#=isActionComplete?'YES':receiveInProcess?'Partial Receive':'NO'#",
                    sortable: false,filterable: false,width: 50
                },
                {
                    command: {
                        text: " ",
                        click: showDetails,
                        className: "fa fa-search-plus fa-2x"
                    }, width: 30,title: "Details"
                }
            ],
            filterable: {
                mode: "row"
            },
            toolbar: kendo.template($("#gridToolbar").html())
        });
        gridRequisitionReceive = $("#gridRequisitionReceive").data("kendoGrid");
        $("#menuGrid").kendoMenu();
    }

    function showDetails(e) {
        var dataItem2 = this.dataItem($(e.currentTarget).closest("tr"));
        var loc2 = "${createLink(controller: 'requisitionReceive', action: 'detailsReceive')}?id=" + dataItem2.id;
        router.navigate(formatLink(loc2));
        return false;
    }

    function acknowledgement(e) {
        if (executeCommonPreConditionForSelectKendo(gridRequisitionReceive, 'record') == false) {
            return;
        }
        showLoadingSpinner(true);
        var id = getSelectedIdFromGridKendo(gridRequisitionReceive);
        var loc1 = "${createLink(controller: 'requisitionReceive', action: 'acknowledgement')}?id=" + id;
        router.navigate(formatLink(loc1));
        return false;
    }

</script>
