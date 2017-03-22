<script language="javascript">
    var frmRequisition, gridMedicineRequisition, dataSourceForMedicine, requisitionNo, totalAmount = 0;

    $(document).ready(function () {
        requisitionNo = '${requisitionNo}';
        $("#requisitionNo").val(requisitionNo);
        $("#hospitalName").val('${hospitalName}');
        $("#requisitionBy").val('${createdBy}');
        totalAmount = ${totalAmount?totalAmount:0};
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
        var formData = jQuery('#frmRequisition').serializeArray();
        formData.push({name: 'gridModelMedicine', value: JSON.stringify(gridMedicineRequisition.dataSource.data())});

        jQuery.ajax({
            type: 'post',
            data: formData,
            url: "${createLink(controller:'requisition', action: 'updateHO')}",
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
                    url: "${createLink(controller: 'requisition', action: 'listOfMedicineHO')}?requisitionNo=" + requisitionNo,
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
                        reqQty: {editable: false, type: "number"},
                        approvedQty: {type: "number",validation: { min: 0 }},
                        procQty: {editable: false, type: "number"},
                        amount: {editable: false,type: "number"},
                        approveAmount: {type: "number"}
                    }
                },
                parse: function (data) {
                    checkIsErrorGridKendo(data);
                    return data;
                }
            },
            aggregate: [
                {field: "amount", aggregate: "sum"},
                {field: "approveAmount", aggregate: "sum"}
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
                var value = input.val(), minus = input.val();
                $("[name='approvedQty']", e.container).focus(function () {
                    var input = $(this);
                    if(input.val()==0){
                        input.val('');
                    }
                });
                $("[name='approvedQty']", e.container).blur(function () {
                    var input = $(this);
                    var row = $(this).closest("tr");
                    var data = $("#gridMedicine").data("kendoGrid").dataItem(row);
                    value = input.val();
                    if(input.val()==''){
                        input.val(0);
                        data.set('approvedQty', 0);
                        var dirty = $(this).closest("tr").find(".k-dirty-cell");
                        dirty.removeClass("k-dirty-cell");
                    }
                    totalAmount -= minus * data.unitPrice;
                    data.set('approveAmount', value * data.unitPrice);
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
                    width: 50,
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
                    width: 20,
                    sortable: false,
                    filterable: false
                }, {
                    field: "unitPrice",
                    title: "Unit Price",
                    width: 30,
                    attributes: {style: setAlignRight()},
                    headerAttributes: {style: setAlignRight()},
                    template: "#=formatAmount(unitPrice)#",
                    sortable: false,
                    filterable: false
                }, {
                    field: "stockQty",
                    title: "Stock Qty",
                    width: 30,
                    attributes: {style: setAlignRight()},
                    headerAttributes: {style: setAlignRight()},
                    sortable: false,
                    filterable: false
                },
                {
                    title: "Requisition", headerAttributes: {style: setAlignCenter()},
                    columns: [

                        {
                            field: "reqQty",
                            title: "Qty",
                            width: 30,
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
                            footerTemplate: "<div style='text-align: right'>Total : #=formatAmount(sum)#</div>"
                        }
                    ]
                },
                {
                    title: "Approved", headerAttributes: {style: setAlignCenter()},
                    columns: [

                        {
                            field: "approvedQty",
                            title: "Qty",
                            width: 40,
                            attributes: {style: setAlignRight()},
                            headerAttributes: {style: setAlignRight()},
                            sortable: false,
                            filterable: false,
                            template: "<span style='float: left; width: 100%;" +
                            "font-size: large; background-color:gainsboro'><b>#=approvedQty#</b></div>"
                        },
                        {
                            field: "approveAmount",
                            title: "Amount",
                            attributes: {style: setAlignRight()},
                            headerAttributes: {style: setAlignRight()},
                            template: "#=formatAmount(approveAmount)#",
                            sortable: false, filterable: false, width: 50,
                            footerTemplate: "<div style='text-align: right'>Total : <span id='footerSpan'>#=formatAmount(sum)#</span></div>"
                        }
                    ]
                }
            ],
            filterable: {
                mode: "row"
            }
        });
        gridMedicineRequisition = $("#gridMedicine").data("kendoGrid");
    }

</script>