<div class="container-fluid">
    <div class="row">
        <div id="gridCounselorServiceList"></div>
    </div>
</div>
<script type="text/x-kendo-template" id="gridToolbar">
<ul id="menuGrid" class="kendoGridMenu" >
    <li onclick="historyBack();"><i class="fa fa-backward"></i>Back to previous page</li>
    <li class="pull-right">
        <span  id="lblDiagnosisSummary" class="form-control" style=" font-weight: bold; padding-top: 5px;" ></span>
    </li>
</ul>
</script>
<script language="JavaScript">
    var gridCounselorServiceList, dataSource,hospitalCode,dateField,rowNumber= 1,pathologyCount;
    $(document).ready(function () {
        onLoadCounselorActionPage();
        initServiceInfoGrid();
    });

    function onLoadCounselorActionPage() {
        hospitalCode = '${hospitalCode}';
        dateField = '${dateField}';
        pathologyCount='${pathologyCount}';
        defaultPageTile("Service List", "reports/showMonthlyStatus");
    }
    function initDataSourceRegAndServiceInfo() {
        dataSource = new kendo.data.DataSource({
            transport: {
                read: {
                    url: "${createLink(controller: 'counselorAction', action: 'diagnosisList')}?hospitalCode="+hospitalCode+"&dateField="+dateField,
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
                        diagnosis_info: {type: "string"},
                        gender: {type: "string"},
                        mobile_no: {type: "string"},
                        service_date: {type: "date"},
                        diagnosis_amt: {type: "number"}
                    }
                },
                parse: function (data) {
                    checkIsErrorGridKendo(data);
                    var msg=pathologyCount +' diagnosis provided to '+ data.count+' patients.';
                   $('#lblDiagnosisSummary').text(msg);
                    return data;
                }
            },
            aggregate: [
                {field: "diagnosis_amt", aggregate: "sum" }
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
                        {title: "SL#", width: 15, sortable: false, filterable: false,template:"#= rowNumber++ #"},
                        {
                            field: "reg_no", title: "Registration No", width: 60, sortable: false, filterable: false
                        },
                        {
                            field: "patient_name", title: "Name", width: 80, sortable: false,filterable: false
                        },
                        {
                            field: "date_of_birth", title: "Age", width: 30, sortable: false, filterable: false,
                            template: "#=evaluateDateRange(date_of_birth, new Date())#"
                        },
                        {
                            field: "service_token_no", title: "Service No", width: 70, sortable: false,filterable: false
                        },
                        {
                            field: "service_date", title: "Service Date", width: 70, sortable: false, filterable: false,
                            template: "#=kendo.toString(kendo.parseDate(service_date, 'yyyy-MM-dd hh:mm:ss'), 'dd/MM/yyyy hh:mm:ss tt')#"
                        },
                        {
                            field: "diagnosis_info", title: "Diagnosis", width: 120, sortable: false,
                            filterable: false,footerTemplate: "Total"
                        },
                        {
                            field: "diagnosis_amt", title: "Total(৳)",
                            width: 50, sortable: false, filterable: false,
                            headerAttributes: {style: setAlignRight()},
                            attributes: {style: setAlignRight()},
                            footerAttributes: {style: setAlignRight()},
                            footerTemplate: "#=formatAmount(sum)#"
                        }
                    ],
                    toolbar: kendo.template($("#gridToolbar").html())
                }
        );
        gridCounselorServiceList = $("#gridCounselorServiceList").data("kendoGrid");
        $("#menuGrid").kendoMenu();
    }
    function setCAlignRight() {
        return "text-align:right;font-size:9pt;";
    }
    function setFontSize() {
        return "font-size:9pt;";
    }
    function gridDataBound(e) {
        var grid = e.sender;
        if (grid.dataSource.total() == 0) {
            var colCount = 11;
            $(e.sender.wrapper)
                    .find('tbody')
                    .append('<tr><td colspan="' + colCount + '" class="no-data"><center>Sorry, no data found <i class="fa fa-frown-o"></i></center></td></tr>');
        }
    }
</script>