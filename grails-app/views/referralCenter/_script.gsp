<script type="text/x-kendo-template" id="gridToolbar">
<ul id="menuGrid" class="kendoGridMenu">
    <sec:access url="/referralCenter/create">
        <li onclick="showForm();"><i class="fa fa-plus-square-o"></i>New</li>
    </sec:access>
    <sec:access url="/referralCenter/update">
        <li onclick="editRecord();"><i class="fa fa-edit"></i>Edit</li>
    </sec:access>
</ul>
</script>

<script language="javascript">
    var gridReferralCenter, dataSource, ReferralCenterModel;

    $(document).ready(function () {
        onLoadReferralCenterPage();
        initReferralCenterGrid();
        initObservable();
    });

    function onLoadReferralCenterPage() {
        $("#referralCenterRow").hide();
        // initialize form with kendo validator & bind onSubmit event
        initializeForm($("#referralCenterForm"), onSubmitReferralCenter);
        var date = new Date();
        date.setDate(date.getDate() + 1);
        $("#activationDate").kendoDatePicker({
            format: "dd/MM/yyyy",
            parseFormats: ["yyyy-MM-dd"],
            min: date
        });
        $("#activationDate").kendoMaskedTextBox({mask: "00/00/0000"});

        // update page title
        defaultPageTile("Create Referral Center",'/referralCenter/show');
    }

    function showForm() {
        $("#referralCenterRow").show();
    }
    function executePreCondition() {
        if (!validateForm($("#referralCenterForm"))) {
            return false;
        }
        return true;
    }

    function onSubmitReferralCenter() {
        if (executePreCondition() == false) {
            return false;
        }

        setButtonDisabled($('#create'), true);
        showLoadingSpinner(true);
        var actionUrl = null;
        if ($('#id').val().isEmpty()) {
            actionUrl = "${createLink(controller:'referralCenter', action: 'create')}";
        } else {
            actionUrl = "${createLink(controller:'referralCenter', action: 'update')}";
        }

        jQuery.ajax({
            type: 'post',
            data: jQuery("#referralCenterForm").serialize(),
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
                var newEntry = result.referralCenter;
                if ($('#id').val().isEmpty() && newEntry != null) { // newly created
                    var gridData = gridReferralCenter.dataSource.data();
                    gridData.unshift(newEntry);
                } else if (newEntry != null) { // updated existing
                    var selectedRow = gridReferralCenter.select();
                    var allItems = gridReferralCenter.items();
                    var selectedIndex = allItems.index(selectedRow);
                    gridReferralCenter.removeRow(selectedRow);
                    gridReferralCenter.dataSource.insert(selectedIndex, newEntry);
                }
                resetForm();
                showSuccess(result.message);
            } catch (e) {
                // Do Nothing
            }
        }
    }

    function resetForm() {
        clearForm($("#referralCenterForm"), $('#name'));
        initObservable();
        $('#create').html("<span class='k-icon k-i-plus'></span>Create");
        $("#referralCenterRow").hide();
        initReferralCenterGrid();
    }

    function initDataSource() {
        dataSource = new kendo.data.DataSource({
            transport: {
                read: {
                    url: "${createLink(controller: 'referralCenter', action: 'list')}",
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
                        address: { type: "string" },
                        isActive: { type: "boolean" }

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

    function initReferralCenterGrid() {
        initDataSource();
        $("#gridReferralCenter").kendoGrid({
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
                {field: "name", title: "Name", width: 100, sortable: false, filterable: kendoCommonFilterable(97)},
                {field: "address", title: "Address", width: 200, sortable: false, filterable: false},
                {field: "isActive", title: "Active", width: 30, sortable: false, filterable: false,attributes: {style: setAlignCenter()},
                    headerAttributes: {style: setAlignCenter()}, template:"#=isActive?'YES':'NO'#"}
            ],
            filterable: {
                mode: "row"
            },
            toolbar: kendo.template($("#gridToolbar").html())
        });
        gridReferralCenter = $("#gridReferralCenter").data("kendoGrid");
        $("#menuGrid").kendoMenu();
    }

    function initObservable() {
        ReferralCenterModel = kendo.observable(
                {
                    referralCenter: {
                        id: "",
                        version: "",
                        name: "",
                        address: "",
                        isActive: true

                    }
                }
        );
        kendo.bind($("#application_top_panel"), ReferralCenterModel);
    }

    function deleteRecord() {
        if (executeCommonPreConditionForSelectKendo(gridReferralCenter, 'record') == false) {
            return;
        }
        var msg = 'Are you sure you want to delete the selected record?',
                url = "${createLink(controller: 'referralCenter', action:  'delete')}";
        confirmDelete(msg, url, gridReferralCenter);
    }

    function editRecord() {
        if (executeCommonPreConditionForSelectKendo(gridReferralCenter, 'record') == false) {
            return;
        }
        $("#referralCenterRow").show();
        var referralCenter = getSelectedObjectFromGridKendo(gridReferralCenter);
        showRecord(referralCenter);
    }

    function showRecord(referralCenter) {
        ReferralCenterModel.set('referralCenter', referralCenter);
        $('#create').html("<span class='k-icon k-i-plus'></span>Update");
    }

</script>
