<g:render template='/counselorAction/detailsTemplate'/>
<div class="container-fluid">
    <div class="row">
        <div id="gridCounselorActionHO"></div>
    </div>
</div>
%{--<style>

.k-grid .k-button
{
    min-width: 0 !important;
}
</style>--}%

<script type="text/x-kendo-template" id="gridToolbar">
<ul id="menuGrid" class="kendoGridMenu">

    <sec:access url="/counselorAction/approveRequest">
        <li onclick="approveRequest();"><i class="fa fa-check-circle-o"></i>Approve</li>
    </sec:access>
    <sec:access url="/counselorAction/approveRequest">
        <li onclick="declineRequest();"><i class="fa fa-check-circle-o"></i>Decline</li>
    </sec:access>
</ul>
</script>

<script language="javascript">
    var gridCounselorActionHO, dataSource;

    $(document).ready(function () {
        onLoadCounselorServiceHOPage();
        initRegAndServiceInfoGrid();
    });

    function onLoadCounselorServiceHOPage() {
        defaultPageTile("Counselor Previous Service Approve Request", 'counselorAction/showOldServiceHO');
    }

    function initDataSourceRegAndServiceInfo() {
        dataSource = new kendo.data.DataSource({
            transport: {
                read: {
                    url: "${createLink(controller: 'counselorAction', action: 'listOfOldService')}",
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
                        serviceType: {type: "string"},
                        remarks: {type: "string"},
                        hospitalName: {type: "string"},
                        CreatedBy: {type: "string"},
                        is_approved:{type: "boolean"},
                        is_decline:{type: "boolean"}
                    }
                },
                parse: function (data) {
                    checkIsErrorGridKendo(data);
                    return data;
                }
            },
            pageSize: getDefaultPageSize(),
            serverPaging: true,
            serverFiltering: true,
            serverSorting: true
        });
    }
    function setCAlignRight() {
        return "text-align:right;font-size:9pt;";
    }
    function setCAlignLeft() {
        return "text-align:leftt;font-size:9pt;";
    }
    function setCAlignCenter() {
        return "text-align:center;font-size:9pt;";
    }
    function initRegAndServiceInfoGrid() {
        initDataSourceRegAndServiceInfo();
        $("#gridCounselorActionHO").kendoGrid({
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
                        {field: "hospitalName", title: "Hospital", width: 100,attributes: {style: setCAlignLeft()},
                            headerAttributes: {style: setCAlignLeft()}, sortable: false, filterable: false},
                        {field: "CreatedBy", title: "Creator", width: 100,attributes: {style: setCAlignLeft()},
                            headerAttributes: {style: setCAlignLeft()}, sortable: false, filterable: false},
                        {field: "regNo", title: "Reg No", width: 60,attributes: {style: setCAlignCenter()},
                            headerAttributes: {style: setCAlignCenter()}, sortable: false, filterable: false},
                        {field: "serviceTokenNo", title: "Token No", width: 65,attributes: {style: setCAlignCenter()},
                            headerAttributes: {style: setCAlignCenter()}, sortable: false, filterable: false},
                        {field: "serviceDate", title: "Service<br/> Date", width: 50,attributes: {style: setCAlignCenter()},
                            headerAttributes: {style: setCAlignCenter()}, sortable: false, filterable: false},
                        {field: "totalCharge", title: "Total(৳)", width: 50,headerAttributes: {style: setCAlignRight()},
                            attributes: {style: setCAlignRight()}, sortable: false, filterable: false},
                        {field: "remarks", title: "Remarks", width: 100,attributes: {style: setCAlignLeft()},
                            headerAttributes: {style: setCAlignLeft()}, sortable: false, filterable: false},
                        {field: "is_approved", title: "Status", width: 50, sortable: false, filterable: false,attributes: {style: setCAlignCenter()},
                            headerAttributes: {style: setCAlignCenter()}, template:"#=is_approved==true?'Approve':(is_decline==true?'Decline':'Not Approve')#"},
                        {
                            command: [
                                //define the commands here
                                { name: "custom1", text: "",click: showDetails, className: "fa fa-search-plus "}
                            ],
                            title: "",width:50
                        }

                    ], toolbar: kendo.template($("#gridToolbar").html())
                }
        )
        ;
        gridCounselorActionHO = $("#gridCounselorActionHO").data("kendoGrid");
        $("#menuGrid").kendoMenu();
    }
    function showDetails(e) {
        e.preventDefault();
        var dataItem = this.dataItem($(e.currentTarget).closest("tr"));
        $.ajax({
            url: "${createLink(controller: 'counselorAction', action: 'oldServiceDetails')}?tokenNo=" + dataItem.serviceTokenNo,
            success: function (data) {
                detailsTemplate = kendo.template($("#detailsTemplate").html());
                wnd.content(detailsTemplate(data.details));
                wnd.center().open();
            },
            error: function (XMLHttpRequest, textStatus, errorThrown) {
                afterAjaxError(XMLHttpRequest, textStatus);
            },
            complete: function (XMLHttpRequest, textStatus) {
                showLoadingSpinner(false);
            },
            dataType: 'json',
            type: 'post'
        });
        return true;
    }


    function approveRequest() {
        if (executeCommonPreConditionForSelectKendo(gridCounselorActionHO, 'record') == false) {
            return;
        }
        if (!confirm('Are you sure you want to approve this service?')) {
            return false;
        }

        var obj = getSelectedObjectFromGridKendo(gridCounselorActionHO);
        if (obj.isApproved) {
            showError('Already approve this Service');
            return false;
        }
        showLoadingSpinner(true);
        var actionUrl = "${createLink(controller: 'counselorAction', action: 'approveRequest')}?serviceTokenNo=" + obj.serviceTokenNo+'&isApprove='+true;
        jQuery.ajax({
            type: 'post',
            url: actionUrl,
            success: function (data, textStatus) {
                executePostCondition(data);
            },
            error: function (XMLHttpRequest, textStatus, errorThrown) {
            },
            complete: function (XMLHttpRequest, textStatus) {
                showLoadingSpinner(false);
            },
            dataType: 'json'
        });
        return false;
    }
function declineRequest() {
        if (executeCommonPreConditionForSelectKendo(gridCounselorActionHO, 'record') == false) {
            return;
        }
    if (!confirm('Are you sure you want to decline this service?')) {
        return false;
    }

        var obj = getSelectedObjectFromGridKendo(gridCounselorActionHO);
        if (obj.isApproved) {
            showError('Already approve this Service');
            return false;
        }
        showLoadingSpinner(true);
        var actionUrl = "${createLink(controller: 'counselorAction', action: 'approveRequest')}?serviceTokenNo=" + obj.serviceTokenNo+'&isApprove='+false;
        jQuery.ajax({
            type: 'post',
            url: actionUrl,
            success: function (data, textStatus) {
                executePostCondition(data);
            },
            error: function (XMLHttpRequest, textStatus, errorThrown) {
            },
            complete: function (XMLHttpRequest, textStatus) {
                showLoadingSpinner(false);
            },
            dataType: 'json'
        });
        return false;
    }


    function executePostCondition(result) {
        if (result.isError) {
            showError(result.message);
            showLoadingSpinner(false);
        } else {
            $("#gridCounselorActionHO").data('kendoGrid').dataSource.read();
            bootboxAlert(result.message);
        }
    }

</script>
