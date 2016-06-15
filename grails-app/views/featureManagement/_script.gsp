<script type="text/javascript">
    var dropDownRole, dropDownModule, gridAvailableRole, gridAssignedRole, dataSourceAvailable, dataSourceAssigned;

    $(document).ready(function () {
        onLoadRequestMapPage();
        initAvailableRoleGrid(); // init at scriptGridControll.gsp
        initAssignedRoleGrid();  // init at scriptGridControll.gsp
    });

    function onLoadRequestMapPage() {
        // initialize form with kendo validator & bind onSubmit event
        initializeForm($("#frmSearchRole"), onSubmitFrmSearchRole);
        // update page title
        defaultPageTile("Role-Right Mapping",null);
    }

    function onSubmitFrmSearchRole() {
        if (!validateForm($("#frmSearchRole"))) {
            return false;
        }
        var roleId = dropDownRole.value();
        $('#hidRole').val(roleId);

        var urlAvailable ="${createLink(controller: 'featureManagement', action: 'listAvailableRole')}?roleId=" + roleId;
        var urlAssigned ="${createLink(controller: 'featureManagement', action: 'listAssignedRole')}?roleId=" + roleId;
        populateGridKendo(gridAvailableRole, urlAvailable);
        populateGridKendo(gridAssignedRole, urlAssigned);
    }

    function saveRequestMapAttributes() {
        var assignedFeatureIds = '';
        var assignedData = gridAssignedRole.dataSource.data();
        $.each(assignedData, function (index, data) {
            assignedFeatureIds += data.id + '_';
        });

        var roleId = $('#hidRole').val();
        var url = "${createLink(controller: 'featureManagement',action: 'update')}?assignedFeatureIds=" + assignedFeatureIds + '&roleId=' + roleId;

        showLoadingSpinner(true);
        jQuery.ajax({
            type: 'post',
            url: url,
            success: function (data, textStatus) {
                if (data.isError) {
                    showError(data.message);
                } else {
                    showSuccess(data.message);
                }            },
            error: function (XMLHttpRequest, textStatus, errorThrown) {
                afterAjaxError(XMLHttpRequest, textStatus)
            },
            complete: function (XMLHttpRequest, textStatus) {
                showLoadingSpinner(false);
            },
            dataType: 'json'
        });
    }

    function discardChanges() {
        var hidRoleId = $('#hidRole').val();
        if ((hidRoleId == '')) {
            showError('No changes found to discard');
            return false;
        }
        dropDownRole.value(hidRoleId);
        onSubmitFrmSearchRole();
        return false;
    }

    function addDataToSelectedRole() {
        if (executeCommonPreConditionForSelectKendo(gridAvailableRole, 'Available Role', false) == false) {
            return false;
        }
        var rows = gridAvailableRole.select();
        rows.each(function (e) {
            var data = gridAvailableRole.dataItem($(this));
            gridAssignedRole.dataSource.insert(0, data);
        });
        rows.each(function (e) {
            gridAvailableRole.removeRow($(this));
        });
    }

    function addAllDataToSelectedRole() {
        var count = gridAvailableRole.dataSource.data().length;
        if(count==0){ return false; }
        if (!confirm('Do you want to assign ' + count + ' right(s) to the selected role?')) {
            return;
        }
        var availableRows = gridAvailableRole.dataSource.data();
        var newData = $.merge(availableRows, gridAssignedRole.dataSource.data());
        gridAssignedRole.dataSource.data(newData);
        gridAvailableRole.dataSource.data([]);
        gridAvailableRole.refresh();
    }

    function removeDataFromSelectedRole() {
        if (executeCommonPreConditionForSelectKendo(gridAssignedRole, 'Assigned Role', false) == false) {
            return false;
        }
        var rows = gridAssignedRole.select();
        rows.each(function (e) {
            var data = gridAssignedRole.dataItem($(this));
            gridAvailableRole.dataSource.insert(0, data);
        });
        rows.each(function (e) {
            gridAssignedRole.removeRow($(this));
        });
    }

    function removeAllDataFromSelectedRole() {
        var count = gridAssignedRole.dataSource.data().length;
        if(count==0){ return false; }
        if (!confirm('Do you want to remove ' + count + ' right(s) from the selected role?')) {
            return;
        }
        var assignedRows = gridAssignedRole.dataSource.data();
        var newData = $.merge(assignedRows, gridAvailableRole.dataSource.data());
        gridAvailableRole.dataSource.data(newData);
        gridAssignedRole.dataSource.data([]);
        gridAssignedRole.refresh();
    }

    function initDataSourceAvailable() {
        dataSourceAvailable = new kendo.data.DataSource({
            transport: {
                read: {
                    url: "/featureManagement/listAvailableRole",
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
                        feature_name: {type: "string"},
                        url: {type: "string"},
                        group_name: {type: "string"}
                    }
                },
                parse: function (data) {
                    checkIsErrorGridKendo(data);
                    return data;
                }
            },
            pageSize: getDefaultPageSize(),
            serverPaging: false,
            serverFiltering: false,
            serverSorting: false
        });
    }

    function initAvailableRoleGrid() {
        initDataSourceAvailable();
        $("#gridAvailableRole").kendoGrid({
            autoBind: false,
            dataSource: dataSourceAvailable,
            height: getGridHeightKendo() - 118,
            selectable: 'multiple',
            sortable: true,
            resizable: true,
            reorderable: true,
            pageable: {
                numeric: false
            },
            columns: [
                {
                    field: "feature_name",
                    title: "Feature Name",
                    sortable: true,
                    width:300,
                    filterable: kendoCommonFilterable()
                }, {
                    field: "group_name",
                    title: "Group Name",
                    sortable: true,
                    filterable: kendoCommonFilterable()
                }
            ],
            filterable: {mode: "row"}
        });
        gridAvailableRole = $("#gridAvailableRole").data("kendoGrid");
    }

    function initDataSourceAssigned() {
        dataSourceAssigned = new kendo.data.DataSource({
            transport: {
                read: {
                    url: "/featureManagement/listAssignedRole",
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
                        feature_name: {type: "string"},
                        url: {type: "string"},
                        group_name: {type: "string"}
                    }
                },
                parse: function (data) {
                    checkIsErrorGridKendo(data);
                    return data;
                }
            },
            pageSize: getDefaultPageSize(),
            serverPaging: false,
            serverFiltering: false,
            serverSorting: false
        });
    }

    function initAssignedRoleGrid() {
        initDataSourceAssigned();
        $("#gridAssignedRole").kendoGrid({
            autoBind: false,
            dataSource: dataSourceAssigned,
            height: getGridHeightKendo() - 118,
            selectable: 'multiple',
            sortable: true,
            resizable: true,
            reorderable: true,
            pageable: {
                numeric: false
            },
            columns: [
                {
                    field: "feature_name",
                    title: "Feature Name",
                    sortable: true,
                    width:300,
                    filterable: kendoCommonFilterable()
                },{
                    field: "group_name",
                    title: "Group Name",
                    sortable: true,
                    filterable: kendoCommonFilterable()
                }
            ],
            filterable: {mode: "row"}
        });
        gridAssignedRole = $("#gridAssignedRole").data("kendoGrid");
    }
</script>
