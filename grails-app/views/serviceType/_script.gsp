<script type="text/x-kendo-template" id="gridToolbar">
<ul id="menuGrid" class="kendoGridMenu">
    <sec:access url="/serviceType/create">
        <li onclick="showForm();"><i class="fa fa-plus-square-o"></i>New</li>
    </sec:access>
    <sec:access url="/serviceType/update">
        <li onclick="editRecord();"><i class="fa fa-edit"></i>Edit</li>
    </sec:access>
    <sec:access url="/serviceType/delete">
        <li onclick="deleteRecord();"><i class="fa fa-trash-o"></i>Delete</li>
    </sec:access>
</ul>
</script>

<script language="javascript">
    var gridServiceType, dataSource, ServiceTypeModel;

    $(document).ready(function () {
        onLoadServiceTypePage();
        initServiceTypeGrid();
        initObservable();
    });

    function onLoadServiceTypePage() {
        $("#serviceTypeRow").hide();
        // initialize form with kendo validator & bind onSubmit event
        initializeForm($("#serviceTypeForm"), onSubmitServiceType);
        // update page title
        defaultPageTile("Create Service Type",null);
    }

    function showForm() {
        $("#serviceTypeRow").show();
    }
    function executePreCondition() {
        if (!validateForm($("#serviceTypeForm"))) {
            return false;
        }
        return true;
    }

    function onSubmitServiceType() {
        if (executePreCondition() == false) {
            return false;
        }

        setButtonDisabled($('#create'), true);
        showLoadingSpinner(true);
        var actionUrl = null;
        if ($('#id').val().isEmpty()) {
            actionUrl = "${createLink(controller:'serviceType', action: 'create')}";
        } else {
            actionUrl = "${createLink(controller:'serviceType', action: 'update')}";
        }

        jQuery.ajax({
            type: 'post',
            data: jQuery("#serviceTypeForm").serialize(),
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
                var newEntry = result.serviceType;
                if ($('#id').val().isEmpty() && newEntry != null) { // newly created
                    var gridData = gridServiceType.dataSource.data();
                    gridData.unshift(newEntry);
                } else if (newEntry != null) { // updated existing
                    var selectedRow = gridServiceType.select();
                    var allItems = gridServiceType.items();
                    var selectedIndex = allItems.index(selectedRow);
                    gridServiceType.removeRow(selectedRow);
                    gridServiceType.dataSource.insert(selectedIndex, newEntry);
                }
                resetForm();
                showSuccess(result.message);
            } catch (e) {
                // Do Nothing
            }
        }
    }

    function resetForm(hide) {
        clearForm($("#serviceTypeForm"), $('#name'));
        initObservable();
        $('#create').html("<span class='k-icon k-i-plus'></span>Create");
        if(hide) $("#serviceTypeRow").hide();
    }

    function initDataSource() {
        dataSource = new kendo.data.DataSource({
            transport: {
                read: {
                    url: "${createLink(controller: 'serviceType', action: 'list')}",
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
                        name: { type: "string" },
                        description: { type: "string" },
                        isActive: { type: "boolean" }
                    }
                },
                parse: function (data) {
                    checkIsErrorGridKendo(data);
                    return data;
                }
            },
            pageSize: 15,
            serverPaging: true,
            serverFiltering: true,
            serverSorting: true
        });
    }

    function initServiceTypeGrid() {
        initDataSource();
        $("#gridServiceType").kendoGrid({
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
                {field: "name", title: "Name", width: 200, sortable: false, filterable: kendoCommonFilterable(97)},
                {field: "description", title: "Description", width: 250, sortable: false, filterable: false},
                {field: "isActive", title: "Is Active", width: 30, sortable: false, filterable: false,attributes: {style: setAlignCenter()},
                    headerAttributes: {style: setAlignCenter()}, template:"#=isActive?'YES':'NO'#"}
            ],
            filterable: {
                mode: "row"
            },
            toolbar: kendo.template($("#gridToolbar").html())
        });
        gridServiceType = $("#gridServiceType").data("kendoGrid");
        $("#menuGrid").kendoMenu();
    }

    function initObservable() {
        ServiceTypeModel = kendo.observable(
                {
                    serviceType: {
                        id: "",
                        version: "",
                        name: "",
                        description: "",
                        isActive: true
                    }
                }
        );
        kendo.bind($("#application_top_panel"), ServiceTypeModel);
    }

    function deleteRecord() {
        if (executeCommonPreConditionForSelectKendo(gridServiceType, 'record') == false) {
            return;
        }
        var msg = 'Are you sure you want to delete the selected record?',
                url = "${createLink(controller: 'serviceType', action:  'delete')}";
        confirmDelete(msg, url, gridServiceType);
    }

    function editRecord() {
        if (executeCommonPreConditionForSelectKendo(gridServiceType, 'record') == false) {
            return;
        }
        $("#serviceTypeRow").show();
        var serviceType = getSelectedObjectFromGridKendo(gridServiceType);
        showRecord(serviceType);
    }

    function showRecord(serviceType) {
        ServiceTypeModel.set('serviceType', serviceType);
        $('#create').html("<span class='k-icon k-i-plus'></span>Update");
    }

</script>
