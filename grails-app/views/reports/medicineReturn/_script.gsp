<script type="text/x-kendo-template" id="gridToolbar">
<ul id="menuGrid" class="kendoGridMenu">
    <sec:access url="/medicineReturn/show">
        <li onclick="viewDetails();"><i class="fa fa-file"></i>View Details</li>
    </sec:access>
</ul>
</script>
<script language="javascript">
    var gridMedicineSellReturnRpt, dataSource, dropDownHospitalCode, start, end, dropDownReturnType;

    $(document).ready(function () {
        onLoadMedicineInfoPage();
        initMedicineReturnGrid();

    });

    function onLoadMedicineInfoPage() {
        start = $('#fromDateTxt').kendoDatePicker({
            format: "dd/MM/yyyy",
            parseFormats: ["yyyy-MM-dd"],
            change: startChange
        }).data("kendoDatePicker");
        $('#fromDateTxt').kendoMaskedTextBox({mask: "00/00/0000"});
        end = $('#toDateTxt').kendoDatePicker({
            format: "dd/MM/yyyy",
            parseFormats: ["yyyy-MM-dd"]
        }).data("kendoDatePicker");
        $('#toDateTxt').kendoMaskedTextBox({mask: "00/00/0000"});
        end.min(start.value());

        if(!${isAdmin}){
            dropDownHospitalCode.value('${hospitalCode}');
            dropDownHospitalCode.readonly(true);
        }
        initializeForm($("#returnSummaryRptForm"), onSubmitForm);
        // update page title
        defaultPageTile("Medicine Wise Sales", null);
    }
    function startChange() {
        var startDate = start.value();
        if (startDate) {
            startDate = new Date(startDate);
            startDate.setDate(startDate.getDate());
            end.min(startDate);
        }
    }
    function executePreCondition() {
        if (!validateForm($("#returnSummaryRptForm"))) {
            return false;
        }
        return true;
    }

    function onSubmitForm() {
        if (executePreCondition() == false) {
            return false;
        }
        loadGridValue();
        return false;
    }
    function loadGridValue() {

        var hospitalCode = dropDownHospitalCode.value();
        showLoadingSpinner(true);
        var params = "?hospitalCode=" + hospitalCode+"&fromDate="+$("#fromDateTxt").val()+"&toDate="+$("#toDateTxt").val()+"&returnType="+$("#returnTypeId").val()+"&isReport=true";
        var url = "${createLink(controller:'medicineReturn', action: 'list')}" + params;
        populateGridKendo(gridMedicineSellReturnRpt, url);
        showLoadingSpinner(false);
    }
    function initDataSource() {
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
                        id: {type: "number"},
                        version: {type: "number"},
                        traceNo: {type: "string"},
                        returnBy: {type: "string"},
                        hospitalCode: {type: "string"},
                        totalAmount: {type: "number"},
                        returnDate: {type: "date"},
                        returnType: {type: "string"}
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

    function initMedicineReturnGrid() {
        initDataSource();
        $("#gridMedicineSellReturnRpt").kendoGrid({
            dataSource: dataSource,
            autoBind: false,
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
                    field: "traceNo",
                    title: "Voucher No",
                    width: 100,
                    sortable: false,
                    filterable: kendoCommonFilterable(97)
                },
                {
                    field: "returnType",
                    title: "Return Type",
                    width: 100,
                    sortable: false,
                    filterable: false
                },
                {
                    field: "totalAmount",
                    title: "Total Amount",
                    width: 50,
                    attributes: {style: setAlignRight()},
                    headerAttributes: {style: setAlignRight()},
                    template: "#=formatAmount(formatFloorAmount(totalAmount))#",
                    sortable: false,
                    filterable: false
                },
                {
                    field: "returnDate", title: "Return Date", width: 50, sortable: false,
                    filterable: {cell: {template: formatFilterableDate,showOperators: false}},
                    attributes: {style: setAlignCenter()}, headerAttributes: {style: setAlignCenter()},
                    template: "#=kendo.toString(kendo.parseDate(returnDate, 'yyyy-MM-dd'), 'dd-MM-yyyy')#"
                }
            ],
            filterable: {
                mode: "row"
            }
            /*,
            toolbar: kendo.template($("#gridToolbar").html())*/
        });
        gridMedicineSellReturnRpt = $("#gridMedicineSellReturnRpt").data("kendoGrid");
        //$("#menuGrid").kendoMenu();
    }
    function viewDetails() {
        if (executeCommonPreConditionForSelectKendo(gridMedicineSellReturnRpt, 'voucher') == false) {
            return;
        }
        showLoadingSpinner(true);

        var id = getSelectedIdFromGridKendo(gridMedicineSellReturnRpt);
        var loc = "${createLink(controller: 'medicineReturn', action: 'details')}?id=" + id;
        router.navigate(formatLink(loc));
        return false;
    }

</script>
