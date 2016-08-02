<script language="javascript">
    var frmRequisition, gridMedicineRequisition, dataSourceForMedicine, hospitalCode,requisitionNo, totalAmount = 0,isUpdate=false;

    $(document).ready(function () {
        hospitalCode = '${hospitalCode}';
        requisitionNo = '${requisitionNo}';
        $("#requisitionNo").val(requisitionNo);
        totalAmount = ${totalAmount?totalAmount:0};
        if(totalAmount>0){
            isUpdate=true;
        }
        initMedicineRequisitionGrid();
        defaultPageTile("Requisition details", null);
    });

    function resetForm() {
        window.history.back();
    }

    function executePreCondition() {
        if (totalAmount == 0) {
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
        var actionUrl = "${createLink(controller:'requisition', action: 'create')}";
        if(isUpdate){
            actionUrl = "${createLink(controller:'requisition', action: 'update')}";
        }
        var formData = jQuery('#frmRequisition').serializeArray();
        formData.push({name: 'gridModelMedicine', value: JSON.stringify(gridMedicineRequisition.dataSource.data())});

        jQuery.ajax({
            type: 'post',
            data: formData,
            url: actionUrl,
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
        } else {
            showSuccess(result.message);
            window.history.back();
        }
    }

    function initDataSource() {
        dataSourceForMedicine = new kendo.data.DataSource({
            transport: {
                read: {
                    url: "${createLink(controller: 'requisition', action: 'listOfMedicine')}?requisitionNo=" + requisitionNo+"&hospitalCode="+hospitalCode,
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
                        type: {editable: false, type: "string"},
                        genericName: {editable: false, type: "string"},
                        medicineName: {editable: false, type: "string"},
                        unitPrice: {editable: false, type: "number"},
                        unitType: {editable: false, type: "string"},
                        stockQty: {editable: false, type: "number"},
                        reqQty: {type: "number"},
                        approveQty: {editable: false, type: "number"},
                        procQty: {editable: false, type: "number"},
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
            height: getGridHeightKendo(),
            selectable: true,
            sortable: true,
            resizable: true,
            reorderable: true,
            pageable: false,
            editable: true,
            edit: function (e) {
                var input = e.container.find(".k-input");
                var value = input.val(),
                        minus = input.val();
                $("[name='reqQty']", e.container).focus(function () {
                    var input = $(this);
                    if(input.val()==0){
                        input.val('');
                    }
                });
                $("[name='reqQty']", e.container).blur(function () {
                    var input = $(this);
                    var row = $(this).closest("tr");
                    var data = $("#gridMedicine").data("kendoGrid").dataItem(row);
                    value = input.val();
                    if(input.val()==''){
                        input.val(0);
                        data.set('reqQty', 0);
                        var dirty = $(this).closest("tr").find(".k-dirty-cell");
                        dirty.removeClass("k-dirty-cell");
                    }
                    totalAmount -= minus * data.unitPrice;
                    data.set('amount', value * data.unitPrice);
                    totalAmount = parseFloat(totalAmount, 10) + parseFloat(value * data.unitPrice, 10);
                    $("#footerSpan").text(formatAmount(totalAmount));
                });
            },

            columns: [
                {
                    field: "type",
                    title: "Type",
                    width: 30,
                    sortable: false,
                    filterable: false
                },
                {
                    field: "genericName",
                    title: "Generic Name",
                    width: 60,
                    sortable: false,
                    filterable: false
                },
                {
                    field: "medicineName",
                    title: "Medicine Name",
                    width: 100,
                    sortable: false,
                    filterable: false
                },
                {
                    field: "unitType",
                    title: "Unit",
                    width: 30,
                    sortable: false,
                    filterable: false
                }, {
                    field: "unitPrice",
                    title: "Price",
                    width: 50,
                    attributes: {style: setAlignRight()},
                    headerAttributes: {style: setAlignRight()},
                    template: "#=formatAmount(unitPrice)#",
                    sortable: false,
                    filterable: false
                }, {
                    field: "stockQty",
                    title: "Stock Qty",
                    width: 50,
                    attributes: {style: setAlignRight()},
                    headerAttributes: {style: setAlignRight()},
                    sortable: false,
                    filterable: false
                }, {
                    field: "reqQty",
                    title: "Req Qty",
                    width: 50,
                    attributes: {style: setAlignRight()},
                    headerAttributes: {style: setAlignRight()},
                    sortable: false,
                    filterable: false
                },
                {
                    field: "amount",
                    title: "Amount",
                    attributes: {style: setAlignRight()},
                    headerAttributes: {style: setAlignRight()},
                    template: "#=formatAmount(amount)#",
                    sortable: false, filterable: false, width: 50,
                    footerTemplate: "<div style='text-align: right'>Total : <span id='footerSpan'>#=formatAmount(sum)#</span></div>"
                }
            ],
            filterable: {
                mode: "row"
            }
        });
        gridMedicineRequisition = $("#gridMedicine").data("kendoGrid");


    }
</script>