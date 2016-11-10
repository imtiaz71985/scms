
<script language="javascript">
    var gridDetails, dataSource, isApplicable, dropDownHospitalCode, start, end;

    $(document).ready(function () {
        onLoadInfoPage();
        initInfoGrid();
        loadGridValue();
    });

    function onLoadInfoPage() {
        var currentDate = moment().format('MMMM YYYY');

        start = $('#from').kendoDatePicker({
            format: "MMMM yyyy",
            parseFormats: ["yyyy-MM-dd"],
            change: startChange,
            start: "year",
            depth: "year"
        }).data("kendoDatePicker");

        start.value(currentDate);

        end = $('#to').kendoDatePicker({
            format: "MMMM yyyy",
            parseFormats: ["yyyy-MM-dd"],
            start: "year",
            depth: "year"
        }).data("kendoDatePicker");

        end.value(currentDate);
        end.min(start.value());

        if (!${isAdmin}) {
            dropDownHospitalCode.value('${hospitalCode}');
            dropDownHospitalCode.readonly(true);
        }

        initializeForm($("#detailsForm"), onSubmitForm);
        // update page title
        defaultPageTile("Pathology Summary", 'reports/showPathologySummary');
    }
    function startChange() {
        var startDate = start.value();
        if (startDate) {
            startDate = new Date(startDate);
            startDate.setDate(startDate.getDate() + 1);
            end.min(startDate);
        }
    }

    function executePreCondition() {
        if (!validateForm($("#detailsForm"))) {
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
        var from = $('#from').val();
        var to = $('#to').val();
        var hospitalCode = dropDownHospitalCode.value();
        showLoadingSpinner(true);
        var params = "?from=" + from + "&to=" + to + "&hospitalCode=" + hospitalCode;
        var url = "${createLink(controller:'reports', action: 'listOfPathologySummary')}" + params;
        populateGridKendo(gridDetails, url);
        showLoadingSpinner(false);
        $("#gridDetails").data("kendoGrid").hideColumn("date_field");
    }

    function resetForm() {
        clearForm($("#detailsForm"), $('#from'));
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
                        date_field: {type: "date"},
                        pathology_name: {type: "string"},
                        pathology_count: {type: "number"},
                        charge_amount: {type: "number"},
                        total: {type: "number"}
                    }
                },
                parse: function (data) {
                    checkIsErrorGridKendo(data);
                    if (data.count > 0) isApplicable = true;
                    return data;
                }
            },aggregate: [
                {field: "pathology_count", aggregate: "sum" },
                {field: "total", aggregate: "sum" }
            ],group:[{field:"date_field"}]
            ,sortable:true



        });
    }

    function formatAmount(amount) {
        return kendo.toString(amount, "##,###");
    }
    function initInfoGrid() {
        initDataSource();
        $("#gridDetails").kendoGrid({
            dataSource: dataSource,
            autoBind: false,
            height: getGridHeightKendo(),
            selectable: true,
            sortable: false,
            resizable: false,
            dataBound: gridDataBound,
            pageable: false,
            columns: [
                {
                    field: "date_field", title: "Month",
                    format: "{0:MMMM-yyyy}",
                    width: 60, sortable: false, filterable: false,
                    headerAttributes: {style: setAlignCenter()},
                    footerAttributes: {style: setAlignRight()},
                    attributes: {style: setAlignCenter()}
                },{
                    field: "pathology_name", title: "Pathology",
                    width: 120, sortable: false, filterable: false,
                    headerAttributes: {style: setAlignCenter()},
                    footerAttributes: {style: setAlignRight()},
                    attributes: {style: setAlignCenter()},
                    footerTemplate: "Grand Total:"
                },{
                    field: "pathology_count", title: "Pathology Count",
                    width: 50, sortable: false, filterable: false,
                    headerAttributes: {style: setAlignRight()},
                    attributes: {style: setAlignRight()},
                    footerAttributes: {style: setAlignRight()},
                    footerTemplate: "#=sum#"
                },{
                    field: "charge_amount", title: "Fees",
                    width: 50, sortable: false, filterable: false,
                    headerAttributes: {style: setAlignRight()},
                    attributes: {style: setAlignRight()},
                    footerAttributes: {style: setAlignRight()}
                },
                {
                    field: "total", title: "Total",
                    width: 40, sortable: false, filterable: false,
                    headerAttributes: {style: setAlignRight()},
                    footerAttributes: {style: setAlignRight()},
                    attributes: {style: setAlignRight()},
                    footerTemplate: "#=sum#"
                }
            ],
            filterable: false
        });
        gridDetails = $("#gridDetails").data("kendoGrid");
    }

    function downloadMonthlyDetails() {
        if (isApplicable) {
            showLoadingSpinner(true);
            var from = $('#from').val();
            var to = $('#to').val();
            var hospitalCode = dropDownHospitalCode.value();
            var params = "?from=" + from + "&to=" + to + "&hospitalCode=" + hospitalCode;
            var  msg = 'Do you want to download the report now?',
                    url = "${createLink(controller: 'reports', action: 'downloadMonthlyPathologySummary')}" + params;

            confirmDownload(msg, url);
        } else {
            showError('No record to download');
        }
        return false;
    }
</script>
