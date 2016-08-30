
<script language="javascript">
    var gridMedicineSellReturnInfo, dataSource, totalAmount=0, rtnAmount=0;

    $(document).ready(function () {
        onLoadMedicineSellReturnPage();
        initMedicineSellInfoGrid();
    });
    function onLoadMedicineSellReturnPage() {
        defaultPageTile("Medicine return", "medicineReturn/show");
    }
    function executePreCondition(){
        var voucherNo = $("#voucherNo").val();
        if(voucherNo==''){
            showError('Please select voucher no.');
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
        var voucherNo = $("#voucherNo").val();
        var formData = jQuery('#frmMedicine').serializeArray();
        formData.push({name: 'gridModelMedicine', value: JSON.stringify(gridMedicineSellReturnInfo.dataSource.data())});
        formData.push({name: 'voucherNo', value: voucherNo});
        jQuery.ajax({
            type: 'post',
            data: formData,
            url: "${createLink(controller:'medicineReturn', action: 'create')}",
            success: function (data, textStatus) {
                executePostCondition(data);
                setButtonDisabled($('#create'), false);
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
            try {
                showSuccess(result.message);
                window.history.back();
            } catch (e) {
                // Do Nothing
            }
        }
    }

    function viewSellDetails(){
        if (executePreCondition() == false) {
            return false;
        }
        var voucherNo = $("#voucherNo").val();
        setButtonDisabled($('#btnNewService'), true);
        jQuery.ajax({
            type: 'post',
            url: "${createLink(controller:'medicineReturn', action: 'retrieveMedicineDetails')}?voucherNo="+voucherNo,
            success: function (data, textStatus) {
                var gridData = data.gridModelMedicine;
                totalAmount = data.totalAmount;
                gridMedicineSellReturnInfo.setDataSource(new kendo.data.DataSource({data: gridData}));
                $("#footerSpan").text(formatCeilAmount(totalAmount));
                setButtonDisabled($('#btnNewService'), false);
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

    function initMedicineSellInfoGrid() {
        $("#gridMedicine").kendoGrid({
            dataSource: getBlankDataSource,
            height: 420,
            selectable: true,
            sortable: true,
            resizable: true,
            reorderable: true,
            pageable: false,
            editable: true,
            edit: function (e) {
                var input = e.container.find(".k-input");
                var value = input.val(),pre = input.val();
                $("[name='rtnQuantity']", e.container).focus(function () {
                    var input = $(this);
                    if(input.val()==0){
                        input.val('');
                    }
                });
                $("[name='rtnQuantity']", e.container).blur(function () {
                    var input = $(this);
                    var row = $(this).closest("tr");
                    var data = $("#gridMedicine").data("kendoGrid").dataItem(row);
                    value = input.val();

                    if (value > data.quantity) {
                        showError("Wrong quantity.");
                        data.set('rtnQuantity', 0);

                    }
                    else {
                        if(input.val()==''){
                            input.val(0);
                            data.set('rtnQuantity', 0);
                            var dirty = $(this).closest("tr").find(".k-dirty-cell");
                            dirty.removeClass("k-dirty-cell");
                        }
                        rtnAmount -= pre * data.unitPrice;
                        rtnAmount += value * data.unitPrice;
                        rtnAmount=Math.floor(rtnAmount)
                        data.set('rtnAmount', value * data.unitPrice);
                        $("#footerSpanRtn").text(formatAmount(rtnAmount));
                    }

                });
            },
            columns: [
                {
                    field: "medicineName",
                    title: "Medicine Name",
                    width: 100,
                    sortable: false,
                    editable:false,
                    filterable: false
                },
                {
                    field: "quantity",
                    title: "Quantity",
                    width: 50,
                    sortable: false,
                    filterable: false
                },
                {
                    field: "rtnQuantity",
                    title: "Rtn Qty",
                    width: 50,
                    sortable: false,
                    template: "<span style='float: left; width: 100%;" +
                    "font-size: large; background-color:gainsboro'><b>#=rtnQuantity#</b></div>",
                    filterable: false
                },
                {
                    field: "unitPriceTxt",
                    title: "Price/Unit",
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
                    footerTemplate:"<div style='text-align: right'>Total amount : <span id='footerSpan'>#=formatCeilAmount(0)#</span></div>"
                },
                {
                    field: "rtnAmount",
                    title: "Rtn Amount",
                    attributes: {style: setAlignRight()},
                    headerAttributes: {style: setAlignRight()},
                    template: "#=formatAmount(rtnAmount)#",
                    sortable: false,filterable: false,width: 50,
                    footerTemplate:"<div style='text-align: right'>Return amount : <span id='footerSpanRtn'>#=formatCeilAmount(0)#</span></div>"
                }
            ],
            filterable: {
                mode: "row"
            }
        });
        gridMedicineSellReturnInfo = $("#gridMedicine").data("kendoGrid");
        $('#gridMedicine  > .k-grid-content').height(390);
    }
    function resetForm(){
        window.history.back();
    }

</script>