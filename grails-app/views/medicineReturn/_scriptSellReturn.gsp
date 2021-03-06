
<script language="javascript">
    var gridMedicineSellReturnInfo, dataSource, totalAmount=0, totalRtnAmount= 0,dropDownReturnType;

    $(document).ready(function () {
        onLoadMedicineSellReturnPage();
        initMedicineSellInfoGrid();
    });
    function onLoadMedicineSellReturnPage() {
        $('#frmMedicineReturn').on('keypress', function(e) {
            return e.which !== 13;
        });
        initializeForm($("#frmMedicineReturn"), null);
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
        var formData = jQuery('#frmMedicineReturn').serializeArray();
        formData.push({name: 'gridModelMedicine', value: JSON.stringify(gridMedicineSellReturnInfo.dataSource.data())});
        formData.push({name: 'voucherNo', value: voucherNo});
        formData.push({name: 'returnTypeId', value: dropDownReturnType.value()});
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
        var url = "${createLink(controller:'medicineReturn', action: 'retrieveMedicineDetails')}?voucherNo="+voucherNo;
        populateGridKendo(gridMedicineSellReturnInfo, url);
        setButtonDisabled($('#btnNewService'), false);
    }
    function initDataSource() {
        dataSource = new kendo.data.DataSource({
            transport: {
                read: {
                    url: false,
                    dataType: "json",
                    type: "post"
                }
            },
            schema: {
                type: 'json',
                data: "gridMedicineReturn",
                model: {
                    fields: {
                        id: {type: "number"},
                        version: {type: "number"},
                        medicineName: {editable: false,type: "string"},
                        quantity: {editable: false,type: "number"},
                        rtnQuantity: {type: "number",validation:{min:0}},
                        unitPriceTxt: {editable: false,type: "string"},
                        amount: {editable: false,type: "number"},
                        rtnAmount: {type: "number"},
                        unitPrice: {editable: false,type: "number"},
                        totalAmount: {editable: false, type: "number"}
                    }
                },
                parse: function (data) {
                    checkIsErrorGridKendo(data);
                    totalAmount = data.totalAmount;
                    return data;
                }
            },
            serverPaging: true,
            serverFiltering: true,
            serverSorting: true
        });
    }
    function gridDataBound(e) {
        setFooter();
    }
    function setFooter() {
        $("#footerSpan").text(formatAmount(totalAmount));
    }
    function initMedicineSellInfoGrid() {
        initDataSource();
        $("#gridMedicineReturn").kendoGrid({
            dataSource: dataSource,
            height: 410,
            autoBind: false,
            selectable: true,
            sortable: true,
            resizable: true,
            reorderable: true,
            pageable: false,
            dataBound: gridDataBound,
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
                    var data = $("#gridMedicineReturn").data("kendoGrid").dataItem(row);
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

                        totalRtnAmount -= pre * data.unitPrice;
                        totalRtnAmount += value * data.unitPrice;
                        data.set('rtnAmount', value * data.unitPrice);
                        $("#footerSpanRtn").text(formatAmount(Math.floor(totalRtnAmount)));
                    }

                });
            },
            columns: [
                {
                    field: "medicineName",
                    title: "Medicine Name",
                    width: 100,
                    sortable: false,
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
                    attributes: {style: setAlignRight()},
                    headerAttributes: {style: setAlignRight()},
                    template: "<div style='float: left; width: 100%;" +
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
        gridMedicineSellReturnInfo = $("#gridMedicineReturn").data("kendoGrid");
        $('#gridMedicineReturn  > .k-grid-content').height(370);
    }
    function resetForm(){
        window.history.back();
    }

</script>