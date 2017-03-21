<script language="javascript">
    var gridRegistrationInfo, dataSource,dropDownSex,dropDownMaritalStatus,
        dropDownDistrict,dropDownUpazila,dropDownUnion,dropDownVillage, regNo,dropDownCreatingDate;

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

    function onSubmitRegistrationInfo() {
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
        var frmValidator = $('#registrationInfoForm').kendoValidator({ validateOnBlur: false }).data("kendoValidator");
        frmValidator.hideMessages();

        dropDownMaritalStatus.value('');
        dropDownSex.value('');
        dropDownDistrict.value('');
        dropDownUnion.value('');
        dropDownUpazila.value('');
        dropDownVillage.value('');

        $("#regNo").val(regNo);

        $('#regFees').val('10 tk');
        $('#newOrRevisit').prop('checked', true);
    }
    function initDataSource() {
        var creatingDate = dropDownCreatingDate.value();

        dataSource = new kendo.data.DataSource({
            transport: {
                read: {
                    url: "${createLink(controller: 'registrationInfo', action: 'list')}?isNew=Yes&creatingDate="+creatingDate,
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
                        sex: { type: "string" },
                        maritalStatusId: { type: "number" },
                        maritalStatus: { type: "string" },
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
                {field: "regNo", title: "Reg No", width: 50, sortable: false, filterable: false},
                {field: "patientName", title: "Name", width: 100, sortable: false, filterable: false},
                {field: "fatherOrMotherName", title: "Father/Mother/Spouse", width: 90, sortable: false, filterable: false},
                {field: "address", title: "Address", width: 150, sortable: false, filterable: false},
                {field: "dateOfBirth", title: "Age", width: 40, sortable: false, filterable: false,
                    template: "#=evaluateDateRange(dateOfBirth, new Date())#"},
                {field: "sex", title: "Gender", width: 50, sortable: false, filterable: false},
                {
                    command: [
                        //define the commands here
                        { name: "custom1", text: "",click: deleteRecord,className: "fa fa-trash "  }
                    ],
                    title: "",width:50
                }
            ],
            filterable: {
                mode: "row"
            }
        });
        gridRegistrationInfo = $("#gridRegistrationInfo").data("kendoGrid");
        $("#menuGrid").kendoMenu();
    }
    function deleteRecord(e) {

        if (!confirm('Are you sure you want to delete this patient?')) {
            return false;
        }
        e.preventDefault();
       // var d = this.dataItem($(e.currentTarget).closest("tr"));
        var di = this.dataItem($(e.currentTarget).closest("tr"));
        showLoadingSpinner(true);
        $.ajax({
            url: "${createLink(controller: 'registrationInfo', action:  'delete')}?regNo=" + di.regNo,
            success: function (data) {
                executePostCondition(data);
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
    function populateUpazilaList() {
        var districtId = dropDownDistrict.value();
        dropDownUpazila.setDataSource(getKendoEmptyDataSource(dropDownUpazila, null));
        dropDownUnion.setDataSource(getKendoEmptyDataSource(dropDownUnion, null));
        dropDownUpazila.value('');
        dropDownUnion.value('');
        if (districtId != '') {
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

    function populateAddress() {

        var villageId = $('#village').val();
        if (!isNaN(villageId) ){
            showLoadingSpinner(true);
            var actionUrl = "${createLink(controller:'registrationInfo', action: 'addressByVillage')}?villageId=" + villageId;
            jQuery.ajax({
                type: 'post',
                url: actionUrl,
                success: function (data, textStatus) {
                    dropDownDistrict.value(data.districtId);
                    populateUpazilaListForUpdate(data.districtId,data.upazilaId);
                    populateUnionListForUpdate(data.upazilaId,data.unionId);
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
    function getAndSetAge() {

       var date1= toMmDdYy($('#dateOfBirth').val());
        if(new Date(date1)>new Date()){
            showError('Sorry! Invalid date.');
            $('#dateOfBirth').val('');
            $('#ageTxt').val('');
            return false;
        }
        var a=evaluateDateRange(new Date(date1),new Date());
        $('#ageTxt').val(a );
    }
    function getAndSetDoB() {
        var year = parseInt($('#ageTxt').val());
        if(year>=0)
        $('#ageTxt').val(year);
        else{
            $('#dateOfBirth').val('');
            $('#ageTxt').val('');
            return false;
        }
       var cuDate=  moment().format('DD/MM/YYYY');
        var curYear=cuDate.substring(6,10);
        year=curYear-year;
        cuDate=cuDate.substring(0,6)+year;
        $('#dateOfBirth').val(cuDate);
    }
    function clearTextBox(){
        $('#dateOfBirth').val('');
        $('#ageTxt').val('');
    }
    function toMmDdYy(inStr) {
        if((typeof inStr == 'undefined') || (inStr == null) ||
                (inStr.length <= 0)) {
            return '';
        }
        var year = inStr.substring(6, 10);
        var month = inStr.substring(3, 5);
        var day = inStr.substring(0, 2);
        return month + '/' + day + '/' + year;
    };
    function changeFees() {
        if($('#newOrRevisit').is(':checked')) {
            $('#regFees').val('10 tk');
        }
       else{
            $('#regFees').val('0 tk');
        }
    }
function populateRegNo(){
    var creatingDate = dropDownCreatingDate.value();

        showLoadingSpinner(true);
        var actionUrl = "${createLink(controller:'registrationInfo', action: 'retrieveRegNo')}?creatingDate=" + creatingDate;
        jQuery.ajax({
            type: 'post',
            url: actionUrl,
            success: function (data, textStatus) {
                $('#regNo').val(data.regNo);
                regNo=data.regNo;
                initRegistrationInfoGrid();
            },
            error: function (XMLHttpRequest, textStatus, errorThrown) {

            },
            complete: function (XMLHttpRequest, textStatus) {
                showLoadingSpinner(false);
            },
            dataType: 'json'
        });
        //return false;

}


</script>
