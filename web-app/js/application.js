var kendoNotificationModel, wnd;
$(document).ready(function () {

    showLoadingSpinner(true);

    var popupSpan = "<span id='globalPopupNotification' style='display:none;'></span>";
    var winElement = "<div id='window'></div>";

    kendoNotificationModel = $(popupSpan).kendoNotification(
        {
            position: {top: 5, right: 10}, autoHideAfter: 3500,
            templates: [
                {
                    type: "success",
                    template: $("#tmplKendoSuccess").html()
                },
                {
                    type: "error",
                    template: $("#tmplKendoError").html()
                },
                {
                    type: "info",
                    template: $("#tmplKendoInfo").html()
                }
            ]

        }).data("kendoNotification");

    wnd = $(winElement).kendoWindow({
        title     : "Patient Service Details",
        modal     : true,
        visible   : false,
        resizable : false,
        width     : 800,
        actions   : [ "Pdf", "Minimize", "Maximize", "Close" ]
    }).data("kendoWindow");

    wnd.wrapper.find(".k-i-pdf").click(function(e){
        // Convert the DOM element to a drawing using kendo.drawing.drawDOM
        kendo.drawing.drawDOM($("#window"))
            .then(function(group) {
                // Render the result as a PDF file
                return kendo.drawing.exportPDF(group, {
                    paperSize : "auto",
                    margin    : { left: "1cm", top: "1cm", right: "1cm", bottom: "1cm" }
                });
            })
            .done(function(data) {
                // Save the PDF file
                kendo.saveAs({
                    dataURI  : data,
                    fileName : "patient_service_details.pdf"
                });
            });
        e.preventDefault();
    });
});

// assign kendo validator & bind onSubmit event
function initializeForm(form, func) {
    $(form).kendoValidator({validateOnBlur: false});

    $(form).submit(function (e) {
        func();
        return false;
    });
}

// return empty data source for kendo dropDown
function getKendoEmptyDataSource(dataModel, unselectedText) {
    var textMember = 'name'; // default value
    if (dataModel) {
        textMember = dataModel.options.dataTextField;
    }
    var unselectedData = new Object();
    unselectedData['id'] = '';
    unselectedData[textMember] = 'Please Select...'; // default value
    if (unselectedText)unselectedData[textMember] = unselectedText;
    return new kendo.data.DataSource({data: [unselectedData]});
}

// return a fully blank dataSoure
function getBlankDataSource() {
    return new kendo.data.DataSource({data: []});
}

function initKendoDropdown(control, paramTextMember, paramValueMember, paramDataSource) {
    if (!paramTextMember) paramTextMember = 'name';
    if (!paramValueMember) paramValueMember = 'id';
    if (!paramDataSource) paramDataSource = getKendoEmptyDataSource();

    $(control).kendoDropDownList({
        dataTextField: paramTextMember,
        dataValueField: paramValueMember,
        dataSource: paramDataSource
    });
    return $(control).data("kendoDropDownList");
}


function trimFormValues(form) {
    // iterate over all of the inputs for the form
    $(':input', form).each(function () {
        var type = this.type.toLowerCase();
        var tag = this.tagName.toLowerCase(); // normalize case

        // for inputs and textareas
        if (type == 'text' || type == 'hidden' || tag == 'textarea') {
            this.value = jQuery.trim(this.value);
        }
    });
}

function validateForm(form) {
    trimFormValues(form);
    var frmValidator = $(form).kendoValidator({
        validateOnBlur: false
    }).data("kendoValidator");
    if (!frmValidator.validate()) {
        return false;
    }
    return true;
}

function clearForm(frm, focusElement) {
    clearErrors(frm);
    clearFormValues(frm);
    if (focusElement) focusFieldElement(focusElement);
}

function focusFieldElement(focusElement) {
    $(focusElement).focus();
}

function clearErrors(form) {
    var frmValidator = $(form).kendoValidator({
        validateOnBlur: false
    }).data("kendoValidator");
    frmValidator.hideMessages();
}

function clearFormValues(form) {
    // iterate over all of the inputs for the form
    $(':input', form).each(function () {
        var type = this.type;
        var tag = this.tagName.toLowerCase(); // normalize case

        // password inputs, and textareas
        if (type == 'text' || type == 'password' || type == 'hidden' || tag == 'textarea' || type == 'email' || type == 'tel') {
            this.value = "";
        }

        // checkboxes and radios need to have their checked state cleared
        else if (type == 'checkbox' || type == 'radio')
            this.checked = false;

        // select elements need to have their 'selectedIndex' property set to -1
        else if (tag == 'select') {
            var dropDownKendo = $(this).data("kendoDropDownList");
            dropDownKendo.value('');
        }
    });

}

