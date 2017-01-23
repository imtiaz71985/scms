<script type="text/x-kendo-template" id="gridToolbar">
<ul id="menuGrid" class="kendoGridMenu">
    <li onclick="reloadKendoGrid();"><i class="fa fa-refresh"></i>Refresh</li>
</ul>
</script>

<script type="text/javascript">
    var gridOnlineUser, dataSource;

    $(document).ready(function () {
        initOnlineUserGrid();
    });

    function iniDataSource() {
        dataSource = new kendo.data.DataSource({
            transport: {
                read: {
                    url: "${createLink(controller: 'login', action: 'listOnlineUser')}",
                    dataType: "json",
                    type: "post"
                }
            },
            schema: {
                type: 'json',
                data: "list", total: "count",
                model: {
                    fields: {
                        id           : {type: "number"},
                        username     : {type: "string"},
                        employeeName : {type: "string"},
                        location     : {type: "string"},
                        signInTime   : {type: "date"}
                    }
                },
                parse: function (data) {
                    checkIsErrorGridKendo(data);
                    return data;
                }
            },
            pageSize: 15,
            sort: [{field:"employeeName", order:"desc"}],
            serverPaging: true,
            serverFiltering: true,
            serverSorting: true
        });
    }

    function initOnlineUserGrid() {
        iniDataSource();
        $("#gridOnlineUser").kendoGrid({
            dataSource  : dataSource,
            height      : getGridHeightKendo(),
            selectable  : true,
            sortable    : true,
            resizable   : true,
            reorderable : true,
            pageable    : {
                refresh     : false,
                pageSizes   : [10, 15, 20],
                buttonCount : 4
            },
            columns     : [
                {field: "username", title: "Login ID", width: 60, sortable: false, filterable: false},
                {field: "employeeName", title: "User Name", width: 100, sortable: false, filterable: false},
                {field: "location", title: "Location", width: 100, sortable: false, filterable: false},
                {field: "signInTime", title: "Signin Time", width: 100, sortable: false, filterable: false,
                    template: "#=kendo.toString(kendo.parseDate(signInTime, 'MM/dd/yyyy h:mm:ss tt'), 'MM/dd/yyyy h:mm:ss tt')#"}
            ],
            filterable  : {
                mode: "row"
            },
            toolbar     : kendo.template($("#gridToolbar").html())
        });
        gridOnlineUser = $("#gridOnlineUser").data("kendoGrid");
        $("#menuGrid").kendoMenu();
    }

    function reloadKendoGrid() {
        gridOnlineUser.dataSource.filter([]);
    }

</script>

<div class="container-fluid">
    <div class="row">
        <div id="gridOnlineUser"></div>
    </div>
</div>
