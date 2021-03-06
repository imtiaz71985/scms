<script type="text/x-kendo-template" id="gridToolbar">
<ul id="menuGrid" class="kendoGridMenu">
    <sec:access url="/medicineInfo/create">
        <li onclick="showForm();"><i class="fa fa-plus-square-o"></i>New</li>
    </sec:access>
    <sec:access url="/medicineInfo/update">
        <li onclick="editForm();"><i class="fa fa-edit"></i>Edit</li>
    </sec:access>
    <sec:access url="/medicinePrice/show">
        <li onclick="navigatePriceForm();"><i class="fa fa-money"></i>Price</li>
    </sec:access>
   %{-- <sec:access url="/medicineInfo/delete">
        <li onclick="deleteForm();"><i class="fa fa-trash-o"></i>Delete</li>
    </sec:access>--}%
</ul>
</script>

<script language="javascript">
    var gridMedicine, dataSource, medicineInfoModel, subsidyPert, mrpPrice, boxSize,boxRate,warnQty,
            dropDownType, dropDownVendor;

    $(document).ready(function () {
        onLoadMedicineInfoPage();
        initMedicineInfoGrid();
        initObservable();
    });

    function onLoadMedicineInfoPage() {
        $('#subsidyPert').kendoNumericTextBox({
            min: 0,
            step: 1,
            max: 100,
            format: "####"

        });
        subsidyPert = $("#subsidyPert").data("kendoNumericTextBox");
        $('#mrpPrice').kendoNumericTextBox({
            min: 0,
            step: 1,
            max: 999999999999.99,
            format: "#.##"

        });
        mrpPrice = $("#mrpPrice").data("kendoNumericTextBox");

        $('#boxSize').kendoNumericTextBox({
            format: "#####",
            decimals: 0
        });
        boxSize = $("#boxSize").data("kendoNumericTextBox");
        $('#boxRate').kendoNumericTextBox({
            min: 0,
            step: 1,
            max: 999999999999.99,
            format: "#.##"

        });
        boxRate = $("#boxRate").data("kendoNumericTextBox");
        $('#warnQty').kendoNumericTextBox({
            min: 0,
            step: 1,
            max: 1000,
            format: "#####"

        });
        warnQty = $("#warnQty").data("kendoNumericTextBox");

        $("#medicineInfoRow").hide();
        // initialize form with kendo validator & bind onSubmit event
        initializeForm($("#medicineForm"), onSubmitMedicineInfoRole);
        // update page title
        defaultPageTile("Create medicine", null);
    }

    function showForm() {
        $("#medicineInfoRow").show();
        resetForm();
    }
    function executePreCondition() {
        if (!validateForm($("#medicineForm"))) {
            return false;
        }
        return true;
    }

    function onSubmitMedicineInfoRole() {
        if (executePreCondition() == false) {
            return false;
        }

        setButtonDisabled($('#create'), true);
        showLoadingSpinner(true);
        var actionUrl = null;
        if ($('#id').val().isEmpty()) {
            actionUrl = "${createLink(controller:'medicineInfo', action: 'create')}";
        } else {
            actionUrl = "${createLink(controller:'medicineInfo', action: 'update')}";
        }

        jQuery.ajax({
            type: 'post',
            data: jQuery("#medicineForm").serialize(),
            url: actionUrl,
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
                var newEntry = result.medicineInfo;
                if ($('#id').val().isEmpty() && newEntry != null) { // newly created
                    var gridData = gridMedicine.dataSource.data();
                    gridData.unshift(newEntry);
                } else if (newEntry != null) { // updated existing
                    var selectedRow = gridMedicine.select();
                    var allItems = gridMedicine.items();
                    var selectedIndex = allItems.index(selectedRow);
                    gridMedicine.removeRow(selectedRow);
                    gridMedicine.dataSource.insert(selectedIndex, newEntry);
                }
                resetForm();
                showSuccess(result.message);
            } catch (e) {
                // Do Nothing
            }
        }
    }

    function resetForm(hide) {
        clearForm($("#medicineForm"), $('#typeId'));
        initObservable();
        mrpPrice.readonly(false);
        $('#create').html("<span class='k-icon k-i-plus'></span>Create");
        if (hide) $("#medicineInfoRow").hide();
    }

    function initDataSource() {
        dataSource = new kendo.data.DataSource({
            transport: {
                read: {
                    url: "${createLink(controller: 'medicineInfo', action: 'list')}",
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
                        typeId: {type: "number"},
                        vendorId: {type: "number"},
                        type: {type: "string"},
                        genericName: {type: "string"},
                        brandName: {type: "string"},
                        medicineName: {type: "string"},
                        strength: {type: "string"},
                        unitType: {type: "string"},
                        subsidyPert: {type: "number"},
                        mrpPrice: {type: "number"},
                        boxSize: {type: "number"},
                        boxRate: {type: "number"},
                        warnQty: {type: "number"}
                    }
                },
                parse: function (data) {
                    checkIsErrorGridKendo(data);
                    return data;
                }
            },
            pageSize: getDefaultPageSize(),
            serverPaging: true,
            serverFiltering: true,
            serverSorting: true
        });
    }

    function initMedicineInfoGrid() {
        initDataSource();
        $("#gridMedicine").kendoGrid({
            dataSource: dataSource,
            height: getGridHeightKendo(),
            selectable: true,
            sortable: true,
            resizable: true,
            reorderable: true,
            dataBound: gridDataBound,
            pageable: {
                refresh: true,
                pageSizes: getDefaultPageSizes(),
                buttonCount: 4
            },
            columns: [
                {field: "type", title: "Type", width: 50, sortable: false, filterable: kendoCommonFilterable(97)},
                {
                    field: "genericName",
                    title: "Generic Name",
                    width: 50,
                    sortable: false,
                    filterable: kendoCommonFilterable(97)
                },
                {
                    field: "medicineName",
                    title: "Brand Name",
                    width: 70,
                    sortable: false,
                    filterable: kendoCommonFilterable(97)
                },
                {
                    field: "vendorName",
                    title: "Vendor Name",
                    width: 100,
                    sortable: false,
                    filterable: kendoCommonFilterable(97)
                },
                {
                    field: "subsidyPert", title: "Subsidy(%)", width: 40, sortable: false, filterable: false,
                    attributes: {style: setAlignRight()}, headerAttributes: {style: setAlignRight()},
                    template: "#=subsidyPert#"
                },
                {
                    field: "mrpPrice", title: "MRP Price", width: 40, sortable: false, filterable: false,
                    attributes: {style: setAlignRight()}, headerAttributes: {style: setAlignRight()},
                    template: "#=formatAmount(mrpPrice)#"
                },
                {
                    field: "unitPrice", title: "Unit Price", width: 40, sortable: false, filterable: false,
                    attributes: {style: setAlignRight()}, headerAttributes: {style: setAlignRight()},
                    template: "#=formatAmount(unitPrice)#"
                },
                {
                    field: "warnQty", title: "Warn Qty", width: 30, sortable: false, filterable: false,
                    attributes: {style: setAlignCenter()}, headerAttributes: {style: setAlignCenter()}
                },
                {field: "unitType", title: "Unit Type", width: 40, sortable: false, filterable: false}
            ],
            filterable: {
                mode: "row"
            },
            toolbar: kendo.template($("#gridToolbar").html())
        });
        gridMedicine = $("#gridMedicine").data("kendoGrid");
        $("#menuGrid").kendoMenu();
    }

    function initObservable() {
        medicineInfoModel = kendo.observable(
                {
                    medicineInfo: {
                        id: "",
                        version: "",
                        typeId: "",
                        vendorId: "",
                        type: "",
                        genericName: "",
                        brandName: "",
                        strength: "",
                        unitType: "",
                        subsidyPert: "",
                        mrpPrice: "",
                        boxSize: "",
                        boxRate: "",
                        warnQty: ""
                    }
                }
        );
        kendo.bind($("#application_top_panel"), medicineInfoModel);
    }

    function deleteForm() {
        if (executeCommonPreConditionForSelectKendo(gridMedicine, 'Medicine') == false) {
            return;
        }
        var msg = 'Are you sure you want to delete the selected Medicine?',
                url = "${createLink(controller: 'medicineInfo', action:  'delete')}";
        confirmDelete(msg, url, gridMedicine);
    }

    function editForm() {
        if (executeCommonPreConditionForSelectKendo(gridMedicine, 'medicine') == false) {
            return;
        }
        $("#medicineInfoRow").show();
        mrpPrice.readonly();
        var medicineInfo = getSelectedObjectFromGridKendo(gridMedicine);
        showSecRole(medicineInfo);
    }

    function showSecRole(medicineInfo) {
        medicineInfoModel.set('medicineInfo', medicineInfo);
        $('#create').html("<span class='k-icon k-i-plus'></span>Update");
    }

    function navigatePriceForm() {
        if (executeCommonPreConditionForSelectKendo(gridMedicine, 'medicine') == false) {
            return;
        }
        showLoadingSpinner(true);
        var medicineId = getSelectedIdFromGridKendo(gridMedicine);
        var loc = "${createLink(controller: 'medicinePrice', action: 'show')}?medicineId=" + medicineId;
        router.navigate(formatLink(loc));
        return false;
    }

</script>
