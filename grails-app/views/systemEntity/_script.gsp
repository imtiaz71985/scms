<script type="text/x-kendo-template" id="gridToolbar">
<ul id="menuGrid" class="kendoGridMenu">
    <sec:access url="/systemEntity/create">
        <li onclick="showForm();"><i class="fa fa-plus-square-o"></i>New</li>
    </sec:access>
    <sec:access url="/systemEntity/update">
        <li onclick="editRecord();"><i class="fa fa-edit"></i>Edit</li>
    </sec:access>
    <sec:access url="/systemEntity/delete">
        <li onclick="deleteRecord();"><i class="fa fa-trash-o"></i>Delete</li>
    </sec:access>
</ul>
</script>

<script language="javascript">
    var gridSystemEntity, dataSource, systemEntityModel, dropDownSystemEntityType;

    $(document).ready(function () {
        onLoadSystemEntityPage();
        initSystemEntityGrid();
        initObservable();
    });

    function onLoadSystemEntityPage() {
        $("#systemEntityRow").hide();
        // initialize form with kendo validator & bind onSubmit event
        initializeForm($("#systemEntityForm"), onSubmitServiceType);
        // update page title
        defaultPageTile("Create System Entity",null);
    }

    function showForm() {
        $("#systemEntityRow").show();
    }
    function executePreCondition() {
        if (!validateForm($("#systemEntityForm"))) {
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
            actionUrl = "${createLink(controller:'systemEntity', action: 'create')}";
        } else {
            actionUrl = "${createLink(controller:'systemEntity', action: 'update')}";
        }

        jQuery.ajax({
            type: 'post',
            data: jQuery("#systemEntityForm").serialize(),
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
                var newEntry = result.systemEntity;
                if ($('#id').val().isEmpty() && newEntry != null) { // newly created
                    var gridData = gridSystemEntity.dataSource.data();
                    gridData.unshift(newEntry);
                } else if (newEntry != null) { // updated existing
                    var selectedRow = gridSystemEntity.select();
                    var allItems = gridSystemEntity.items();
                    var selectedIndex = allItems.index(selectedRow);
                    gridSystemEntity.removeRow(selectedRow);
                    gridSystemEntity.dataSource.insert(selectedIndex, newEntry);
                }
                resetForm();
                showSuccess(result.message);
            } catch (e) {
                // Do Nothing
            }
        }
    }

    function resetForm() {
        clearForm($("#systemEntityForm"), $('#name'));
        initObservable();
        $('#create').html("<span class='k-icon k-i-plus'></span>Create");
        $("#systemEntityRow").hide();
    }

    function initDataSource() {
        dataSource = new kendo.data.DataSource({
            transport: {
                read: {
                    url: "${createLink(controller: 'systemEntity', action: 'list')}",
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
                        type: { type: "string" },
                        name: { type: "string" },
                        description: { type: "string" }
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

    function initSystemEntityGrid() {
        initDataSource();
        $("#gridSystemEntity").kendoGrid({
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
                {field: "type", title: "Type", width: 200, sortable: false, filterable: kendoCommonFilterable(97)},
                {field: "name", title: "Name", width: 200, sortable: false, filterable: kendoCommonFilterable(97)},
                {field: "description", title: "Description", width: 250, sortable: false, filterable: false}
            ],
            filterable: {
                mode: "row"
            },
            toolbar: kendo.template($("#gridToolbar").html())
        });
        gridSystemEntity = $("#gridSystemEntity").data("kendoGrid");
        $("#menuGrid").kendoMenu();
    }

    function initObservable() {
        systemEntityModel = kendo.observable(
                {
                    systemEntity: {
                        id: "",
                        version: "",
                        type: "",
                        name: "",
                        description: ""
                    }
                }
        );
        kendo.bind($("#application_top_panel"), systemEntityModel);
    }

    function deleteRecord() {
        if (executeCommonPreConditionForSelectKendo(gridSystemEntity, 'record') == false) {
            return;
        }
        var msg = 'Are you sure you want to delete the selected record?',
                url = "${createLink(controller: 'systemEntity', action:  'delete')}";
        confirmDelete(msg, url, gridSystemEntity);
    }

    function editRecord() {
        if (executeCommonPreConditionForSelectKendo(gridSystemEntity, 'record') == false) {
            return;
        }
        $("#systemEntityRow").show();
        var systemEntity = getSelectedObjectFromGridKendo(gridSystemEntity);
        showRecord(systemEntity);
    }

    function showRecord(systemEntity) {
        systemEntityModel.set('systemEntity', systemEntity);
        $('#create').html("<span class='k-icon k-i-plus'></span>Update");
    }

</script>
