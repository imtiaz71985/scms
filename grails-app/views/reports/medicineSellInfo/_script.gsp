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
        if (!$('#month').val()) {
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
    function dataBoundGrid(e) {
        var grid = e.sender;
        var data = grid.dataSource.data();
        $.each(data, function (i, row) {
            var str = row.dateField;
            var currentDate = moment().format('YYYY-MM-DD');
            if (str == currentDate) {
                var sel = $('tr[data-uid="' + row.uid + '"] ');
                grid.select(sel);
            }
            if (row.is_holiday) {
                $('tr[data-uid="' + row.uid + '"] ').css("background-color", "#fee7df");  //light red
                $('tr[data-uid="' + row.uid + '"] ').css("color", "#7f7f7f"); // light black
            }
        });
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
                        registration_amount: {type: "number"},
                        re_registration_amount: {type: "number"},
                        consultation_amount: {type: "number"},
                        subsidy_amount: {type: "number"},
                        pathology_amount: {type: "number"},
                        medicine_sales: {type: "number"},
                        date_field: {type: "date"},
                        is_holiday: {type: "boolean"},
                        holiday_status: {type: "string"}
                    }
                },
                parse: function (data) {
                    checkIsErrorGridKendo(data);
                    if (data.count > 0) isApplicable = true;
                    return data;
                }
            },
            aggregate: [
                {field: "registration_amount", aggregate: "sum" },
                {field: "re_registration_amount", aggregate: "sum" },
                {field: "consultation_amount", aggregate: "sum" },
                {field: "subsidy_amount", aggregate: "sum" },
                {field: "pathology_amount", aggregate: "sum" },
                {field: "medicine_sales", aggregate: "sum" }
            ],
            sort: [{field: 'date_field', dir: 'asc'}],
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
            autoBind: false,
            height: getGridHeightKendo(),
            selectable: true,
            sortable: true,
            resizable: true,
            dataBound: dataBoundGrid,
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
                {
                    field: "date_field",
                    title: "Date",
                    width: 100,
                    sortable: false,
                    filterable: false,
                    headerAttributes: {style: setAlignCenter()},
                    footerAttributes: {style: setAlignRight()},
                    attributes: {style: setAlignCenter()},
                    template: "#=kendo.toString(kendo.parseDate(date_field, 'yyyy-MM-dd'), 'dd-MM-yyyy')#",
                    footerTemplate: "Total : "
                },
                {
                    field: "registration_amount",
                    title: "Membership Charge",
                    width: 80,sortable: false,filterable: false,
                    headerAttributes: {style: setAlignRight()},
                    footerAttributes: {style: setAlignRight()},
                    attributes: {style: setAlignRight()},
                    template: "#=is_holiday?'':formatAmount(registration_amount)#",
                    footerTemplate: "#=formatAmount(sum)#"
                },
                {
                    field: "re_registration_amount",
                    title: "Card Re-issue Charge",
                    width: 80,sortable: false,filterable: false,
                    headerAttributes: {style: setAlignRight()},
                    footerAttributes: {style: setAlignRight()},
                    attributes: {style: setAlignRight()},
                    template: "#=is_holiday?'':formatAmount(re_registration_amount)#",
                    footerTemplate: "#=formatAmount(sum)#"
                },
                {
                    field: "consultation_amount",
                    title: "Consultation Fee",
                    width: 80,sortable: false,filterable: false,
                    headerAttributes: {style: setAlignRight()},
                    footerAttributes: {style: setAlignRight()},
                    attributes: {style: setAlignRight()},
                    template: "#=is_holiday?'':formatAmount(consultation_amount)#",
                    footerTemplate: "#=formatAmount(sum)#"
                },
                {
                    field: "subsidy_amount",
                    title: "Subsidy Amount",
                    width: 80,sortable: false,filterable: false,
                    headerAttributes: {style: setAlignRight()},
                    footerAttributes: {style: setAlignRight()},
                    attributes: {style: setAlignRight()},
                    template: "#=is_holiday?'':formatAmount(subsidy_amount)#",
                    footerTemplate: "#=formatAmount(sum)#"
                },
                {
                    field: "pathology_amount",
                    title: "Diagnostic Charge",
                    width: 80,sortable: false,filterable: false,
                    headerAttributes: {style: setAlignRight()},
                    footerAttributes: {style: setAlignRight()},
                    attributes: {style: setAlignRight()},
                    template: "#=is_holiday?'':formatAmount(pathology_amount)#",
                    footerTemplate: "#=formatAmount(sum)#"
                },
                {
                    field: "medicine_sales",
                    title: "Medicine Sales",
                    width: 80,sortable: false,filterable: false,
                    headerAttributes: {style: setAlignRight()},
                    footerAttributes: {style: setAlignRight()},
                    attributes: {style: setAlignRight()},
                    template: "#=is_holiday?holiday_status:formatAmount(medicine_sales)#",
                    footerTemplate: "#=formatAmount(sum)#"
                }
            ],
            filterable: {
                mode: "row"
            },
            toolbar: kendo.template($("#gridToolbar").html())
        });
        gridSellReportInfo = $("#gridSellReportInfo").data("kendoGrid");
        $("#menuGrid").kendoMenu();
    }

    function downloadMonthWiseSell() {
        if (isApplicable) {
            showLoadingSpinner(true);
            var month = $('#month').val(),
                    msg = 'Do you want to download the sell report now?',
                    url = "${createLink(controller: 'medicineSellInfo', action: 'downloadMonthWiseSell')}?month=" + month;
            confirmDownload(msg, url);
        } else {
            showError('No record to download');
        }
        return false;
    }
</script>
