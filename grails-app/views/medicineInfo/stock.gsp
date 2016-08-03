<div class="container-fluid">
    <div class="row">
        <div id="application_top_panel" class="panel panel-primary">
            <div class="panel-heading">
                <div class="panel-title">
                    Inventory
                </div>
            </div>

            <g:form name='medicineStockForm' id='medicineStockForm' class="form-horizontal form-widgets" role="form">
                <div class="panel-body">
                    <div class="form-group">
                        <label class="col-md-1 control-label label-optional" for="hospitalCode">Hospital:</label>

                        <div class="col-md-3">
                            <app:dropDownHospital
                                    data_model_name="dropDownHospitalCode"
                                    tabindex="1"
                                    class="kendo-drop-down"
                                    show_hints="true"
                                    hints_text="ALL"
                                    is_clinic="true"
                                    id="hospitalCode"
                                    name="hospitalCode">
                            </app:dropDownHospital>
                        </div>
                    </div>

                </div>

                <div class="panel-footer">
                    <button id="create" name="create" type="submit" data-role="button"
                            class="k-button k-button-icontext"
                            role="button" tabindex="2"
                            aria-disabled="false"><span class="k-icon k-i-search"></span>View Result
                    </button>
                </div>
            </g:form>
        </div>
    </div>

    <div class="row">
        <div id="gridMedicineStock"></div>
    </div>
</div>
<script language="javascript">
    var gridMedicineStock, dataSource, dropDownHospitalCode;

    $(document).ready(function () {
        onLoadMedicineInfoPage();
        initMedicineInfoGrid();
        loadGridValue();
    });

    function onLoadMedicineInfoPage() {
        if(!${isAdmin}){
            dropDownHospitalCode.value('${hospitalCode}');
            dropDownHospitalCode.readonly(true);
        }
        initializeForm($("#medicineStockForm"), onSubmitForm);
        // update page title
        defaultPageTile("Medicine Stock", null);
    }
    function executePreCondition() {
        if (!validateForm($("#medicineStockForm"))) {
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
        var params = "?hospitalCode=" + hospitalCode;
        var url = "${createLink(controller:'medicineInfo', action: 'listMedicineStock')}" + params;
        populateGridKendo(gridMedicineStock, url);
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
                        typeId: {type: "number"},
                        vendorId: {type: "number"},
                        type: {type: "string"},
                        genericName: {type: "string"},
                        brandName: {type: "string"},
                        medicineName: {type: "string"},
                        strength: {type: "string"},
                        unitType: {type: "string"},
                        unitPrice: {type: "number"},
                        mrpPrice: {type: "number"},
                        stockQty: {type: "number"},
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
        $("#gridMedicineStock").kendoGrid({
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
                    width: 80,
                    sortable: false,
                    filterable: kendoCommonFilterable(97)
                },
                {
                    field: "stockQty", title: "Current Stock", width: 40, sortable: false, filterable: false,
                    attributes: {style: setAlignCenter()}, headerAttributes: {style: setAlignCenter()},
                    template: "<span style='float: left; width: 100%; background-color:lightgray'>#=formatStock(stockQty,warnQty)#</div>"
                },
                {
                    field: "unitPrice", title: "Unit Price", width: 35, sortable: false, filterable: false,
                    attributes: {style: setAlignRight()}, headerAttributes: {style: setAlignRight()},
                    template: "#=formatAmount(unitPrice)#"
                },
                {
                    field: "mrpPrice", title: "MRP Price", width: 35, sortable: false, filterable: false,
                    attributes: {style: setAlignRight()}, headerAttributes: {style: setAlignRight()},
                    template: "#=formatAmount(mrpPrice)#"
                },
                {field: "unitType", title: "Unit Type", width: 30, sortable: false, filterable: false}
            ],
            filterable: {
                mode: "row"
            }
        });
        gridMedicineStock = $("#gridMedicineStock").data("kendoGrid");
    }
    function formatStock(stockQty,warnQty){
        if(stockQty==0) return "<b style='color:red;font-size: larger;'>"+ stockQty+"</b>";
        if(stockQty<warnQty) return "<b style='color:#ffff00;font-size: larger;'>"+ stockQty+"</b>";
        return "<b style='color:#000000;font-size: larger;'>"+ stockQty+"</b>";
    }
    
</script>
