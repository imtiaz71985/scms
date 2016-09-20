
<div class="container-fluid">
    <div class="row">
        <div id="gridRegistrationInfo"></div>
    </div>
</div>

<script language="javascript">
    var gridRegistrationInfo, dataSourceGrid,dateField;

    $(document).ready(function () {
        defaultPageTile("Patient Info", "registrationInfo/show");
        dateField = '${dateField}';
        initRegistrationInfoGrid();
    });

    function initDataSource() {
        dataSourceGrid = new kendo.data.DataSource({
            transport: {
                read: {
                    url: "${createLink(controller: 'registrationInfo', action: 'reissueList')}?dateField="+dateField,
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
                        regNo: {type: "string"},
                        patientName: {type: "string"},
                        fatherOrMotherName: {type: "string"},
                        dateOfBirth: {type: "date"},
                        registrationDate: {type: "date"},
                        reissueDate: {type: "date"},
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
            sort: {field: 'reissueDate', dir: 'asc'},

            pageSize: getDefaultPageSize(),
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
            pageable: {
                refresh: true,
                pageSizes: getDefaultPageSizes(),
                buttonCount: 4
            },
            columns: [
                {field: "regNo", title: "Registration No", width: 60, sortable: false, filterable: kendoCommonFilterable(97)},
                {field: "reissueDate", title: "Reissue Date", width: 70, sortable: false, filterable: false,
                template:"#=kendo.toString(kendo.parseDate(reissueDate, 'yyyy/MM/dd HH:mm:ss'), 'dd/MM/yy hh:mm tt')#"},
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

