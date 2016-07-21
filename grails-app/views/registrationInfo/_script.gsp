<script type="text/x-kendo-template" id="gridToolbar">
<ul id="menuGrid" class="kendoGridMenu">
    <sec:access url="/registrationInfo/create">
        <li onclick="showForm();"><i class="fa fa-plus-square-o"></i>New</li>
    </sec:access>
    <sec:access url="/registrationInfo/update">
        <li onclick="editRecord();"><i class="fa fa-edit"></i>Edit</li>
    </sec:access>
    <sec:access url="/registrationInfo/delete">
        <li onclick="deleteRecord();"><i class="fa fa-trash-o"></i>Delete</li>
    </sec:access>
    <sec:access url="/registrationInfo/reIssue">
        <li onclick="reIssueRegNo();"><i class="fa fa-anchor"></i>Re Issue</li>
    </sec:access>
</ul>
</script>

<script language="javascript">
    var gridRegistrationInfo, dataSourceGrid, registrationInfoModel,dropDownSex,dropDownMaritalStatus,
            dropDownDistrict,dropDownUpazila,dropDownUnion,dropDownVillage;

    $(document).ready(function () {
        onLoadRegistrationInfoPage();
        initRegistrationInfoGrid();
        initObservable();
    });
    jQuery(function() {
        jQuery("form.counselorActionForm").submit(function(event) {
            event.preventDefault();
            return false;
        });
    });

    function onLoadRegistrationInfoPage() {
        dropDownUpazila = initKendoDropdown($('#upazilaId'), null, null, null);
        dropDownUnion = initKendoDropdown($('#unionId'), null, null, null);
        $("#registrationInfoRow").hide();

        // initialize form with kendo validator & bind onSubmit event
        initializeForm($("#registrationInfoForm"), onSubmitRegistrationInfo);
        // update page title
        defaultPageTile("Create Registration",null);
    }
    function showForm() {
        showLoadingSpinner(true);
        var actionUrl = "${createLink(controller:'registrationInfo', action: 'retrieveRegNo')}";
        jQuery.ajax({
            type: 'post',
            //data: jQuery("#registrationInfoForm").serialize(),
            url: actionUrl,
            success: function (data, textStatus) {
                $('#regNo').val(data.regNo);
            },
            error: function (XMLHttpRequest, textStatus, errorThrown) {

            },
            complete: function (XMLHttpRequest, textStatus) {
                showLoadingSpinner(false);
            },
            dataType: 'json'
        });
        $("#registrationInfoRow").show();
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
        var actionUrl = null;
        if ($('#id').val().isEmpty()) {
            actionUrl = "${createLink(controller:'registrationInfo', action: 'create')}";
        } else {
            actionUrl = "${createLink(controller:'registrationInfo', action: 'update')}";
        }
        jQuery.ajax({
            type: 'post',
            data: jQuery("#registrationInfoForm").serialize(),
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

        $('#regFees').val('10 tk');
        $('#create').html("<span class='k-icon k-i-plus'></span>Create");

        $('#addressSelection').hide();
        $('#divAddress').show();
        $("#registrationInfoRow").hide();
    }
    function initDataSource() {
        dataSourceGrid = new kendo.data.DataSource({
            transport: {
                read: {
                    url: "${createLink(controller: 'registrationInfo', action: 'list')}",
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
                {field: "regNo", title: "Reg No", width: 40, sortable: false, filterable: kendoCommonFilterable(97)},
                {field: "patientName", title: "Name", width: 100, sortable: false, filterable: kendoCommonFilterable(97)},
                {field: "fatherOrMotherName", title: "Father/Mother", width: 100, sortable: false, filterable: kendoCommonFilterable(97)},
                {field: "address", title: "Address", width: 170, sortable: false, filterable: kendoCommonFilterable(97)},
                {field: "dateOfBirth", title: "Age", width: 50, sortable: false, filterable: false,
                    template: "#=evaluateDateRange(dateOfBirth, new Date())#"}
                 ],
            filterable: {
                mode: "row"
            },
            toolbar: kendo.template($("#gridToolbar").html())
        });
        gridRegistrationInfo = $("#gridRegistrationInfo").data("kendoGrid");
        $("#menuGrid").kendoMenu();
    }

    function initObservable() {
        registrationInfoModel = kendo.observable(
                {
                    registrationInfo: {
                        regNo: "",
                        patientName: "",
                        fatherOrMotherName: "",
                        dateOfBirth: "",
                        sexId: "",
                        maritalStatusId:"",
                        mobileNo:"",
                        village:"",
                        unionId:"",
                        upazilaId:"",
                        districtId:"",
                        address:""
                    }
                }
        );
        kendo.bind($("#application_top_panel"), registrationInfoModel);
    }

    function deleteRecord() {
        if (executeCommonPreConditionForSelectKendo(gridRegistrationInfo, 'record') == false) {
            return;
        }
        if(!confirm('Are you sure you want to delete the record?')){
            return false;
        }
        showLoadingSpinner(true);
        var regNo = getSelectedValueFromGridKendo(gridRegistrationInfo, 'regNo');
        $.ajax({
            url: "${createLink(controller: 'registrationInfo', action:  'delete')}?regNo=" + regNo,
            success: executePostConditionForDelete,
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
   function executePostConditionForDelete(data){
       if (data.isError){
           showError(data.message);
           return false;
       }
       var row = gridRegistrationInfo.select();
       row.each(function () {
           gridRegistrationInfo.removeRow($(this));
       });
       resetForm();
       showSuccess(data.message);
    }

    function editRecord() {
        if (executeCommonPreConditionForSelectKendo(gridRegistrationInfo, 'record') == false) {
            return;
        }
        $("#registrationInfoRow").show();
        $('#addressSelection').show();
        $('#divAddress').hide();
        var registrationInfo = getSelectedObjectFromGridKendo(gridRegistrationInfo);

        populateUpazilaListForUpdate(registrationInfo.districtId,registrationInfo.upazilaId);
        populateUnionListForUpdate(registrationInfo.upazilaId,registrationInfo.unionId);
        showRecord(registrationInfo);
        dropDownVillage.value(registrationInfo.village);
        $('#id').val($('#regNo').val());

    }

    function showRecord(registrationInfo) {
        registrationInfoModel.set('registrationInfo', registrationInfo);
        $('#create').html("<span class='k-icon k-i-plus'></span>Update");
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
    function reIssueRegNo(){
        if (executeCommonPreConditionForSelectKendo(gridRegistrationInfo, 'record') == false) {
            return;
        }
        var data = getSelectedObjectFromGridKendo(gridRegistrationInfo);
        showReIssueModal(data);

    }

    function showReIssueModal(data) {
        $("#createRegReIssueModal").modal('show');

        $('#reissueRegNo').text(data.regNo);
        $('#hidReIssueRegNo').val(data.regNo);
        $('#reissueName').text(data.patientName);
        $('#reissueAddress').text(data.address);
    }

    function onClickCreateRegReIssueModal(){
        if (!validateForm($('#createRegReIssueForm'))) {
            return
        }
        var regNo = $('#hidReIssueRegNo').val(),
        description = $('#descriptionReissueModal').val();
        var param = "?regNo=" + regNo+"&description="+description;
        $.ajax({
            type: "POST",
            url: "${createLink(controller:'registrationInfo', action: 'reIssue')}"+param,
            data: $('#updateAttendance').serialize(),
            success: function (result, textStatus) {
                var data = JSON.parse(result);
                clearReIssueModal();
                if (data.isError == true) {
                    showError(data.message);
                    return false;
                }
                showSuccess(data.message);
                executePostCondition();
            }
        });
    }
    function hideCreateRegReIssueModal(){
        clearReIssueModal();
    }

    function clearReIssueModal(){
        $('#reissueRegNo').text('');
        $('#reissueName').text('');
        $('#reissueAddress').text('');
        $('#hidReIssueRegNo').val('');
        $('#descriptionReissueModal').val('');
        $("#createRegReIssueModal").modal('hide');
    }

</script>
