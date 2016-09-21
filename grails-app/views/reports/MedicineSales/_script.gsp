
<script language="javascript">
    var gridMedicineDetails, dataSource, dropDownHospitalCode;

    $(document).ready(function () {
        onLoadMedicineInfoPage();
        initMedicineInfoGrid();

    });

    function onLoadMedicineInfoPage() {
        if(!${isAdmin}){
            dropDownHospitalCode.value('${hospitalCode}');
            dropDownHospitalCode.readonly(true);
        }
        initializeForm($("#detailsForm"), onSubmitForm);
        // update page title
        defaultPageTile("Medicine Wise Sales", null);
    }
    function executePreCondition() {
        if (!validateForm($("#detailsForm"))) {
            return false;
        }
        return true;
    }

    function onSubmitForm() {
        if (executePreCondition() == false) {
            return false;
        }
        loadGridValue();
        return false;
    }
    function loadGridValue() {
        var hospitalCode = dropDownHospitalCode.value();
        showLoadingSpinner(true);
        var params = "?hospitalCode=" + hospitalCode+"&fromDate="+$("#fromDateTxt").val()+"&toDate="+$("#toDateTxt").val();
        var url = "${createLink(controller:'reports', action: 'listOfMedicineWiseSalesWithStock')}" + params;
        populateGridKendo(gridMedicineDetails, url);
        showLoadingSpinner(false);
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
                data: "list", total: "count",
                model: {
                    fields: {
                        id: {type: "number"},
                        version: {type: "number"},
                        type: {type: "string"},
                        genericName: {type: "string"},
                        brandName: {type: "string"},
                        medicineName: {type: "string"},
                        unitType: {type: "string"},
                        unitPrice: {type: "number"},
                        mrpPrice: {type: "number"},
                        stockQty: {type: "number"},
                        saleQty: {type: "number"},
                        saleAmt: {type: "number"},
                        returnQty: {type: "number"},
                        returnAmt: {type: "number"}
                    }
                },
                parse: function (data) {
                    checkIsErrorGridKendo(data);
                    return data;
                }
            },
            sort:{field:"brandName",dir:"asc"},
            pageSize: getDefaultPageSize(),
            serverPaging: true,
            serverFiltering: true,
            serverSorting: true
        });
    }

    function initMedicineInfoGrid() {
        initDataSource();
        $("#gridDetails").kendoGrid({
            dataSource: dataSource,
            autoBind: false,
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
                {field: "type", title: "Type", width: 40, sortable: false, filterable: kendoCommonFilterable(97)},
                {
                    field: "genericName",
                    title: "Generic Name",
                    width: 50,
                    sortable: false,
                    filterable: kendoCommonFilterable(97)
                },                {
                    field: "medicineName",
                    title: "Brand Name",
                    width: 70,
                    sortable: false,
                    filterable: kendoCommonFilterable(97)
                },
                {
                    field: "vendorName",
                    title: "Vendor Name",
                    width: 60,
                    sortable: false,
                    filterable: kendoCommonFilterable(97)
                },
                {
                    field: "stockQty", title: "Current Stock", width: 50, sortable: false, filterable: false,
                    attributes: {style: setAlignCenter()}, headerAttributes: {style: setAlignCenter()},
                    template: "<span>#: stockQty #</span>"
                },
                {
                    field: "unitPrice", title: "Unit Price", width: 35, sortable: false, filterable: false,
                    attributes: {style: setAlignRight()}, headerAttributes: {style: setAlignRight()},
                    template: "#=formatAmount(unitPrice)#"
                },
                {field: "unitType", title: "Unit Type", width: 35, sortable: false, filterable: false
                },
                {
                    field: "saleQty", title: "Sale Qty", width: 40, sortable: false, filterable: false,
                    attributes: {style: setAlignCenter()}, headerAttributes: {style: setAlignCenter()}
                },
                {
                    field: "saleAmt", title: "Sale Amt", width: 40, sortable: false, filterable: false,
                    attributes: {style: setAlignCenter()}, headerAttributes: {style: setAlignCenter()}
                },
                {
                    field: "returnQty", title: "Return Qty", width: 40, sortable: false, filterable: false,
                    attributes: {style: setAlignCenter()}, headerAttributes: {style: setAlignCenter()}
                },
                {
                    field: "returnAmt", title: "Return Amt", width: 40, sortable: false, filterable: false,
                    attributes: {style: setAlignCenter()}, headerAttributes: {style: setAlignCenter()}
                }
            ],
            filterable: {
                mode: "row"
            }
        });
        gridMedicineDetails = $("#gridDetails").data("kendoGrid");
    }

</script>
