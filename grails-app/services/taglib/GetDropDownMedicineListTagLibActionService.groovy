package taglib

import com.scms.MedicineInfo
import com.scms.SecUser
import grails.converters.JSON
import grails.transaction.Transactional
import groovy.sql.GroovyRowResult
import org.apache.log4j.Logger
import scms.ActionServiceIntf
import scms.BaseService

@Transactional
class GetDropDownMedicineListTagLibActionService extends BaseService implements ActionServiceIntf  {

    private static final String NAME = 'name'
    private static final String CLASS = 'class'
    private static final String ON_CHANGE = 'onchange'
    private static final String HINTS_TEXT = 'hints_text'
    private static final String SHOW_HINTS = 'show_hints'
    private static final String DEFAULT_VALUE = 'default_value'
    private static final String PLEASE_SELECT = 'Please Select...'
    private static final String REQUIRED = 'required'
    private static final String VALIDATION_MESSAGE = 'validationmessage'
    private static final String DEFAULT_MESSAGE = 'Required'
    private static final String DATA_MODEL_NAME = 'data_model_name'
    private static final String SINGLE_DOT = '.'
    private static final String ESCAPE_DOT = '\\\\.'

    def springSecurityService
    private Logger log = Logger.getLogger(getClass())

    /** Build a map containing properties of html select
     *  1. Set default values of properties
     *  2. Overwrite default properties if defined in parameters
     * @param parameters - a map of given attributes
     * @return - a map containing all necessary properties with value
     */
    public Map executePreCondition(Map params) {
        try {
            String name = params.get(NAME)
            String dataModelName = params.get(DATA_MODEL_NAME)

            if ((!name) || (!dataModelName)) {
                return super.setError(params, INVALID_INPUT_MSG)
            }

            // Set default values for optional parameters
            params.put(HINTS_TEXT, params.hints_text ? params.hints_text : PLEASE_SELECT)
            params.put(SHOW_HINTS, params.show_hints ? new Boolean(Boolean.parseBoolean(params.show_hints.toString())) : Boolean.TRUE)
            params.put(REQUIRED, params.required ? new Boolean(Boolean.parseBoolean(params.required.toString())) : Boolean.FALSE)
            params.put(VALIDATION_MESSAGE, params.validationmessage ? params.validationmessage : DEFAULT_MESSAGE)

            return params

        } catch (Exception e) {
            log.error(e.getMessage())
            super.setError(params, INVALID_INPUT_MSG)
        }
    }

    /** Get the list of Roles
     *  build the html for 'select'
     * @param parameters - map returned from preCondition
     * @return - html string for 'select'
     */
    public Map execute(Map result) {
        try {
            List<GroovyRowResult> lstMedicineInfo = listMedicineInfo()
            String html = buildDropDown(lstMedicineInfo, result)
            result.html = html
            return result
        } catch (Exception e) {
            log.error(e.message)
            return super.setError(result, INVALID_INPUT_MSG)
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

    private static final String SELECT_END = "</select>"

    /** Generate the html for select
     * @param lstValues - list for select 'options'
     * @param dropDownAttributes - a map containing the attributes of drop down
     * @return - html string for select
     */
    private String buildDropDown(List<GroovyRowResult> lstValues, Map dropDownAttributes) {
        // read map values
        String name = dropDownAttributes.get(NAME)
        String dataModelName = dropDownAttributes.get(DATA_MODEL_NAME)
        String paramOnChange = dropDownAttributes.get(ON_CHANGE)
        String hintsText = dropDownAttributes.get(HINTS_TEXT)
        Boolean showHints = dropDownAttributes.get(SHOW_HINTS)
        Long defaultValue = (Long) dropDownAttributes.get(DEFAULT_VALUE)

        Map attributes = (Map) dropDownAttributes
        String strAttributes = EMPTY_SPACE
        attributes.each {
            if (it.value) {
                strAttributes = strAttributes + "${it.key} = '${it.value}' "
            }
        }

        String html = "<select ${strAttributes}>\n" + SELECT_END
        String strDefaultValue = defaultValue ? defaultValue : EMPTY_SPACE

        if (showHints.booleanValue()) {
            lstValues = listForKendoDropdown(lstValues, null, hintsText)
        }
        String jsonData = lstValues as JSON

        String script = """ \n
            <script type="text/javascript">
                \$(document).ready(function () {
                    \$('#${escapeChar(name)}').kendoDropDownList({
                        dataTextField   : 'name',
                        dataValueField  : 'id',
                        filter          : "contains",
                        suggest         : true,
                        dataSource      : ${jsonData},
                        value           :'${strDefaultValue}'
                    });
                });
                ${dataModelName} = \$("#${escapeChar(name)}").data("kendoDropDownList");
            </script>
        """
        return html + script
    }

    private String escapeChar(String str) {
        return str.replace(SINGLE_DOT, ESCAPE_DOT)
    }

    private List<GroovyRowResult> listMedicineInfo() {
        String queryForList = """
            SELECT mi.id, CONCAT(se.name,' - ', mi.brand_name,COALESCE(CONCAT(' (',mi.strength,')'),'')) AS name
                FROM medicine_info mi
                LEFT JOIN system_entity se ON se.id = mi.type
                ORDER BY mi.brand_name,se.name ASC;
        """
/*        SecUser user = SecUser.read(springSecurityService.principal.id)
        String queryForList = """
           SELECT mi.id AS id, CONCAT(se.name,'-', mi.brand_name,COALESCE(CONCAT(' (',mi.strength,')'),''),',',ms.stock_qty ,COALESCE(CONCAT('-',mi.unit_type),'')) AS name
                FROM medicine_info mi
                LEFT JOIN system_entity se ON se.id = mi.type
                LEFT JOIN medicine_stock ms ON mi.id=ms.medicine_id AND ms.hospital_code='${user.hospitalCode}'
                ORDER BY mi.brand_name,se.name ASC;
        """*/
        List<GroovyRowResult> lstMedicine = executeSelectSql(queryForList)
        return lstMedicine
    }
}
