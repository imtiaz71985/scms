<script type="text/x-kendo-template" id="gridToolbar">
<ul id="menuGrid" class="kendoGridMenu">
    <sec:access url="/medicineSellInfo/downloadMonthWiseSell">
        <li onclick="downloadMonthWiseSell();"><i class="fa fa-file-pdf-o"></i>Download</li>
    </sec:access>
</ul>
</script>

<script language="javascript">
    var gridSellReportInfo, dataSource, isApplicable;

    $(document).ready(function () {
        onLoadInfoPage();
        initInfoGrid();
        loadGridValue();
    });

    function onLoadInfoPage() {
        $('#month').kendoDatePicker({
            format: "MMMM yyyy",
            parseFormats: ["yyyy-MM-dd"],
            start: "year",
            depth: "year"
        });
        var currentDate = moment().format('MMMM YYYY');
        $('#month').val(currentDate);
        initializeForm($("#monthWiseSellForm"), onSubmitForm);
        // update page title
        defaultPageTile("Month Wise Report", null);
    }

    function executePreCondition() {
        if(!$('#month').val()){
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

    function loadGridValue(){
        var month = $('#month').val();
        showLoadingSpinner(true);
        var params = "?month=" + month;
        var url = "${createLink(controller:'medicineSellInfo', action: 'listMonthlyStatus')}" + params;
        populateGridKendo(gridSellReportInfo, url);
        showLoadingSpinner(false);
    }

    function resetForm() {
        clearForm($("#monthWiseSellForm"), $('#month'));
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
                        id: { type: "number" },
                        version: { type: "number" },
                        total_amount: { type: "number" },
                        sell_date: { type: "date" }
                    }
                },
                parse: function (data) {
                    checkIsErrorGridKendo(data);
                    if(data.count > 0) isApplicable = true;
                    return data;
                }
            },
            sort: [{field: 'sell_date', dir: 'asc'}],
            pageSize: 50,
            serverPaging: true,
            serverFiltering: true,
            serverSorting: true
        });
    }

    function initInfoGrid() {
        initDataSource();
        $("#gridSellReportInfo").kendoGrid({
            dataSource: dataSource,
            autoBind:false,
            height: getGridHeightKendo(),
            selectable: true,
            sortable: true,
            resizable: true,
            dataBound: gridDataBound,
            reorderable: true,
            pageable: {
                refresh: true,
                pageSizes: [10, 15, 20],
                buttonCount: 4,
                messages: {
                    display: "{0} - {1} of {2} records",
                    empty: "No records to display",
                    itemsPerPage: "records(s) per page"
                }
            },
            columns: [
                {field: "sell_date", title: "Sale Date", width: 100, sortable: false, filterable: false,headerAttributes: {style: setAlignCenter()},attributes: {style: setAlignCenter()},
                template: "#=kendo.toString(kendo.parseDate(sell_date, 'yyyy-MM-dd'), 'dd-MM-yyyy')#"},
                {field: "total_amount", title: "Total Amount", width: 80, sortable: false, filterable: false,headerAttributes: {style: setAlignRight()},attributes: {style: setAlignRight()},
                template: "#=formatAmount(total_amount)#"}
            ],
            filterable: {
                mode: "row"
            },
            toolbar: kendo.template($("#gridToolbar").html())
        });
        gridSellReportInfo = $("#gridSellReportInfo").data("kendoGrid");
        $("#menuGrid").kendoMenu();
    }

    function downloadMonthWiseSell(){
        if(isApplicable){
            showLoadingSpinner(true);
            var month = $('#month').val(),
                  msg = 'Do you want to download the sell report now?',
                  url = "${createLink(controller: 'medicineSellInfo', action: 'downloadMonthWiseSell')}?month=" + month;
            confirmDownload(msg, url);
        }else{
            showError('No record to download');
        }
        return false;
    }
</script>
