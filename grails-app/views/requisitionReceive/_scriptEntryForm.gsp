
<script language="javascript">
    var frmRequisitionReceive,gridMedicineReqReceive, dataSourceForMedicine, dropDownVendor,dropDownRequisitionNo,
            requisitionNo='', unitPrice = 0, totalAmount = 0;

    $(document).ready(function () {
        onLoadRequisitionPage();
        populateDDLRequisitionNo();
        initMedicineRequisitionGrid();
        defaultPageTile("Requisition details", null);
    });

    function onLoadRequisitionPage() {
        dropDownRequisitionNo = initKendoDropdown($('#ddlRequisition'), null, null, null);
    }
    function populateDDLRequisitionNo(){
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
    function  resetForm(){
        dropDownVendor.value('');
        populateDDLRequisitionNo();
        requisitionNo='';
        initMedicineRequisitionGrid();
        $("input:radio").removeAttr("checked");
        $('#prNo').val('');
        $('#chalanNo').val('');

    }

    function executePreCondition() {
        var count = gridMedicineReqReceive.dataSource.total();
        var check=$("input:radio").is(':checked');
        if (count == 0) {
            showError('No data found to save');
            return false;
        }
        else if(!check){
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
        var formData=jQuery('#frmRequisitionReceive').serializeArray();
        formData.push({name: 'gridModelMedicine', value: JSON.stringify(gridMedicineReqReceive.dataSource.data())});
        var isComplete=false;
        if($('#rbComplete').is(':checked')) {
            isComplete=true;
        }

        jQuery.ajax({
            type: 'post',
            data: formData,
            url: "${createLink(controller:'requisitionReceive', action: 'create')}?requisitionNo=" + requisitionNo+"&isReceived=" + isComplete,
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
                    url: "${createLink(controller: 'requisitionReceive', action: 'listOfMedicine')}?requisitionNo=" + requisitionNo,
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
                        medicineId: {type: "number"},
                        genericName: {editable: false, type: "string"},
                        medicineName: {editable: false, type: "string"},
                        unitPrice: {editable: false, type: "number"},
                        unitType: {editable: false, type: "string"},
                        stockQty: {editable: false, type: "number"},
                        reqQty: {editable: false, type: "number"},
                        approvedQty: {editable: false,type: "number"},
                        procQty: {editable: false, type: "number"},
                        prevReceiveQty: {editable: false, type: "number"},
                        receiveQty: { type: "number"},
                        amount: {type: "number"}

                    }
                },
                parse: function (data) {
                    checkIsErrorGridKendo(data);
                    return data;
                }
            },
            aggregate: [
                {field: "amount", aggregate: "sum"}
            ],
            serverPaging: false,
            serverFiltering: true,
            serverSorting: true
        });
    }

    function initMedicineRequisitionGrid() {
        initDataSource();
        $("#gridMedicine").kendoGrid({
            dataSource: dataSourceForMedicine,
            height: getGridHeightKendo()-140,
            selectable: true,
            sortable: true,
            resizable: true,
            reorderable: true,
            pageable: false,
            editable: true,
            edit: function(e) {
            var input = e.container.find(".k-input");
            var value = input.val(), minus = input.val();
            $("[name='receiveQty']", e.container).blur(function(){
                var input = $(this);
                value = input.val();
                var row = $(this).closest("tr");
                var data = $("#gridMedicine").data("kendoGrid").dataItem(row);

                 if(value > (data.approvedQty-data.prevReceiveQty)){
                            showError("Wrong quantity.");
                            data.set('receiveQty', minus);
                            data.set('amount', minus * data.unitPrice);
                        }
                        else {
                     var a = $("#footerSpan").text();
                     totalAmount = parseFloat((a.substring(1, a.length)).replace(/[^\d\.]/g, ''));
                     totalAmount -= minus * data.unitPrice;
                     data.set('amount', value * data.unitPrice);
                     totalAmount = parseFloat(totalAmount, 10) + parseFloat(value * data.unitPrice, 10);
                     $("#footerSpan").text(formatAmount(totalAmount));
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
                }, {
                    field: "medicineName",
                    title: "Medicine Name",
                    width: 100,
                    sortable: false,
                    filterable: false
                },
                {
                    field: "unitType",
                    title: "Unit",
                    width: 50,
                    sortable: false,
                    filterable: false
                },
                {
                    field: "unitPrice",
                    title: "Price",
                    width: 50,
                    attributes: {style: setAlignRight()},
                    headerAttributes: {style: setAlignRight()},
                    template: "#=formatAmount(unitPrice)#",
                    sortable: false,
                    filterable: false
                },{
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
                footerTemplate:"<div style='text-align: right'>Total : </div>"

            },
                {
                    field: "amount",
                    title: "Amount",
                    attributes: {style: setAlignRight()},
                    headerAttributes: {style: setAlignRight()},
                    template: "#=formatAmount(amount)#",
                    sortable: false,filterable: false,width: 50,
                    footerTemplate:"<div style='text-align: right'><span id='footerSpan'>#=formatAmount(sum)#</span></div>"
                }
            ],
            filterable: {
                mode: "row"
            }
        });
        gridMedicineReqReceive = $("#gridMedicine").data("kendoGrid");



    }
function editRecord(){
    requisitionNo = dropDownRequisitionNo.value();
    initMedicineRequisitionGrid();
}

</script>