<script type="text/x-kendo-template" id="gridToolbar">
<ul id="menuGrid" class="kendoGridMenu">
    <sec:access url="/counselorAction/update">
        <li onclick="editRecord();"><i class="fa fa-edit"></i>Counselor Action</li>
    </sec:access>
</ul>
</script>

<script language="javascript">
    var gridCounselorAction, dataSource, registrationInfoModel, dropDownServiceType, dropDownReferTo,
            dropDownDiseaseGroup, gridServiceHeadInfo, gridDiseaseDetails, dropDownRegistrationNo,
            dropDownreferenceServiceNoDDL;
    var checkedIds = {}; // declare an object to hold selected grid ids
    var checkedDiseaseCodes = {}; // declare an object to hold selected disease codes
    var checkedDiseaseNames = {}; // declare an object to hold selected disease names
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
        var checked = [];
        for (var i in checkedIds) {
            if (checkedIds[i]) {
                checked.push(i);
            }
        }
        $('#selectedChargeId').val(checked);
        if( $('#chkboxPathology').is(":checked"))
            $('#chkboxPathology').val('true');
        if( $('#chkboxMedicine').is(":checked"))
            $('#chkboxMedicine').val('true');
        if( $('#chkboxDocReferral').is(":checked"))
            $('#chkboxDocReferral').val('true');
        actionUrl = "${createLink(controller:'counselorAction', action: 'create')}";

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

    function resetBasicData() {
        for (var i in checkedIds) delete checkedIds[i];
        for (var i in checkedDiseaseCodes) delete checkedDiseaseCodes[i];
        for (var j in checkedDiseaseNames) delete checkedDiseaseNames[j];
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

                    bootboxAlert(result.message);

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
        $('#selectedDiseaseCode').val('');
        $("#selectedChargeId").val('');
        $("#serviceCharges").val('');
        $("#pathologyCharges").val('0');
        $('#actualPaid').val('');
        $('#subsidyAmount').val('');
        $('#divServiceDetails').hide();
        $('#divReferTo').show();
        $("#divPrescriptionType").show();
        $('#chkboxMedicine').attr('checked', false);
        $('#chkboxPathology').attr('checked', false);
        $('#chkboxDocReferral').attr('checked', false);
        $('#divCharges').show();
        $('#divServiceCharges').hide();
        $('#divSubsidy').hide();
        $('#divPayable').hide();
        $('#divPathology').hide();
        $('#btnPathologyService').hide();
        $('#divDiseaseDetails').hide();
        $('#divSelectedDisease').hide();
        dropDownServiceType.value('');
        dropDownReferTo.value('');
        dropDownRegistrationNo.value('');
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
                        subsidyAmount: {type: "number"},
                        consultancyAmt: {type: "number"},
                        pathologyAmt: {type: "number"},
                        totalCharge: {type: "number"},
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
    function gridDataBound(e) {
        var grid = e.sender;
        if (grid.dataSource.total() == 0) {
            $(e.sender.wrapper)
                    .find('tbody')
                    .append('<tr><td colspan="' + 9 + '" class="no-data"><center>Sorry, no data found <i class="fa fa-frown-o"></i></center></td></tr>');
        }
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
                        }, {
                            title: "Charges", headerAttributes: {style: setAlignCenter()},
                            columns: [

                                {
                                    field: "consultancyAmt",
                                    title: "Consultancy(৳)",
                                    width: 60,
                                    sortable: false,
                                    filterable: false
                                },
                                {
                                    field: "subsidyAmount",
                                    title: "Subsidy(৳)",
                                    width: 50,
                                    sortable: false,
                                    filterable: false
                                },
                                {
                                    field: "pathologyAmt",
                                    title: "Pathology(৳)",
                                    width: 70,
                                    sortable: false,
                                    filterable: false
                                },
                                {field: "totalCharge", title: "Total(৳)", width: 70, sortable: false, filterable: false}
                            ]
                        },
                        {
                            field: "isExit",
                            title: "Action <br/> Completed",
                            width: 50, sortable: false,filterable: false,
                            attributes: {style: setAlignCenter()},
                            headerAttributes: {style: setAlignCenter()},
                            template: "#=isExit?'YES':'NO'#"
                        }
                    ],
                    toolbar: kendo.template($("#gridToolbar").html())
                }
        )
        ;
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
        $('#divCharges').show();
        $('#divReferTo').hide();
        $("#divPrescriptionType").show();

        if (serviceTypeId == '') {
            dropDownServiceType.value('');
            $('#divServiceDetails').hide();
            return false;
        }
        else if (serviceTypeId == 2) {
            $('#chkboxMedicine').attr('checked', false);
            $('#chkboxPathology').attr('checked', false);
            $('#chkboxDocReferral').attr('checked', false);
            $('#divReferTo').show();
            $('#divServiceCharges').show();
            $('#pathologyCharges').val('0');
            $('#divPathology').hide();
            $('#divServiceDetails').hide();
            $("#counselorActionRow").show();
            $('#searchCriteriaRow').hide();
            $('#counselorActionGridRow').hide();
            $('#serviceCharges').show();
            $('#divServiceCharges').show();
            $('#divSubsidy').show();
            $('#divPayable').show();
            $('#divDiseaseDetails').show();
            $('#divSelectedDisease').show();
            loadDisease();
        }
        else if (serviceTypeId == 4) {
            $('#divCharges').hide();
            $("#divPrescriptionType").hide();
            $('#divDiseaseDetails').hide();
            $('#divSelectedDisease').hide();
            $('#divServiceDetails').show();
            resetBasicData();
            var url = "${createLink(controller: 'counselorAction', action: 'serviceHeadInfoListByType')}?serviceTypeId=" + serviceTypeId;
            populateGridKendo(gridServiceHeadInfo, url);
        }
        else if (serviceTypeId == 5) {
            $('#divPayable').hide();
            $('#divServiceDetails').hide();
            $("#divPrescriptionType").hide();
            $('#divDiseaseDetails').hide();
            $('#divSelectedDisease').hide();
            $('#divReferTo').show();
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
            height: 250,
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
            chargeAmt += parseFloat(dataItem.chargeAmount);
        } else {
            //-remove selection
            row.removeClass("k-state-selected");
            chargeAmt -= parseFloat(dataItem.chargeAmount);

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

        var charge = 0
        var subsidy = 0;
        var pathCharges = 0;
        if ($('#serviceCharges').val() > '0')
            charge = $('#serviceCharges').val();
        var v = $('#pathologyCharges').is(":visible");
        if (v) {
            pathCharges = $('#pathologyCharges').val();
        }
        if ($('#subsidyAmount').val() > '0') {
            subsidy = $('#subsidyAmount').val();
        }
        if (parseFloat(subsidy) > parseFloat(charge)) {
            subsidy=0;
            $('#subsidyAmount').val('');
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
            populateGridKendo(gridServiceHeadInfo, url);
        }
        else {
            $('#divPathology').hide();
            $('#pathologyCharges').val('');
            $('#divServiceDetails').hide();
            getPayableAmount();
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
        $('#divSelectedDisease').show();
        resetBasicData();
        var diseaseGroupId = 0;
        var url = "${createLink(controller: 'counselorAction', action: 'diseaseListByGroup')}?diseaseGroupId=" + diseaseGroupId;
        populateGridKendo(gridDiseaseDetails, url);
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
            sort: {field: 'diseaseCode', dir: 'asc'},
            serverPaging: false,
            serverFiltering: true,
            serverSorting: false
        });
    }

    function initDiseaseInfoGrid() {
        initDiseaseInfoDataSource();
        $("#gridDiseaseDetails").kendoGrid({
            dataSource: dataSource,
            height: 250,
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
                    filterable: true
                },
                {field: "name", title: "Name", width: 250, sortable: false, filterable: true},
                {
                    template: "<input type='checkbox' class='checkboxDisease' />"
                }
            ],filterable: {
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
        checkedDiseaseNames[dataItem.name] = checked;
        if (checked) {
            //-select the row
            row.addClass("k-state-selected");
        } else {
            //-remove selection
            row.removeClass("k-state-selected");
        }
        ShowSelectedDisease();
    }
    function ShowSelectedDisease(){
            var checkedDisease = [];
            for (var i in checkedDiseaseCodes) {
                if (checkedDiseaseCodes[i]) {
                    checkedDisease.push(i);
                }
            }
            $('#selectedDiseaseCode').val(checkedDisease);
            var diseaseNames = [];
            for (var j in checkedDiseaseNames) {
                if (checkedDiseaseNames[j]) {
                    diseaseNames.push(j);
                }
            }

           $('#selectedDiseaseTxt').val(diseaseNames);
            $.ajax({
                url: "${createLink(controller: 'counselorAction', action: 'getTotalServiceChargesByDiseaseCode')}?diseaseCodes=" + checkedDisease,
                success: function (data) {
                    if (data.isError) {
                        showError(data.message);
                        return false;
                    }
                    $('#serviceCharges').val(data.totalCharge)
                    getPayableAmount();
                },
                error: function (XMLHttpRequest, textStatus, errorThrown) {
                    afterAjaxError(XMLHttpRequest, textStatus);
                },
                complete: function (XMLHttpRequest, textStatus) {
                    showLoadingSpinner(false);
                }

            });
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

</script>
