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
        defaultPageTile("Monthly Report", null);
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
        var url = "${createLink(controller:'reports', action: 'listSummary')}" + params;
        populateGridKendo(gridDetails, url);
        showLoadingSpinner(false);
    }

    function resetForm() {
        clearForm($("#detailsForm"), $('#from'));
    }
    function dataBoundGrid(e) {
        var grid = e.sender;
        var data = grid.dataSource.data();
        var grandTotal = 0;
        $.each(data, function (i, row) {
            grandTotal += formatCeilAmount(row.medicine_sales + row.pathology_amount + row.registration_amount +
            row.re_registration_amount + row.consultation_amount - row.subsidy_amount - row.return_amt);
        });
        $("#footerSpan").text(formatAmount(grandTotal));
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
                        registration_amount: {type: "number"},
                        re_registration_amount: {type: "number"},
                        consultation_amount: {type: "number"},
                        consultation_count: {type: "number"},
                        subsidy_amount: {type: "number"},
                        subsidy_count: {type: "number"},
                        pathology_amount: {type: "number"},
                        pathology_count: {type: "number"},
                        medicine_sales: {type: "number"},
                        return_amt: {type: "number"},
                        month_name: {type: "string"},
                        new_patient: {type: "number"},
                        re_reg_patient: {type: "number"},
                        patient_followup: {type: "number"},
                        patient_followup_amt: {type: "number"},
                        patient_revisit: {type: "number"},
                        total_patient: {type: "number"},
                        total_service: {type: "number"}
                    }
                },
                parse: function (data) {
                    checkIsErrorGridKendo(data);
                    if (data.count > 0) isApplicable = true;
                    return data;
                }
            },
            aggregate: [
                {field: "registration_amount", aggregate: "sum"},
                {field: "re_registration_amount", aggregate: "sum"},
                {field: "consultation_amount", aggregate: "sum"},
                {field: "consultation_count", aggregate: "sum"},
                {field: "subsidy_amount", aggregate: "sum"},
                {field: "subsidy_count", aggregate: "sum"},
                {field: "pathology_amount", aggregate: "sum"},
                {field: "pathology_count", aggregate: "sum"},
                {field: "medicine_sales", aggregate: "sum"},
                {field: "return_amt", aggregate: "sum"},
                {field: "new_patient", aggregate: "sum"},
                {field: "re_reg_patient", aggregate: "sum"},
                {field: "patient_followup", aggregate: "sum"},
                {field: "patient_followup_amt", aggregate: "sum"},
                {field: "patient_revisit", aggregate: "sum"},
                {field: "total_patient", aggregate: "sum"},
                {field: "total_service", aggregate: "sum"}
            ],
            pageSize: false,
            serverPaging: true,
            serverFiltering: true,
            serverSorting: true
        });
    }
    function setCAlignRight() {
        return "text-align:right;font-size:8pt;";
    }
    function setCAlignCenter() {
        return "text-align:right;font-size:8pt;";
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
            sortable: true,
            resizable: true,
            dataBound: dataBoundGrid,
            reorderable: true,
            pageable: false,
            columns: [
                {
                    field: "month_name", title: "Month",
                    width: 60, sortable: false, filterable: false,
                    headerAttributes: {style: setAlignCenter()},
                    footerAttributes: {style: setAlignRight()},
                    attributes: {style: setAlignCenter()},
                    footerTemplate: "Grand Total:"
                },
                {
                    title: "Patient", headerAttributes: {style: setAlignCenter()},
                    columns: [
                        {
                            field: "new_patient", title: "New",
                            width: 30, sortable: false, filterable: false,
                            headerAttributes: {style: setCAlignRight()},
                            footerAttributes: {style: setAlignRight()},
                            attributes: {style: setAlignRight()},
                            template: "#=new_patient#",
                            footerTemplate: "#=sum#"
                        },
                        {
                            field: "patient_revisit", title: "Re-visit",
                            width: 35, sortable: false, filterable: false,
                            headerAttributes: {style: setCAlignRight()},
                            footerAttributes: {style: setAlignRight()},
                            attributes: {style: setAlignRight()},
                            template: "#=patient_revisit#",
                            footerTemplate: "#=sum#"
                        },
                        {
                            field: "total_patient", title: "Total",
                            width: 40, sortable: false, filterable: false,
                            headerAttributes: {style: setCAlignRight()},
                            footerAttributes: {style: setAlignRight()},
                            attributes: {style: setAlignRight()},
                            template: "#=total_patient#",
                            footerTemplate: "#=sum#"
                        }
                    ]
                },
                {
                    field: "total_service", title: "Total <br/> Service",
                    width: 40, sortable: false, filterable: false,
                    headerAttributes: {style: setCAlignRight()},
                    footerAttributes: {style: setAlignRight()},
                    attributes: {style: setAlignRight()},
                    template: "#=total_service#",
                    footerTemplate: "#=sum#"
                },
                {
                    title: "Charges", headerAttributes: {style: setAlignCenter()},
                    columns: [
                        {
                            title: "Membership", headerAttributes: {style: setAlignCenter()},
                            columns: [
                                {
                                    field: "new_patient", title: "Count",
                                    width: 30, sortable: false, filterable: false,
                                    headerAttributes: {style: setCAlignCenter()},
                                    footerAttributes: {style: setAlignCenter()},
                                    attributes: {style: setAlignCenter()},
                                    template: "#=new_patient#",
                                    footerTemplate: "#=sum#"
                                },
                                {
                                    field: "registration_amount", title: "Amount(৳)",
                                    width: 45, sortable: false, filterable: false,
                                    headerAttributes: {style: setCAlignRight()},
                                    footerAttributes: {style: setAlignRight()},
                                    attributes: {style: setAlignRight()},
                                    template: "#=formatAmount(registration_amount)#",
                                    footerTemplate: "#=formatAmount(sum)#"
                                }
                            ]
                        },
                        {
                            title: "Card Re-issue", headerAttributes: {style: setAlignCenter()},
                            columns: [
                                {
                                    field: "re_reg_patient", title: "Count",
                                    width: 30, sortable: false, filterable: false,
                                    headerAttributes: {style: setCAlignCenter()},
                                    footerAttributes: {style: setAlignCenter()},
                                    attributes: {style: setAlignCenter()},
                                    template: "#=re_reg_patient#",
                                    footerTemplate: "#=sum#"
                                },
                                {
                                    field: "re_registration_amount", title: "Amount(৳)",
                                    width: 45, sortable: false, filterable: false,
                                    headerAttributes: {style: setCAlignRight()},
                                    footerAttributes: {style: setAlignRight()},
                                    attributes: {style: setAlignRight()},
                                    template: "#=formatAmount(re_registration_amount)#",
                                    footerTemplate: "#=formatAmount(sum)#"
                                }
                            ]
                        },
                        {
                            title: "Consultation", headerAttributes: {style: setAlignCenter()},
                            columns: [
                                {
                                    field: "consultation_count", title: "Count",
                                    width: 30, sortable: false, filterable: false,
                                    headerAttributes: {style: setCAlignCenter()},
                                    footerAttributes: {style: setAlignCenter()},
                                    attributes: {style: setAlignCenter()},
                                    template: "#=consultation_count#",
                                    footerTemplate: "#=sum#"
                                },
                                {
                                    field: "consultation_amount", title: "Amount(৳)",
                                    width: 45, sortable: false, filterable: false,
                                    headerAttributes: {style: setCAlignRight()},
                                    footerAttributes: {style: setAlignRight()},
                                    attributes: {style: setAlignRight()},
                                    template: "#=formatAmount(consultation_amount)#",
                                    footerTemplate: "#=formatAmount(sum)#"
                                },
                                {
                                    field: "patient_followup", title: "Followup",
                                    width: 42, sortable: false, filterable: false,
                                    headerAttributes: {style: setCAlignRight()},
                                    footerAttributes: {style: setAlignRight()},
                                    attributes: {style: setAlignRight()},
                                    template: "#=patient_followup#",
                                    footerTemplate: "#=sum#"
                                },
                                {
                                    field: "patient_followup_amt", title: "Amount(৳)",
                                    width: 45, sortable: false, filterable: false,
                                    headerAttributes: {style: setCAlignRight()},
                                    footerAttributes: {style: setAlignRight()},
                                    attributes: {style: setAlignRight()},
                                    template: "#=formatAmount(patient_followup_amt)#",
                                    footerTemplate: "#=formatAmount(sum)#"
                                }
                            ]
                        },
                        {
                            title: "Subsidy", headerAttributes: {style: setAlignCenter()},
                            columns: [
                                {
                                    field: "subsidy_count", title: "Count",
                                    width: 30, sortable: false, filterable: false,
                                    headerAttributes: {style: setCAlignCenter()},
                                    footerAttributes: {style: setAlignCenter()},
                                    attributes: {style: setAlignCenter()},
                                    template: "#=subsidy_count#",
                                    footerTemplate: "#=sum#"
                                },
                                {
                                    field: "subsidy_amount", title: "Amount(৳)",
                                    width: 45, sortable: false, filterable: false,
                                    headerAttributes: {style: setCAlignRight()},
                                    footerAttributes: {style: setAlignRight()},
                                    attributes: {style: setAlignRight()},
                                    template: "#=formatAmount(subsidy_amount)#",
                                    footerTemplate: "#=formatAmount(sum)#"
                                }
                            ]
                        },
                        {
                            title: "Diagnostic", headerAttributes: {style: setAlignCenter()},
                            columns: [
                                {
                                    field: "pathology_count", title: "Count",
                                    width: 30, sortable: false, filterable: false,
                                    headerAttributes: {style: setCAlignCenter()},
                                    footerAttributes: {style: setAlignCenter()},
                                    attributes: {style: setAlignCenter()},
                                    template: "#=pathology_count#",
                                    footerTemplate: "#=sum#"
                                },
                                {
                                    field: "pathology_amount", title: "Amount(৳)",
                                    width: 45, sortable: false, filterable: false,
                                    headerAttributes: {style: setCAlignRight()},
                                    footerAttributes: {style: setAlignRight()},
                                    attributes: {style: setAlignRight()},
                                    template: "#=formatAmount(pathology_amount)#",
                                    footerTemplate: "#=formatAmount(sum)#"
                                }
                            ]
                        }
                    ]
                },
                {
                    title: "Medicine", headerAttributes: {style: setAlignCenter()},
                    columns: [
                        {
                            field: "medicine_sales", title: "Sales(৳)",
                            width: 40, sortable: false, filterable: false,
                            headerAttributes: {style: setAlignRight()},
                            footerAttributes: {style: setAlignRight()},
                            attributes: {style: setAlignRight()},
                            template: "#=formatAmount(medicine_sales)#",
                            footerTemplate: "#=sum#"
                        }, {
                            field: "return_amt", title: "Return",
                            width: 40, sortable: false, filterable: false,
                            headerAttributes: {style: setCAlignRight()},
                            footerAttributes: {style: setAlignRight()},
                            attributes: {style: setAlignRight()},
                            template: "#=formatAmount(return_amt)#",
                            footerTemplate: "#=sum#"
                        }
                    ]
                },
                {
                    field: "medicine_sales", title: "Month <br/> Collection(৳)",
                    width: 60, sortable: false, filterable: false,
                    headerAttributes: {style: setAlignRight()},
                    footerAttributes: {style: setAlignRight()},
                    attributes: {style: setAlignRight()},
                    template: "#=formatCeilAmount(medicine_sales+pathology_amount+registration_amount+re_registration_amount+consultation_amount-subsidy_amount-return_amt)#",
                    footerTemplate: "<span id='footerSpan'>#=formatAmount(sum)#</span>"
                }
            ],
            filterable: false
        });
        gridDetails = $("#gridDetails").data("kendoGrid");
    }

    function downloadMonthlyDetails() {
        if (isApplicable) {
            showLoadingSpinner(true);
            var month = $('#month').val(),
                    hospitalCode = dropDownHospitalCode.value(),
                    msg = 'Do you want to download the sell report now?',
                    url = "${createLink(controller: 'reports', action: 'downloadMonthlyDetails')}?month=" + month + "&hospitalCode=" + hospitalCode;
            confirmDownload(msg, url);
        } else {
            showError('No record to download');
        }
        return false;
    }
</script>
