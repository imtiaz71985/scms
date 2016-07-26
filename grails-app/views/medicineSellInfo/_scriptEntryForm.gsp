<script type="text/x-kendo-template" id="gridToolbarKendoDr">
<ul id="menuGridKendoDr" class="kendoGridMenu">
    <li onclick="editMedicine();"><i class="fa fa-edit"></i>Edit</li>
    <li onclick="deleteMedicine();"><i class="fa fa-trash-o"></i>remove</li>
</ul>
</script>
<script language="javascript">
    var voucherNo,quantity,gridMedicineSellInfo, dataSource, dropDownMedicine,
            dropDownTokenId, medicineName, unitPrice = 0, totalAmount = 0, availableStock = 0;

    $(document).ready(function () {
        voucherNo = '${voucherNo}';
        $("#voucherNo").val(voucherNo);
        initMedicineSellInfoGrid();
        $('#quantity').kendoNumericTextBox({
            spin: function() {
                calculateTotalPrice();
            },
            min: 1,
            step:1,
            max: 999999999999.99,
            format: "#.##"

        });
        quantity = $("#quantity").data("kendoNumericTextBox");
        $("#frmMedicine").submit(function (e) {
            onSubmitForm();
        });
        defaultPageTile("Sale details", null);

    });

    function  resetForm(){
        window.history.back();
    }

    function executePreCondition() {
        var count = gridMedicineSellInfo.dataSource.total();
        if (count == 0) {
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
        var formData = jQuery('#frmMedicine').serializeArray();
        formData.push({name: 'gridModelMedicine', value: JSON.stringify(gridMedicineSellInfo.dataSource.data())});

        jQuery.ajax({
            type: 'post',
            data: formData,
            url: "${createLink(controller:'medicineSellInfo', action: 'create')}",
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
            clearForm($("#frmMedicine"), $('#medicineId'));
            var dsDr = new kendo.data.DataSource({data: []});
            gridMedicineSellInfo.setDataSource(dsDr);
            window.history.back();
        }
    }

    function addMedicineToGrid() {
        setButtonDisabled($('#addMedicine'), true);
        showLoadingSpinner(true);
        var medicineId = dropDownMedicine.value();
        if (executePreConForMedicine(medicineId) == false) {
            setButtonDisabled($('#addMedicine'), false);
            showLoadingSpinner(false);
            return false;
        }
        var quantity = $('#quantity').val();
        var amount = $('#amount').val();
        var unitPriceTxt = $('#unitPriceTxt').val();

        // add data into grid;
        addToGrid(gridMedicineSellInfo, medicineId, quantity, amount, unitPriceTxt);
        showLoadingSpinner(false);
        setButtonDisabled($('#addMedicine'), false);
        return false;
    }
    function executePreConForMedicine(medicineId) {
        if(medicineId==''){
            showError('Please select any medicine.');
            return false;
        }
        var quantity = $("#quantity").val();
        if(quantity==''){
            showError('Please insert medicine quantity.');
            return false;
        }
        if(quantity > availableStock){
            showError('Stock not available');
            return false;
        }
        if (checkDuplicateEntry(medicineId) == false) return false;
    }
    function checkDuplicateEntry(medicineId) {
        var success = true;
        gridMedicineSellInfo.items().each(function () {
            var dataItem = gridMedicineSellInfo.dataItem($(this));
            if (dataItem.medicineId == medicineId) {
                showError('Same value already exists');
                success = false;
            }
        });
        return success;
    }
    function addToGrid(gridModel, medicineId, quantity, amount, unitPriceTxt) {
        var data = {
            medicineName: medicineName,
            medicineId: medicineId,
            quantity: quantity,
            stock: availableStock,
            amount: amount,
            unitPriceTxt: unitPriceTxt
        };

        var gridCount = gridModel.dataSource.data().length;
        if (gridCount > 0) {
            gridModel.dataSource.data().unshift(data);
        } else {
            var dsDr = new kendo.data.DataSource({data: [data]});
            gridModel.setDataSource(dsDr);
        }
        totalAmount=parseFloat(totalAmount,10)+parseFloat(amount,10);
        $("#footerSpan").text(formatAmount(totalAmount));
        unitPrice = 0;
        dropDownMedicine.dataSource.filter("");
        var refNo = $("#refTokenNo").val();
        clearForm($("#frmMedicine"), $("#medicineId"));
        dropDownTokenId.value(refNo);
        availableStock = 0;
        $("#stockQty").text('');
        $("#voucherNo").val(voucherNo);
        $('#gridMedicine  > .k-grid-content').height(220);
        return false;
    }


    function initMedicineSellInfoGrid() {
        $("#gridMedicine").kendoGrid({
            dataSource: getBlankDataSource,
            height: getGridHeightKendo(),
            selectable: true,
            sortable: true,
            resizable: true,
            reorderable: true,
            pageable: false,
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
                    field: "unitPriceTxt",
                    title: "Unit Price",
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
                    footerTemplate:"<div style='text-align: right'>Total amount : <span id='footerSpan'>#=formatAmount(0)#</span></div>"
                }
            ],
            filterable: {
                mode: "row"
            },
            toolbar: kendo.template($("#gridToolbarKendoDr").html())

        });
        gridMedicineSellInfo = $("#gridMedicine").data("kendoGrid");
        $("#menuGridKendoDr").kendoMenu();
        $('#gridMedicine  > .k-grid-content').height(220);
    }

    function getMedicinePrice() {
        var medicineId = dropDownMedicine.value();
        if (medicineId == '') {
            $("#amount").val('');
            unitPrice = 0;
            return false;
        }
        showLoadingSpinner(true);
        var actionUrl = "${createLink(controller:'medicineSellInfo', action: 'retrieveMedicinePrice')}?medicineId=" + medicineId;
        jQuery.ajax({
            type: 'post',
            url: actionUrl,
            success: function (data, textStatus) {
                unitPrice = data.amount;
                quantity.value(1);
                medicineName = data.name;
                availableStock = data.stockQty;
                $("#stockQty").text(availableStock);
                var quantitya = $("#quantity").val();
                if (quantitya != '') {
                    $('#amount').val((data.amount * quantitya).toFixed(2));
                } else {
                    $('#amount').val(data.amount);
                }
                $('#unitPriceTxt').val(data.unitPriceTxt);
            },
            error: function (XMLHttpRequest, textStatus, errorThrown) {
            },
            complete: function (XMLHttpRequest, textStatus) {
                showLoadingSpinner(false);
            },
            dataType: 'json'
        });
    }
    function getOnlyMedicinePrice() {
        var medicineId = dropDownMedicine.value();
        showLoadingSpinner(true);
        var actionUrl = "${createLink(controller:'medicineSellInfo', action: 'retrieveMedicinePrice')}?medicineId=" + medicineId;
        jQuery.ajax({
            type: 'post',
            url: actionUrl,
            success: function (data, textStatus) {
                unitPrice = data.amount;
            },
            error: function (XMLHttpRequest, textStatus, errorThrown) {
            },
            complete: function (XMLHttpRequest, textStatus) {
                showLoadingSpinner(false);
            },
            dataType: 'json'
        });
    }
    function calculateTotalPrice() {
        var medicineId = dropDownMedicine.value();
        var quantity = $("#quantity").val();
        if (medicineId != '' && unitPrice != 0) {
            $("#amount").val((unitPrice * quantity).toFixed(2));
        } else {

        }
    }

    function getVoucherNo(){
        $.ajax({
            url: "${createLink(controller: 'medicineSellInfo', action:  'retrieveVoucherNo')}",
            success: function (data, textStatus) {
                voucherNo = data.voucherNo;
                $("#voucherNo").val(voucherNo);
            },
            error: function (XMLHttpRequest, textStatus, errorThrown) {
                afterAjaxError(XMLHttpRequest, textStatus)
            },
            complete: function (XMLHttpRequest, textStatus) {
                showLoadingSpinner(false);
            },
            dataType: 'json',
            type: 'post'
        });
    }
    function editMedicine(com, grid) {
        if (executeCommonPreConditionForSelectKendo(gridMedicineSellInfo, 'medicine') == false) {
            return;
        }
        var row = gridMedicineSellInfo.select();
        var data = gridMedicineSellInfo.dataItem(row);
        dropDownMedicine.value(data.medicineId);
        quantity.value(data.quantity);
        $("#amount").val(data.amount);
        $("#unitPriceTxt").val(data.unitPriceTxt);
        availableStock = data.stock;
        $("#stockQty").text(data.stock);
        gridMedicineSellInfo.dataSource.remove(data);
        getOnlyMedicinePrice();
        var amount = $("#amount").val();
        totalAmount=parseFloat(totalAmount,10)-parseFloat(amount,10);
        $("#footerSpan").text('');
        $("#footerSpan").text(formatAmount(totalAmount));
        $('#gridMedicine  > .k-grid-content').height(220);
    }
    function deleteMedicine(com, grid) {
        if (executeCommonPreConditionForSelectKendo(gridMedicineSellInfo, 'medicine') == false) {
            return;
        }
        var data = gridMedicineSellInfo.dataItem(gridMedicineSellInfo.select());
        totalAmount=parseFloat(totalAmount,10)-parseFloat(data.amount,10);
        gridMedicineSellInfo.dataSource.remove(data);
        $("#footerSpan").text('');
        $("#footerSpan").text(formatAmount(totalAmount));
        $('#gridMedicine  > .k-grid-content').height(220);
    }
</script>