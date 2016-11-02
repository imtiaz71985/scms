<div class="container-fluid">
    <div class="row">
        <div id="gridPatientServedDetailsList"></div>
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
    var gridPatientServedDetailsList, dataSource, hospitalCode, dateField,counter=1;
    $(document).ready(function () {
        onLoadCounselorActionPage();
        initPatientServedDetails();
    });

    function onLoadCounselorActionPage() {
        hospitalCode = '${hospitalCode}';
        dateField = '${dateField}';
        patientCount='${patientCount}';
        defaultPageTile("Service List", "reports/showMonthlyStatus");
    }
    function initDataSourceRegAndServiceInfo() {
        dataSource = new kendo.data.DataSource({
            transport: {
                read: {
                    url: "${createLink(controller: 'reports', action: 'listOfPatientServedDetails')}?hospitalCode=" + hospitalCode + "&dateField=" + dateField,
                    dataType: "json",
                    type: "post"
                }
            },
            schema: {
                type: 'json',
                data: "list", total: "count",
                model: {
                    fields: {
                        regNo: {type: "string"},
                        patientName: {type: "string"},
                        dateOfBirth: {type: "date"},
                        serviceType: {type: "string"},
                        gender: {type: "string"},
                        mobileNo: {type: "string"}
                    }
                },
                parse: function (data) {
                    checkIsErrorGridKendo(data);
                    var msg=data.count+' served patient details.';
                    $('#lblDiagnosisSummary').text(msg);
                    return data;
                }
            },
            pageSize: false,
            serverPaging: false,
            serverFiltering: false,
            serverSorting: false
        });
    }

    function initPatientServedDetails() {
        initDataSourceRegAndServiceInfo();
        $("#gridPatientServedDetailsList").kendoGrid({
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
                    field: "regNo", title: "Registration No", width: 60, sortable: false, filterable: false
                },
                {
                    field: "patientName", title: "Name", width: 130, sortable: false, filterable: false
                },
                {
                    field: "gender", title: "Gender", width: 30, sortable: false, filterable: false
                },
                {
                    field: "dateOfBirth", title: "Age", width: 30, sortable: false, filterable: false,
                    template: "#=evaluateDateRange(dateOfBirth, new Date())#"
                },
                {
                    field: "mobileNo", title: "Mobile No", width: 80, sortable: false, filterable: false
                },
                {
                    field: "serviceType", title: "Services", width: 170, sortable: false,
                    filterable: false, attributes: {style: setFontSize()}
                }
            ],
            toolbar: kendo.template($("#gridToolbar").html())
        });
        gridPatientServedDetailsList = $("#gridPatientServedDetailsList").data("kendoGrid");
        $("#menuGrid").kendoMenu();
    }
    function setCAlignRight() {
        return "text-align:right;font-size:11pt;";
    }
    function setFontSize() {
        return "font-size:11pt;";
    }
</script>