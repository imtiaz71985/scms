
<div class="container-fluid">
    <div class="row">
        <div id="gridRegistrationInfo"></div>
    </div>
</div>

<script language="javascript">
    var gridRegistrationInfo, dataSourceGrid,dateField;

    $(document).ready(function () {
        defaultPageTile("Registration Info", "registrationInfo/show");
        dateField = '${dateField}';
        initRegistrationInfoGrid();
    });

    function initDataSource() {
        dataSourceGrid = new kendo.data.DataSource({
            transport: {
                read: {
                    url: "${createLink(controller: 'registrationInfo', action: 'list')}?dateField="+dateField,
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
                        createDate: {type: "date"},
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
            sort: {field: 'createDate', dir: 'desc'},

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
                {field: "regNo", title: "Reg No", width: 40, sortable: false, filterable: kendoCommonFilterable(97)},
                {
                    field: "patientName",
                    title: "Name",
                    width: 100,
                    sortable: false,
                    filterable: kendoCommonFilterable(97)
                },
                {
                    field: "fatherOrMotherName",
                    title: "Father/Mother",
                    width: 100,
                    sortable: false,
                    filterable: kendoCommonFilterable(97)
                },
                {
                    field: "address",
                    title: "Address",
                    width: 170,
                    sortable: false,
                    filterable: kendoCommonFilterable(97)
                },
                {
                    field: "dateOfBirth", title: "Age", width: 50, sortable: false, filterable: false,
                    template: "#=evaluateDateRange(dateOfBirth, new Date())#"
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

