<script type="text/x-kendo-template" id="gridToolbar">
<ul id="menuGrid" class="kendoGridMenu">
    <sec:access url="/secUser/update">
        <li onclick="showForm();"><i class="fa fa-plus-square"></i>New</li>
    </sec:access>
    <sec:access url="/secUser/update">
        <li onclick="editSecUser();"><i class="fa fa-edit"></i>Edit</li>
    </sec:access>
</ul>
</script>

<script language="javascript">
    var gridSecUser, dataSource, secUserModel;

    $(document).ready(function () {
        $("#userRow").hide();
        onLoadSecUserPage();
        initSecUserGrid();
        initObservable();
    });

    function showForm() {
        $("#userRow").show();
    }
    function onLoadSecUserPage() {
        $("#userRow").hide();
        initializeForm($("#userForm"), onSubmitSecUser);
        defaultPageTile("Update User",null);
    }

    function executePreCondition() {
        if (!validateForm($("#userForm"))) {
            return false;
        }
        return true;
    }

    function onSubmitSecUser() {
        if (executePreCondition() == false) {
            return false;
        }
/*        if ($('#id').val().isEmpty()) {
            resetForm();
            showError('User could not be created. Update Only.');
            return false;
        }*/
        var password = $('#password').val(),
            confirmPassword = $('#confirmPassword').val();
        if(password!=confirmPassword){
            showError('Password mis-match');
            return false;
        }
        setButtonDisabled($('#create'), true);
        showLoadingSpinner(true);
        var actionUrl = null;
        if ($('#id').val().isEmpty()) {
            actionUrl = "${createLink(controller:'secUser', action: 'create')}";
        } else {
            actionUrl = "${createLink(controller:'secUser', action: 'update')}";
        }
        jQuery.ajax({
            type: 'post',
            data: jQuery("#userForm").serialize(),
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
                var newEntry = result.secUser;
                if ($('#id').val().isEmpty() && newEntry != null) { // newly created
                    var gridData = gridSecUser.dataSource.data();
                    gridData.unshift(newEntry);
                } else if (newEntry != null) { // updated existing
                    var selectedRow = gridSecUser.select();
                    var allItems = gridSecUser.items();
                    var selectedIndex = allItems.index(selectedRow);
                    gridSecUser.removeRow(selectedRow);
                    gridSecUser.dataSource.insert(selectedIndex, newEntry);
                }
                resetForm('hide');
                showSuccess(result.message);
            } catch (e) {
                // Do Nothing
            }
        }
    }

    function resetForm(hide) {
        clearForm($("#userForm"), $('#username'));
        clearErrors($("#userForm"));
        initObservable();
        $('#create').html("<span class='k-icon k-i-plus'></span>Create");
        if(hide) $("#userRow").hide();
    }

    function initDataSource() {
        dataSource = new kendo.data.DataSource({
            transport: {
                read: {
                    url: "${createLink(controller: 'secUser', action: 'list')}",
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
                        username: { type: "string" },
                        enabled: { type: "boolean" },
                        accountLocked: { type: "boolean" },
                        accountExpired: { type: "boolean" }
                    }
                },
                parse: function (data) {
                    checkIsErrorGridKendo(data);
                    return data;
                }
            },
            sort: {field: 'id', dir: 'asc'},
            pageSize: 10,
            serverPaging: true,
            serverFiltering: true,
            serverSorting: true
        });
    }

    function initSecUserGrid() {
        initDataSource();
        $("#gridSecUser").kendoGrid({
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
                {field: "username", title: "Login ID", width: 100, sortable: false, filterable: kendoCommonFilterable(97)},
                {field: "enabled", title: "Enabled", width: 30, sortable: false, filterable: false,attributes: {style: setAlignCenter()},
                    headerAttributes: {style: setAlignCenter()}, template:"#=enabled?'YES':'NO'#"},
                {field: "accountLocked", title: "Locked", width: 30, sortable: false, filterable: false,attributes: {style: setAlignCenter()},
                    headerAttributes: {style: setAlignCenter()}, template:"#=accountLocked?'YES':'NO'#"},
                {field: "accountExpired", title: "Expired", width: 30, sortable: false, filterable: false,attributes: {style: setAlignCenter()},
                    headerAttributes: {style: setAlignCenter()}, template:"#=accountExpired?'YES':'NO'#"}
            ],
            filterable: {
                mode: "row"
            },
            toolbar: kendo.template($("#gridToolbar").html())
        });
        gridSecUser = $("#gridSecUser").data("kendoGrid");
        $("#menuGrid").kendoMenu();
    }

    function initObservable() {
        secUserModel = kendo.observable(
                {
                    secUser: {
                        id: "",
                        version: "",
                        username: "",
                        enabled: false,
                        accountLocked: false,
                        accountExpired: false
                    }
                }
        );
        kendo.bind($("#application_top_panel"), secUserModel);
    }

    function editSecUser() {
        if (executeCommonPreConditionForSelectKendo(gridSecUser, 'user') == false) {
            return;
        }
        $("#userRow").show();
        var secUser = getSelectedObjectFromGridKendo(gridSecUser);
        showSecUser(secUser);
    }

    function showSecUser(secUser) {
        secUserModel.set('secUser', secUser);
        $('#create').html("<span class='k-icon k-i-plus'></span>Update");
    }

</script>
