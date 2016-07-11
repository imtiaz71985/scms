
<script language="javascript">
    var frmRequisition,quantity,gridMedicineRequisition, dataSourceForMedicine, dropDownMedicine,
            requisitionNo, medicineName, unitPrice = 0, totalAmount = 0;

    $(document).ready(function () {
        requisitionNo = '${requisitionNo}';
        $("#requisitionNo").val(requisitionNo);
        initMedicineRequisitionGrid();

        defaultPageTile("Requisition details", null);
    });

    function  resetForm(){
        window.history.back();
    }

    function executePreCondition() {
        var count = gridMedicineRequisition.dataSource.total();
        if (count == 0) {
            showError('No data found to save');
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
        var formData=jQuery('#frmRequisition').serializeArray();
        formData.push({name: 'gridModelMedicine', value: JSON.stringify(gridMedicineRequisition.dataSource.data())});

        jQuery.ajax({
            type: 'post',
            data: formData,
            url: "${createLink(controller:'requisitionReceive', action: 'update')}",
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
            //clearForm($("#frmRequisition"), $('#medicineId'));

           // gridMedicineRequisition.setDataSource(dsDr);
            //$("#unit").text('');
            window.history.back();
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
                        receiveQty: { type: "number"},
                        amount: {type: "number"}

                    }
                },
                parse: function (data) {
                    checkIsErrorGridKendo(data);
                    return data;
                }
            },
            serverPaging: false,
            serverFiltering: true,
            serverSorting: true
        });
    }

    function initMedicineRequisitionGrid() {
        initDataSource();
        $("#gridMedicine").kendoGrid({
            dataSource: dataSourceForMedicine,
            height: getGridHeightKendo(),
            selectable: true,
            sortable: true,
            resizable: true,
            reorderable: true,
            pageable: false,
            editable: true,
            edit: function(e) {
            var input = e.container.find(".k-input");
            var value = input.val(),
                    minus = input.val();
            $("[name='receiveQty']", e.container).blur(function(){
                var input = $(this);
                value = input.val();
                var row = $(this).closest("tr");
                var data = $("#gridMedicine").data("kendoGrid").dataItem(row);
                totalAmount-=minus*data.unitPrice;
                data.set('amount',value*data.unitPrice);
                totalAmount=parseFloat(totalAmount,10)+parseFloat(value*data.unitPrice,10);
                $("#footerSpan").text(formatAmount(totalAmount));
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
                },{
                    field: "unitPrice",
                    title: "Price",
                    width: 50,
                    sortable: false,
                    filterable: false
                },
                {
                    field: "reqQty",
                    title: "Req Qty",
                    width: 50,
                    sortable: false,
                    filterable: false
                },{
                field: "approvedQty",
                title: "Approve Qty",
                width: 50,
                sortable: false,
                filterable: false
                },{
                field: "procQty",
                title: "Delivery Qty",
                width: 50,
                sortable: false,
                filterable: false
                },
                {
                field: "receiveQty",
                title: "Receive Qty",
                width: 50,
                sortable: false,
                filterable: false
                },
                {
                    field: "amount",
                    title: "Amount",
                    attributes: {style: setAlignRight()},
                    headerAttributes: {style: setAlignRight()},
                    template: "#=formatAmount(amount)#",
                    sortable: false,filterable: false,width: 50,
                    footerTemplate:"<div style='text-align: right'>Total : <span id='footerSpan'>#=formatAmount(0)#</span></div>"
                }
            ],
            filterable: {
                mode: "row"
            }
        });
        gridMedicineRequisition = $("#gridMedicine").data("kendoGrid");



    }


</script>