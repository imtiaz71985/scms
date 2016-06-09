<script type="text/x-kendo-template" id="gridToolbarKendoDr">
<ul id="menuGridKendoDr" class="kendoGridMenu">
    <li onclick="editMedicine();"><i class="fa fa-edit"></i>Edit</li>
    <li onclick="deleteMedicine();"><i class="fa fa-trash-o"></i>remove</li>
</ul>
</script>
<script language="javascript">
    var voucherNo,quantity,gridMedicineSellInfo, dataSource, medicineSellInfoModel, dropDownMedicine, medicineName, unitPrice = 0, totalAmount = 0;

    $(document).ready(function () {
        voucherNo = '${voucherNo}';
        $("#voucherNo").val(voucherNo);
        initMedicineSellInfoGrid();
        initObservable();
        gridMedicineSellInfo.setDataSource(new kendo.data.DataSource({data: ${gridModelMedicine}}));

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
        $('#gridMedicine  > .k-grid-content').height(285);
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
        var sellDate = $('#sellDate').val();
        var quantity = $('#quantity').val();
        var amount = $('#amount').val();

        // add data into grid;
        addToGrid(gridMedicineSellInfo, medicineId, sellDate, quantity, amount);
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
    function addToGrid(gridModel, medicineId, sellDate, quantity, amount) {
        var data = {
            medicineName: medicineName,
            medicineId: medicineId,
            sellDate: sellDate,
            quantity: quantity,
            amount: amount
        };

        var gridCount = gridModel.dataSource.data().length;
        if (gridCount > 0) {
            gridModel.dataSource.data().unshift(data);
        }
        else {
            var dsDr = new kendo.data.DataSource({data: [data]});
            gridModel.setDataSource(dsDr);
        }
        clearForm($("#frmMedicine"), $("#medicineId"));
        $("#voucherNo").val(voucherNo);
        totalAmount=parseFloat(totalAmount,10)+parseFloat(amount,10);
        $("#footerSpan").text(formatAmount(totalAmount));
        unitPrice = 0;
        $('#gridMedicine  > .k-grid-content').height(285);
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
                    field: "amount",
                    title: "Amount",
                    attributes: {style: setAlignRight()},
                    headerAttributes: {style: setAlignRight()},
                    template: "#=formatAmount(amount)#",
                    sortable: false,filterable: false,width: 50
                },
                {
                    field: "quantity",
                    title: "Quantity",
                    width: 50,
                    sortable: false,
                    filterable: false
                }
            ],
            filterable: {
                mode: "row"
            },
            toolbar: kendo.template($("#gridToolbarKendoDr").html())

        });
        gridMedicineSellInfo = $("#gridMedicine").data("kendoGrid");
        $("#menuGridKendoDr").kendoMenu();
        $('#gridMedicine  > .k-grid-content').height(285);
    }

    function initObservable() {
        medicineSellInfoModel = kendo.observable(
                {
                    medicineSell: {
                        id: "",
                        version: "",
                        medicineId: "",
                        genericName: "",
                        strength: "",
                        quantity: "",
                        amount: "",
                        sellDate: ""
                    }
                }
        );
        kendo.bind($("#application_top_panel"), medicineSellInfoModel);
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
        if(data.unit!=null){
            $("#unit").text(data.unit);
        }
        gridMedicineSellInfo.dataSource.remove(data);
        getOnlyMedicinePrice();
        var amount = $("#amount").val();
        totalAmount=parseFloat(totalAmount,10)-parseFloat(amount,10);
        $("#footerSpan").text('');
        $("#footerSpan").text(formatAmount(totalAmount));
        $('#gridMedicine  > .k-grid-content').height(285);
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
        $('#gridMedicine  > .k-grid-content').height(285);
    }
</script>