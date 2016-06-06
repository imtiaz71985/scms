<script type="text/x-kendo-template" id="gridToolbar">
<ul id="menuGrid" class="kendoGridMenu">
    <sec:access url="/theme/update">
    <li onclick="editTheme();"><i class="fa fa-edit"></i>Edit</li>
    </sec:access>
    <sec:access url="/theme/delete">
        <li onclick="deleteTheme();"><i class="fa fa-trash-o"></i>Delete</li>
    </sec:access>
</ul>
</script>

<script language="javascript">
    var gridTheme, dataSource, themeModel;

    $(document).ready(function () {
        onLoadThemePage();
        initThemeGrid();
        initObservable();
    });

    function onLoadThemePage() {
        // initialize form with kendo validator & bind onSubmit event
        initializeForm($("#themeForm"), onSubmitTheme);
        // update page title
        defaultPageTile("Update Theme",null);
    }

    function executePreCondition() {
        if (!validateForm($("#themeForm"))) {
            return false;
        }
        return true;
    }

    function onSubmitTheme() {
        if (executePreCondition() == false) {
            return false;
        }
        if(!$('#id').val()){
            showError('Theme could not be created. Update only.');
            return false;
        }

        setButtonDisabled($('#create'), true);
        showLoadingSpinner(true);

        jQuery.ajax({
            type: 'post',
            data: jQuery("#themeForm").serialize(),
            url: "${createLink(controller:'theme', action: 'update')}",
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
                var newEntry = result.theme;
                if ($('#id').val().isEmpty() && newEntry != null) { // newly created
                    var gridData = gridTheme.dataSource.data();
                    gridData.unshift(newEntry);
                } else if (newEntry != null) { // updated existing
                    var selectedRow = gridTheme.select();
                    var allItems = gridTheme.items();
                    var selectedIndex = allItems.index(selectedRow);
                    gridTheme.removeRow(selectedRow);
                    gridTheme.dataSource.insert(selectedIndex, newEntry);
                }
                resetForm();
                showSuccess(result.message);
            } catch (e) {
                // Do Nothing
            }
        }
    }

    function resetForm() {
        clearForm($("#themeForm"), $('#name'));
        initObservable();
    }

    function initDataSource() {
        dataSource = new kendo.data.DataSource({
            transport: {
                read: {
                    url: "${createLink(controller: 'theme', action: 'list')}",
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
                        value: { type: "string" }
                    }
                },
                parse: function (data) {
                    checkIsErrorGridKendo(data);
                    return data;
                }
            },
            pageSize: 1,
            serverPaging: true,
            serverFiltering: true,
            serverSorting: true
        });
    }

    function initThemeGrid() {
        initDataSource();
        $("#gridTheme").kendoGrid({
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
                {field: "name", title: "Key", width: 80, sortable: false, filterable: kendoCommonFilterable(97)},
                {field: "value", title: "Value", width: 300, sortable: false, filterable: false,
                template: "#= value #" }
            ],
            filterable: {
                mode: "row"
            },
            toolbar: kendo.template($("#gridToolbar").html())
        });
        gridTheme = $("#gridTheme").data("kendoGrid");
        $("#menuGrid").kendoMenu();
    }

    function initObservable() {
        themeModel = kendo.observable(
                {
                    project: {
                        id: "",
                        version: "",
                        name: "",
                        value: ""
                    }
                }
        );
        kendo.bind($("#application_top_panel"), themeModel);
    }

    function deleteTheme() {
        if (executeCommonPreConditionForSelectKendo(gridTheme, 'theme') == false) {
            return;
        }
        var msg = 'Are you sure you want to delete the selected theme?',
            url = "${createLink(controller: 'theme', action:  'delete')}";
        confirmDelete(msg, url, gridTheme);
    }

    function editTheme() {
        if (executeCommonPreConditionForSelectKendo(gridTheme, 'theme') == false) {
            return;
        }
        var theme = getSelectedObjectFromGridKendo(gridTheme);
        showTheme(theme);
    }

    function showTheme(theme) {
        themeModel.set('theme', theme);
    }

</script>
