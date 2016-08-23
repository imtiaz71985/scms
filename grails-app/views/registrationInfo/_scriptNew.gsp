<script language="javascript">
    var gridRegistrationInfo, dataSourceGrid,dropDownSex,dropDownMaritalStatus,
        dropDownDistrict,dropDownUpazila,dropDownUnion,dropDownVillage, regNo;

    $(document).ready(function () {
        onLoadRegistrationInfoPage();
        initRegistrationInfoGrid();
    });

    function onLoadRegistrationInfoPage() {
        regNo = '${regNo}';
        $('#regNo').val(regNo);
        dropDownUpazila = initKendoDropdown($('#upazilaId'), null, null, null);
        dropDownUnion = initKendoDropdown($('#unionId'), null, null, null);

        // initialize form with kendo validator & bind onSubmit event
        initializeForm($("#registrationInfoForm"), onSubmitRegistrationInfo);
        // update page title
        defaultPageTile("Create Registration",null);
    }

    function executePreCondition() {
        if (!validateForm($("#registrationInfoForm"))) {
            return false;
        }
        return true;
    }

    function onSubmitRegistrationInfo() {
        if (executePreCondition() == false) {
            return false;
        }
        setButtonDisabled($('#create'), true);
        showLoadingSpinner(true);
        jQuery.ajax({
            type: 'post',
            data: jQuery("#registrationInfoForm").serialize(),
            url: "${createLink(controller:'registrationInfo', action: 'create')}",
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
                regNo = result.regNo;
                $("#gridRegistrationInfo").data("kendoGrid").dataSource.read();
                resetForm();
                $("#village").reloadMe();
                showSuccess(result.message);
            } catch (e) {
                // Do Nothing
            }
        }
    }

    function resetForm() {
        $(':input', $('#registrationInfoForm')).each(function () {
            var type = this.type;
            var tag = this.tagName.toLowerCase(); // normalize case
            // password inputs, and textareas
            if (type == 'text' || type == 'password' || type == 'hidden' || tag == 'textarea' || type == 'select' ) {
                this.value = "";
            }
        });
        var frmValidator = $('#registrationInfoForm').kendoValidator({
            validateOnBlur: false
        }).data("kendoValidator");
        frmValidator.hideMessages();

        dropDownMaritalStatus.value('');
        dropDownSex.value('');
        dropDownDistrict.value('');
        dropDownUnion.value('');
        dropDownUpazila.value('');
        dropDownVillage.value('');
        $("#regNo").val(regNo);

        $('#regFees').val('10 tk');
        $('#addressSelection').hide();
        $('#divAddress').show();
    }
    function initDataSource() {
        dataSourceGrid = new kendo.data.DataSource({
            transport: {
                read: {
                    url: "${createLink(controller: 'registrationInfo', action: 'list')}?isNew=Yes",
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
                        regNo: { type: "string" },
                        patientName: { type: "string" },
                        fatherOrMotherName: { type: "string" },
                        dateOfBirth: { type: "date" },
                        createDate: { type: "date" },
                        sexId: { type: "number" },
                        maritalStatusId: { type: "number" },
                        mobileNo: { type: "string" },
                        village:{type:"number"},
                        unionId:{type:"number"},
                        upazilaId:{type:"number"},
                        districtId:{type:"number"},
                        address:{type:"string"}
                    }
                },
                parse: function (data) {
                    checkIsErrorGridKendo(data);
                    return data;
                }
            },
            sort: {field: 'createDate', dir: 'desc'},
            pageSize: getDefaultPageSize(),
            serverPaging: true,
            serverFiltering: true,
            serverSorting: true
        });
    }

    function initRegistrationInfoGrid() {
        initDataSource();
        $("#gridRegistrationInfo").kendoGrid({
            dataSource: dataSourceGrid,
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
                {field: "regNo", title: "Reg No", width: 50, sortable: false, filterable: kendoCommonFilterable(97)},
                {field: "patientName", title: "Name", width: 100, sortable: false, filterable: kendoCommonFilterable(97)},
                {field: "fatherOrMotherName", title: "Father/Mother", width: 80, sortable: false, filterable: kendoCommonFilterable(97)},
                {field: "address", title: "Address", width: 150, sortable: false, filterable: kendoCommonFilterable(97)},
                {field: "dateOfBirth", title: "Age", width: 35, sortable: false, filterable: false,
                    template: "#=evaluateDateRange(dateOfBirth, new Date())#"}
            ],
            filterable: {
                mode: "row"
            }
        });
        $("#menuGrid").kendoMenu();
    }
    function populateUpazilaList() {
        var districtId = dropDownDistrict.value();
        if (districtId == '') {
            dropDownUpazila.setDataSource(getKendoEmptyDataSource(dropDownUpazila, null));
            dropDownUpazila.value('');
            return false;
        }
        showLoadingSpinner(true);
        $.ajax({
            url: "${createLink(controller: 'registrationInfo', action: 'upazilaListByDistrictId')}?districtId=" + districtId,
            success: function (data) {
                if (data.isError) {
                    showError(data.message);
                    return false;
                }
                dropDownUpazila.setDataSource(data.lstUpazila);
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

    function populateUpazilaListForUpdate(districtId,upzilaId) {

        if (districtId == '') {
            dropDownUpazila.setDataSource(getKendoEmptyDataSource(dropDownUpazila, null));
            dropDownUpazila.value('');
            return false;
        }
        showLoadingSpinner(true);
        $.ajax({
            url: "${createLink(controller: 'registrationInfo', action: 'upazilaListByDistrictId')}?districtId=" + districtId,
            success: function (data) {
                if (data.isError) {
                    showError(data.message);
                    return false;
                }
                dropDownUpazila.setDataSource(data.lstUpazila);
                dropDownUpazila.value(upzilaId);
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
    function populateUnionList() {
        var upazilaId = $("#upazilaId").val();
        if (upazilaId == '') {
            dropDownUnion.setDataSource(getKendoEmptyDataSource(dropDownUnion, null));
            dropDownUnion.value('');
            return false;
        }
        showLoadingSpinner(true);
        $.ajax({
            url: "${createLink(controller: 'registrationInfo', action: 'unionListByUpazilaId')}?upazilaId=" + upazilaId,
            success: function (data) {
                if (data.isError) {
                    showError(data.message);
                    return false;
                }
                dropDownUnion.setDataSource(data.lstUnion);
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
    function populateUnionListForUpdate(upazilaId,unionId) {
        if (upazilaId == '') {
            dropDownUnion.setDataSource(getKendoEmptyDataSource(dropDownUnion, null));
            dropDownUnion.value('');
            return false;
        }
        showLoadingSpinner(true);
        $.ajax({
            url: "${createLink(controller: 'registrationInfo', action: 'unionListByUpazilaId')}?upazilaId=" + upazilaId,
            success: function (data) {
                if (data.isError) {
                    showError(data.message);
                    return false;
                }
                dropDownUnion.setDataSource(data.lstUnion);
                dropDownUnion.value(unionId);
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
    $("#village").keypress(function(event) {
        if (event.which == 13) {
            event.preventDefault();
            populateAddress();
        }
    });
    function populateAddress() {

        var villageId = $('#village').val();
        if (isNaN(villageId) ){
            $('#addressSelection').show();
            $('#divAddress').hide();
            return false;
        }
        else {
            showLoadingSpinner(true);
            $('#addressSelection').hide();
            $('#divAddress').show();
            var actionUrl = "${createLink(controller:'registrationInfo', action: 'addressByVillage')}?villageId=" + villageId;
            jQuery.ajax({
                type: 'post',
                url: actionUrl,
                success: function (data, textStatus) {
                    $('#addressDetails').val(data.address);
                },
                error: function (XMLHttpRequest, textStatus, errorThrown) {

                },
                complete: function (XMLHttpRequest, textStatus) {
                    showLoadingSpinner(false);
                },
                dataType: 'json'
            });
            return true;
        }
    }

</script>
