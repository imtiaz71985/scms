<style>

.k-grid .k-button {
    min-width: 0 !important;
}

</style>
<script language="javascript">
    var gridCounselorAction, dataSource, registrationInfoModel, dropDownServiceType, dropDownServiceProvider,
            dropDownDiseaseGroup, gridServiceHeadInfo, dropDownRegistrationNo, dropDownReferralCenter,
            dropDownReferenceServiceNoDDL, detailsTemplate, dropDownDiseaseCode, dropDownOldServiceDate;
    var checkedIds = {}; // declare an object to hold selected grid ids

    var chargeAmt = 0;


    $(document).ready(function () {
        onLoadCounselorActionPage();
        initRegAndServiceInfoGrid();
        initServiceHeadInfoGrid();
        initObservable();
    });
    jQuery(function () {
        jQuery("form.oldServiceActionForm").submit(function (event) {
            event.preventDefault();
            return false;
        });
    });

    function onLoadCounselorActionPage() {

        $("#counselorActionRow").hide();
        $('#searchCriteriaRow').show();
        $('#counselorActionGridRow').show();
        dropDownDiseaseCode = initKendoDropdown($('#diseaseCode'), null, null, null);
        dropDownRegistrationNo = initKendoDropdown($('#regNoDDL'), null, null, null);
        // initialize form with kendo validator & bind onSubmit event
        initializeForm($("#oldServiceActionForm"), onSubmitCounselorAction);
        // update page title
        defaultPageTile("Previous Service Details", "counselorAction/showOldService");
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
            return false;
        }
        var date = dropDownOldServiceDate.value();
        showLoadingSpinner(true);
        var actionUrl = "${createLink(controller:'counselorAction', action: 'createTokenNoForOldService')}?createDate=" + date;

        jQuery.ajax({
            type: 'post',
            //data: jQuery("#oldServiceActionForm").serialize(),
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
        if (!validateForm($("#oldServiceActionForm"))) {
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
        if ($('#chkboxPathology').is(":checked"))
            $('#chkboxPathology').val('true');
        if ($('#chkboxMedicine').is(":checked"))
            $('#chkboxMedicine').val('true');
        if ($('#chkboxDocReferral').is(":checked"))
            $('#chkboxDocReferral').val('true');
        else if ($('#chkboxFollowupNeeded').is(":checked"))
            $('#chkboxFollowupNeeded').val('true');

        actionUrl = "${createLink(controller:'counselorAction', action: 'createOldService')}";

        jQuery.ajax({
            type: 'post',
            data: jQuery("#oldServiceActionForm").serialize(),
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
        chargeAmt = 0;
    }
    function executePostCondition(result) {
        if (result.isError) {
            showError(result.message);
            showLoadingSpinner(false);
        } else {
            try {
                bootboxAlert(result.message);
                resetForm();
            } catch (e) {
                // Do Nothing
            }
        }
    }
    function populateRegNoDDL() {
        var date = dropDownOldServiceDate.value();
        dropDownRegistrationNo.setDataSource(getKendoEmptyDataSource(dropDownRegistrationNo, null));
        dropDownRegistrationNo.value('');

        if (date != '') {
            showLoadingSpinner(true);
            $.ajax({
                url: "${createLink(controller: 'counselorAction', action: 'retrieveRegNoByDate')}?createDate=" + date,
                success: function (data) {
                    if (data.isError) {
                        showError(data.message);
                        return false;
                    }
                    dropDownRegistrationNo.setDataSource(data.lstRegNo);
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
    }
    function resetForm() {
        $(':input', $('#oldServiceActionForm')).each(function () {
            var type = this.type;
            var tag = this.tagName.toLowerCase(); // normalize case

            // password inputs, and textareas
            if (type == 'text' || type == 'password' || type == 'hidden' || tag == 'textarea' || type == 'select') {
                this.value = "";
            }
        });
        $("#selectedChargeId").val('');
        $("#selectedConsultancyId").val('');
        $("#serviceCharges").val('');
        $("#pathologyCharges").val('0');
        $('#actualPaid').val('');
        $('#subsidyAmount').val('');
        $('#divServiceDetails').hide();
        $('#divServiceProvider').show();
        $("#divPrescriptionType").show();
        $('#chkboxMedicine').attr('checked', false);
        $('#chkboxPathology').attr('checked', false);
        $('#chkboxDocReferral').attr('checked', false);
        $('#chkboxFollowupNeeded').attr('checked', false);
        $('#divCharges').show();
        $('#divServiceCharges').hide();
        $('#divSubsidy').hide();
        $('#divPayable').hide();
        $('#divPathology').hide();
        $('#btnPathologyService').hide();
        $('#divSelectedDisease').hide();
        $('#divTakenService').hide();
        $('#divReferenceServiceNo').hide();
        $('#divReferralCenter').hide();
        dropDownServiceType.value('');
        dropDownDiseaseGroup.value('');
        dropDownDiseaseCode.value('');
        dropDownServiceProvider.value('');
        dropDownRegistrationNo.value('');
        dropDownReferralCenter.value('');
        dropDownOldServiceDate.value('');
        $('#referenceServiceNoDDL').val('');
        $("#counselorActionRow").hide();
        $('#searchCriteriaRow').show();
        $('#counselorActionGridRow').show();
        $('#chkboxPathology').val('');
        $('#chkboxMedicine').val('');
        $('#chkboxDocReferral').val('');
        $("#gridCounselorAction").data('kendoGrid').dataSource.read();
        $('#diseaseCodeForChargeFree').val('');
        $("#isUndiagnosed").val('');
        $('#serviceDate').val('');

        resetBasicData();
    }
    function initDataSourceRegAndServiceInfo() {
        dataSource = new kendo.data.DataSource({
            transport: {
                read: {
                    url: "${createLink(controller: 'counselorAction', action: 'listOfOldService')}",
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
                        serviceType: {type: "string"},
                        remarks: {type: "string"},
                        is_approved: {type: "boolean"},
                        is_decline: {type: "boolean"}
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

    function setCAlignRight() {
        return "text-align:right;font-size:9pt;";
    }
    function setCAlignLeft() {
        return "text-align:leftt;font-size:9pt;";
    }
    function setCAlignCenter() {
        return "text-align:center;font-size:9pt;";
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
                        {
                            field: "regNo", title: "Reg No", width: 60, attributes: {style: setCAlignCenter()},
                            headerAttributes: {style: setCAlignCenter()}, sortable: false, filterable: false
                        },
                        {
                            field: "serviceTokenNo",
                            title: "Token No",
                            width: 65,
                            attributes: {style: setCAlignCenter()},
                            headerAttributes: {style: setCAlignCenter()},
                            sortable: false,
                            filterable: false
                        },
                        {
                            field: "serviceDate",
                            title: "Service<br/> Date",
                            width: 50,
                            attributes: {style: setCAlignCenter()},
                            headerAttributes: {style: setCAlignCenter()},
                            sortable: false,
                            filterable: false
                        },
                        {
                            field: "patientName", title: "Name", width: 100, attributes: {style: setCAlignLeft()},
                            headerAttributes: {style: setCAlignLeft()}, sortable: false, filterable: false
                        },
                        {
                            field: "serviceType",
                            title: "Service Type",
                            width: 100,
                            attributes: {style: setCAlignLeft()},
                            headerAttributes: {style: setCAlignLeft()},
                            sortable: false,
                            filterable: false
                        },
                        {
                            field: "dateOfBirth", title: "Age", width: 30, attributes: {style: setCAlignCenter()},
                            headerAttributes: {style: setCAlignCenter()}, sortable: false, filterable: false,
                            template: "#=evaluateDateRange(dateOfBirth, new Date())#"
                        }, {
                            field: "remarks", title: "Remarks", width: 80, attributes: {style: setCAlignLeft()},
                            headerAttributes: {style: setCAlignLeft()}, sortable: false, filterable: false
                        },
                        {
                            field: "is_approved",
                            title: "Status",
                            width: 50,
                            sortable: false,
                            filterable: false,
                            attributes: {style: setCAlignCenter()},
                            headerAttributes: {style: setCAlignCenter()},
                            template: "#=is_approved==true?'Approve':(is_decline==true?'Decline':'Not Approve')#"
                        },
                         {
                            command: [
                                //define the commands here
                                {name: "custom1", text: "", click: showDetails, className: "fa fa-search-plus "},
                                {name: "custom2", text: "", click: deleteRecord, className: "fa fa-trash "}
                            ],
                            title: "", width: 50
                        }

                    ]
                }
        )
        ;
        gridCounselorAction = $("#gridCounselorAction").data("kendoGrid");
    }

    function showDetails(e) {
        e.preventDefault();
        var dataItem = this.dataItem($(e.currentTarget).closest("tr"));
        $.ajax({
            url: "${createLink(controller: 'counselorAction', action: 'oldServiceDetails')}?tokenNo=" + dataItem.serviceTokenNo,
            success: function (data) {
                detailsTemplate = kendo.template($("#detailsTemplate").html());
                wnd.content(detailsTemplate(data.details));
                wnd.center().open();
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
        $('#divCharges').hide();
        $('#divPathology').hide();
        $('#divServiceProvider').hide();
        $("#divPrescriptionType").hide();
        $('#divSelectedDisease').hide();
        $('#searchCriteriaRow').hide();
        $('#counselorActionGridRow').hide();
        $('#divPayable').hide();
        $('#divServiceDetails').hide();
        $('#divTakenService').hide();
        dropDownDiseaseGroup.value('');
        $('#selectedConsultancyId').val('');
        $('#selectedDiseaseCode').val('');

        if (serviceTypeId == '') {
            $('#divServiceProvider').show();
            $("#divPrescriptionType").show();
        }
        else if (serviceTypeId == 4) {
            $('#chkboxPathology').attr('checked', false);
            $('#chkboxMedicine').attr('checked', false);
            $('#chkboxDocReferral').attr('checked', false);
            $('#divReferralCenter').hide();
            $('#divServiceDetails').show();
            resetBasicData();
            var url = "${createLink(controller: 'counselorAction', action: 'serviceHeadInfoListByType')}?serviceTypeId=" + serviceTypeId;
            populateGridKendo(gridServiceHeadInfo, url);
        }
        else {
            $('#divServiceProvider').show();
            $("#divPrescriptionType").show();
            $('#divCharges').show();
            $('#divServiceCharges').show();
            $('#serviceCharges').show();
            $('#divSubsidy').show();
            $('#divPayable').show();
            $('#divSelectedDisease').show();
            $('#divTakenService').show();
            $('#serviceCharges').val('0');
            $('#groupServiceCharge').val('0');
            $('#subsidyAmount').val('');
            loadDisease();
        }

        if ($('#chkboxPathology').is(":checked")) {
            $('#divServiceDetails').show();
            $('#divCharges').show();
            $('#divPathology').show();
            getPayableAmount();
        }
        else
            $('#payableAmount').val('0');
    }
    function populateServiceNoDDL(regNo) {
        if (regNo == '') {
            dropDownReferenceServiceNoDDL.setDataSource(getKendoEmptyDataSource(dropDownReferenceServiceNoDDL, null));
            dropDownReferenceServiceNoDDL.value('');
            return false;
        }
        showLoadingSpinner(true);
        $.ajax({
            url: "${createLink(controller: 'counselorAction', action: 'retrieveTokenNoByRegNo')}?regNo=" + regNo + '&serviceDate=' + $('#serviceDate').val(),
            success: function (data) {
                if (data.isError) {
                    showError(data.message);
                    return false;
                }
                dropDownReferenceServiceNoDDL.setDataSource(data.lstTokenNo);
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
            height: 350,
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

        var charge = 0;
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
            subsidy = 0;
            $('#subsidyAmount').val('');
        }

        var payable = (parseFloat(charge) + parseFloat(pathCharges)) - parseFloat(subsidy);
        $('#payableAmount').val(payable);
    }
    function loadPathologyServicesToComplete() {
        $("#selectedChargeId").val('');
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
        $('#divSelectedDisease').show();
        resetBasicData();
        dropDownDiseaseCode.setDataSource(getKendoEmptyDataSource(dropDownDiseaseCode, null));
        dropDownDiseaseCode.value('');
        var diseaseGroupId = dropDownDiseaseGroup.value();
        var url = "${createLink(controller: 'counselorAction', action: 'diseaseListByGroup')}?diseaseGroupId=" + diseaseGroupId;

        if (diseaseGroupId != '') {
            showLoadingSpinner(true);
            $.ajax({
                url: url,
                success: function (data) {
                    if (data.isError) {
                        showError(data.message);
                        return false;
                    }
                    dropDownDiseaseCode.setDataSource(data.list);
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
    }
    function LoadDetailsByRegNo() {
        generateTokenNo();
        $('#divServiceType').show();
        $("#counselorActionRow").show();
        $('#searchCriteriaRow').hide();
        $('#counselorActionGridRow').hide();

    }
    function generateTokenNo() {
        var regNo = $('#regNoDDL').val();
        $("#regNo").val(regNo);
        if (regNo > 0) {
            var date = dropDownOldServiceDate.value();
            $('#serviceDate').val(date);
            showLoadingSpinner(true);
            var actionUrl = "${createLink(controller:'counselorAction', action: 'createTokenNoForOldService')}?createDate=" + date;

            jQuery.ajax({
                type: 'post',
                //data: jQuery("#oldServiceActionForm").serialize(),
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
    }
    function loadFormForFollowup() {
        generateTokenNo();
        $("#counselorActionRow").show();
        $('#searchCriteriaRow').hide();
        $('#counselorActionGridRow').hide();
        $('#divServiceProvider').show();
        $('#divServiceType').hide();
        $("#divPrescriptionType").show();
        $('#divCharges').show();
        $('#divServiceCharges').show();
        $('#serviceCharges').show();
        $('#divSubsidy').show();
        $('#divPayable').show();
        $('#divSelectedDisease').show();
        $('#divTakenService').show();
        $('#serviceCharges').val('0');
        $('#groupServiceCharge').val('0');
        $('#subsidyAmount').val('');
        $('#divReferenceServiceNo').show();
        $('#referenceServiceNoDDL').kendoDropDownList({
            dataTextField: 'serviceTokenNo',
            dataValueField: 'serviceTokenNo',
            filter: "contains",
            suggest: true
        });
        dropDownReferenceServiceNoDDL = $('#referenceServiceNoDDL').data('kendoDropDownList');
        var regNo = $('#regNo').val();
        populateServiceNoDDL(regNo);
    }
    function getReferenceNoWiseDisease() {
        var tokenNo = $("#referenceServiceNoDDL").val();

        var actionUrl = "${createLink(controller:'counselorAction', action: 'retrieveDiseaseOfReferenceTokenNo')}?tokenNo=" + tokenNo;

        jQuery.ajax({
            type: 'post',
            //data: jQuery("#oldServiceActionForm").serialize(),
            url: actionUrl,
            success: function (data, textStatus) {

                $('#serviceCharges').val('0');
                $('#groupServiceCharge').val('0');
                $('#subsidyAmount').val('');
                $('#payableAmount').val('0');
                $("#selectedConsultancyId").val('');
                $("#isUndiagnosed").val(data.isUndiagnosed);
                dropDownDiseaseGroup.value(data.lstDiseaseInfo[0].groupId);

                if (data.isChargeApply) {
                    getConsultationFees();
                }
                else {
                    $('#diseaseCodeForChargeFree').val(data.lstDiseaseInfo[0].disease_code);
                    loadDisease();
                }
                dropDownDiseaseCode.value(data.lstDiseaseInfo[0].disease_code);

            },
            error: function (XMLHttpRequest, textStatus, errorThrown) {

            },
            complete: function (XMLHttpRequest, textStatus) {
                showLoadingSpinner(false);
            },
            dataType: 'json'
        });

    }
    function getConsultationFees() {
        var groupId = $("#diseaseGroupId").val();
        loadDisease();

        if ($("#isUndiagnosed").val() != 'true') {
            $.ajax({
                url: "${createLink(controller: 'counselorAction', action: 'getTotalServiceChargesByGroupId')}?groupId=" + groupId + '&serviceDate=' + $('#serviceDate').val(),
                success: function (data) {
                    if (data.isError) {
                        showError(data.message);
                        return false;
                    }
                    $('#serviceCharges').val(data.totalCharge);
                    $('#groupServiceCharge').val(data.totalCharge);
                    $('#selectedConsultancyId').val(data.chargeIds);

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
        else {
            $('#serviceCharges').val('0');
            $('#groupServiceCharge').val('0');
            $('#subsidyAmount').val('');
            $("#selectedConsultancyId").val('');
            getPayableAmount();
        }

    }
    function loadReferralCenter() {
        if ($('#chkboxDocReferral').is(":checked")) {
            $('#divReferralCenter').show();
            $('#chkboxFollowupNeeded').attr('checked', false);
        }
        else {
            $('#divReferralCenter').hide();
            dropDownReferralCenter.value('');
        }
    }
    function unLoadReferralCenter() {
        if ($('#chkboxFollowupNeeded').is(":checked")) {
            $('#divReferralCenter').hide();
            $('#chkboxDocReferral').attr('checked', false);
            dropDownReferralCenter.value('');
        }

    }
    function deleteRecord(e) {

        if (!confirm('Are you sure you want to delete this service?')) {
            return false;
        }
        e.preventDefault();
        var dataItem = this.dataItem($(e.currentTarget).closest("tr"));

        showLoadingSpinner(true);
        $.ajax({
            url: "${createLink(controller: 'counselorAction', action:  'deleteOldService')}?tokenNo=" + dataItem.serviceTokenNo,
            success: function (data) {
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
        return true;
    }
    function executePostConditionDelete(result) {
        if (result.isError) {
            showError(result.message);
            showLoadingSpinner(false);
        } else {
            try {
                $("#gridCounselorAction").data("kendoGrid").dataSource.read();
                showSuccess(result.message);
            } catch (e) {
                // Do Nothing
            }
        }
    }
    function checkIsChargeApply() {
        if ($('#divReferenceServiceNo').is(":visible")) {
            var diseaseId = $("#diseaseCode").val();
            if (($('#diseaseCodeForChargeFree').val() != diseaseId) && ($("#isUndiagnosed").val() != 'true')) {
                var groupId = $("#diseaseGroupId").val();
                $.ajax({
                    url: "${createLink(controller: 'counselorAction', action: 'getTotalServiceChargesByGroupId')}?groupId=" + groupId + '&serviceDate=' + $('#serviceDate').val(),
                    success: function (data) {
                        if (data.isError) {
                            showError(data.message);
                            return false;
                        }
                        $('#serviceCharges').val(data.totalCharge);
                        $('#groupServiceCharge').val(data.totalCharge);
                        $('#selectedConsultancyId').val(data.chargeIds);

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
            else {
                $('#serviceCharges').val('0');
                $('#groupServiceCharge').val('0');
                $('#subsidyAmount').val('');
                $("#selectedConsultancyId").val('');
                getPayableAmount();
            }
        }

        if($('#serviceCharges').val()<=0) {
            getChargeAmountByDiseaseCode();
        }
    }
    function getChargeAmountByDiseaseCode(){
        var diseaseId = $("#diseaseCode").val();
        $.ajax({
            url: "${createLink(controller: 'counselorAction', action: 'getTotalServiceChargesByDiseaseCode')}?diseaseCode=" + diseaseId,
            success: function (data) {
                if (data.isError) {
                    showError(data.message);
                    return false;
                }
                $('#serviceCharges').val(data.totalCharge);
                $('#selectedConsultancyId').val(data.chargeIds);

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

</script>
