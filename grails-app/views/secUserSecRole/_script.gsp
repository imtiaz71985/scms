<script type="text/x-kendo-template" id="gridToolbar">
<ul id="menuGrid" class="kendoGridMenu">
    <sec:access url="/secUserSecRole/delete">
        <li onclick="deleteUserRole();"><i class="fa fa-trash-o"></i>Delete</li>
    </sec:access>
</ul>
</script>

<script language="javascript">
    var gridUserRole, dataSource, roleId,dropDownSecUser;

    $(document).ready(function () {
        onLoadUserRolePage();
        initUserRoleGrid();
    });

    function onLoadUserRolePage() {
        roleId = ${roleId};
        $('#roleId').val(roleId);
        // initialize form with kendo validator & bind onSubmit event
        initializeForm($("#userRoleForm"), onSubmitUserRole);
        // update page title
        defaultPageTile("Create User Role", "secRole/show");
    }

    function executePreCondition() {
        if (!$('#userId').val()) {
            showError('Please select user');
            return false;
        }
        return true;
    }

    function onSubmitUserRole() {
        if (executePreCondition() == false) {
            return false;
        }
        setButtonDisabled($('#create'), true);
        showLoadingSpinner(true);
        var actionUrl = null;
        if ($('#id').val().isEmpty()) {
            actionUrl = "${createLink(controller:'secUserSecRole', action: 'create')}";
        } else {
            actionUrl = "${createLink(controller:'secUserSecRole', action: 'update')}";
        }

        jQuery.ajax({
            type: 'post',
            data: jQuery("#userRoleForm").serialize(),
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
                var newEntry = result.userRole;
                if ($('#id').val().isEmpty() && newEntry != null) { // newly created
                    var gridData = gridUserRole.dataSource.data();
                    gridData.unshift(newEntry);
                } else if (newEntry != null) { // updated existing
                    var selectedRow = gridUserRole.select();
                    var allItems = gridUserRole.items();
                    var selectedIndex = allItems.index(selectedRow);
                    gridUserRole.removeRow(selectedRow);
                    gridUserRole.dataSource.insert(selectedIndex, newEntry);
                }
                resetForm();
                showSuccess(result.message);
                $('#userId').reloadMe();
            } catch (e) {
                // Do Nothing
            }
        }
    }

    function resetForm() {
        clearForm($("#userRoleForm"), $('#userId'));
        $('#roleId').val(roleId);
        $('#userId').attr('default_value', '');
        $('#userId').reloadMe();
        $('#create').html("<span class='k-icon k-i-plus'></span>Create");
    }

    function initDataSource() {
        dataSource = new kendo.data.DataSource({
            transport: {
                read: {
                    url: "${createLink(controller: 'secUserSecRole', action: 'list')}",
                    data: { roleId: roleId},
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
                        userId: { type: "number" },
                        roleId: { type: "number" },
                        username: { type: "string" },
                        authority: { type: "string" }
                    }
                },
                parse: function (data) {
                    checkIsErrorGridKendo(data);
                    return data;
                }
            },
            pageSize: 10,
            sort: {field: 'username', dir: 'asc'},
            serverPaging: true,
            serverFiltering: true,
            serverSorting: true
        });
    }

    function initUserRoleGrid() {
        initDataSource();
        $("#gridUserRole").kendoGrid({
            dataSource: dataSource,
            height: getGridHeightKendo(),
            selectable: true,
            sortable: true,
            resizable: true,
            reorderable: true,
            pageable: {
                refresh: true,
                pageSizes: [10, 15, 20],
                buttonCount: 4
            },
            columns: [
                {field: "username", title: "User Name", width: 150, sortable: false, filterable: kendoCommonFilterable(96)}
            ],
            filterable: {
                mode: "row"
            },
            toolbar: kendo.template($("#gridToolbar").html())
        });
        gridUserRole = $("#gridUserRole").data("kendoGrid");
        $("#menuGrid").kendoMenu();
    }

    function deleteUserRole() {
        if (executePreConditionForDelete() == false) {
            return;
        }
        showLoadingSpinner(true);
        var userId = getSelectedValueFromGridKendo(gridUserRole, 'userId');
        var roleId = getSelectedValueFromGridKendo(gridUserRole, 'roleId');
        $.ajax({
            url: "${createLink(controller: 'secUserSecRole', action:  'delete')}?userId=" + userId+"&roleId="+roleId,
            success: executePostConditionForDelete,
            error: function (XMLHttpRequest, textStatus, errorThrown) {
                afterAjaxError(XMLHttpRequest, textStatus)
            },
            complete: function (XMLHttpRequest, textStatus) {
                showLoadingSpinner(false);
            },
            dataType: 'json',
            type: 'post'
        });
    }

    function executePreConditionForDelete() {
        if (executeCommonPreConditionForSelectKendo(gridUserRole, 'user') == false) {
            return false;
        }
        if (!confirm('Are you sure you want to delete the selected User?')) {
            return false;
        }
        return true;
    }

    <%-- removing selected row and clean input form --%>
    function executePostConditionForDelete(data) {
        if (data.isError){
            showError(data.message);
            return false;
        }
        var row = gridUserRole.select();
        row.each(function () {
            gridUserRole.removeRow($(this));
        });
        resetForm();
        showSuccess(data.message);
        $('#userId').reloadMe();
    }

</script>
