package scms.usage

import scms.BaseTagLibExecutor
import taglib.GetDropDownRoleTagLibActionService

class RoleDropDownTagLib extends BaseTagLibExecutor {

    static namespace = "sec"

    GetDropDownRoleTagLibActionService getDropDownRoleTagLibActionService

    /**
     * Render html select of role
     * example: <sec:dropDownRole name="roleId"}"></sec:dropDownRole>
     *
     * @attr name REQUIRED - name & id of html component
     * @attr dataModelName REQUIRED - name of dataModel of Kendo dropdownList
     * @attr class - css or validation class
     * @attr tabindex - component tab index
     * @attr onchange - on change event call
     * @attr hintsText - No selection text (Default is Please Select...)
     * @attr showHints - Hints-text will be shown (Default is 'true')
     * @attr defaultValue - default value to be shown as selected (Default is '')
     * @attr required - boolean value (true/false), if true append required
     * @attr validationMessage - validation message to be shown (Default is 'Required')
     * @attr addAllAttributes - default value false
     *      - if true add all attributes of role in list
     */
    def dropDownRole = { attrs, body ->
        attrs.body = body
        super.executeTag(getDropDownRoleTagLibActionService, attrs)
        out << (String) attrs.html
    }
}
