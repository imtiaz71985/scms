<div class="container-fluid">
    <div class="row">
        <div id="gridMedicineStock"></div>
    </div>
</div>
<script language="javascript">
    var gridMedicineStock, dataSource;

    $(document).ready(function () {
        onLoadMedicineInfoPage();
        initMedicineInfoGrid();
    });

    function onLoadMedicineInfoPage() {
        // update page title
        defaultPageTile("Medicine Stock", null);
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
                        unitPrice: {type: "number"},
                        mrpPrice: {type: "number"},
                        stockQty: {type: "number"}
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
                    title: "Medicine Name",
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
                    template: "<span style='float: left; width: 100%; background-color:lightgray'>#=stockQty#</div>"
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
    
</script>
