<script type="text/x-kendo-template" id="gridToolbar">
<ul id="menuGrid" class="kendoGridMenu">
    <sec:access url="/diseaseInfo/create">
        <li onclick="showForm();"><i class="fa fa-plus-square-o"></i>New</li>
    </sec:access>
    <sec:access url="/diseaseInfo/update">
        <li onclick="editRecord();"><i class="fa fa-edit"></i>Edit</li>
    </sec:access>
    <sec:access url="/diseaseInfo/delete">
        <li onclick="deleteRecord();"><i class="fa fa-trash-o"></i>Inactive</li>
    </sec:access>
</ul>
</script>

<script language="javascript">
    var gridDiseaseInfo, dataSource, diseaseInfoModel, dropDownDiseaseGroup;

    $(document).ready(function () {
        onLoadDiseaseInfoPage();
        initDiseaseInfoGrid();
        initObservable();
    });

    function onLoadDiseaseInfoPage() {
        var date = new Date();
        date.setDate(date.getDate() + 1);
        // initialize form with kendo validator & bind onSubmit event
        initializeForm($("#diseaseInfoForm"), onSubmitDiseaseInfo);

        $("#diseaseInfoRow").hide();
        // update page title
        defaultPageTile("Create Disease", null);
    }

    function showForm() {
        $("#diseaseInfoRow").show();
    }
    function executePreCondition() {
        if (!validateForm($("#diseaseInfoForm"))) {
            return false;
        }
        return true;
    }

    function onSubmitDiseaseInfo() {
        if (executePreCondition() == false) {
            return false;
        }

        setButtonDisabled($('#create'), true);
        showLoadingSpinner(true);
        var actionUrl = null;
        if ($('#id').val().isEmpty()) {
            actionUrl = "${createLink(controller:'diseaseInfo', action: 'create')}";
        } else {
            actionUrl = "${createLink(controller:'diseaseInfo', action: 'update')}";
        }
//alert(actionUrl);
        jQuery.ajax({
            type: 'post',
            data: jQuery("#diseaseInfoForm").serialize(),
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
                var newEntry = result.diseaseInfo;
                if ($('#id').val().isEmpty() && newEntry != null) { // newly created
                    var gridData = gridDiseaseInfo.dataSource.data();
                    gridData.unshift(newEntry);
                } else if (newEntry != null) { // updated existing
                    var selectedRow = gridDiseaseInfo.select();
                    var allItems = gridDiseaseInfo.items();
                    var selectedIndex = allItems.index(selectedRow);
                    gridDiseaseInfo.removeRow(selectedRow);
                    gridDiseaseInfo.dataSource.insert(selectedIndex, newEntry);
                }
                resetForm();
                showSuccess(result.message);
            } catch (e) {
                // Do Nothing
            }
        }
    }

    function resetForm() {
        clearForm($("#diseaseInfoForm"), $('#name'));
        dropDownDiseaseGroup.enable(true);
        initObservable();
        $('#create').html("<span class='k-icon k-i-plus'></span>Create");
        $("#diseaseInfoRow").hide();
    }

    function initDataSource() {
        dataSource = new kendo.data.DataSource({
            transport: {
                read: {
                    url: "${createLink(controller: 'diseaseInfo', action: 'list')}",
                    dataType: "json",
                    type: "post"
                }
            },
            schema: {
                type: 'json',
                data: "list", total: "count",
                model: {
                    fields: {
                        diseaseCode: {type: "string"},
                        name: {type: "string"},
                        description:{type:"string"},
                        diseaseGroupId: {type: "string"},
                        diseaseGroupName: {type: "string"},
                        isActive: {type: "boolean"}
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

    function initDiseaseInfoGrid() {
        initDataSource();
        $("#gridDiseaseInfo").kendoGrid({
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
                {
                    field: "diseaseCode",
                    title: "Disease Code",
                    width: 50,
                    sortable: false,
                    filterable: kendoCommonFilterable(97)
                },
                {
                    field: "diseaseGroupName",
                    title: "Group Name",
                    width: 120,
                    sortable: false,
                    filterable: kendoCommonFilterable(97)
                },
                {field: "name", title: "Name", width: 200, sortable: false, filterable: kendoCommonFilterable(97)},
                {
                    field: "description",
                    title: "Description",
                    width: 200,
                    sortable: false,
                    filterable: false
                },
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
        gridDiseaseInfo = $("#gridDiseaseInfo").data("kendoGrid");
        $("#menuGrid").kendoMenu();
    }

    function initObservable() {
        diseaseInfoModel = kendo.observable(
                {
                    diseaseInfo: {
                        diseaseCode: "",
                        name: "",
                        description:"",
                        diseaseGroupId: "",
                        diseaseGroupName: "",
                        isActive: true
                    }
                }
        );
        kendo.bind($("#application_top_panel"), diseaseInfoModel);
    }

    function deleteRecord() {
        if (executeCommonPreConditionForSelectKendo(gridDiseaseInfo, 'record') == false) {
            return;
        }
        var diseaseCode = getSelectedValueFromGridKendo(gridDiseaseInfo, 'diseaseCode');
        var isActive = getSelectedValueFromGridKendo(gridDiseaseInfo, 'isActive');
        if(!isActive){
            showError('Already inactive');
            return false;
        }
        if (!confirm('Are you sure you want to deactivate this disease?')) {
            return false;
        }

        showLoadingSpinner(true);
        $.ajax({
            url: "${createLink(controller: 'diseaseInfo', action:  'delete')}?diseaseCode=" + diseaseCode,
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
        if (executeCommonPreConditionForSelectKendo(gridDiseaseInfo, 'record') == false) {
            return;
        }

        dropDownDiseaseGroup.enable(false);
        $("#diseaseInfoRow").show();
        var diseaseInfo = getSelectedObjectFromGridKendo(gridDiseaseInfo);
        showRecord(diseaseInfo);
    }

    function showRecord(diseaseInfo) {
        diseaseInfoModel.set('diseaseInfo', diseaseInfo);
        $('#create').html("<span class='k-icon k-i-plus'></span>Update");
    }
    function getDiseaseCode() {
        var diseaseGroupId = $("#diseaseGroupId").val();

        if (diseaseGroupId == '') {
            $("#diseaseCode").val('');
            dropDownDiseaseGroup.value('');
            return false;
        }
        showLoadingSpinner(true);
        var actionUrl = "${createLink(controller:'diseaseInfo', action: 'retrieveDiseaseCode')}?diseaseGroupId=" + diseaseGroupId;
        jQuery.ajax({
            type: 'post',
            url: actionUrl,
            success: function (data, textStatus) {
                $('#diseaseCode').val(data.diseaseCode);
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
                var newEntry = result.diseaseInfo;
                var selectedRow = gridDiseaseInfo.select();
                var allItems = gridDiseaseInfo.items();
                var selectedIndex = allItems.index(selectedRow);
                gridDiseaseInfo.removeRow(selectedRow);
                gridDiseaseInfo.dataSource.insert(selectedIndex, newEntry);
                resetForm();
                showSuccess(result.message);
            } catch (e) {
                // Do Nothing
            }
        }
    }

</script>
