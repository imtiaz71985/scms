<script type="text/x-kendo-template" id="gridToolbarKendoDr">
<ul id="menuGridKendoDr" class="kendoGridMenu">
    <li onclick="editMedicine();"><i class="fa fa-edit"></i>Edit</li>
    <li onclick="deleteMedicine();"><i class="fa fa-trash-o"></i>remove</li>
</ul>
</script>
<script language="javascript">
    var frmRequisition,quantity,gridMedicineRequisition, dataSource, requisitionModel, dropDownMedicine,
            requisitionNo, medicineName, unitPrice = 0, totalAmount = 0;

    $(document).ready(function () {
        requisitionNo = '${requisitionNo}';
        $("#requisitionNo").val(requisitionNo);
        initMedicineRequisitionGrid();
        initObservable();
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
            url: "${createLink(controller:'requisition', action: 'create')}",
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
            clearForm($("#frmRequisition"), $('#medicineId'));
            var dsDr = new kendo.data.DataSource({data: []});
            gridMedicineRequisition.setDataSource(dsDr);
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

        // add data into grid;
        addToGrid(gridMedicineRequisition, medicineId, quantity, amount);
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
        gridMedicineRequisition.items().each(function () {
            var dataItem = gridMedicineRequisition.dataItem($(this));
            if (dataItem.medicineId == medicineId) {
                showError('Same value already exists');
                success = false;
            }
        });
        return success;
    }
    function addToGrid(gridModel, medicineId, quantity, amount) {
        var data = {
            medicineName: medicineName,
            medicineId: medicineId,
            quantity: quantity,
            amount: amount
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
        clearForm($("#frmRequisition"), $("#medicineId"));
        $("#requisitionNo").val(requisitionNo);
        $('#gridMedicine  > .k-grid-content').height(285);
        return false;
    }


    function initMedicineRequisitionGrid() {
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
        gridMedicineRequisition = $("#gridMedicine").data("kendoGrid");
        $("#menuGridKendoDr").kendoMenu();
        $('#gridMedicine  > .k-grid-content').height(285);
    }

    function initObservable() {
        requisitionModel = kendo.observable(
                {
                    requisition: {
                        id: "",
                        version: "",
                        medicineId: "",
                        genericName: "",
                        strength: "",
                        quantity: "",
                        amount: ""
                    }
                }
        );
        kendo.bind($("#application_top_panel"), requisitionModel);
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
                quantity.value(1);
                if(data.unit!=null){
                    $("#unit").text(data.unit);
                }
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

    function getRequisitionNo(){
        $.ajax({
            url: "${createLink(controller: 'requisition', action:  'retrieveRequisitionNo')}",
            success: function (data, textStatus) {
                requisitionNo = data.requisitionNo;
                $("#requisitionNo").val(requisitionNo);
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
        if (executeCommonPreConditionForSelectKendo(gridMedicineRequisition, 'medicine') == false) {
            return;
        }
        var row = gridMedicineRequisition.select();
        var data = gridMedicineRequisition.dataItem(row);
        dropDownMedicine.value(data.medicineId);
        quantity.value(data.quantity);
        $("#amount").val(data.amount);
        if(data.unit!=null){
            $("#unit").text(data.unit);
        }
        gridMedicineRequisition.dataSource.remove(data);
        getOnlyMedicinePrice();
        var amount = $("#amount").val();
        totalAmount=parseFloat(totalAmount,10)-parseFloat(amount,10);
        $("#footerSpan").text('');
        $("#footerSpan").text(formatAmount(totalAmount));
        $('#gridMedicine  > .k-grid-content').height(285);
    }
    function deleteMedicine(com, grid) {
        if (executeCommonPreConditionForSelectKendo(gridMedicineRequisition, 'medicine') == false) {
            return;
        }
        var data = gridMedicineRequisition.dataItem(gridMedicineRequisition.select());
        totalAmount=parseFloat(totalAmount,10)-parseFloat(data.amount,10);
        gridMedicineRequisition.dataSource.remove(data);
        $("#footerSpan").text('');
        $("#footerSpan").text(formatAmount(totalAmount));
        $('#gridMedicine  > .k-grid-content').height(285);
    }
</script>