function setButtonDisabled(button, isDisable) {
    if (isDisable) {
        $(button).attr('disabled', 'disabled');
    } else {
        $(button).removeAttr('disabled');
    }

}

/*Method to disable kendo button*/
function setButtonDisabledKendo(button, isDisable) {
    var buttonObject = $(button).kendoButton({}).data("kendoButton");
    if (isDisable) {
        buttonObject.enable(false);
    } else {
        buttonObject.enable(true);
    }
}


function bindAutoLoadClass() {
    $('a.autoload').click(function (e) {
        var href = $(this).attr('href');
        var currentUrl = document.location.href;
        var currentPage = currentUrl.substring(currentUrl.indexOf('#', 0), currentUrl.length);
        if (currentPage == href) {
            var reqUrl = href.substring(1, href.length);
            load(reqUrl);
        }
    });
}


function setTabId(tabid) {
    leftMenuKendoModel.expand(">li:nth-child(" + (tabid + 1) + ")");
}

function setFavicon() {
    var link = $("link[type='image/x-icon']").remove().attr("href");
    $('<link href="' + link + '" rel="shortcut icon" type="image/x-icon" />').appendTo('head');
}

kendo.data.DataSource.prototype.options.error = function (e) {
    afterAjaxError(e.xhr, null);
};

function onErrorKendo(e) {
    afterAjaxError(e.XMLHttpRequest, e.XMLHttpRequest.statusText);
}

function afterAjaxError(XMLHttpRequest, textStatus) {
    redirectToLogoutPage(); // defined in main.gsp
    return false;
}

function showLoadingSpinner(show) {
    if (show) {
        $('#spinner').show();
    } else {
        $('#spinner').hide();
    }
}


function onCompleteAjaxCall(XMLHttpRequest, textStatus) {
    showLoadingSpinner(false);
}

// function trims the leading / for hash loading
function formatLink(link) {
    link=link.substring(6, link.length); // 6 = '/scms/'
    if (link.indexOf('/') == 0) {
        link = link.substring(1, link.length);
    }
    return link;
}


function showError(errDescrip) {
    if (errDescrip.length == 0) {
        return false;
    }
    kendoNotificationModel.show({message: errDescrip}, "error");
}

function showSuccess(successDescrip) {
    if (successDescrip.length == 0) {
        return false;
    }
    kendoNotificationModel.show({message: successDescrip}, "success");
}

function showInfo(infoDescrip) {
    if (!infoDescrip || infoDescrip.length == 0) {
        return false;
    }
    kendoNotificationModel.show({message: infoDescrip}, "info");
}

String.prototype.endsWith = function (str) {
    return (this.match(str + "$") == str);
}

String.prototype.isEmpty = function () {
    try {
        return ($.trim(this).length == 0);
    } catch (e) {
        return true;
    }
}

function isEmpty(val) {
    var val2;
    val2 = $.trim(val);
    return (val2.length == 0);
}

/*Function is responsible to refresh dropDown by url
 * 1. Extract all attributes
 * 2. build url parameter with attributes
 * 3. fire the url, receive html data & update div with data
 * */

$.fn.reloadMe = function (callbackFunc, customDivToUpdate) {
    var attributes = this.get(0).attributes;
    var params = "?" + attributes[0].name + "=" + attributes[0].value;
    for (var i = 1; i < attributes.length; i++) {
        params = params + "&" + attributes[i].name + "=" + encodeURIComponent(attributes[i].value);
    }
    var url = this.attr('url');
    var divToUpdate = (typeof customDivToUpdate != "undefined") ? $(customDivToUpdate) : $(this).parent().closest('div');
    var isDropDown = this.is('select');
    if (isDropDown) {
        $(this).prev('span.k-dropdown-wrap').find('span.k-icon').toggleClass('k-loading');
    } else {
        showLoadingSpinner(true);
    }
    jQuery.ajax({
        type: 'post', dataType: 'html', url: url + params,
        success: function (data, textStatus) {
            $(divToUpdate).html(data);
            if (callbackFunc) callbackFunc();
        },
        complete: function (XMLHttpRequest, textStatus) {
            if (isDropDown) {
                $(this).prev('span.k-dropdown-wrap').find('span.k-icon').toggleClass('k-loading');
            } else {
                showLoadingSpinner(false);
            }
        }
    });
}

