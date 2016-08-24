<script type="text/x-kendo-template" id="gridToolbarKendoDr">
<ul id="menuGridKendoDr" class="kendoGridMenu">
    <li onclick="editMedicine();"><i class="fa fa-edit"></i>Edit</li>
    <li onclick="deleteMedicine();"><i class="fa fa-trash-o"></i>remove</li>
</ul>
</script>
<script language="javascript">
    var voucherNo,quantity,gridMedicineSellInfo, dataSource, dropDownMedicine,
            medicineName, unitPrice = 0, totalAmount = 0, availableStock = 0;

    $(document).ready(function () {
        voucherNo = '${voucherNo}';
        totalAmount = ${totalAmount};
        $("#voucherNo").val(voucherNo);
        initMedicineSellInfoGrid();
        gridMedicineSellInfo.setDataSource(new kendo.data.DataSource({data: ${gridModelMedicine}}));
        $("#footerSpan").text(formatCeilAmount(totalAmount));

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
            onSubmitForm(e);
        });
        $('#gridMedicine  > .k-grid-content').height(275);
        defaultPageTile("Sale details", "medicineSellInfo/show");

    });
    function  resetForm(){
        window.history.back();
    }
    function executePreCondition(e) {
        e.preventDefault();
        var count = gridMedicineSellInfo.dataSource.total();
        if (count == 0) {
            return false;
        }
        return true;
    }
    function onSubmitForm(e) {
        if (executePreCondition(e) == false) {
            return false;
        }
        setButtonDisabled($('#create'), true);
        showLoadingSpinner(true);
        var formData=jQuery('#frmMedicine').serializeArray();
        formData.push({name: 'gridModelMedicine', value: JSON.stringify(gridMedicineSellInfo.dataSource.data())});

        jQuery.ajax({
            type: 'post',
            data: formData,
            url: "${createLink(controller:'medicineSellInfo', action: 'update')}",
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
            clearForm($("#frmMedicine"), $('#medicineId'));
            var dsDr = new kendo.data.DataSource({data: []});
            gridMedicineSellInfo.setDataSource(dsDr);
            $("#unit").text('');
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
            stock: availableStock,
            quantity: quantity,
            amount: amount,
            unitPriceTxt: unitPriceTxt
        };

        var gridCount = gridModel.dataSource.data().length;
        if (gridCount > 0) {
            gridModel.dataSource.data().unshift(data);
        }
        else {
            var dsDr = new kendo.data.DataSource({data: [data]});
            gridModel.setDataSource(dsDr);
        }
        dropDownMedicine.dataSource.filter("");
        clearForm($("#frmMedicine"), $("#medicineId"));
        availableStock = 0;
        $("#stockQty").text('');
        $("#voucherNo").val(voucherNo);
        totalAmount=parseFloat(totalAmount,10)+parseFloat(amount,10);
        $("#footerSpan").text(formatCeilAmount(totalAmount));
        unitPrice = 0;
        $('#gridMedicine  > .k-grid-content').height(275);
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
                }
            ],
            filterable: {
                mode: "row"
            },
            toolbar: kendo.template($("#gridToolbarKendoDr").html())

        });
        gridMedicineSellInfo = $("#gridMedicine").data("kendoGrid");
        $("#menuGridKendoDr").kendoMenu();
        $('#gridMedicine  > .k-grid-content').height(275);
    }

    function getMedicinePrice() {
        var medicineId = dropDownMedicine.value();
        if (medicineId == '') {
            $("#amount").val('');
            $("#unit").text('');
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
                if(data.unit!=null){
                    $("#unit").text(data.unit);
                }
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
        medicineName = data.medicineName;
        availableStock = parseInt(data.stock, 10);
        $("#stockQty").text(availableStock);
        if(data.unit!=null){
            $("#unit").text(data.unit);
        }
        gridMedicineSellInfo.dataSource.remove(data);
        getOnlyMedicinePrice();
        var amount = $("#amount").val();
        totalAmount = parseFloat(totalAmount,10)-parseFloat(amount,10);
        $("#footerSpan").text('');
        $("#footerSpan").text(formatCeilAmount(totalAmount));
        $('#gridMedicine  > .k-grid-content').height(275);
    }
    function deleteMedicine(com, grid) {
        if (executeCommonPreConditionForSelectKendo(gridMedicineSellInfo, 'medicine') == false) {
            return;
        }
        var data = gridMedicineSellInfo.dataItem(gridMedicineSellInfo.select());
        totalAmount=parseFloat(totalAmount,10)-parseFloat(data.amount,10);
        gridMedicineSellInfo.dataSource.remove(data);
        $("#footerSpan").text('');
        $("#footerSpan").text(formatCeilAmount(totalAmount));
        $('#gridMedicine  > .k-grid-content').height(275);
    }
</script>