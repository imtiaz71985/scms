
<script language="javascript">
    var gridDetails, dataSource, isApplicable,dropDownHospitalCode;

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

        if(!${isAdmin}){
         dropDownHospitalCode.value('${hospitalCode}');
            dropDownHospitalCode.readonly(true);
        }

        initializeForm($("#detailsForm"), onSubmitForm);
        // update page title
        defaultPageTile("Monthly Report", null);
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
        var month = $('#month').val();
        var hospitalCode = dropDownHospitalCode.value();
        showLoadingSpinner(true);
        var params = "?month=" + month + "&hospitalCode=" + hospitalCode;
        var url = "${createLink(controller:'reports', action: 'listMonthlyStatus')}" + params;
        populateGridKendo(gridDetails, url);
        showLoadingSpinner(false);
    }

    function resetForm() {
        clearForm($("#detailsForm"), $('#month'));
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
                        consultation_count: {type: "number"},
                        subsidy_amount: {type: "number"},
                        subsidy_count: {type: "number"},
                        pathology_amount: {type: "number"},
                        pathology_count: {type: "number"},
                        medicine_sales: {type: "number"},
                        date_field: {type: "date"},
                        is_holiday: {type: "boolean"},
                        holiday_status: {type: "string"},
                        new_patient: {type: "number"},
                        re_reg_patient: {type: "number"},
                        patient_followup: {type: "number"},
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
                {field: "registration_amount", aggregate: "sum" },
                {field: "re_registration_amount", aggregate: "sum" },
                {field: "consultation_amount", aggregate: "sum" },
                {field: "consultation_count", aggregate: "sum" },
                {field: "subsidy_amount", aggregate: "sum" },
                {field: "subsidy_count", aggregate: "sum" },
                {field: "pathology_amount", aggregate: "sum" },
                {field: "pathology_count", aggregate: "sum" },
                {field: "medicine_sales", aggregate: "sum" },
                {field: "new_patient", aggregate: "sum" },
                {field: "re_reg_patient", aggregate: "sum" },
                {field: "patient_followup", aggregate: "sum" },
                {field: "patient_revisit", aggregate: "sum" },
                {field: "total_patient", aggregate: "sum" },
                {field: "total_service", aggregate: "sum" }
            ],
            sort: [{field: 'date_field', dir: 'asc'}],
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
                    field: "date_field",title: "Date",
                    width: 60,sortable: false,filterable: false,
                    headerAttributes: {style: setAlignCenter()},
                    footerAttributes: {style: setAlignRight()},
                    attributes: {style: setAlignCenter()},
                    template: "#=kendo.toString(kendo.parseDate(date_field, 'yyyy-MM-dd'), 'dd-MM-yyyy')#",
                    footerTemplate: "Total : "
                },
                {title: "Patient",headerAttributes:{style:setAlignCenter()},
                    columns: [
                        {
                            field: "new_patient", title: "New",
                            width: 30,sortable: false,filterable: false,
                            headerAttributes: {style: setCAlignRight()},
                            footerAttributes: {style: setAlignRight()},
                            attributes: {style: setAlignRight()},
                            template: "#=is_holiday?'':new_patient#",
                            footerTemplate: "#=sum#"
                        },
                        {
                            field: "patient_followup", title: "Followup",
                            width: 38,sortable: false,filterable: false,
                            headerAttributes: {style: setCAlignRight()},
                            footerAttributes: {style: setAlignRight()},
                            attributes: {style: setAlignRight()},
                            template: "#=is_holiday?'':patient_followup#",
                            footerTemplate: "#=sum#"
                        },
                        {
                            field: "patient_revisit", title: "Re-visit",
                            width: 35,sortable: false,filterable: false,
                            headerAttributes: {style: setCAlignRight()},
                            footerAttributes: {style: setAlignRight()},
                            attributes: {style: setAlignRight()},
                            template: "#=is_holiday?'':patient_revisit#",
                            footerTemplate: "#=sum#"
                        },
                        {
                            field: "total_patient", title: "Total",
                            width: 40,sortable: false,filterable: false,
                            headerAttributes: {style: setCAlignRight()},
                            footerAttributes: {style: setAlignRight()},
                            attributes: {style: setAlignRight()},
                            template: "#=is_holiday?'':total_patient#",
                            footerTemplate: "#=sum#"
                        },
                        {
                            field: "total_service", title: "Total <br/> Service",
                            width: 40,sortable: false,filterable: false,
                            headerAttributes: {style: setCAlignRight()},
                            footerAttributes: {style: setAlignRight()},
                            attributes: {style: setAlignRight()},
                            template: "#=is_holiday?'':total_service#",
                            footerTemplate: "#=sum#"
                        }
                    ]
                },
                {title: "Charges",headerAttributes:{style:setAlignCenter()},
                    columns: [
                        {title: "Membership",headerAttributes:{style:setAlignCenter()},
                            columns: [
                                {
                                    field: "new_patient",title: "Count",
                                    width: 30,sortable: false,filterable: false,
                                    headerAttributes: {style: setCAlignCenter()},
                                    footerAttributes: {style: setAlignCenter()},
                                    attributes: {style: setAlignCenter()},
                                    template: "#=is_holiday?'':new_patient#",
                                    footerTemplate: "#=sum#"
                                },
                                {
                                    field: "registration_amount",title: "Amount(৳)",
                                    width: 50,sortable: false,filterable: false,
                                    headerAttributes: {style: setCAlignRight()},
                                    footerAttributes: {style: setAlignRight()},
                                    attributes: {style: setAlignRight()},
                                    template: "#=is_holiday?'':formatAmount(registration_amount)#",
                                    footerTemplate: "#=formatAmount(sum)#"
                                }
                            ]
                        },
                        {title: "Card Re-issue",headerAttributes:{style:setAlignCenter()},
                            columns: [
                                {
                                    field: "re_reg_patient",title: "Count",
                                    width: 30,sortable: false,filterable: false,
                                    headerAttributes: {style: setCAlignCenter()},
                                    footerAttributes: {style: setAlignCenter()},
                                    attributes: {style: setAlignCenter()},
                                    template: "#=is_holiday?'':re_reg_patient#",
                                    footerTemplate: "#=sum#"
                                },
                                {
                                    field: "re_registration_amount",title: "Amount(৳)",
                                    width: 50,sortable: false,filterable: false,
                                    headerAttributes: {style: setCAlignRight()},
                                    footerAttributes: {style: setAlignRight()},
                                    attributes: {style: setAlignRight()},
                                    template: "#=is_holiday?'':formatAmount(re_registration_amount)#",
                                    footerTemplate: "#=formatAmount(sum)#"
                                }
                            ]
                        },
                        {title: "Consultation",headerAttributes:{style:setAlignCenter()},
                            columns: [
                                {
                                    field: "consultation_count",title: "Count",
                                    width: 30,sortable: false,filterable: false,
                                    headerAttributes: {style: setCAlignCenter()},
                                    footerAttributes: {style: setAlignCenter()},
                                    attributes: {style: setAlignCenter()},
                                    template: "#=is_holiday?'':consultation_count#",
                                    footerTemplate: "#=sum#"
                                },
                                {
                                    field: "consultation_amount",title: "Amount(৳)",
                                    width: 50,sortable: false,filterable: false,
                                    headerAttributes: {style: setCAlignRight()},
                                    footerAttributes: {style: setAlignRight()},
                                    attributes: {style: setAlignRight()},
                                    template: "#=is_holiday?'':formatAmount(consultation_amount)#",
                                    footerTemplate: "#=formatAmount(sum)#"
                                }
                            ]
                        },
                        {title: "Subsidy",headerAttributes:{style:setAlignCenter()},
                            columns: [
                                {
                                    field: "subsidy_count",title: "Count",
                                    width: 30,sortable: false,filterable: false,
                                    headerAttributes: {style: setCAlignCenter()},
                                    footerAttributes: {style: setAlignCenter()},
                                    attributes: {style: setAlignCenter()},
                                    template: "#=is_holiday?'':subsidy_count#",
                                    footerTemplate: "#=sum#"
                                },
                                {
                                    field: "subsidy_amount",title: "Amount(৳)",
                                    width: 50,sortable: false,filterable: false,
                                    headerAttributes: {style: setCAlignRight()},
                                    footerAttributes: {style: setAlignRight()},
                                    attributes: {style: setAlignRight()},
                                    template: "#=is_holiday?'':formatAmount(subsidy_amount)#",
                                    footerTemplate: "#=formatAmount(sum)#"
                                }
                            ]
                        },
                        {title: "Diagnostic",headerAttributes:{style:setAlignCenter()},
                            columns: [
                                {
                                    field: "pathology_count",title: "Count",
                                    width: 30,sortable: false,filterable: false,
                                    headerAttributes: {style: setCAlignCenter()},
                                    footerAttributes: {style: setAlignCenter()},
                                    attributes: {style: setAlignCenter()},
                                    template: "#=is_holiday?'':pathology_count#",
                                    footerTemplate: "#=sum#"
                                },
                                {
                                    field: "pathology_amount",title: "Amount(৳)",
                                    width: 50,sortable: false,filterable: false,
                                    headerAttributes: {style: setCAlignRight()},
                                    footerAttributes: {style: setAlignRight()},
                                    attributes: {style: setAlignRight()},
                                    template: "#=is_holiday?'':formatAmount(pathology_amount)#",
                                    footerTemplate: "#=formatAmount(sum)#"
                                }
                            ]
                        }
                    ]
                },
                {
                    field: "medicine_sales",title: "Medicine <br/> Sales(৳)",
                    width: 60,sortable: false,filterable: false,
                    headerAttributes: {style: setAlignRight()},
                    footerAttributes: {style: setAlignRight()},
                    attributes: {style: setAlignRight()},
                    template: "#=is_holiday?holiday_status:formatAmount(medicine_sales)#",
                    footerTemplate: "#=formatAmount(sum)#"
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
                    url = "${createLink(controller: 'reports', action: 'downloadMonthlyDetails')}?month=" + month + "&hospitalCode="+hospitalCode;
            confirmDownload(msg, url);
        } else {
            showError('No record to download');
        }
        return false;
    }
</script>