function getFullGridHeightKendo() {
    var gridHeight = $("#page-wrapper").height() - 20;
    return gridHeight;
}

function gridDataBound(e) {
    var grid = e.sender;
    if (grid.dataSource.total() == 0) {
        var colCount = grid.columns.length;
        $(e.sender.wrapper)
            .find('tbody')
            .append('<tr><td colspan="' + colCount + '" class="no-data"><center>Sorry, no data found <i class="fa fa-frown-o"></i></center></td></tr>');
    }
}

function getGridHeightKendo() {
    var height = $("#page-wrapper").height() - $("#application_top_panel").height() - 20;
    return height;
}

function clearGridKendo(gridModel) {
    gridModel.dataSource.data([]);
}

function kendoCommonFilterable(width) {
    width = width? width:103
    return {cell: {inputWidth: width+"%",showOperators: false,operator: "contains", dataSource:getBlankDataSource()}};
}

// function to check if one or more grid row is selected or not
function executeCommonPreConditionForSelectKendo(gridModel, objName, singleOnly) {
    var objectName = 'row';
    if (objName) {
        objectName = objName;
    }
    var row = gridModel.select();

    if (row.size() == 0) {
        showError("Please select " + objectName + " to perform this operation");
        return false;
    }
    if (singleOnly && (row.size() > 1)) {
        showError("Please select only one " + objectName + " to perform this operation");
        return false;
    }
    return true;
}

/* function returns objectId from grid row.
 In case of multi select return '_' separated ids
 */
function getSelectedIdFromGridKendo(gridModel) {
    var objectId = '';
    var row = gridModel.select();
    var data;
    if (row.size() == 1) {
        data = gridModel.dataItem(row);
        objectId = data.id;
    } else if (row.size() > 1) {
        row.each(function (e) {
            data = gridModel.dataItem($(this));
            objectId += data.id + '_';
        });
    }
    return objectId;
}

/* function returns object from grid row.
 */
function getSelectedObjectFromGridKendo(gridModel) {
    var obj = {};
    var row = gridModel.select();
    if (row.size() == 1) {
        var data = gridModel.dataItem(row);
        if (data.fields) {  // for declared datasource
            $.each(data.fields, function (pName, pVal) {
                obj[pName] = data.get(pName);
            });
        } else {    // for non-declared datasource
            obj = data;
        }
    }
    return obj;
}


/* function returns specific 'cell value' of a row
 Used to check client side validation.
 */
function getSelectedValueFromGridKendo(gridModel, propertyName) {
    var row = gridModel.select();
    var data = gridModel.dataItem(row);
    var propertyValue = data.get(propertyName);
    return propertyValue;
}

/*Checks if grid data contains any error*/
function checkIsErrorGridKendo(data) {
    if (data.isError) {
        showError(data.message);
    }
}

/*Trim long text to display in kendo Grid cell*/
function trimTextForKendo(txt, len) {
    if (txt == null || txt == undefined) return '';
    if (txt.length > len) {
        txt = txt.substring(0, (len)) + '...';
    }
    return txt;
}

/*Serialise form data & convert to json object
 * used in kendo upload control to provide additional form data
 */
function serializeFormAsObject(frm) {
    var data = {};
    $(frm).serializeArray().map(function (x) {
        data[x.name] = x.value;
    });
    return data;
}

jQuery.fn.extend({
    enableSingleFiltering: function () {
        return this.each(function () {
            this.currentFilter = false;
            var _this = this;

            _this.originalFilter = this.dataSource.filter;
            this.dataSource.filter = function () {
                if (arguments.length > 0 && arguments[0] === null) {
                    console.log("Resetting filter");
                    _this.currentFilter = false;
                } else if (arguments.length > 0) {
                    var filterOptions = arguments[0];
                    if (filterOptions.filters && filterOptions.filters.length > 0) {
                        var filters = filterOptions.filters;
                        var i;
                        for (i = 0; i < filters.length; i++) {
                            var filter = filters[i];
                            if (_this.currentFilter === false
                                || _this.currentFilter.field !== filter.field) {
                                _this.currentFilter = filter;
                                break;
                            }
                            _this.currentFilter.value = filter.value;
                            _this.currentFilter.operator = filter.operator;
                        }
                    } else {
                        _this.currentFilter = false;
                    }
                }

                if (_this.currentFilter !== false && arguments[0]) {
                    var _args = arguments;
                    _args[0].filters = [_this.currentFilter];
                    console.log(_args);
                    return _this.originalFilter.apply(this, _args);
                } else {
                    return _this.originalFilter.apply(this, arguments);
                }
            };
        });
    }
});

