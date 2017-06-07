<script type="text/x-kendo-template" id="gridToolbar">
<ul id="menuGrid" class="kendoGridMenu">
    <sec:access url="/diseaseInfo/update">
        <li onclick="editRecord();"><i class="fa fa-edit"></i>Unlock Transaction</li>
    </sec:access>
</ul>
</script>

<script language="javascript">
    var gridTransactionClosing, dataSource, transactionClosing, dropDownClosingDate,isAdmin;

    $(document).ready(function () {
        onLoadTransactionClosingPage();
        initTransactionClosingGrid();
        initObservable();
    });

    function onLoadTransactionClosingPage() {

        // initialize form with kendo validator & bind onSubmit event
        initializeForm($("#transactionClosingForm"), onSubmitTransactionClosing);
        // update page title
        defaultPageTile("Create Transaction Closing",null);

        isAdmin=${isAdmin};
        if(isAdmin==true){
            $("#transactionClosingRow").hide();
        }
    }
    function executePreCondition() {
        if (!validateForm($("#transactionClosingForm"))) {
            return false;
        }
        return true;
    }
    function getServedAndTotalPatient(){

        showLoadingSpinner(true);
        var closingDate=$('#closingDate').val();
        $.ajax({
            url: "${createLink(controller: 'transactionClosing', action:  'retrieveServedAndTotalPatient')}?closingDate=" + closingDate,
            success: function (data, textStatus) {
                $('#totalPatient').val(data.totalPatient);
                $('#servedPatient').val(data.totalServed);
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
    function onSubmitTransactionClosing() {
        if (executePreCondition() == false) {
            return false;
        }

        setButtonDisabled($('#create'), true);
        showLoadingSpinner(true);
        var actionUrl = null;
        if ($('#id').val().isEmpty()) {
            actionUrl = "${createLink(controller:'transactionClosing', action: 'create')}";
        }

        jQuery.ajax({
            type: 'post',
            data: jQuery("#transactionClosingForm").serialize(),
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
                gridTransactionClosing.dataSource.read();
                resetForm();
                showSuccess(result.message);
            } catch (e) {
                // Do Nothing
            }
        }
    }

    function resetForm() {
        clearForm($("#transactionClosingForm"), $('#closingDate'));
        $('#closingDate').reloadMe();
        initObservable();

    }

    function initDataSource() {
        dataSource = new kendo.data.DataSource({
            transport: {
                read: {
                    url: "${createLink(controller: 'transactionClosing', action: 'list')}",
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
                        remarks: { type: "string" },
                        creator: { type: "string" },
                        closingDate: { type: "date" },
                        createDate: { type: "date" },
                        isTransactionClosed: {type: "boolean"}
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

    function initTransactionClosingGrid() {
        initDataSource();
        $("#gridTransactionClosing").kendoGrid({
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
                {field: "closingDate", title: "Transaction Date", width: 70, sortable: false,
                    filterable: {cell: {template: formatFilterableDate, showOperators:false}},
                    attributes: {style: setAlignCenter()}, headerAttributes: {style: setAlignCenter()},
                    template: "#=kendo.toString(kendo.parseDate(closingDate, 'yyyy-MM-dd'), 'dd-MM-yyyy')#"},
                {field: "createDate", title: "Create Date", template: "#=kendo.toString(kendo.parseDate(createDate, 'yyyy-MM-dd'), 'dd-MM-yyyy hh:mm:ss tt')#", width: 100, sortable: false, filterable: false},
                {field: "creator", title: "Create By", width: 150, sortable: false, filterable: false},
                {field: "remarks", title: "Remarks", width: 200, sortable: false, filterable: false},
                {
                    field: "isTransactionClosed", title: "Closed", width: 30, sortable: false, filterable: false,
                    attributes: {style: setAlignCenter()}, headerAttributes: {style: setAlignCenter()},
                    template: "#=isTransactionClosed?'YES':'NO'#"
                }
            ],
            filterable: {
                mode: "row"
            },
            toolbar: isAdmin==true?kendo.template($("#gridToolbar").html()):''
        });
        gridTransactionClosing = $("#gridTransactionClosing").data("kendoGrid");
        $("#menuGrid").kendoMenu();
    }

    function initObservable() {
        transactionClosing = kendo.observable(
                {
                    transactionClosing: {
                        id: "",
                        version: "",
                        remarks: "",
                        closingDate: "",
                        createDate: "",
                        isTransactionClosed:true
                    }
                }
        );
        kendo.bind($("#application_top_panel"), transactionClosing);
    }
    function editRecord() {
        if (executeCommonPreConditionForSelectKendo(gridTransactionClosing, 'record') == false) {
            return;
        }
        var closingDate = getSelectedValueFromGridKendo(gridTransactionClosing, 'closingDate');

        if (!confirm('Are you sure you want to unlock this transaction?')) {
            return false;
        }

        showLoadingSpinner(true);
        $.ajax({
            url: "${createLink(controller: 'transactionClosing', action:  'unlock')}?closingDate=" + closingDate,
            success: function (data, textStatus) {
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
    }


</script>
