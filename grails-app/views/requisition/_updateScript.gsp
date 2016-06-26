<script type="text/x-kendo-template" id="gridToolbarKendoDr">
<ul id="menuGridKendoDr" class="kendoGridMenu">
    <li onclick="editMedicine();"><i class="fa fa-edit"></i>Edit</li>
    <li onclick="deleteMedicine();"><i class="fa fa-trash-o"></i>remove</li>
</ul>
</script>
<script language="javascript">
    var requisitionNo,quantity,gridRequisition, dataSource, requisitionModel, dropDownMedicine, medicineName, unitPrice = 0, totalAmount = 0;

    $(document).ready(function () {
        requisitionNo = '${requisitionNo}';
        totalAmount = ${totalAmount};
        $("#requisitionNo").val(requisitionNo);
        initRequisitionGrid();
        initObservable();
        gridRequisition.setDataSource(new kendo.data.DataSource({data: ${gridModelMedicine}}));
        $("#footerSpan").text(formatAmount(totalAmount));

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
        $('#gridMedicine  > .k-grid-content').height(285);
        defaultPageTile("Update requisition details", null);

    });
    function  resetForm(){
        window.history.back();
    }
    function executePreCondition() {
        var count = gridRequisition.dataSource.total();
        if (count == 0) {
            showError('No data found to update');
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
        var formData=jQuery('#frmRequisitionUpt').serializeArray();
        formData.push({name: 'gridModelMedicine', value: JSON.stringify(gridRequisition.dataSource.data())});

        jQuery.ajax({
            type: 'post',
            data: formData,
            url: "${createLink(controller:'requisition', action: 'update')}",
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
            clearForm($("#frmRequisitionUpt"), $('#medicineId'));
            var dsDr = new kendo.data.DataSource({data: []});
            gridRequisition.setDataSource(dsDr);
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
        addToGrid(gridRequisition, medicineId, quantity, amount);
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
        gridRequisition.items().each(function () {
            var dataItem = gridRequisition.dataItem($(this));
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
        }
        else {
            var dsDr = new kendo.data.DataSource({data: [data]});
            gridModel.setDataSource(dsDr);
        }
        clearForm($("#frmRequisitionUpt"), $("#medicineId"));
        $("#requisitionNo").val(requisitionNo);
        totalAmount=parseFloat(totalAmount,10)+parseFloat(amount,10);
        $("#footerSpan").text(formatAmount(totalAmount));
        unitPrice = 0;
        $('#gridMedicine  > .k-grid-content').height(285);
        return false;
    }


    function initRequisitionGrid() {
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
                    field: "approvedQty",
                    title: "Approve Quantity",
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
                },
                {
                    field: "approveAmount",
                    title: "Approve Amount",
                    attributes: {style: setAlignRight()},
                    headerAttributes: {style: setAlignRight()},
                    template: "#=formatAmount(approveAmount)#",
                    sortable: false,filterable: false,width: 50,
                    footerTemplate:"<div style='text-align: right'>Total amount : <span id='footerSpan'>#=formatAmount(0)#</span></div>"
                }
            ],
            filterable: {
                mode: "row"
            },
            toolbar: kendo.template($("#gridToolbarKendoDr").html())

        });
        gridRequisition = $("#gridMedicine").data("kendoGrid");
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
                medicineName = data.name;
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
        if (executeCommonPreConditionForSelectKendo(gridRequisition, 'medicine') == false) {
            return;
        }
        var row = gridRequisition.select();
        var data = gridRequisition.dataItem(row);
        dropDownMedicine.value(data.medicineId);
        quantity.value(data.quantity);
        $("#amount").val(data.amount);
        if(data.unit!=null){
            $("#unit").text(data.unit);
        }
        gridRequisition.dataSource.remove(data);
        getOnlyMedicinePrice();
        var amount = $("#amount").val();
        totalAmount=parseFloat(totalAmount,10)-parseFloat(amount,10);
        $("#footerSpan").text('');
        $("#footerSpan").text(formatAmount(totalAmount));
        $('#gridMedicine  > .k-grid-content').height(285);
    }
    function deleteMedicine(com, grid) {
        if (executeCommonPreConditionForSelectKendo(gridRequisition, 'medicine') == false) {
            return;
        }
        var data = gridRequisition.dataItem(gridRequisition.select());
        totalAmount=parseFloat(totalAmount,10)-parseFloat(data.amount,10);
        gridRequisition.dataSource.remove(data);
        $("#footerSpan").text('');
        $("#footerSpan").text(formatAmount(totalAmount));
        $('#gridMedicine  > .k-grid-content').height(285);
    }
</script>