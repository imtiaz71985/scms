<script language="javascript">
    var frmRequisitionReceive, gridMedicineReqReceive, dataSourceForMedicine, dropDownVendor, dropDownRequisitionNo,
            dropDownRemarks, requisitionNo = '', unitPrice = 0, totalAmount = 0;

    $(document).ready(function () {
        onLoadRequisitionPage();
        initMedicineRequisitionGrid();
        populateDDLRequisitionNo();

        defaultPageTile("Requisition details", null);
    });

    function onLoadRequisitionPage() {
        dropDownRequisitionNo = initKendoDropdown($('#ddlRequisition'), null, null, null);
    }
    function populateDDLRequisitionNo() {
        requisitionNo = '';
        clearGridKendo(gridMedicineReqReceive);
        totalAmount=0;
        setFooter();
        var vendorId = dropDownVendor.value();
        showLoadingSpinner(true);
        $.ajax({
            url: "${createLink(controller: 'requisitionReceive', action: 'requisitionByVendorId')}?id=" + vendorId,
            success: function (data) {
                if (data.isError) {
                    showError(data.message);
                    return false;
                }
                dropDownRequisitionNo.setDataSource(data.lst);
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
    function resetForm() {
        dropDownVendor.value('');
        dropDownRemarks.value('');
        populateDDLRequisitionNo();
        requisitionNo = '';
       //initMedicineRequisitionGrid();
        clearGridKendo(gridMedicineReqReceive);
        totalAmount=0;
        setFooter();
        $("input:radio").removeAttr("checked");
        $('#prNo').val('');
        $('#chalanNo').val('');

    }

    function executePreCondition() {
        var count = gridMedicineReqReceive.dataSource.total();
        var check = $("input:radio").is(':checked');
        if (count == 0) {
            showError('No data found to save');
            return false;
        }
        else if (!check) {
            showError('Need to select completion status.');
            return false;
        }
        return true;
    }
    function onSubmitForm() {
        if (executePreCondition() == false) {
            return false;
        }
        setButtonDisabled($('#create'), true);
        showLoadingSpinner(true);
        var formData = jQuery('#frmRequisitionReceive').serializeArray();
        formData.push({name: 'gridModelMedicine', value: JSON.stringify(gridMedicineReqReceive.dataSource.data())});
        var isComplete = false;
        if ($('#rbComplete').is(':checked')) {
            isComplete = true;
        }
        var remarks='';

        if($("#remarksDDL").val()>0){
            remarks=$("#remarksDDL").data("kendoDropDownList").text();
        }
        jQuery.ajax({
            type: 'post',
            data: formData,
            url: "${createLink(controller:'requisitionReceive', action: 'create')}?requisitionNo=" + requisitionNo + "&isReceived=" + isComplete+"&remarks="+remarks,
            success: function (data, textStatus) {
                executePostCondition(data);
                setButtonDisabled($('#create'), false);
            },
            error: function (XMLHttpRequest, textStatus, errorThrown) {
                afterAjaxError(XMLHttpRequest, textStatus);
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
            $("#unit").text('');
        } else {
            showSuccess(result.message);
            resetForm();
        }
    }

    function initDataSource() {
        dataSourceForMedicine = new kendo.data.DataSource({
            transport: {
                read: {
                    url      : false,
                    dataType : "json",
                    type     : "post"
                }
            },
            schema: {
                type  : 'json',
                data  : "list",
                total : "count",
                model : {
                    fields: {
                        id             : {type: "number"},
                        version        : {type: "number"},
                        medicineId     : {type: "number"},
                        genericName    : {editable: false, type: "string"},
                        medicineName   : {editable: false, type: "string"},
                        unitPrice      : {editable: false, type: "number"},
                        unitType       : {editable: false, type: "string"},
                        stockQty       : {editable: false, type: "number"},
                        reqQty         : {editable: false, type: "number"},
                        approvedQty    : {editable: false, type: "number"},
                        procQty        : {editable: false, type: "number"},
                        prevReceiveQty : {editable: false, type: "number"},
                        receiveQty     : {type: "number"},
                        amount         : {type: "number"}

                    }
                },
                parse: function (data) {
                    checkIsErrorGridKendo(data);
                    totalAmount = data.totalAmount;
                    return data;
                }
            },
            serverPaging: false,
            serverFiltering: true,
            serverSorting: true
        });
    }
    function gridDataBound(e){
        setFooter();
    }
    function initMedicineRequisitionGrid() {
        initDataSource();
        $("#gridMedicine").kendoGrid({
            dataSource : dataSourceForMedicine,
            height     : getGridHeightKendo() - 140,
            autoBind   : false,
            selectable : true,
            sortable   : true,
            resizable  : true,
            reorderable: true,
            pageable   : false,
            dataBound  : gridDataBound,
            editable   : true,
            edit       : function (e) {
                var input = e.container.find(".k-input");
                var value = input.val(), baseValue = input.val();
                $("[name='receiveQty']", e.container).focus(function () {
                    var input = $(this);
                    baseValue = input.val();
                    if(input.val()==0){
                        input.val('');
                        baseValue=0;
                    }
                });
                $("[name='receiveQty']", e.container).blur(function () {
                    var input = $(this);
                    value = input.val();
                    var row = $(this).closest("tr");
                    var data = $("#gridMedicine").data("kendoGrid").dataItem(row);

                    if (value > (data.approvedQty - data.prevReceiveQty)) {
                        showError("Wrong quantity.");
                        data.set('receiveQty', baseValue);
                        data.set('amount', baseValue * data.unitPrice);
                    } else {
                        if(input.val()==''){
                            input.val(0);
                            value = 0;
                            data.set('receiveQty', 0);
                            var dirty = $(this).closest("tr").find(".k-dirty-cell");
                            dirty.removeClass("k-dirty-cell");
                        }
                        totalAmount -= baseValue * data.unitPrice;
                        data.set('amount', parseFloat(value, 10) * data.unitPrice);
                        totalAmount = parseFloat(totalAmount, 10) + parseFloat(value * data.unitPrice, 10);
                        setFooter();
                    }
                });
            },

            columns: [
                {
                    field: "genericName",
                    title: "Generic Name",
                    width: 100,
                    sortable: false,
                    filterable: false
                },{
                    field: "medicineName",
                    title: "Medicine Name",
                    width: 100,
                    sortable: false,
                    filterable: false
                },{
                    field: "unitType",
                    title: "Unit",
                    width: 50,
                    sortable: false,
                    filterable: false
                },{
                    field: "unitPrice",
                    title: "Price",
                    width: 50,
                    attributes: {style: setAlignRight()},
                    headerAttributes: {style: setAlignRight()},
                    template: "#=formatAmount(unitPrice)#",
                    sortable: false,
                    filterable: false
                },
                {
                    field: "reqQty",
                    title: "Req Qty",
                    width: 50,
                    attributes: {style: setAlignRight()},
                    headerAttributes: {style: setAlignRight()},
                    sortable: false,
                    filterable: false
                },{
                    field: "approvedQty",
                    title: "Approve Qty",
                    width: 50,
                    attributes: {style: setAlignRight()},
                    headerAttributes: {style: setAlignRight()},
                    sortable: false,
                    filterable: false
                },{
                    field: "prevReceiveQty",
                    title: "Prev Receive",
                    width: 50,
                    attributes: {style: setAlignRight()},
                    headerAttributes: {style: setAlignRight()},
                    sortable: false,
                    filterable: false
                },{
                    field: "receiveQty",
                    title: "Receive Qty",
                    attributes: {style: setAlignRight()},
                    headerAttributes: {style: setAlignRight()},
                    width: 50,
                    sortable: false,
                    filterable: false,
                    footerTemplate: "<div style='text-align: right'>Total : </div>"
                },{
                    field: "amount",
                    title: "Amount",
                    attributes: {style: setAlignRight()},
                    headerAttributes: {style: setAlignRight()},
                    template: "#=formatAmount(amount)#",
                    sortable: false, filterable: false, width: 50,
                    footerTemplate: "<div style='text-align: right'><span id='footerSpan'>#=formatAmount(0)#</span></div>"
                }
            ],
            filterable: {
                mode: "row"
            }
        });
        gridMedicineReqReceive = $("#gridMedicine").data("kendoGrid");
    }

    function editRecord() {
        requisitionNo = dropDownRequisitionNo.value();
        var url ="${createLink(controller: 'requisitionReceive', action: 'listOfMedicine')}?requisitionNo=" + requisitionNo;
        populateGridKendo(gridMedicineReqReceive,url);
    }

    function setFooter(){
        $("#footerSpan").text(formatAmount(totalAmount));
    }

</script>