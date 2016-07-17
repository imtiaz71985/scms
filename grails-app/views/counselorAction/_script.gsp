<script type="text/x-kendo-template" id="gridToolbar">
<ul id="menuGrid" class="kendoGridMenu">
    <sec:access url="/counselorAction/update">
        <li onclick="editRecord();"><i class="fa fa-edit"></i>Counselor Action</li>
    </sec:access>
</ul>
</script>

<script language="javascript">
    var gridCounselorAction, dataSource, registrationInfoModel, dropDownServiceType, dropDownReferTo, dropDownPrescriptionType,
            dropDownDiseaseGroup, gridServiceHeadInfo, gridDiseaseDetails, dropDownRegistrationNo, dropDownServiceTokenNo,
            dropDownreferenceServiceNoDDL;
    var checkedIds = {}; // declare an object to hold selected grid ids
    var checkedDiseaseCodes = {}; // declare an object to hold selected disease codes
    var chargeAmt = 0;


    $(document).ready(function () {
        onLoadCounselorActionPage();
        initRegAndServiceInfoGrid();
        initServiceHeadInfoGrid();
        initDiseaseInfoGrid();
        initObservable();
    });
    jQuery(function () {
        jQuery("form.counselorActionForm").submit(function (event) {
            event.preventDefault();
            return false;
        });
    });

    function onLoadCounselorActionPage() {

        $("#counselorActionRow").hide();
        $('#searchCriteriaRow').show();
        $('#counselorActionGridRow').show();

        // initialize form with kendo validator & bind onSubmit event
        initializeForm($("#counselorActionForm"), onSubmitCounselorAction);
        // update page title
        defaultPageTile("Service Details", null);
    }
    function showForm() {
        if (executeCommonPreConditionForSelectKendo(gridCounselorAction, 'record') == false) {
            return;
        }
        $("#counselorActionRow").show();
        $('#searchCriteriaRow').hide();
        $('#counselorActionGridRow').hide();
        var counselorAction = getSelectedObjectFromGridKendo(gridCounselorAction);
        var regNo = counselorAction.regNo;
        $("#regNo").val(counselorAction.regNo);
        if (regNo == '') {
            $("#serviceTokenNo").val('');
            //dropDownDiseaseGroup.value('');
            return false;
        }
        showLoadingSpinner(true);
        var actionUrl = "${createLink(controller:'counselorAction', action: 'createServiceTokenNo')}";

        jQuery.ajax({
            type: 'post',
            //data: jQuery("#counselorActionForm").serialize(),
            url: actionUrl,
            success: function (data, textStatus) {
                $('#serviceTokenNo').val(data.tokenNo);
            },
            error: function (XMLHttpRequest, textStatus, errorThrown) {

            },
            complete: function (XMLHttpRequest, textStatus) {
                showLoadingSpinner(false);
            },
            dataType: 'json'
        });

    }
    function editRecord() {

        if (executeCommonPreConditionForSelectKendo(gridCounselorAction, 'record') == false) {
            return;
        }
        var counselorAction = getSelectedObjectFromGridKendo(gridCounselorAction);
        var regNo = counselorAction.regNo;
        if (counselorAction.isExit) {
            showError('Sorry! Selected service is completed.');
            return;
        }
        $("#regNo").val(counselorAction.regNo);
        $("#counselorActionRow").show();
        $('#searchCriteriaRow').hide();
        $('#counselorActionGridRow').hide();
        $("#divPrescriptionType").show();
        $('#serviceCharges').show();
        $('#divCharges').show();
        $('#divServiceCharges').show();
        $('#divSubsidy').show();
        $('#divPayable').show();
        $('#btnPathologyService').show();
        //$('#btnDiseaseInfo').show();
        $('#divDiseaseGroup').show();
        $('#divDiseaseDetails').show();
        initDiseaseInfoGrid();

        showLoadingSpinner(true);
        var actionUrl = "${createLink(controller:'counselorAction', action: 'retrieveServiceTokenNo')}?regNo=" + regNo;

        jQuery.ajax({
            type: 'post',
            //data: jQuery("#counselorActionForm").serialize(),
            url: actionUrl,
            success: function (data, textStatus) {
                if (data.serviceTokenNo == '') {
                    resetForm();
                }
                $('#serviceTokenNo').val(data.serviceTokenNo);
                $('#id').val(data.serviceTokenNo);
                $('#serviceCharges').val(data.totalHealthCharge);
                $('#payableAmount').val(data.totalHealthCharge);
                dropDownServiceType.value(data.serviceTypeId);
                dropDownServiceType.enable(false);
            },
            error: function (XMLHttpRequest, textStatus, errorThrown) {

            },
            complete: function (XMLHttpRequest, textStatus) {
                showLoadingSpinner(false);
            },
            dataType: 'json'
        });
        var url = "${createLink(controller: 'diseaseInfo', action: 'list')}?diseaseGroupId=" ;
        populateGridKendo(gridDiseaseDetails,url);

        $('#create').html("<span class='k-icon k-i-plus'></span>Save");
    }
    function executePreCondition() {
        if (!validateForm($("#counselorActionForm"))) {
            return false;
        }
        return true;
    }

    function onSubmitCounselorAction() {
        if (executePreCondition() == false) {
            return false;
        }
        setButtonDisabled($('#create'), true);
        showLoadingSpinner(true);
        var actionUrl = null;
        if ($('#id').val().isEmpty()) {
            actionUrl = "${createLink(controller:'counselorAction', action: 'create')}";
            var checked = [];
            for (var i in checkedIds) {
                if (checkedIds[i]) {
                    checked.push(i);
                }
            }
            $('#selectedChargeId').val(checked);
        } else {
            actionUrl = "${createLink(controller:'counselorAction', action: 'update')}";
            var checkedDisease = [];
            for (var i in checkedDiseaseCodes) {
                if (checkedDiseaseCodes[i]) {
                    checkedDisease.push(i);
                }
            }
            $('#selectedDiseaseCode').val(checkedDisease);
        }
        jQuery.ajax({
            type: 'post',
            data: jQuery("#counselorActionForm").serialize(),
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

    function resetBasicData(){
        for (var i in checkedIds) delete checkedIds[i];
        for (var i in checkedDiseaseCodes) delete checkedDiseaseCodes[i];
        chargeAmt = 0;
    }

    function executePostCondition(result) {
        if (result.isError) {
            showError(result.message);
            showLoadingSpinner(false);
        } else {
            try {
                /*var newEntry = result.counselorAction;
                 if ($('#id').val().isEmpty() && newEntry != null) { // newly created
                 var gridData = gridCounselorAction.dataSource.data();
                 gridData.unshift(newEntry);
                 } else if (newEntry != null) { // updated existing
                 var selectedRow = gridCounselorAction.select();
                 var allItems = gridCounselorAction.items();
                 var selectedIndex = allItems.index(selectedRow);
                 gridCounselorAction.removeRow(selectedRow);
                 gridCounselorAction.dataSource.insert(selectedIndex, newEntry);
                 }*/
                if ($('#id').val().isEmpty()) {
                    bootboxAlert(result.message);
                } else {
                    showSuccess(result.message);
                }
                resetForm();

            } catch (e) {
                // Do Nothing
            }
        }
    }

    function resetForm() {
        $(':input', $('#counselorActionForm')).each(function () {
            var type = this.type;
            var tag = this.tagName.toLowerCase(); // normalize case

            // password inputs, and textareas
            if (type == 'text' || type == 'password' || type == 'hidden' || tag == 'textarea' || type == 'select') {
                this.value = "";
            }
        });
        $("#selectedChargeId").val('');
        $("#serviceCharges").val('');
        $("#pathologyCharges").val('');
        $('#actualPaid').val('');
        $('#subsidyAmount').val('');
        $('#divServiceDetails').hide();
        $('#divReferTo').hide();
        $("#divPrescriptionType").hide();
        $('#divCharges').hide();
        $('#divServiceCharges').hide();
        $('#divSubsidy').hide();
        $('#divPayable').hide();
        $('#divPathology').hide();
        $('#btnPathologyService').hide();
        //$('#btnDiseaseInfo').hide();
        $('#divDiseaseGroup').hide();
        $('#divDiseaseDetails').hide();
        dropDownServiceType.value('');
        dropDownServiceType.enable(true);
        dropDownReferTo.value('');
        dropDownPrescriptionType.value('');
        dropDownRegistrationNo.value('');
        dropDownServiceTokenNo.value('');
        $('#create').html("<span class='k-icon k-i-plus'></span>Create");
        $("#counselorActionRow").hide();
        $('#searchCriteriaRow').show();
        $('#counselorActionGridRow').show();
        initRegAndServiceInfoGrid();
        resetBasicData();
    }

    function initDataSourceRegAndServiceInfo() {
        dataSource = new kendo.data.DataSource({
            transport: {
                read: {
                    url: "${createLink(controller: 'counselorAction', action: 'list')}",
                    dataType: "json",
                    type: "post"
                }
            },
            schema: {
                type: 'json',
                data: "list", total: "count",
                model: {
                    fields: {
                        regNo: {type: "string"},
                        patientName: {type: "string"},
                        dateOfBirth: {type: "date"},
                        mobileNo: {type: "string"},
                        address: {type: "string"},
                        serviceTokenNo: {type: "string"},
                        totalCharge: {type: "string"},
                        serviceDate: {type: "string"},
                        isExit: {type: "boolean"}
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

    function initRegAndServiceInfoGrid() {
        initDataSourceRegAndServiceInfo();
        $("#gridCounselorAction").kendoGrid({
            dataSource: dataSource,
            height: getGridHeightKendo(),
            selectable: true,
            sortable: true,
            resizable: true,
            reorderable: true,
            dataBound: gridDataBound,
            pageable: {
                refresh: true,
                pageSizes: getDefaultPageSizes(),
                buttonCount: 4
            },
            columns: [
                {field: "regNo", title: "Reg No", width: 80, sortable: false, filterable: false},
                {field: "serviceTokenNo", title: "Token No", width: 80, sortable: false, filterable: false},

                {field: "patientName", title: "Name", width: 150, sortable: false, filterable: false},
                {
                    field: "dateOfBirth", title: "Age", width: 50, sortable: false, filterable: false,
                    template: "#=evaluateDateRange(dateOfBirth, new Date())#"
                },
                {field: "totalCharge", title: "Total Charges", width: 80, sortable: false, filterable: false},
                {
                    field: "isExit",
                    title: "Action Completed",
                    width: 80,
                    sortable: false,
                    filterable: false,
                    attributes: {style: setAlignCenter()},
                    headerAttributes: {style: setAlignCenter()},
                    template: "#=isExit?'YES':'NO'#"
                }
            ],
            toolbar: kendo.template($("#gridToolbar").html())
        });
        gridCounselorAction = $("#gridCounselorAction").data("kendoGrid");
        $("#menuGrid").kendoMenu();
    }

    function initObservable() {
        registrationInfoModel = kendo.observable(
                {
                    counselorAction: {
                        regNo: "",
                        serviceTokenNo: "",
                        serviceDate: "",
                        prescriptionTypeId: "",
                        subsidyAmount: "",
                        visitTypeId: ""

                    }
                }
        );
        kendo.bind($("#application_top_panel"), registrationInfoModel);
    }

    function executePostConditionForDelete(data) {
        if (data.isError) {
            showError(data.message);
            return false;
        }
        var row = gridCounselorAction.select();
        row.each(function () {
            gridCounselorAction.removeRow($(this));
        });
        resetForm();
        showSuccess(data.message);
    }
    function getServiceHeadInfo() {
        var serviceTypeId = $("#serviceTypeId").val();
        $('#divReferenceServiceNo').hide();
        $('#divServiceCharges').hide();
        $('#divPathology').hide();
        $('#divCharges').hide();
        $('#divReferTo').hide();
        if (serviceTypeId == '') {
            dropDownServiceType.value('');
            $('#divServiceDetails').hide();
            $('#divCharges').hide();
            return false;
        }
        else if (serviceTypeId == 2) {
            $('#divCharges').show();
            $('#divReferTo').show();
            $('#divServiceCharges').show();
            //$('#divSubsidy').show();
            // $('#divPayable').show();
            $('#pathologyCharges').val('');
            $('#divPathology').hide();
        }
        else if (serviceTypeId == 3) {
            $('#divCharges').show();
            $('#divPathology').show();
            $('#divServiceCharges').hide();
            $('#divReferTo').show();
            //$('#divSubsidy').hide();
            //$('#divPayable').hide();
            $('#serviceCharges').val('');
        }
        else if (serviceTypeId == 5) {
            $('#divCharges').show();
            $('#divReferTo').show();
            $('#divServiceDetails').hide();
            $('#divReferenceServiceNo').show();
            $('#referenceServiceNoDDL').kendoDropDownList({
                dataTextField: 'serviceTokenNo',
                dataValueField: 'serviceTokenNo',
                filter: "contains",
                suggest: true
            });
            dropDownreferenceServiceNoDDL = $('#referenceServiceNoDDL').data('kendoDropDownList');
            var regNo = $('#regNo').val();
            populateServiceNoDDL(regNo)
        }
        if (serviceTypeId != 5) {

            $('#divServiceDetails').show();
            resetBasicData();
            var url = "${createLink(controller: 'counselorAction', action: 'serviceHeadInfoListByType')}?serviceTypeId=" + serviceTypeId;
            populateGridKendo(gridServiceHeadInfo, url);
        }
    }
    function populateServiceNoDDL(regNo) {

        if (regNo == '') {
            dropDownreferenceServiceNoDDL.setDataSource(getKendoEmptyDataSource(dropDownreferenceServiceNoDDL, null));
            dropDownreferenceServiceNoDDL.value('');
            return false;
        }
        showLoadingSpinner(true);
        $.ajax({
            url: "${createLink(controller: 'counselorAction', action: 'retrieveTokenNoByRegNo')}?regNo=" + regNo,
            success: function (data) {
                if (data.isError) {
                    showError(data.message);
                    return false;
                }
                dropDownreferenceServiceNoDDL.setDataSource(data.lstTokenNo);
            },
            error: function (XMLHttpRequest, textStatus, errorThrown) {
                afterAjaxError(XMLHttpRequest, textStatus);
            },
            complete: function (XMLHttpRequest, textStatus) {
                showLoadingSpinner(false);
            },
            dataType: 'json',
            type: 'post'
        });
        return true;
    }
    function initDataSourceForServiceHeadInfo() {
        dataSource = new kendo.data.DataSource({
            transport: {
                read: {
                    url: false,
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
            sort: {field: 'name', dir: 'asc'},
            serverPaging: false,
            serverFiltering: false,
            serverSorting: false
        });
    }

    function initServiceHeadInfoGrid() {
        initDataSourceForServiceHeadInfo();
        $("#gridServiceHeadInfo").kendoGrid({
            dataSource: dataSource,
            autoBind: false,
            height: 200,
            selectable: false,
            sortable: true,
            resizable: true,
            reorderable: true,
            navigatable: true,

            columns: [
                {field: "name", title: "Name", width: 270, sortable: false, filterable: false},
                {
                    field: "chargeAmount", title: "Fees", width: 100, attributes: {style: setAlignRight()},
                    headerAttributes: {style: setAlignRight()}, sortable: false, filterable: false
                },
                {
                    template: "<input type='checkbox' id='shiCheckbox' class='checkbox' />"
                }
            ]
        });
        gridServiceHeadInfo = $("#gridServiceHeadInfo").data("kendoGrid");
        //bind click event to the checkbox
        gridServiceHeadInfo.table.on("click", ".checkbox", selectServiceHead);
    }

    function selectServiceHead() {
        var checked = this.checked,
                row = $(this).closest("tr"),
                grid = $("#gridServiceHeadInfo").data("kendoGrid"),
                dataItem = grid.dataItem(row);
        checkedIds[dataItem.id] = checked;

        if (checked) {
            //-select the row
            row.addClass("k-state-selected");
            chargeAmt+=parseFloat(dataItem.chargeAmount);
        } else {
            //-remove selection
            row.removeClass("k-state-selected");
            chargeAmt-=parseFloat(dataItem.chargeAmount);

        }
        var v = $('#pathologyCharges').is(":visible");
        if (!v) {
            $('#serviceCharges').val(chargeAmt);
        }
        else {
            $('#pathologyCharges').val(chargeAmt);
        }
        getPayableAmount();
    }

    function getPayableAmount() {
        var charge = $('#serviceCharges').val();
        var subsidy = 0;
        var pathCharges = 0;
        var v = $('#pathologyCharges').is(":visible");
        if (v) {
            pathCharges = $('#pathologyCharges').val();
        }
        if ($('#subsidyAmount').val() > '0') {
            subsidy = $('#subsidyAmount').val();
        }
        if (subsidy > charge) {
            $('#subsidyAmount').val('0');
        }

        var payable = (parseFloat(charge) + parseFloat(pathCharges)) - parseFloat(subsidy);
        $('#payableAmount').val(payable);
    }
    function loadPathologyServicesToComplete() {
        var v = $('#divServiceDetails').is(":visible");
        if (!v) {
            $('#divServiceDetails').show();
            $('#divPathology').show();
            var serviceTypeId = 3;
            resetBasicData();
            var url = "${createLink(controller: 'counselorAction', action: 'serviceHeadInfoListByType')}?serviceTypeId=" + serviceTypeId;
            populateGridKendo(gridServiceHeadInfo,url);
        }
        else {
            $('#divPathology').hide();
            $('#divServiceDetails').hide();
        }
    }

    $('#subsidyAmount').kendoNumericTextBox({
        min: 0,
        step: 1,
        max: 999999999999.99,
        format: "#.##"

    });

    function loadDisease() {
        $('#divDiseaseDetails').show();
        resetBasicData();
        var diseaseGroupId = $('#diseaseGroupId').val();
        var url = "${createLink(controller: 'counselorAction', action: 'diseaseListByGroup')}?diseaseGroupId=" + diseaseGroupId;
        populateGridKendo(gridDiseaseDetails,url);
    }

    function initDiseaseInfoDataSource() {
        dataSource = new kendo.data.DataSource({
            transport: {
                read: {
                    url: false,
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
                        description: {type: "string"},
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
            sort: {field: 'name', dir: 'asc'},
            serverPaging: false,
            serverFiltering: false,
            serverSorting: false
        });
    }

    function initDiseaseInfoGrid() {
        initDiseaseInfoDataSource();
        $("#gridDiseaseDetails").kendoGrid({
            dataSource: dataSource,
            height: 200,
            autoBind: false,
            selectable: false,
            sortable: true,
            resizable: true,
            reorderable: true,
            pageable: false,
            columns: [
                {
                    field: "diseaseCode",
                    title: "Disease Code",
                    width: 100,
                    sortable: false,
                    filterable: false
                },
                {field: "name", title: "Name", width: 250, sortable: false, filterable: false },
                {
                    template: "<input type='checkbox' class='checkboxDisease' />"
                }
            ],
            filterable: {
                mode: "row"
            }
        });
        gridDiseaseDetails = $("#gridDiseaseDetails").data("kendoGrid");
        $("#menuGrid").kendoMenu();
    }
    gridDiseaseDetails.table.on("click", ".checkboxDisease", selectDisease);

    function selectDisease() {
        var checked = this.checked,
                row = $(this).closest("tr"),
                grid = $("#gridDiseaseDetails").data("kendoGrid"),
                dataItem = grid.dataItem(row);
        checkedDiseaseCodes[dataItem.diseaseCode] = checked;
        if (checked) {
            //-select the row
            row.addClass("k-state-selected");
        } else {
            //-remove selection
            row.removeClass("k-state-selected");
        }
    }

    function LoadDetailsByRegNo() {
        var regNo = $('#regNoDDL').val();
        $("#regNo").val(regNo);
        if (regNo > 0) {
            showLoadingSpinner(true);
            var actionUrl = "${createLink(controller:'counselorAction', action: 'createServiceTokenNo')}";

            jQuery.ajax({
                type: 'post',
                //data: jQuery("#counselorActionForm").serialize(),
                url: actionUrl,
                success: function (data, textStatus) {
                    $('#serviceTokenNo').val(data.tokenNo);
                },
                error: function (XMLHttpRequest, textStatus, errorThrown) {

                },
                complete: function (XMLHttpRequest, textStatus) {
                    showLoadingSpinner(false);
                },
                dataType: 'json'
            });
        }
        else {
            return;
        }
        $("#counselorActionRow").show();
        $('#searchCriteriaRow').hide();
        $('#counselorActionGridRow').hide();

    }
    function LoadDetailsByTokenNo() {

        var tokenNo = $('#serviceTokenNoDDL').val();
        if (tokenNo.length > 2) {
            $("#serviceTokenNo").val(tokenNo);
            showLoadingSpinner(true);
            var actionUrl = "${createLink(controller:'counselorAction', action: 'retrieveDataByTokenNo')}?tokenNo=" + tokenNo;

            jQuery.ajax({
                type: 'post',
                //data: jQuery("#counselorActionForm").serialize(),
                url: actionUrl,
                success: function (data, textStatus) {
                    if (data.regNo == '') {
                        resetForm();
                    }
                    $('#regNo').val(data.regNo);
                    $('#id').val(tokenNo);
                    $('#serviceCharges').val(data.totalHealthCharge);
                    $('#payableAmount').val(data.totalHealthCharge);
                    dropDownServiceType.value(data.serviceTypeId);
                    dropDownServiceType.enable(false);
                },
                error: function (XMLHttpRequest, textStatus, errorThrown) {

                },
                complete: function (XMLHttpRequest, textStatus) {
                    showLoadingSpinner(false);
                },
                dataType: 'json'
            });
        }
        else {
            return;
        }
        $('#create').html("<span class='k-icon k-i-plus'></span>Save");
        $("#counselorActionRow").show();
        $('#searchCriteriaRow').hide();
        $('#counselorActionGridRow').hide();
        $("#divPrescriptionType").show();
        $('#serviceCharges').show();
        $('#divCharges').show();
        $('#divServiceCharges').show();
        $('#divSubsidy').show();
        $('#divPayable').show();
        $('#btnPathologyService').show();
        //$('#btnDiseaseInfo').show();
        $('#divDiseaseGroup').show();
        $('#divDiseaseDetails').show();
        var url = "${createLink(controller: 'counselorAction', action: 'diseaseListByGroup')}?diseaseGroupId=" ;
        populateGridKendo(gridDiseaseDetails,url);
    }

</script>
