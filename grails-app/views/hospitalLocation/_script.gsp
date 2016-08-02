<script type="text/x-kendo-template" id="gridToolbar">
<ul id="menuGrid" class="kendoGridMenu">
    <sec:access url="/hospitalLocation/create">
        <li onclick="showForm();"><i class="fa fa-plus-square-o"></i>New</li>
    </sec:access>
    <sec:access url="/hospitalLocation/update">
        <li onclick="editRecord();"><i class="fa fa-edit"></i>Edit</li>
    </sec:access>
    <sec:access url="/hospitalLocation/delete">
        <li onclick="deleteRecord();"><i class="fa fa-trash-o"></i>Delete</li>
    </sec:access>
</ul>
</script>

<script language="javascript">
    var gridHospitalLocation, dataSource, hospitalLocationModel;

    $(document).ready(function () {
        onLoadHospitalLocationPage();
        initHospitalLocationGrid();
        initObservable();
    });

    function onLoadHospitalLocationPage() {
        $("#hospitalLocationRow").hide();
        // initialize form with kendo validator & bind onSubmit event
        initializeForm($("#hospitalLocationForm"), onSubmitHospitalLocation);
        // update page title
        defaultPageTile("Create Hospital",null);
    }

    function showForm() {
        $("#hospitalLocationRow").show();
    }
    function executePreCondition() {
        if (!validateForm($("#hospitalLocationForm"))) {
            return false;
        }
        return true;
    }

    function onSubmitHospitalLocation() {
        if (executePreCondition() == false) {
            return false;
        }

        setButtonDisabled($('#create'), true);
        showLoadingSpinner(true);
        var actionUrl = null;
        if ($('#id').val().isEmpty()) {
            actionUrl = "${createLink(controller:'hospitalLocation', action: 'create')}";
        } else {
            actionUrl = "${createLink(controller:'hospitalLocation', action: 'update')}";
        }

        jQuery.ajax({
            type: 'post',
            data: jQuery("#hospitalLocationForm").serialize(),
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
                var newEntry = result.hospitalLocation;
                if ($('#id').val().isEmpty() && newEntry != null) { // newly created
                    var gridData = gridHospitalLocation.dataSource.data();
                    gridData.unshift(newEntry);
                } else if (newEntry != null) { // updated existing
                    var selectedRow = gridHospitalLocation.select();
                    var allItems = gridHospitalLocation.items();
                    var selectedIndex = allItems.index(selectedRow);
                    gridHospitalLocation.removeRow(selectedRow);
                    gridHospitalLocation.dataSource.insert(selectedIndex, newEntry);
                }
                resetForm();
                showSuccess(result.message);
            } catch (e) {
                // Do Nothing
            }
        }
    }

    function resetForm() {
        clearForm($("#hospitalLocationForm"), $('#name'));
        initObservable();
        $('#create').html("<span class='k-icon k-i-plus'></span>Create");
        $("#hospitalLocationRow").hide();
    }

    function initDataSource() {
        dataSource = new kendo.data.DataSource({
            transport: {
                read: {
                    url: "${createLink(controller: 'hospitalLocation', action: 'list')}",
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
                        code: { type: "string" },
                        address: { type: "string" },
                        isClinic: { type: "boolean" }
                    }
                },
                parse: function (data) {
                    checkIsErrorGridKendo(data);
                    return data;
                }
            },
            sort: [{field: 'isClinic', dir: 'asc'}],
            pageSize: getDefaultPageSize(),
            serverPaging: true,
            serverFiltering: true,
            serverSorting: true
        });
    }

    function initHospitalLocationGrid() {
        initDataSource();
        $("#gridHospitalLocation").kendoGrid({
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
                {field: "address", title: "Address", width: 100, sortable: false, filterable: false},
                {field: "isClinic", title: "Clinic", width: 50, sortable: false, filterable: false,
                template: "#=isClinic?'YES':'NO'#"}
            ],
            filterable: {
                mode: "row"
            },
            toolbar: kendo.template($("#gridToolbar").html())
        });
        gridHospitalLocation = $("#gridHospitalLocation").data("kendoGrid");
        $("#menuGrid").kendoMenu();
    }

    function initObservable() {
        hospitalLocationModel = kendo.observable(
                {
                    hospitalLocation: {
                        id: "",
                        version: "",
                        name: "",
                        code: "",
                        address: "",
                        isClinic: true
                    }
                }
        );
        kendo.bind($("#application_top_panel"), hospitalLocationModel);
    }

    function deleteRecord() {
        if (executeCommonPreConditionForSelectKendo(gridHospitalLocation, 'record') == false) {
            return;
        }
        var msg = 'Are you sure you want to delete the selected record?',
                url = "${createLink(controller: 'hospitalLocation', action:  'delete')}";
        confirmDelete(msg, url, gridHospitalLocation);
    }

    function editRecord() {
        if (executeCommonPreConditionForSelectKendo(gridHospitalLocation, 'record') == false) {
            return;
        }
        $("#hospitalLocationRow").show();
        var hospitalLocation = getSelectedObjectFromGridKendo(gridHospitalLocation);
        showRecord(hospitalLocation);
    }

    function showRecord(hospitalLocation) {
        hospitalLocationModel.set('hospitalLocation', hospitalLocation);
        $('#create').html("<span class='k-icon k-i-plus'></span>Update");
    }

</script>
