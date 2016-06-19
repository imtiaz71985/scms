<script language="javascript">
    var gridMedicinePrice, dataSource, medicineId, price,name;

    $(document).ready(function () {
        onLoadMedicinePricePage();
    });

    function onLoadMedicinePricePage() {
        var currentDate = moment().format('DD/MM/YYYY');
        medicineId = ${medicineId};
        name = '${name}';
        $('#medicineId').val(medicineId);
        $('#name').val(name);
        $('#price').kendoNumericTextBox({
            min: 0,
            step:1,
            max: 999999999999.99,
            format: "#.##"

        });
        price = $("#price").data("kendoNumericTextBox");

        $("#start").kendoDateTimePicker({
            timeFormat: "HH:mm:ss",
            format: "dd/MM/yyyy HH:mm:ss",
            parseFormats: ["yyyy-MM-dd hh:mm:ss"]
        });
        $("#start").kendoMaskedTextBox({mask: "00/00/0000 00:00:00"});

        initMedicinePriceGrid();
        // initialize form with kendo validator & bind onSubmit event
        initializeForm($("#medicinePriceForm"), onSubmitPrice);
        // update page title
        defaultPageTile("Medicine Price", "medicineInfo/show");
    }

    function executePreCondition() {
        if($("#price").val()==''){
            showError('Please input medicine price.');
            return false;
        }
        return true;
    }

    function onSubmitPrice() {
        if (executePreCondition() == false) {
            return false;
        }
        setButtonDisabled($('#create'), true);
        showLoadingSpinner(true);

        jQuery.ajax({
            type: 'post',
            data: jQuery("#medicinePriceForm").serialize(),
            url: "${createLink(controller:'medicinePrice', action: 'create')}",
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
                gridMedicinePrice.dataSource.read();
                resetForm();
                showSuccess(result.message);
            } catch (e) {
                // Do Nothing
            }
        }
    }

    function resetForm() {
        clearForm($("#medicinePriceForm"), $('#price'));
        $('#medicineId').val(medicineId);
        $('#name').val(name);
    }

    function initDataSource() {
        dataSource = new kendo.data.DataSource({
            transport: {
                read: {
                    url: "${createLink(controller: 'medicinePrice', action: 'list')}",
                    data: {medicineId: medicineId},
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
                        price: {type: "number"},
                        isActive: {type: "boolean"},
                        start: {type: "date"},
                        end: {type: "date"}
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

    function initMedicinePriceGrid() {
        initDataSource();
        $("#gridMedicinePrice").kendoGrid({
            dataSource: dataSource,
            height: getGridHeightKendo(),
            selectable: true,
            sortable: true,
            resizable: true,
            reorderable: true,
            pageable: {
                refresh: true,
                pageSizes: getDefaultPageSizes(),
                buttonCount: 4
            },
            columns: [
                {
                    field: "price",title: "Price", width: 50,
                    attributes: {style: setAlignRight()},headerAttributes: {style: setAlignRight()},
                    template: "#=formatAmount(price)#",sortable: false,filterable: false
                },
                {
                    field: "start", title: "From Date", width: 100, sortable: false,filterable: false,
                    attributes: {style: setAlignCenter()}, headerAttributes: {style: setAlignCenter()},
                    template: "#=kendo.toString(kendo.parseDate(start, 'yyyy-MM-dd HH:mm:ss'), 'dd-MM-yyyy hh:mm:ss tt')#"
                },
                {
                    field: "end", title: "To Date", width: 100, sortable: false,filterable: false,
                    attributes: {style: setAlignCenter()}, headerAttributes: {style: setAlignCenter()},
                    template: "#=end!=null?kendo.toString(kendo.parseDate(end, 'yyyy-MM-dd HH:mm:ss'), 'dd-MM-yyyy hh:mm:ss tt'):''#"
                },
                {
                    field: "isActive", title: "Is Current", width: 50, sortable: false,filterable: false,
                    attributes: {style: setAlignCenter()}, headerAttributes: {style: setAlignCenter()},
                    template: "#=isActive?'YES':'NO'#"
                }
            ],
            filterable: {
                mode: "row"
            }
        });
        gridMedicinePrice = $("#gridMedicinePrice").data("kendoGrid");
    }

</script>
