
<script language="javascript">
    var gridDetails, dataSource, dropDownHospitalCode, start, end;

    $(document).ready(function () {
        onLoadMedicineInfoPage();
        initMedicineInfoGrid();

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
        /*var todayDate = new Date();
        $('#fromDateTxt').data("kendoDatePicker").value(todayDate);
        $('#toDateTxt').data("kendoDatePicker").value(todayDate);*/

        if(!${isAdmin}){
            dropDownHospitalCode.value('${hospitalCode}');
            dropDownHospitalCode.readonly(true);
        }
        initializeForm($("#detailsForm"), onSubmitForm);
        // update page title
        defaultPageTile("Registered Patient Served", null);
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
        var hospitalCode = dropDownHospitalCode.value();
        var fromDateTxt = $("#fromDateTxt").val();
        var toDateTxt = $("#toDateTxt").val();
        showLoadingSpinner(true);
        var params = "?hospitalCode=" + hospitalCode+"&fromDate="+fromDateTxt+"&toDate="+toDateTxt;
        var url = "${createLink(controller:'reports', action: 'listOfPatientServedSummary')}" + params;
        populateGridKendo(gridDetails, url);
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
                        date_field: {type: "date"},
                        is_holiday: {type: "boolean"},
                        holiday_status: {type: "string"},
                        new_patient: {type: "number"},
                        patient_revisit: {type: "number"},
                        total_patient: {type: "number"},
                        total_served: {type: "number"},
                        is_tran_closed: {type: "boolean"}
                    }
                },
                parse: function (data) {
                    checkIsErrorGridKendo(data);
                    return data;
                }
            },aggregate: [

                {field: "new_patient", aggregate: "sum" },
                {field: "patient_revisit", aggregate: "sum" },
                {field: "total_patient", aggregate: "sum" },
                {field: "total_served", aggregate: "sum" }
            ],
            sort: [{field: 'date_field', dir: 'asc'}],
            pageSize: false,
            serverPaging: true,
            serverFiltering: true,
            serverSorting: true
        });
    }

    function initMedicineInfoGrid() {
        initDataSource();
        $("#gridDetails").kendoGrid({
            dataSource: dataSource,
            autoBind: false,
            height: getGridHeightKendo(),
            selectable: true,
            sortable: true,
            resizable: true,
            reorderable: true,
            dataBound: dataBoundGrid,
            pageable: false,
            columns: [
                {
                    field: "date_field",title: "Date",
                    width: 60,sortable: false,filterable: false,
                    headerAttributes: {style: setAlignCenter()},
                    footerAttributes: {style: setAlignRight()},
                    attributes: {style: setAlignCenter()},
                    template: "#=kendo.toString(kendo.parseDate(date_field, 'yyyy-MM-dd'), 'dd-MM-yyyy')#",
                    footerTemplate: "Month Total:"
                },
                {
                    field: "new_patient", title: "New Patient",
                    width: 30,sortable: false,filterable: false,
                    headerAttributes: {style: setAlignRight()},
                    footerAttributes: {style: setAlignRight()},
                    attributes: {style: setAlignRight()},
                    template: "#=is_holiday?'':new_patient#",
                    footerTemplate: "#=sum#"
                },
                {
                    field: "patient_revisit", title: "Re-visit Patient",
                    width: 35,sortable: false,filterable: false,
                    headerAttributes: {style: setAlignRight()},
                    footerAttributes: {style: setAlignRight()},
                    attributes: {style: setAlignRight()},
                    template: "#=is_holiday?'':patient_revisit#",
                    footerTemplate: "#=sum#"
                },
                {
                    field: "total_patient", title: "Total Patient",
                    width: 40,sortable: false,filterable: false,
                    headerAttributes: {style: setAlignRight()},
                    footerAttributes: {style: setAlignRight()},
                    attributes: {style: setAlignRight()},
                    template: "#=is_holiday?'':total_patient#",
                    footerTemplate: "#=sum#"
                },
                {
                    field: "total_served", title: "Total Served",
                    width: 40,sortable: false,filterable: false,
                    headerAttributes: {style: setAlignRight()},
                    footerAttributes: {style: setAlignRight()},
                    attributes: {style: setAlignRight()},
                    template: "#=is_holiday?holiday_status:navigateLink(date_field,total_served,'reports','showPatientServedDetails')#",

                    footerTemplate: "#=sum#"
                }
            ],
            filterable: {
                mode: "row"
            }
        });
        gridDetails = $("#gridDetails").data("kendoGrid");
    }
    function dataBoundGrid(e) {
        var grid = e.sender;
        var data = grid.dataSource.data();
        $.each(data, function (i, row) {
            if (row.is_holiday) {
                $('tr[data-uid="' + row.uid + '"] ').css("background-color", "#fee7df");  //light red
                $('tr[data-uid="' + row.uid + '"] ').css("color", "#7f7f7f"); // light black
            }
            else{
                if (dropDownHospitalCode.value() != '' && !row.is_tran_closed) {
                    $('tr[data-uid="' + row.uid + '"] ').css("color", "#e60000"); // red
                    $('tr[data-uid="' + row.uid + '"] ').css("font-weight", "bold");// font bold
                }
            }
        });

    }
    function navigateLink(dateField,value,controller,action){
        var hospitalCode = dropDownHospitalCode.value();
        if(value>0){
            return '<a href="/scms#'+controller+'/'+action+'?dateField='+dateField+'&hospitalCode='+hospitalCode+'&serviceCount='+value+'">'+value+'</a>';
        }
        return value;
    }
</script>
