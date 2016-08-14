<script type="text/x-kendo-template" id="gridToolbar">
<ul id="menuGrid" class="kendoGridMenu">
    <sec:access url="/serviceProvider/create">
        <li onclick="showForm();"><i class="fa fa-plus-square-o"></i>New</li>
    </sec:access>
    <sec:access url="/serviceProvider/update">
        <li onclick="editServiceProvider();"><i class="fa fa-edit"></i>Edit</li>
    </sec:access>
%{--    <sec:access url="/serviceProvider/delete">
        <li onclick="deleteServiceProvider();"><i class="fa fa-trash-o"></i>Delete</li>
    </sec:access>--}%
</ul>
</script>

<script language="javascript">
    var gridServiceProvider, dataSource, ServiceProviderModel, dropDownType;

    $(document).ready(function () {
        onLoadServiceProviderPage();
        initServiceProviderGrid();
        initObservable();
    });

    function onLoadServiceProviderPage() {
        $("#providerRow").hide();
        initializeForm($("#providerForm"), onSubmitServiceProvider);
        defaultPageTile("Create Service Provider",null);
    }

    function showForm() {
        $("#providerRow").show();
    }
    function executePreCondition() {
        if (!validateForm($("#providerForm"))) {
            return false;
        }
        return true;
    }

    function onSubmitServiceProvider() {
        if (executePreCondition() == false) {
            return false;
        }

        setButtonDisabled($('#create'), true);
        showLoadingSpinner(true);
        var actionUrl = null;
        if ($('#id').val().isEmpty()) {
            actionUrl = "${createLink(controller:'serviceProvider', action: 'create')}";
        } else {
            actionUrl = "${createLink(controller:'serviceProvider', action: 'update')}";
        }

        jQuery.ajax({
            type: 'post',
            data: jQuery("#providerForm").serialize(),
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
                var newEntry = result.serviceProvider;
                if ($('#id').val().isEmpty() && newEntry != null) { // newly created
                    var gridData = gridServiceProvider.dataSource.data();
                    gridData.unshift(newEntry);
                } else if (newEntry != null) { // updated existing
                    var selectedRow = gridServiceProvider.select();
                    var allItems = gridServiceProvider.items();
                    var selectedIndex = allItems.index(selectedRow);
                    gridServiceProvider.removeRow(selectedRow);
                    gridServiceProvider.dataSource.insert(selectedIndex, newEntry);
                }
                resetForm();
                showSuccess(result.message);
            } catch (e) {
                // Do Nothing
            }
        }
    }

    function resetForm(hide) {
        clearForm($("#providerForm"), $('#name'));
        initObservable();
        $('#create').html("<span class='k-icon k-i-plus'></span>Create");
        if(hide) $("#providerRow").hide();
    }

    function initDataSource() {
        dataSource = new kendo.data.DataSource({
            transport: {
                read: {
                    url: "${createLink(controller: 'serviceProvider', action: 'list')}",
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
                        typeId: { type: "number" },
                        typeName: { type: "string" },
                        name: { type: "string" },
                        mobileNo: { type: "string" },
                        isActive: { type: "boolean" }
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

    function initServiceProviderGrid() {
        initDataSource();
        $("#gridServiceProvider").kendoGrid({
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
                {field: "typeName", title: "Type", width: 50, sortable: false, filterable: kendoCommonFilterable(97)},
                {field: "name", title: "Name", width: 120, sortable: false, filterable: kendoCommonFilterable(97)},
                {field: "mobileNo", title: "Mobile No", width: 60, sortable: false, filterable: false},
                {field: "isActive", title: "Is Active", width: 50, sortable: false,filterable:false,
                template: "#=isActive?'YES':'NO'#"}
            ],
            filterable: {
                mode: "row"
            },
            toolbar: kendo.template($("#gridToolbar").html())
        });
        gridServiceProvider = $("#gridServiceProvider").data("kendoGrid");
        $("#menuGrid").kendoMenu();
    }

    function initObservable() {
        ServiceProviderModel = kendo.observable(
                {
                    serviceProvider: {
                        id: "",
                        version: "",
                        typeId: "",
                        name: "",
                        mobileNo: "",
                        isActive: true
                    }
                }
        );
        kendo.bind($("#application_top_panel"), ServiceProviderModel);
    }

    function deleteServiceProvider() {
        if (executeCommonPreConditionForSelectKendo(gridServiceProvider, 'Provider') == false) {
            return;
        }
        var msg = 'Are you sure you want to delete the selected Provider?',
                url = "${createLink(controller: 'serviceProvider', action:  'delete')}";
        confirmDelete(msg, url, gridServiceProvider);
    }

    function editServiceProvider() {
        if (executeCommonPreConditionForSelectKendo(gridServiceProvider, 'Provider') == false) {
            return;
        }
        $("#providerRow").show();
        var serviceProvider = getSelectedObjectFromGridKendo(gridServiceProvider);
        showServiceProvider(serviceProvider);
    }

    function showServiceProvider(serviceProvider) {
        ServiceProviderModel.set('serviceProvider', serviceProvider);
        $('#create').html("<span class='k-icon k-i-plus'></span>Update");
    }

</script>
