<div class="container-fluid">
    <div class="row">
        <div id="gridCounselorServiceList"></div>
    </div>
</div>

<script language="JavaScript">
    var gridCounselorServiceList, dataSource, hospitalCode, dateField,counter=1;
    $(document).ready(function () {
        onLoadCounselorActionPage();
        initServiceInfoGrid();
    });

    function onLoadCounselorActionPage() {
        hospitalCode = '${hospitalCode}';
        dateField = '${dateField}';
        defaultPageTile("Service List", "reports/showMonthlyStatus");
    }
    function initDataSourceRegAndServiceInfo() {
        dataSource = new kendo.data.DataSource({
            transport: {
                read: {
                    url: "${createLink(controller: 'counselorAction', action: 'consultancyList')}?hospitalCode=" + hospitalCode + "&dateField=" + dateField,
                    dataType: "json",
                    type: "post"
                }
            },
            schema: {
                type: 'json',
                data: "list", total: "count",
                model: {
                    fields: {
                        reg_no: {type: "string"},
                        patient_name: {type: "string"},
                        date_of_birth: {type: "date"},
                        address: {type: "string"},
                        service_token_no: {type: "string"},
                        consultancy_info: {type: "string"},
                        gender: {type: "string"},
                        mobile_no: {type: "string"},
                        service_date: {type: "date"},
                        consultancy_amt: {type: "number"}
                    }
                },
                parse: function (data) {
                    checkIsErrorGridKendo(data);
                    return data;
                }
            },
            aggregate: [
                {field: "consultancy_amt", aggregate: "sum"}
            ],
            pageSize: false,
            serverPaging: false,
            serverFiltering: false,
            serverSorting: false
        });
    }

    function initServiceInfoGrid() {
        initDataSourceRegAndServiceInfo();
        $("#gridCounselorServiceList").kendoGrid({
            dataSource: dataSource,
            height: getGridHeightKendo(),
            selectable: true,
            sortable: true,
            resizable: true,
            reorderable: true,
            filterable: true,
            dataBound: gridDataBound,
            pageable: false,
            columns: [
                {title: "SL#", width: 15, sortable: false, filterable: false,template:"#=counter++#"},
                {
                    field: "reg_no", title: "Registration No", width: 60, sortable: false, filterable: false
                },
                {
                    field: "patient_name", title: "Name", width: 80, sortable: false, filterable: false
                },
                {
                    field: "date_of_birth", title: "Age", width: 30, sortable: false, filterable: false,
                    template: "#=evaluateDateRange(date_of_birth, new Date())#"
                },
                {
                    field: "service_token_no", title: "Token No", width: 70, sortable: false, filterable: false
                },
                {
                    field: "service_date", title: "Service Date & Time", width: 70, sortable: false, filterable: false,
                    template: "#=kendo.toString(kendo.parseDate(service_date, 'yyyy-MM-dd hh:mm:ss'), 'dd/MM/yyyy hh:mm:ss tt')#"
                },
                {
                    field: "consultancy_info", title: "Consultation", width: 120, sortable: false,
                    filterable: false,footerTemplate: "Total"
                },
                {
                    field: "consultancy_amt", title: "Total(৳)",
                    width: 50, sortable: false, filterable: false,
                    headerAttributes: {style: setAlignRight()},
                    attributes: {style: setAlignRight()},
                    footerAttributes: {style: setAlignRight()},
                    footerTemplate: "#=formatAmount(sum)#"
                }
            ],
            toolbar: kendo.template($("#gridToolbarBase").html())
        });
        gridCounselorServiceList = $("#gridCounselorServiceList").data("kendoGrid");
        $("#menuGrid").kendoMenu();
    }
    function setCAlignRight() {
        return "text-align:right;font-size:7pt;";
    }
    function setFontSize() {
        return "font-size:7pt;";
    }
</script>