Date.prototype.toString = function () {
    return this.getFullYear() + "-" + paddZero((this.getMonth() + 1)) + "-" + paddZero(this.getDate()) + " " + paddZero(this.getHours()) + ":" + paddZero(this.getMinutes()) + ":" + paddZero(this.getSeconds());
}

function paddZero(val, len) {
    if (new String(val).length == 2) {
        return val;
    }
    return '0'.concat(val);
}

function populateGridKendo(gridModel, url) {
    if (typeof url != "undefined") {
        gridModel.dataSource.transport.options.read.url = url;
    }
    if (gridModel.dataSource.options.serverPaging == true) {
        gridModel.dataSource.filter([]);
    } else {
        // prevent multiple server I/O
        if (gridModel.dataSource.data().length > 0) {
            gridModel.dataSource.filter([]);
            gridModel.dataSource.read();
        } else {
            gridModel.dataSource.read();
        }
    }
}

/* function selects all rows from grid (if selectable:'multiple')
 */
function selectAllFromGridKendo(gridModel) {
    gridModel.items().each(function () {
        gridModel.select($(this));
    });
}

/* function de-selects all rows from grid
 */
function deSelectAllFromGridKendo(gridModel) {
    gridModel.items().each(function () {
        $(this).removeClass("k-state-selected");
    });
}

/**
 * used in kendo grid amount fields
 */
function roundFloat(value, precision) {
    if (!value || value == 'undefined') value = 0;
    return parseFloat(value).toFixed(precision);
}

function setAlignCenter() {
    return "text-align:center";
}
function setAlignRight() {
    return "text-align:right";
}

function formatAmount(amount) {
    return formatNumberTwo(amount);
}
function formatCeilAmount(amount) {
    return Math.ceil(amount);
}

function formatNumberTwo(amount) {
    return kendo.toString(amount, "##,###.00");
}

/** applicable only for filterable fields those have long value(e.g- id) to show
 * effect - restrict decimal inputs
 */
function formatFilterablePositiveInteger(args) {
    var element = args instanceof jQuery ? args : args.element;
    element.kendoNumericTextBox({
        format: "#####",
        decimals: 0,
        spinners: false
    });

}
/** applicable only for filterable fields those have double value with four decimal(e.g- 2.4521 TON Cement) to show
 * effect - allow four decimal inputs
 */
function formatFilterableFourDecimalInteger(args) {
    var element = args instanceof jQuery ? args : args.element;
    element.kendoNumericTextBox({
        format: "#####.0000",
        decimals: 4,
        spinners: false
    });
}
/* Used to format date in filterable */
function formatFilterableDate(args) {
    var element = args instanceof jQuery ? args : args.element;
    element.kendoDatePicker({
        format: "dd/MM/yyyy"
    });
}

/**
 *
 * @param fileExt - file extention
 * @returns {string} - related font awesome class
 */
function getProperFileClass(fileExt) {
    var extClass = '';
    var word = ['doc', 'docx'];
    var excel = ['xls', 'xlsx', 'xlsm', 'xltx', 'xla', 'xlw', 'xl'];
    var pPoint = ['pptx', 'ppt', 'pptm'];
    var archive = ['rar', 'zip'];

    if (excel.indexOf(fileExt) >= 0) {
        extClass = "fa fa-file-excel-o";
    }else if (word.indexOf(fileExt) >= 0) {
        extClass = "fa fa-file-word-o";
    }else if (['pdf'].indexOf(fileExt) >= 0) {
        extClass = "fa fa-file-pdf-o";
    }else if (pPoint.indexOf(fileExt) >= 0) {
        extClass = "fa fa-file-powerpoint-o";
    }else if (['txt'].indexOf(fileExt) >= 0) {
        extClass = "fa fa-file-text-o";
    }else if (archive.indexOf(fileExt) >= 0) {
        extClass = "fa fa-file-archive-o";
    }else{
        extClass = "fa fa-file-code-o";
    }
        return extClass;
}

