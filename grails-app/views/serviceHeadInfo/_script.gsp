<script type="text/x-kendo-template" id="gridToolbar">
<ul id="menuGrid" class="kendoGridMenu">
    <sec:access url="/serviceHeadInfo/create">
        <li onclick="showForm();"><i class="fa fa-plus-square-o"></i>New</li>
    </sec:access>
    <sec:access url="/serviceHeadInfo/update">
        <li onclick="editRecord();"><i class="fa fa-edit"></i>Edit</li>
    </sec:access>
    <sec:access url="/serviceHeadInfo/delete">
        <li onclick="deleteRecord();"><i class="fa fa-trash-o"></i>Inactive</li>
    </sec:access>
</ul>
</script>

<script language="javascript">
    var gridServiceHeadInfo, dataSource, serviceHeadInfoModel, dropDownServiceType;

    $(document).ready(function () {
        onLoadServiceHeadInfoPage();
        initServiceHeadInfoGrid();
        initObservable();
    });

    function onLoadServiceHeadInfoPage() {
        var date = new Date();
        date.setDate(date.getDate() + 1);
        // initialize form with kendo validator & bind onSubmit event
        initializeForm($("#serviceHeadInfoForm"), onSubmitServiceHeadInfo);

        $("#activationDate").kendoDatePicker({
            format: "dd/MM/yyyy",
            parseFormats: ["yyyy-MM-dd"],
            min: date
        });
        $("#activationDate").kendoMaskedTextBox({mask: "00/00/0000"});

        $("#serviceHeadInfoRow").hide();
        // update page title
        defaultPageTile("Create Service Type", null);
    }

    function showForm() {
        $("#serviceHeadInfoRow").show();
    }
    function executePreCondition() {
        if (!validateForm($("#serviceHeadInfoForm"))) {
            return false;
        }
        return true;
    }

    function onSubmitServiceHeadInfo() {
        if (executePreCondition() == false) {
            return false;
        }

        setButtonDisabled($('#create'), true);
        showLoadingSpinner(true);
        var actionUrl = null;
        if ($('#id').val().isEmpty()) {
            actionUrl = "${createLink(controller:'serviceHeadInfo', action: 'create')}";
        } else {
            actionUrl = "${createLink(controller:'serviceHeadInfo', action: 'update')}";
        }

        jQuery.ajax({
            type: 'post',
            data: jQuery("#serviceHeadInfoForm").serialize(),
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
                var newEntry = result.serviceHeadInfo;
                if ($('#id').val().isEmpty() && newEntry != null) { // newly created
                    var gridData = gridServiceHeadInfo.dataSource.data();
                    gridData.unshift(newEntry);
                } else if (newEntry != null) { // updated existing
                    var selectedRow = gridServiceHeadInfo.select();
                    var allItems = gridServiceHeadInfo.items();
                    var selectedIndex = allItems.index(selectedRow);
                    gridServiceHeadInfo.removeRow(selectedRow);
                    gridServiceHeadInfo.dataSource.insert(selectedIndex, newEntry);
                }
                //initServiceHeadInfoGrid();
                resetForm();
                showSuccess(result.message);
            } catch (e) {
                // Do Nothing
            }
        }
    }

    function resetForm() {
        clearForm($("#serviceHeadInfoForm"), $('#name'));
        dropDownServiceType.enable(true);
        initObservable();
        $('#create').html("<span class='k-icon k-i-plus'></span>Create");
        $("#serviceHeadInfoRow").hide();
    }

    function initDataSource() {
        dataSource = new kendo.data.DataSource({
            transport: {
                read: {
                    url: "${createLink(controller: 'serviceHeadInfo', action: 'list')}",
                    dataType: "json",
                    type: "post"
                }
            },
            schema: {
                type: 'json',
                data: "list", total: "count",
                model: {
                    fields: {
                        serviceCode: {type: "string"},
                        name: {type: "string"},
                        serviceTypeId: {type: "string"},
                        serviceTypeName: {type: "string"},
                        activationDate: {type: "string"},
                        chargeAmount: {type: "string"},
                        isActive: {type: "boolean"}
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

    function initServiceHeadInfoGrid() {
        initDataSource();
        $("#gridServiceHeadInfo").kendoGrid({
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
                    field: "serviceCode",
                    title: "Service Code",
                    width: 50,
                    sortable: false,
                    filterable: kendoCommonFilterable(97)
                },
                {
                    field: "serviceTypeName",
                    title: "Service Type",
                    width: 120,
                    sortable: false,
                    filterable: kendoCommonFilterable(97)
                },
                {field: "name", title: "Name", width: 200, sortable: false, filterable: kendoCommonFilterable(97)},
                {
                    field: "activationDate",
                    title: "Activation Date",
                    format: "{0:dd-MM-yyyy}",
                    width: 70,
                    sortable: false,
                    filterable: false
                },
                {field: "chargeAmount", title: "Fees", width: 70, sortable: false, filterable: false},
                {
                    field: "isActive", title: "Is Active", width: 30, sortable: false, filterable: false,
                    attributes: {style: setAlignCenter()}, headerAttributes: {style: setAlignCenter()},
                    template: "#=isActive?'YES':'NO'#"
                }
            ],
            filterable: {
                mode: "row"
            },
            toolbar: kendo.template($("#gridToolbar").html())
        });
        gridServiceHeadInfo = $("#gridServiceHeadInfo").data("kendoGrid");
        $("#menuGrid").kendoMenu();
    }

    function initObservable() {
        serviceHeadInfoModel = kendo.observable(
                {
                    serviceHeadInfo: {
                        serviceCode: "",
                        name: "",
                        serviceTypeId: "",
                        serviceTypeName: "",
                        activationDate: "",
                        chargeAmount: "",
                        isActive: true

                    }
                }
        );
        kendo.bind($("#application_top_panel"), serviceHeadInfoModel);
    }

    function deleteRecord() {
        if (executeCommonPreConditionForSelectKendo(gridServiceHeadInfo, 'record') == false) {
            return;
        }
        var serviceCode = getSelectedValueFromGridKendo(gridServiceHeadInfo, 'serviceCode');
        var isActive = getSelectedValueFromGridKendo(gridServiceHeadInfo, 'isActive');
        if(!isActive){
            showError('Already inactive');
            return false;
        }
        if (!confirm('Are you sure you want to deactivate this service?')) {
            return false;
        }

        showLoadingSpinner(true);
        $.ajax({
            url: "${createLink(controller: 'serviceHeadInfo', action:  'delete')}?serviceCode=" + serviceCode,
            success: function (data, textStatus) {
                executePostConditionDelete(data);
            },
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

    function editRecord() {
        if (executeCommonPreConditionForSelectKendo(gridServiceHeadInfo, 'record') == false) {
            return;
        }

        dropDownServiceType.enable(false);
        $("#serviceHeadInfoRow").show();
        var serviceHeadInfo = getSelectedObjectFromGridKendo(gridServiceHeadInfo);
        showRecord(serviceHeadInfo);
    }

    function showRecord(serviceHeadInfo) {
        serviceHeadInfoModel.set('serviceHeadInfo', serviceHeadInfo);
        $('#create').html("<span class='k-icon k-i-plus'></span>Update");
    }
    function getServiceCode() {
        var serviceTypeId = $("#serviceTypeId").val();

        if (serviceTypeId == '') {
            $("#serviceCode").val('');
            dropDownServiceType.value('');
            return false;
        }
        showLoadingSpinner(true);
        var actionUrl = "${createLink(controller:'serviceHeadInfo', action: 'retrieveServiceCode')}?serviceTypeId=" + serviceTypeId;
        jQuery.ajax({
            type: 'post',
            url: actionUrl,
            success: function (data, textStatus) {
                $('#serviceCode').val(data.serviceCode);
            },
            error: function (XMLHttpRequest, textStatus, errorThrown) {

            },
            complete: function (XMLHttpRequest, textStatus) {
                showLoadingSpinner(false);
            },
            dataType: 'json'
        });
    }


    function executePostConditionDelete(result) {
        if (result.isError) {
            showError(result.message);
            showLoadingSpinner(false);
        } else {
            try {
                var newEntry = result.serviceHeadInfo;
                var selectedRow = gridServiceHeadInfo.select();
                var allItems = gridServiceHeadInfo.items();
                var selectedIndex = allItems.index(selectedRow);
                gridServiceHeadInfo.removeRow(selectedRow);
                gridServiceHeadInfo.dataSource.insert(selectedIndex, newEntry);
                resetForm();
                showSuccess(result.message);
            } catch (e) {
                // Do Nothing
            }
        }
    }

</script>
