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
                        serviceDate: {type: "date"},
                        serviceType: {type: "string"}
                    }
                },
                parse: function (data) {
                    checkIsErrorGridKendo(data);
                    return data;
                }
            },
            group: {
                field: "regNo",
                dir: "asc"
            },
            pageSize: getDefaultPageSize(),
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
                    pageable: {
                        refresh: true,
                        pageSizes: getDefaultPageSizes(),
                        buttonCount: 4
                    },
                    columns: [
                        {field: "regNo", title: "Registration No", width: 70, sortable: false,
                            filterable: {
                                extra: false,
                                operators: {
                                    string: {
                                        contains: "Contains"
                                    }
                                }
                            }
                        },
                        {field: "patientName", title: "Name", width: 120, sortable: false,
                            filterable: {
                                extra: false,
                                operators: {
                                    string: {
                                        contains: "Contains"
                                    }
                                }
                            }
                        },
                        {field: "serviceTokenNo", title: "Service No", width: 70, sortable: false,
                            filterable: {
                                extra: false,
                                operators: {
                                    string: {
                                        contains: "Contains"
                                    }
                                }
                            }
                        },
                        {field: "serviceDate", title: "Service Date", width: 60, sortable: false,filterable: {
                            extra: false,
                            operators: {
                                date: {
                                    eq: "Contains"
                                }
                            },
                            ui: function (element) {
                                element.kendoDatePicker({
                                    format: "dd/MM/yyyy"
                                });
                            }
                        },
                            format: "{0:dd/MM/yyyy}"
                        },
                        {
                            field: "dateOfBirth", title: "Age", width: 40, sortable: false, filterable: false,
                            template: "#=evaluateDateRange(dateOfBirth, new Date())#"
                        },
                        {
                            field: "serviceType", title: "Service Type", width: 120, sortable: false,
                            filterable: false,attributes: {style: setFontSize()}
                        },
                        {
                            title: "Charges", headerAttributes: {style: setAlignCenter()},
                            columns: [

                                {
                                    field: "consultancyAmt",
                                    title: "Consultancy(৳)",
                                    headerAttributes: {style: setCAlignRight()},
                                    attributes: {style: setAlignRight()},
                                    width: 40,
                                    sortable: false,
                                    filterable: false
                                },
                                {
                                    field: "subsidyAmount",
                                    title: "Subsidy(৳)",
                                    headerAttributes: {style: setCAlignRight()},
                                    attributes: {style: setAlignRight()},
                                    width: 40,
                                    sortable: false,
                                    filterable: false
                                },
                                {
                                    field: "pathologyAmt",
                                    title: "Pathology(৳)",
                                    headerAttributes: {style: setCAlignRight()},
                                    attributes: {style: setAlignRight()},
                                    width: 40,
                                    sortable: false,
                                    filterable: false
                                },
                                {field: "totalCharge", title: "Total(৳)",
                                    width: 50, sortable: false, filterable: false,
                                    headerAttributes: {style: setAlignRight()},
                                    attributes: {style: setAlignRight()}
                                }
                            ]
                        }
                    ]
                }
        );
        gridCounselorServiceList = $("#gridCounselorServiceList").data("kendoGrid");
    }
    function setCAlignRight() {
        return "text-align:right;font-size:7pt;";
    }
    function setFontSize() {
        return "font-size:7pt;";
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