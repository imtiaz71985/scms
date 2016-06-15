<script type="text/x-kendo-template" id="gridToolbar">
<ul id="menuGrid" class="kendoGridMenu">
    <sec:access url="/calendar/update">
        <li onclick="editCalendar();"><i class="fa fa-edit"></i>Edit</li>
    </sec:access>
    <sec:access url="/calendar/newYearRecords">
        <li onclick="newYearEntry();"><i class="fa fa-calendar-plus-o"></i>New Calendar Year</li>
    </sec:access>
</ul>
</script>

<script language="javascript">
    var gridCalendar, dataSource, calendarModel;

    $(document).ready(function () {
        onLoadCalendarPage();
        initCalendarGrid();
        initObservable();
        loadGridValue();
    });

    function onLoadCalendarPage() {
        $('#calYearModal').kendoDatePicker({
            format: "yyyy",
            parseFormats: ["yyyy"],
            depth: "decade",
            start: "decade"
        });
        $('#calenderYear').kendoDatePicker({
            format: "yyyy",
            parseFormats: ["yyyy"],
            depth: "decade",
            start: "decade",
            change: onChange
        });
        var currentYear = moment().format('YYYY');
        $('#calenderYear').val(currentYear);
        $(".k-datepicker input").prop("readonly", true);
        // initialize form with kendo validator & bind onSubmit event
        initializeForm($("#calendarForm"), onSubmitCalendar);
        // update page title
        defaultPageTile("Official calendar","calendar/show");
    }

    function loadGridValue(){
        var currentYear = $('#calenderYear').val();
        showLoadingSpinner(true);
        var url = "${createLink(controller:'calendar', action: 'list')}?currentYear=" + currentYear;
        populateGridKendo(gridCalendar, url);
        showLoadingSpinner(false);
    }

    function onChange(){
        var currentYear = $('#calenderYear').val();
        var params = "?currentYear=" + currentYear;
        var url = "${createLink(controller:'calendar', action: 'list')}" + params;
        populateGridKendo(gridCalendar, url);
    }

    function executePreCondition() {
        if (!validateForm($("#calendarForm"))) {
            return false;
        }
        return true;
    }

    function onSubmitCalendar() {
        if (executePreCondition() == false) {
            return false;
        }

        setButtonDisabled($('#create'), true);
        showLoadingSpinner(true);

        jQuery.ajax({
            type: 'post',
            data: jQuery('#calendarForm').serializeArray(),
            url: "${createLink(controller:'calendar', action: 'update')}",
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
                var newEntry = result.calendar;
                var selectedRow = gridCalendar.select();
                var allItems = gridCalendar.items();
                var selectedIndex = allItems.index(selectedRow);
                gridCalendar.removeRow(selectedRow);
                gridCalendar.dataSource.insert(selectedIndex, newEntry);
                resetForm();
                showSuccess(result.message);
            } catch (e) {
                // Do Nothing
            }
        }
    }

    function resetForm() {
        clearForm($("#calendarForm"), $('#name'));
        initObservable();
    }
    function dataBoundGrid(e) {
        var grid = e.sender;
        var data = grid.dataSource.data();
        $.each(data, function (i, row) {
            var str = row.dateField;
            var currentDate = moment().format('YYYY-MM-DD');
            if (str==currentDate) {
                var sel = $('tr[data-uid="' + row.uid + '"] ');
                grid.select(sel);
            }
            if(row.isHoliday){
//                $('tr[data-uid="' + row.uid + '"] ').css("background-color", "#fee7df");  //light red
                $('tr[data-uid="' + row.uid + '"] ').css("color", "red"); // light black
            }
        });
    }
    function initDataSource() {
        dataSource = new kendo.data.DataSource({
            transport: {
                read: {
                    url: "${createLink(controller: 'calendar', action: 'list')}",
                    dataType: "json",
                    type: "post"
                }
            },
            schema: {
                type: 'json',
                data: "list", total: "count",
                model: {
                    fields: {
                        id: { type: "number" },
                        version: { type: "number" },
                        dateField: { type: "date" },
                        holidayStatus: { type: "string" },
                        isHoliday: { type: "boolean" }
                    }
                },
                parse: function (data) {
                    checkIsErrorGridKendo(data);
                    return data;
                }
            },
            sort: [{field: 'dateField', dir: 'asc'}],
            pageSize: getDefaultPageSize(),
            serverPaging: true,
            serverFiltering: true,
            serverSorting: true
        });
    }

    function initCalendarGrid() {
        initDataSource();
        $("#gridCalendar").kendoGrid({
            dataSource: dataSource,
            autoBind    : false,
            height: getGridHeightKendo(),
            dataBound   : dataBoundGrid,
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
                {field: "dateField", title: "Calendar Date", width: 80, sortable: false,
                    filterable: {cell: {template: formatFilterableDate}},
                    template: "#=kendo.toString(kendo.parseDate(dateField, 'yyyy-MM-dd'), 'dd-MMMM-yyyy (dddd)')#"},
                {field: "holidayStatus", title: "Status", width: 80, sortable: false, filterable: false}
            ],
            filterable: {
                mode: "row"
            },
            toolbar: kendo.template($("#gridToolbar").html())
        });
        gridCalendar = $("#gridCalendar").data("kendoGrid");
        $("#menuGrid").kendoMenu();
    }

    function initObservable() {
        calendarModel = kendo.observable(
                {
                    calendar: {
                        id: "",
                        version: "",
                        dateField: "",
                        holidayStatus: "",
                        isHoliday: ""
                    }
                }
        );
        kendo.bind($("#application_top_panel"), calendarModel);
    }

    function editCalendar() {
        if (executeCommonPreConditionForSelectKendo(gridCalendar, 'calendar') == false) {
            return;
        }
        var calendar = getSelectedObjectFromGridKendo(gridCalendar);
        showCalendar(calendar);
    }

    function showCalendar(calendar) {
        calendarModel.set('calendar', calendar);
    }

    function newYearEntry() {
        $("#createCalendarModal").modal('show');
    }

    function onClickCalendarModal() {
        if (!validateForm($('#createCalendarForm'))) {
            return
        }
        $.ajax({
            type: "POST",
            url: "${createLink(controller:'calendar', action: 'newYearRecords')}",
            data: $('#createCalendarForm').serialize(),
            success: function (result, textStatus) {
                var data = JSON.parse(result);
                hideCalendarModal();
                if (data.isError == true) {
                    showError(data.message);
                    return false;
                }
                showSuccess(data.message);
            }
        });
    }

    function hideCalendarModal() {
        clearErrors($('#createCalendarForm'));
        $('#calYearModal').val('');
        $("#createCalendarModal").modal('hide');
        return false;
    }

</script>
