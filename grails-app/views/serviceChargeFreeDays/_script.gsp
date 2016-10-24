<script type="text/x-kendo-template" id="gridToolbar">
<ul id="menuGrid" class="kendoGridMenu">
    <sec:access url="/serviceChargeFreeDays/create">
        <li onclick="showForm();"><i class="fa fa-plus-square-o"></i>New</li>
    </sec:access>

   %{-- <sec:access url="/serviceChargeFreeDays/delete">
        <li onclick="deleteRecord();"><i class="fa fa-trash-o"></i>Delete</li>
    </sec:access>--}%
</ul>
</script>

<script language="javascript">
    var gridServiceChargeFreeDays, dataSource, ServiceChargeFreeDaysModel;

    $(document).ready(function () {
        onLoadServiceChargeFreeDaysPage();
        initServiceChargeFreeDaysGrid();
        initObservable();
    });

    function onLoadServiceChargeFreeDaysPage() {
        $("#serviceChargeFreeDaysRow").hide();
        // initialize form with kendo validator & bind onSubmit event
        initializeForm($("#serviceChargeFreeDaysForm"), onSubmitServiceChargeFreeDays);
        var date = new Date();
        date.setDate(date.getDate() + 1);
        $("#activationDate").kendoDatePicker({
            format: "dd/MM/yyyy",
            parseFormats: ["yyyy-MM-dd"],
            min: date
        });
        $("#activationDate").kendoMaskedTextBox({mask: "00/00/0000"});

        // update page title
        defaultPageTile("Service Charge Free Days Setup",'/serviceChargeFreeDays/show');
    }

    function showForm() {
        $("#serviceChargeFreeDaysRow").show();
    }
    function executePreCondition() {
        if (!validateForm($("#serviceChargeFreeDaysForm"))) {
            return false;
        }
        return true;
    }

    function onSubmitServiceChargeFreeDays() {
        if (executePreCondition() == false) {
            return false;
        }

        setButtonDisabled($('#create'), true);
        showLoadingSpinner(true);
        var actionUrl = null;
        if ($('#id').val().isEmpty()) {
            actionUrl = "${createLink(controller:'serviceChargeFreeDays', action: 'create')}";
        } else {
            actionUrl = "${createLink(controller:'serviceChargeFreeDays', action: 'update')}";
        }

        jQuery.ajax({
            type: 'post',
            data: jQuery("#serviceChargeFreeDaysForm").serialize(),
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
                var newEntry = result.serviceChargeFreeDays;
                if ($('#id').val().isEmpty() && newEntry != null) { // newly created
                    var gridData = gridServiceChargeFreeDays.dataSource.data();
                    gridData.unshift(newEntry);
                } else if (newEntry != null) { // updated existing
                    var selectedRow = gridServiceChargeFreeDays.select();
                    var allItems = gridServiceChargeFreeDays.items();
                    var selectedIndex = allItems.index(selectedRow);
                    gridServiceChargeFreeDays.removeRow(selectedRow);
                    gridServiceChargeFreeDays.dataSource.insert(selectedIndex, newEntry);
                }
                resetForm();
                showSuccess(result.message);
            } catch (e) {
                // Do Nothing
            }
        }
    }

    function resetForm() {
        clearForm($("#serviceChargeFreeDaysForm"), $('#name'));
        initObservable();
        $('#create').html("<span class='k-icon k-i-plus'></span>Create");
        $("#serviceChargeFreeDaysRow").hide();
        initServiceChargeFreeDaysGrid();
    }

    function initDataSource() {
        dataSource = new kendo.data.DataSource({
            transport: {
                read: {
                    url: "${createLink(controller: 'serviceChargeFreeDays', action: 'list')}",
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
                        serviceTypeId: {type: "string"},
                        serviceTypeName: {type: "string"},
                        description: { type: "string" },
                        isActive: { type: "boolean" },
                        daysForFree:{type:"string"},
                        activationDate:{type:"string"}

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

    function initServiceChargeFreeDaysGrid() {
        initDataSource();
        $("#gridServiceChargeFreeDays").kendoGrid({
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
                {
                    field: "serviceTypeName",
                    title: "Service Type",
                    width: 120,
                    sortable: false,
                    filterable: kendoCommonFilterable(97)
                },
                {field: "description", title: "Description", width: 200, sortable: false, filterable: false},
                {
                    field: "activationDate",
                    title: "Activation Date",
                    format: "{0:dd-MM-yyyy}",
                    width: 70,
                    sortable: false,
                    filterable: false
                },
                {field: "daysForFree", title: "Days For Free", width: 70, sortable: false, filterable: false},

            ],
            filterable: {
                mode: "row"
            },
            toolbar: kendo.template($("#gridToolbar").html())
        });
        gridServiceChargeFreeDays = $("#gridServiceChargeFreeDays").data("kendoGrid");
        $("#menuGrid").kendoMenu();
    }

    function initObservable() {
        ServiceChargeFreeDaysModel = kendo.observable(
                {
                    serviceChargeFreeDays: {
                        id: "",
                        version: "",
                        serviceTypeId: "",
                        serviceTypeName: "",
                        description: "",
                        isActive: true,
                        daysForFree:"",
                        activationDate:""
                    }
                }
        );
        kendo.bind($("#application_top_panel"), ServiceChargeFreeDaysModel);
    }

    function editRecord() {
        if (executeCommonPreConditionForSelectKendo(gridServiceChargeFreeDays, 'record') == false) {
            return;
        }
        $("#serviceChargeFreeDaysRow").show();
        var serviceChargeFreeDays = getSelectedObjectFromGridKendo(gridServiceChargeFreeDays);
        showRecord(serviceChargeFreeDays);
    }

    function showRecord(serviceChargeFreeDays) {
        ServiceChargeFreeDaysModel.set('serviceChargeFreeDays', serviceChargeFreeDays);
        $('#create').html("<span class='k-icon k-i-plus'></span>Update");
    }

</script>
