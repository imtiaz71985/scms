<script type="text/x-kendo-template" id="gridToolbar">
<ul id="menuGrid" class="kendoGridMenu">
    <sec:access url="/medicineSellInfo/update">
        <li onclick="newRecord();"><i class="fa fa-plus-square"></i>New</li>
    </sec:access>
 <sec:access url="/medicineSellInfo/update">
    <li onclick="editRecord();"><i class="fa fa-file"></i>View Details</li>
</sec:access>
<sec:access url="/medicineSellInfo/delete">
<li onclick="deleteRecord();"><i class="fa fa-trash-o"></i>Delete</li>
</sec:access>
    <div class="pull-right">
            <input type="text" id="creatingDateDDL" name="creatingDateDDL" class="kendo-drop-down" onchange="getSelectedDateData()" style="width: 150px"/>
  </div>
</ul>
</script>

<script language="javascript">
    var gridMedicineSellInfo, dataSource, medicineSellInfoModel, dropDownMedicine, currentDate,unitPrice = 0,dropDownTransactionDate;

    $(document).ready(function () {

        onLoadMedicineSellInfoPage();
        initMedicineSellInfoGrid();
        initObservable();
        dropDownTransactionDate= initKendoDropdown($('#creatingDateDDL'), null, null, ${dropDownVals});
        if(currentDate!=null) {
            dropDownTransactionDate.value(currentDate);
            getSelectedDateData();
        }
        else{
            currentDate = moment().format('YYYY-MM-DD');
        }
    });

    function newRecord() {
        showLoadingSpinner(true);
        var loc = "${createLink(controller: 'medicineSellInfo', action: 'showDetails')}?dateField="+currentDate;
        router.navigate(formatLink(loc));
        return false;
    }
    function onLoadMedicineSellInfoPage() {
//        initializeForm($("#medicineSellInfoForm"), onSubmitMedicineSellInfo);
        defaultPageTile("Sale Medicine", null);
    }

    function executePreCondition() {
        if (!validateForm($("#medicineSellInfoForm"))) {
            return false;
        }
        return true;
    }

    function onSubmitMedicineSellInfo() {
        if (executePreCondition() == false) {
            return false;
        }

        setButtonDisabled($('#create'), true);
        showLoadingSpinner(true);
        var actionUrl = null;
        if ($('#id').val().isEmpty()) {
            actionUrl = "${createLink(controller:'medicineSellInfo', action: 'create')}";
        } else {
            actionUrl = "${createLink(controller:'medicineSellInfo', action: 'update')}";
        }
        jQuery.ajax({
            type: 'post',
            data: jQuery("#medicineSellInfoForm").serialize(),
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
                var newEntry = result.medicineSellInfo;
                if ($('#id').val().isEmpty() && newEntry != null) { // newly created
                    var gridData = gridMedicineSellInfo.dataSource.data();
                    gridData.unshift(newEntry);
                } else if (newEntry != null) { // updated existing
                    var selectedRow = gridMedicineSellInfo.select();
                    var allItems = gridMedicineSellInfo.items();
                    var selectedIndex = allItems.index(selectedRow);
                    gridMedicineSellInfo.removeRow(selectedRow);
                    gridMedicineSellInfo.dataSource.insert(selectedIndex, newEntry);
                }
                resetForm();
                showSuccess(result.message);
            } catch (e) {
                // Do Nothing
            }
        }
    }

    function resetForm() {

    }

    function initDataSource() {
        dataSource = new kendo.data.DataSource({
            transport: {
                read: {
                    url: "${createLink(controller: 'medicineSellInfo', action: 'list')}?dateField="+currentDate,
                    dataType: "json",
                    type: "post"
                }
            },
            schema: {
                type: 'json',
                data: "list", total: "count",
                model: {
                    fields: {
                        id: {type: "number"},
                        version: {type: "number"},
                        voucherNo: {type: "string"},
                        seller: {type: "string"},
                        totalAmount: {type: "number"},
                        sellDate: {type: "date"}
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

    function initMedicineSellInfoGrid() {
        initDataSource();
        $("#gridMedicineSellInfo").kendoGrid({
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
                    field: "voucherNo",
                    title: "Voucher No",
                    width: 100,
                    sortable: false,
                    filterable: kendoCommonFilterable(97)
                },
                {
                    field: "totalAmount",
                    title: "Total Amount",
                    width: 50,
                    attributes: {style: setAlignRight()},
                    headerAttributes: {style: setAlignRight()},
                    template: "#=formatAmount(formatCeilAmount(totalAmount))#",
                    sortable: false,
                    filterable: false
                },
                {
                    field: "sellDate", title: "Date", width: 100, sortable: false,
                    filterable: {cell: {template: formatFilterableDate, showOperators:false}},
                    attributes: {style: setAlignCenter()}, headerAttributes: {style: setAlignCenter()},
                    template: "#=kendo.toString(kendo.parseDate(sellDate, 'yyyy-MM-dd'), 'dd-MM-yyyy')#"
                }
            ],
            filterable: {
                mode: "row"
            },
            toolbar: kendo.template($("#gridToolbar").html())
        });
        gridMedicineSellInfo = $("#gridMedicineSellInfo").data("kendoGrid");
        $("#menuGrid").kendoMenu();
    }

    function initObservable() {
        medicineSellInfoModel = kendo.observable(
                {
                    medicineSell: {
                        id:"",
                        version: "",
                        voucherNo: "",
                        quantity: "",
                        totalAmount: "",
                        sellDate: ""
                    }
                }
        );
        kendo.bind($("#application_top_panel"), medicineSellInfoModel);
    }

    function deleteRecord() {
        if (executeCommonPreConditionForSelectKendo(gridMedicineSellInfo, 'record') == false) {
            return;
        }
        var msg = 'Are you sure you want to remove this record?',
                url = "${createLink(controller: 'medicineSellInfo', action:  'delete')}";
        confirmDelete(msg, url, gridMedicineSellInfo);
    }

    function editRecord() {
        if (executeCommonPreConditionForSelectKendo(gridMedicineSellInfo, 'voucher') == false) {
            return;
        }
        showLoadingSpinner(true);
        var id = getSelectedIdFromGridKendo(gridMedicineSellInfo);
        var loc = "${createLink(controller: 'medicineSellInfo', action: 'select')}?id=" + id;
        router.navigate(formatLink(loc));
        return false;
    }
    function getSelectedDateData() {
        currentDate=dropDownTransactionDate.value();
        initMedicineSellInfoGrid();
        return false;
    }

</script>