function isFileImage(fileExt){
    var image = ['jpg', 'jepg', 'gif', 'png'];
    if (image.indexOf(fileExt) >= 0) {
        return true;
    }
    return false;
}

function byteCount(s) {
    return encodeURI(s).split(/%..|./).length - 1;
}

function bytesToSize(bytes) {
    var sizes = ['Bytes', 'KB', 'MB', 'GB', 'TB'];
    if (bytes == 0) return '0 Byte';
    var i = parseInt(Math.floor(Math.log(bytes) / Math.log(1024)));
    return Math.round(bytes / Math.pow(1024, i), 2) + ' ' + sizes[i];
}

function defaultPageTile(page_header, left_menu) {
    $(document).attr('title', "Friendship - " + page_header);
    if (left_menu) markLeftMenu(left_menu);
    showLoadingSpinner(false);
    return false;
}

//return date as dd/mm/yyyy format
function convertDate(date){
    var formatedDate = new Date(date);
    var dd = formatedDate.getDate();
    var mm = formatedDate.getMonth()+1;
    var yyyy = formatedDate.getFullYear();
    if(dd<10){dd='0'+dd} if(mm<10){mm='0'+mm}
    formatedDate = dd+'/'+mm+'/'+yyyy;
    return formatedDate;
}

//return  date difference as year, month, days format
function evaluateDateRange(date1, date2){
    var diff = new Date(date2.getTime() - date1.getTime());
    var years = diff.getUTCFullYear() - 1970;
    var months = diff.getUTCMonth();
    var days = diff.getUTCDate() - 1;
    var hours = diff.getUTCHours();

    var strDifference = years > 0 ? (years + '  Y   ') : ''
    if(years > 10) return strDifference;
    strDifference += months > 0 ? (months + '  M   ') : ''
    if(years > 1) return strDifference;
    strDifference += days > 0 ? (days + '  D') : ''
    if (strDifference.size == 0) strDifference = 0 + ' ' + ' Day(s)'
    if(years == 0 && months == 0 && days == 0) strDifference = 0 + ' Day(s)';
    return strDifference
}
function minToHourMin(a){
    var hours = Math.trunc(a/60);
    var minutes = a % 60;
    return hours +":"+ minutes;
}

//********** START ----  Delete selected row from grid with custom confirmation box  ***********//
function confirmDelete(msg, url, grid){
    bootbox.confirm(msg, function(result) {
        if(result){
            executeDelete(url, grid);
        }
    }).find("div.modal-content").addClass("conf-delete");
}

function executeDelete(url, grid){
    showLoadingSpinner(true);
    var id = getSelectedIdFromGridKendo(grid);
    $.ajax({
        url: url + "?id=" + id,
        customData: {grid: grid},
        success: executePostConditionForDelete,
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


function executePostConditionForDelete(data) {
    if (data.isError){
    showError(data.message);
    return false;
    }
    var grid = this.customData.grid,
        row = grid.select();
    row.each(function () {
        grid.removeRow($(this));
        });
    resetForm();
    showSuccess(data.message);
}

function confirmAction(msg, url){
    bootbox.confirm(msg, function(result) {
        if(result){
            executeAction(url);
        }
    }).find("div.modal-content").addClass("conf-delete");
}

function executeAction(url){
    showLoadingSpinner(true);
    $.ajax({
        url: url,
        success: executePostConditionForAction,
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


function executePostConditionForAction(data) {
    if (data.isError){
        showError(data.message);
        return false;
    }
    showSuccess(data.message);
}
//********** END ----  Delete selected row from grid with custom confirmation box  ***********//

function confirmDownload(msg, url){
    bootbox.confirm(msg, function(result) {
        showLoadingSpinner(false);
        if(result){
            document.location = url;
        }
    }).find("div.modal-content").addClass("conf-download");
}

function allowOnlyNumeric(evt) {
    evt = (evt) ? evt : window.event;
    var charCode = (evt.which) ? evt.which : evt.keyCode;
    if (charCode > 31 && (charCode < 48 || charCode > 57)) {
        return false
    }
    return true
}
function bootboxAlert(msg){
    bootbox.alert({
        size: 'medium',
        message: msg
    })
}


function getDefaultPageSize(){
    return 50;
}
function getDefaultPageSizes(){
    return [20, 30, 40, 50];
}




