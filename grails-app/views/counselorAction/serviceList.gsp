<div class="container-fluid">
<div class="row">
    <div id="gridCounselorServiceList"></div>
</div>
</div>

<script language="JavaScript">
    var gridCounselorServiceList, dataSource;
    $(document).ready(function () {
        onLoadCounselorActionPage();
        initServiceInfoGrid();
    });

    function onLoadCounselorActionPage() {
        defaultPageTile("Service List", null);
    }
    function initDataSourceRegAndServiceInfo() {
        dataSource = new kendo.data.DataSource({
            transport: {
                read: {
                    url: "${createLink(controller: 'counselorAction', action: 'serviceList')}",
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
                        mobileNo: {type: "string"},
                        address: {type: "string"},
                        serviceTokenNo: {type: "string"},
                        subsidyAmount: {type: "number"},
                        consultancyAmt: {type: "number"},
                        pathologyAmt: {type: "number"},
                        totalCharge: {type: "number"},
                        serviceDate: {type: "string"},
                        isExit: {type: "boolean"}
                    }
                },
                parse: function (data) {
                    checkIsErrorGridKendo(data);
                    return data;
                }
            },
            pageSize: 10,
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
                    dataBound: gridDataBound,
                    pageable: {
                        refresh: true,
                        pageSizes: getDefaultPageSizes(),
                        buttonCount: 4
                    },
                    columns: [
                        {field: "regNo", title: "Reg No", width: 80, sortable: false, filterable: false},
                        {field: "serviceTokenNo", title: "Token No", width: 80, sortable: false, filterable: false},
                        {field: "patientName", title: "Name", width: 150, sortable: false, filterable: false},
                        {
                            field: "dateOfBirth", title: "Age", width: 50, sortable: false, filterable: false,
                            template: "#=evaluateDateRange(dateOfBirth, new Date())#"
                        }, {
                            title: "Charges", headerAttributes: {style: setAlignCenter()},
                            columns: [

                                {
                                    field: "consultancyAmt",
                                    title: "Consultancy(৳)",
                                    width: 60,
                                    sortable: false,
                                    filterable: false
                                },
                                {
                                    field: "subsidyAmount",
                                    title: "Subsidy(৳)",
                                    width: 50,
                                    sortable: false,
                                    filterable: false
                                },
                                {
                                    field: "pathologyAmt",
                                    title: "Pathology(৳)",
                                    width: 70,
                                    sortable: false,
                                    filterable: false
                                },
                                {field: "totalCharge", title: "Total(৳)", width: 70, sortable: false, filterable: false}
                            ]
                        }
                    ]
                }
        );
        gridCounselorServiceList = $("#gridCounselorServiceList").data("kendoGrid");
    }
</script>