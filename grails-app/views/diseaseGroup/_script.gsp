<script type="text/x-kendo-template" id="gridToolbar">
<ul id="menuGrid" class="kendoGridMenu">
    <sec:access url="/diseaseGroup/create">
        <li onclick="showForm();"><i class="fa fa-plus-square-o"></i>New</li>
    </sec:access>
    <sec:access url="/diseaseGroup/update">
        <li onclick="editRecord();"><i class="fa fa-edit"></i>Edit</li>
    </sec:access>
   %{-- <sec:access url="/diseaseGroup/delete">
        <li onclick="deleteRecord();"><i class="fa fa-trash-o"></i>Delete</li>
    </sec:access>--}%
</ul>
</script>

<script language="javascript">
    var gridDiseaseGroup, dataSource, DiseaseGroupModel;

    $(document).ready(function () {
        onLoadDiseaseGroupPage();
        initDiseaseGroupGrid();
        initObservable();
    });

    function onLoadDiseaseGroupPage() {
        $("#diseaseGroupRow").hide();
        // initialize form with kendo validator & bind onSubmit event
        initializeForm($("#diseaseGroupForm"), onSubmitDiseaseGroup);
        // update page title
        defaultPageTile("Create Disease Group",null);
    }

    function showForm() {
        $("#diseaseGroupRow").show();
    }
    function executePreCondition() {
        if (!validateForm($("#diseaseGroupForm"))) {
            return false;
        }
        return true;
    }

    function onSubmitDiseaseGroup() {
        if (executePreCondition() == false) {
            return false;
        }

        setButtonDisabled($('#create'), true);
        showLoadingSpinner(true);
        var actionUrl = null;
        if ($('#id').val().isEmpty()) {
            actionUrl = "${createLink(controller:'diseaseGroup', action: 'create')}";
        } else {
            actionUrl = "${createLink(controller:'diseaseGroup', action: 'update')}";
        }

        jQuery.ajax({
            type: 'post',
            data: jQuery("#diseaseGroupForm").serialize(),
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
                var newEntry = result.diseaseGroup;
                if ($('#id').val().isEmpty() && newEntry != null) { // newly created
                    var gridData = gridDiseaseGroup.dataSource.data();
                    gridData.unshift(newEntry);
                } else if (newEntry != null) { // updated existing
                    var selectedRow = gridDiseaseGroup.select();
                    var allItems = gridDiseaseGroup.items();
                    var selectedIndex = allItems.index(selectedRow);
                    gridDiseaseGroup.removeRow(selectedRow);
                    gridDiseaseGroup.dataSource.insert(selectedIndex, newEntry);
                }
                resetForm();
                showSuccess(result.message);
            } catch (e) {
                // Do Nothing
            }
        }
    }

    function resetForm() {
        clearForm($("#diseaseGroupForm"), $('#name'));
        initObservable();
        $('#create').html("<span class='k-icon k-i-plus'></span>Create");
        $("#diseaseGroupRow").hide();
    }

    function initDataSource() {
        dataSource = new kendo.data.DataSource({
            transport: {
                read: {
                    url: "${createLink(controller: 'diseaseGroup', action: 'list')}",
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
            pageSize: getDefaultPageSize(),
            serverPaging: true,
            serverFiltering: true,
            serverSorting: true
        });
    }

    function initDiseaseGroupGrid() {
        initDataSource();
        $("#gridDiseaseGroup").kendoGrid({
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
        gridDiseaseGroup = $("#gridDiseaseGroup").data("kendoGrid");
        $("#menuGrid").kendoMenu();
    }

    function initObservable() {
        DiseaseGroupModel = kendo.observable(
                {
                    diseaseGroup: {
                        id: "",
                        version: "",
                        name: "",
                        description: "",
                        isActive: true
                    }
                }
        );
        kendo.bind($("#application_top_panel"), DiseaseGroupModel);
    }

    function deleteRecord() {
        if (executeCommonPreConditionForSelectKendo(gridDiseaseGroup, 'record') == false) {
            return;
        }
        var msg = 'Are you sure you want to delete the selected record?',
                url = "${createLink(controller: 'diseaseGroup', action:  'delete')}";
        confirmDelete(msg, url, gridDiseaseGroup);
    }

    function editRecord() {
        if (executeCommonPreConditionForSelectKendo(gridDiseaseGroup, 'record') == false) {
            return;
        }
        $("#diseaseGroupRow").show();
        var diseaseGroup = getSelectedObjectFromGridKendo(gridDiseaseGroup);
        showRecord(diseaseGroup);
    }

    function showRecord(diseaseGroup) {
        DiseaseGroupModel.set('diseaseGroup', diseaseGroup);
        $('#create').html("<span class='k-icon k-i-plus'></span>Update");
    }

</script>
