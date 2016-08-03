<script type="text/x-kendo-template" id="gridToolbar">
<ul id="menuGrid" class="kendoGridMenu">
    <sec:access url="/requisitionAuthority/update">
        <li onclick="showForm();"><i class="fa fa-plus-square"></i>New</li>
    </sec:access>
    <sec:access url="/requisitionAuthority/update">
        <li onclick="editAuthority();"><i class="fa fa-edit"></i>Edit</li>
    </sec:access>
</ul>
</script>

<script language="javascript">
    var gridAuthority, dataSource, authorityModel,dropDownLocation, dropDownRights;

    $(document).ready(function () {
        $("#authorityRow").hide();
        onLoadAuthorityPage();
        initAuthorityGrid();
        initObservable();
    });

    function showForm() {
        if(${isClinic}){
            dropDownLocation.value('${hospitalCode}');
            dropDownLocation.readonly(true);
            dropDownRights.value(${rightsId});
            dropDownRights.readonly(true);
        }
        $("#authorityRow").show();
    }
    function onLoadAuthorityPage() {
        $("#authorityRow").hide();
        initializeForm($("#authorityForm"), onSubmitAuthority);
        defaultPageTile("Requisition Authority",null);
    }

    function executePreCondition() {
        if (!validateForm($("#authorityForm"))) {
            return false;
        }
        return true;
    }

    function onSubmitAuthority() {
        if (executePreCondition() == false) {
            return false;
        }
        setButtonDisabled($('#create'), true);
        showLoadingSpinner(true);
        var actionUrl = null;
        if ($('#id').val().isEmpty()) {
            actionUrl = "${createLink(controller:'requisitionAuthority', action: 'create')}";
        } else {
            actionUrl = "${createLink(controller:'requisitionAuthority', action: 'update')}";
        }
        jQuery.ajax({
            type: 'post',
            data: jQuery("#authorityForm").serialize(),
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
            $("#gridAuthority").data('kendoGrid').dataSource.read();
            resetForm('hide');
            showSuccess(result.message);
        }
    }

    function resetForm(hide) {
        clearForm($("#authorityForm"), $('#username'));
        clearErrors($("#authorityForm"));
        initObservable();
        $('#create').html("<span class='k-icon k-i-plus'></span>Create");
        dropDownRights.readonly(false);
        dropDownLocation.readonly(false);
        if(hide) $("#authorityRow").hide();
    }

    function initDataSource() {
        dataSource = new kendo.data.DataSource({
            transport: {
                read: {
                    url: "${createLink(controller: 'requisitionAuthority', action: 'list')}",
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
                        designation: { type: "string" },
                        location: { type: "string" },
                        locationCode: { type: "string" },
                        rights: { type: "string" },
                        rightsId: { type: "number" },
                        isActive: { type: "boolean" }
                    }
                },
                parse: function (data) {
                    checkIsErrorGridKendo(data);
                    return data;
                }
            },
            sort: {field: 'id', dir: 'asc'},
            pageSize: getDefaultPageSize(),
            serverPaging: true,
            serverFiltering: true,
            serverSorting: true
        });
    }

    function initAuthorityGrid() {
        initDataSource();
        $("#gridAuthority").kendoGrid({
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
                {field: "name", title: "Name", width: 70, sortable: false, filterable: false},
                {field: "designation", title: "Designation", width: 100, sortable: false, filterable: false},
                {field: "location", title: "Location", width: 100, sortable: false, filterable: false},
                {field: "rights", title: "Contribution", width: 50, sortable: false, filterable: false},
                {field: "isActive", title: "Is Active", width: 30, sortable: false, filterable: false,
                template:"#=isActive?'YES':'NO'#"}
            ],
            filterable: {
                mode: "row"
            },
            toolbar: kendo.template($("#gridToolbar").html())
        });
        gridAuthority = $("#gridAuthority").data("kendoGrid");
        $("#menuGrid").kendoMenu();
    }

    function initObservable() {
        authorityModel = kendo.observable(
                {
                    authority: {
                        id: "",
                        version: "",
                        name: "",
                        designation: "",
                        locationCode: "",
                        rightsId: "",
                        isActive: "true"
                    }
                }
        );
        kendo.bind($("#application_top_panel"), authorityModel);
    }

    function editAuthority() {
        if (executeCommonPreConditionForSelectKendo(gridAuthority, 'record') == false) {
            return;
        }
        $("#authorityRow").show();
        var authority = getSelectedObjectFromGridKendo(gridAuthority);
        showAuthority(authority);
    }

    function showAuthority(authority) {
        authorityModel.set('authority', authority);
        dropDownLocation.readonly(true);
        dropDownRights.readonly(true);
        $('#create').html("<span class='k-icon k-i-plus'></span>Update");
    }

</script>
