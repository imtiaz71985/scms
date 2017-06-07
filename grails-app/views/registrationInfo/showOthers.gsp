
<div class="container-fluid">
    <div class="row">
        <div id="gridRegistrationInfo"></div>
    </div>
</div>

<script language="javascript">
    var gridRegistrationInfo, dataSourceGrid,dateField, visitType,rowNumber=1;

    $(document).ready(function () {
        defaultPageTile("Patient Info", "reports/showMonthlyStatus");
        dateField = '${dateField}';
        visitType = '${visitType}';
        initRegistrationInfoGrid();
    });

    function initDataSource() {
        dataSourceGrid = new kendo.data.DataSource({
            transport: {
                read: {
                    url: "${createLink(controller: 'registrationInfo', action: 'customList')}?dateField="+dateField+"&visitType="+visitType,
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
                        visitTypeId: {type: "number"},
                        regNo: {type: "string"},
                        serviceTokenNo: {type: "string"},
                        patientName: {type: "string"},
                        fatherOrMotherName: {type: "string"},
                        dateOfBirth: {type: "date"},
                        registrationDate: {type: "date"},
                        serviceDate: {type: "date"},
                        sexId: {type: "number"},
                        maritalStatusId: {type: "number"},
                        mobileNo: {type: "string"},
                        village: {type: "number"},
                        unionId: {type: "number"},
                        upazilaId: {type: "number"},
                        districtId: {type: "number"},
                        address: {type: "string"}
                    }
                },
                parse: function (data) {
                    checkIsErrorGridKendo(data);
                    return data;
                }
            },
            sort: {field: 'serviceDate', dir: 'asc'},

            pageSize: false,
            serverPaging: true,
            serverFiltering: true,
            serverSorting: true
        });
    }

    function initRegistrationInfoGrid() {
        initDataSource();
        $("#gridRegistrationInfo").kendoGrid({
            dataSource: dataSourceGrid,
            height: getGridHeightKendo(),
            selectable: true,
            sortable: true,
            resizable: true,
            reorderable: true,
            dataBound: gridDataBound,
            pageable:false,
            columns: [
                {title: "SL#", width: 15, sortable: false, filterable: false,template:"#= rowNumber++ #"},
                {field: "serviceTokenNo", title: "Service No", width: 60, sortable: false, filterable: kendoCommonFilterable(97)},
                {field: "serviceDate", title: "Service Date", width: 70, sortable: false, filterable: false,
                template:"#=kendo.toString(kendo.parseDate(serviceDate, 'yyyy/MM/dd HH:mm:ss'), 'dd/MM/yy hh:mm tt')#"},
                {field: "regNo", title: "Registration No", width: 60, sortable: false, filterable: kendoCommonFilterable(97)},
                {
                    field: "patientName",
                    title: "Name",
                    width: 80,
                    sortable: false,
                    filterable: kendoCommonFilterable(97)
                },
                {
                    field: "dateOfBirth", title: "Age", width: 50, sortable: false, filterable: false,
                    template: "#=evaluateDateRange(dateOfBirth, new Date())#"
                },
                {
                    field: "fatherOrMotherName",
                    title: "Father/Mother",
                    width: 80,
                    sortable: false,
                    filterable: kendoCommonFilterable(97)
                },
                {
                    field: "address",
                    title: "Address",
                    width: 120,
                    sortable: false,
                    filterable: kendoCommonFilterable(97)
                }
            ],
            filterable: {
                mode: "row"
            },
            toolbar: kendo.template($("#gridToolbarBase").html())
        });
        gridRegistrationInfo = $("#gridRegistrationInfo").data("kendoGrid");
        $("#menuGrid").kendoMenu();
    }

</script>

