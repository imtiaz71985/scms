package taglib

import grails.converters.JSON
import grails.plugin.springsecurity.SpringSecurityService
import grails.transaction.Transactional
import groovy.sql.GroovyRowResult
import scms.ActionServiceIntf
import scms.BaseService
import service.SecUserService

@Transactional
class GetDropDownEmployeeTaglibActionService extends BaseService implements ActionServiceIntf {

    private static final String NAME = 'name'
    private static final String ID = 'id'
    private static final String HINTS_TEXT = 'hints_text'
    private static final String SHOW_HINTS = 'show_hints'
    private static final String PLEASE_SELECT = 'Please Select...'
    private static final String REQUIRED = 'required'
    private static final String VALIDATION_MESSAGE = 'validationmessage'
    private static final String DEFAULT_MESSAGE = 'Required'
    private static final String DATA_MODEL_NAME = 'data_model_name'
    private static final String SORT_BY_DEPARTMENT = 'sort_by_department'
    private static final String IS_FOR_LOGIN = 'is_for_login'
    private static final String LST_DEPARTMENT = 'lstDepartment'
    private static final String ERROR_FOR_INVALID_INPUT = 'Error for invalid input'

    SecUserService secUserService
    SpringSecurityService springSecurityService

    /**
     * Build a map containing properties of html select
     *  1. Set default values of properties
     *  2. Overwrite default properties if defined in parameters
     *
     * @param parameters - a map of given attributes
     * @return - a map containing all necessary properties with value
     */
    public Map executePreCondition(Map params) {
        try {
            String name = params.get(NAME)
            String id = params.get(ID)
            String dataModelName = params.get(DATA_MODEL_NAME)

            // check required parameters
            if ((!id) || (!name) || (!dataModelName)) {
                return setError(params, ERROR_FOR_INVALID_INPUT)
            }
            // Set default values for optional parameters
            params.put(HINTS_TEXT, params.hints_text ? params.hints_text : PLEASE_SELECT)
            params.put(SHOW_HINTS, params.show_hints ? new Boolean(Boolean.parseBoolean(params.show_hints.toString())) : Boolean.TRUE)
            params.put(REQUIRED, params.required ? new Boolean(Boolean.parseBoolean(params.required.toString())) : Boolean.FALSE)
            params.put(IS_FOR_LOGIN, params.is_for_login ? new Boolean(Boolean.parseBoolean(params.is_for_login.toString())) : Boolean.FALSE)
            params.put(VALIDATION_MESSAGE, params.validationmessage ? params.validationmessage : DEFAULT_MESSAGE)
            return params
        } catch (Exception e) {
            return super.setError(params, ERROR_FOR_INVALID_INPUT)
        }
    }

    /**
     * Get the list of Staff Type objects
     *  build the html for 'select'
     *
     * @param parameters - map returned from preCondition
     * @return - html string for 'select'
     */
    public Map execute(Map result) {
        try {
            List<GroovyRowResult> lstEmployee = (List<GroovyRowResult>) listOfficeEmployee()
            String html = buildDropDown(lstEmployee, result)
            result.html = html
            return result
        } catch (Exception e) {
            return super.setError(result, ERROR_FOR_INVALID_INPUT)
        }
    }

    /**
     * Do nothing in post condition
     * @param result - A map returned by execute method
     * @return - returned the received map
     */
    public Map executePostCondition(Map result) {
        return result
    }

    /**
     * do nothing for build success operation
     * @param result - A map returned by post condition method.
     * @return - returned the same received map containing isError = false
     */
    public Map buildSuccessResultForUI(Map result) {
        return result
    }

    /**
     * Do nothing here
     * @param result - map returned from previous any of method
     * @return - a map containing isError = true & relevant error message
     */
    public Map buildFailureResultForUI(Map result) {
        return result
    }

    private List<GroovyRowResult> listOfficeEmployee() {
        String query = """
            SELECT e.employee_id AS id, CONCAT(e.name,' (',e.employee_id,')') AS name
                FROM employee e
                WHERE e.employee_status_id = 1
                ORDER BY e.name
        """
        List<GroovyRowResult> lstAppUser = groovySql_mis.rows(query)
        consolePrint(query, null)
        return lstAppUser
    }

    private static final String SELECT_END = "</select>"

    /**
     * Generate the html for select
     *  1.set attributes to strAttributes
     *  2.set value for refresh dropdown in strDefaultValue
     *  3.Build list for kendo dropdown
     *
     * @param lstStaff - list for select 'options'
     * @param dropDownAttributes - a map containing the attributes of drop down
     * @return - html string for select
     */
    private String buildDropDown(List<GroovyRowResult> lstStaff, Map dropDownAttributes) {
        // read map values
        String name = dropDownAttributes.get(NAME)
        String dataModelName = dropDownAttributes.get(DATA_MODEL_NAME)
        String hintsText = dropDownAttributes.get(HINTS_TEXT)
        Boolean showHints = dropDownAttributes.get(SHOW_HINTS)

        Map attributes = (Map) dropDownAttributes
        String strAttributes = EMPTY_SPACE
        attributes.each {
            if (it.value) {
                strAttributes = strAttributes + "${it.key} = '${it.value}' "
            }
        }

        String html = "<select ${strAttributes}>\n" + SELECT_END

        if (showHints.booleanValue()) {
            lstStaff = listForKendoDropdown(lstStaff, null, hintsText)
        }
        String jsonData = lstStaff as JSON
        String script = """ \n
            <script type="text/javascript">
                \$(document).ready(function () {
                     if (${dataModelName}){
                            ${dataModelName}.destroy();
                     }
                        \$('#${name}').kendoDropDownList({
                            dataTextField  : "name",
                            dataValueField : "id",
                            filter         : "contains",
                            suggest        : true,
                            dataSource     :${jsonData}
                        });
                });
                ${dataModelName} = \$("#${name}").data("kendoDropDownList");
            </script>
        """
        return html + script
    }
}
