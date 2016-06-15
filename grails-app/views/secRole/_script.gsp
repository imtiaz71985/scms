<script type="text/x-kendo-template" id="gridToolbar">
<ul id="menuGrid" class="kendoGridMenu">
    <sec:access url="/secRole/create">
        <li onclick="showForm();"><i class="fa fa-plus-square-o"></i>New</li>
    </sec:access>
    <sec:access url="/secRole/update">
        <li onclick="editSecRole();"><i class="fa fa-edit"></i>Edit</li>
    </sec:access>
    <sec:access url="/secRole/delete">
        <li onclick="deleteSecRole();"><i class="fa fa-trash-o"></i>Delete</li>
    </sec:access>
    <sec:access url="/secUserSecRole/show">
        <li onclick="showUserRole();"><i class="fa fa-user"></i>User</li>
    </sec:access>
</ul>
</script>

<script language="javascript">
    var gridSecRole, dataSource, SecRoleModel;

    $(document).ready(function () {
        onLoadSecRolePage();
        initSecRoleGrid();
        initObservable();
    });

    function onLoadSecRolePage() {
        $("#roleRow").hide();
        // initialize form with kendo validator & bind onSubmit event
        initializeForm($("#roleForm"), onSubmitSecRole);
        // update page title
        defaultPageTile("Create Role",null);
    }

    function showForm() {
        $("#roleRow").show();
    }
    function executePreCondition() {
        if (!validateForm($("#roleForm"))) {
            return false;
        }
        return true;
    }

    function onSubmitSecRole() {
        if (executePreCondition() == false) {
            return false;
        }

        setButtonDisabled($('#create'), true);
        showLoadingSpinner(true);
        var actionUrl = null;
        if ($('#id').val().isEmpty()) {
            actionUrl = "${createLink(controller:'secRole', action: 'create')}";
        } else {
            actionUrl = "${createLink(controller:'secRole', action: 'update')}";
        }

        jQuery.ajax({
            type: 'post',
            data: jQuery("#roleForm").serialize(),
            url: actionUrl,
            success: function (data, textStatus) {
                executePostCondition(data);
                setButtonDisabled($('#create'), false);
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
            try {
                var newEntry = result.secRole;
                if ($('#id').val().isEmpty() && newEntry != null) { // newly created
                    var gridData = gridSecRole.dataSource.data();
                    gridData.unshift(newEntry);
                } else if (newEntry != null) { // updated existing
                    var selectedRow = gridSecRole.select();
                    var allItems = gridSecRole.items();
                    var selectedIndex = allItems.index(selectedRow);
                    gridSecRole.removeRow(selectedRow);
                    gridSecRole.dataSource.insert(selectedIndex, newEntry);
                }
                resetForm();
                showSuccess(result.message);
            } catch (e) {
                // Do Nothing
            }
        }
    }

    function resetForm(hide) {
        clearForm($("#roleForm"), $('#name'));
        initObservable();
        $('#create').html("<span class='k-icon k-i-plus'></span>Create");
        if(hide) $("#roleRow").hide();
    }

    function initDataSource() {
        dataSource = new kendo.data.DataSource({
            transport: {
                read: {
                    url: "${createLink(controller: 'secRole', action: 'list')}",
                    dataType: "json",
                    type: "post"
                }
            },
            schema: {
                type: 'json',
                data: "list", total: "count",
                model: {
                    fields: {
                        id: { type: "number" },
                        version: { type: "number" },
                        count: { type: "number" },
                        name: { type: "string" }
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

    function initSecRoleGrid() {
        initDataSource();
        $("#gridSecRole").kendoGrid({
            dataSource: dataSource,
            height: getGridHeightKendo(),
            selectable: true,
            sortable: true,
            resizable: true,
            reorderable: true,
            pageable: {
                refresh: true,
                pageSizes: getDefaultPageSizes(),
                buttonCount: 4
            },
            columns: [
                {field: "name", title: "Role", width: 400, sortable: false, filterable: kendoCommonFilterable(97)},
                {field: "count", title: "User Count", width: 50, sortable: false, filterable: false}
            ],
            filterable: {
                mode: "row"
            },
            toolbar: kendo.template($("#gridToolbar").html())
        });
        gridSecRole = $("#gridSecRole").data("kendoGrid");
        $("#menuGrid").kendoMenu();
    }

    function initObservable() {
        SecRoleModel = kendo.observable(
                {
                    secRole: {
                        id: "",
                        version: "",
                        name: ""
                    }
                }
        );
        kendo.bind($("#application_top_panel"), SecRoleModel);
    }

    function deleteSecRole() {
        if (executeCommonPreConditionForSelectKendo(gridSecRole, 'Role') == false) {
            return;
        }
        var msg = 'Are you sure you want to delete the selected Role?',
                url = "${createLink(controller: 'secRole', action:  'delete')}";
        confirmDelete(msg, url, gridSecRole);
    }

    function editSecRole() {
        if (executeCommonPreConditionForSelectKendo(gridSecRole, 'role') == false) {
            return;
        }
        $("#roleRow").show();
        var secRole = getSelectedObjectFromGridKendo(gridSecRole);
        showSecRole(secRole);
    }

    function showSecRole(secRole) {
        SecRoleModel.set('secRole', secRole);
        $('#create').html("<span class='k-icon k-i-plus'></span>Update");
    }

    function showUserRole(){
        if (executeCommonPreConditionForSelectKendo(gridSecRole, 'role') == false) {
            return;
        }
        showLoadingSpinner(true);
        var roleId = getSelectedIdFromGridKendo(gridSecRole);
        var loc = "${createLink(controller: 'secUserSecRole', action: 'show')}?roleId=" + roleId;
        router.navigate(formatLink(loc));
        return false;
    }

    function downloadReport(){
        showLoadingSpinner(true);
        if (confirm('Do you want to download the user-role report now?')) {
            var url = "${createLink(controller: 'secUserSecRole', action: 'report')}";
            document.location = url;
        }
        showLoadingSpinner(false);
        return false;
    }

</script>
