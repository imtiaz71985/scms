package scms.usage

import scms.BaseTagLibExecutor
import taglib.GetDropDownAddressTaglibActionService
import taglib.GetDropDownDiseaseGroupTagLibActionService
import taglib.GetDropDownHospitalTagLibActionService
import taglib.GetDropDownMedicineListTagLibActionService
import taglib.GetDropDownReferralCenterTagLibActionService
import taglib.GetDropDownRegistrationNoTagLibActionService
import taglib.GetDropDownSellVoucherNoTagLibActionService
import taglib.GetDropDownServiceProviderTagLibActionService
import taglib.GetDropDownServiceTokenNoTagLibActionService
import taglib.GetDropDownServiceTypeTagLibActionService
import taglib.GetDropDownSystemEntityTaglibActionService
import taglib.GetDropDownSystemEntityTypeTaglibActionService
import taglib.GetDropDownVendorTagLibActionService

class ApplicationTagLib extends BaseTagLibExecutor {

    static namespace = "app"

    GetDropDownSystemEntityTypeTaglibActionService getDropDownSystemEntityTypeTaglibActionService
    GetDropDownSystemEntityTaglibActionService getDropDownSystemEntityTaglibActionService
    GetDropDownAddressTaglibActionService getDropDownAddressTaglibActionService
    GetDropDownServiceTypeTagLibActionService getDropDownServiceTypeTagLibActionService
    GetDropDownDiseaseGroupTagLibActionService getDropDownDiseaseGroupTagLibActionService
    GetDropDownMedicineListTagLibActionService getDropDownMedicineListTagLibActionService
    GetDropDownRegistrationNoTagLibActionService getDropDownRegistrationNoTagLibActionService
    GetDropDownServiceTokenNoTagLibActionService getDropDownServiceTokenNoTagLibActionService
    GetDropDownHospitalTagLibActionService getDropDownHospitalTagLibActionService
    GetDropDownVendorTagLibActionService getDropDownVendorTagLibActionService
    GetDropDownServiceProviderTagLibActionService getDropDownServiceProviderTagLibActionService
    GetDropDownReferralCenterTagLibActionService getDropDownReferralCenterTagLibActionService
    GetDropDownSellVoucherNoTagLibActionService getDropDownSellVoucherNoTagLibActionService

    /**
     * Render html select of Department
     * example: <depart:dropDownDepartment id=""></depart:dropDownDepartment>
     *
     * @attr id REQUIRED - id of html component
     * @attr name REQUIRED - name of html component
     * @attr data_model_name REQUIRED - name of dataModel of Kendo dropdownList
     * @attr class - css or validation class
     * @attr tabindex - component tab index
     * @attr onchange - on change event call
     * @attr hints_text - No selection text (Default is Please Select...)
     * @attr show_hints - Hints-text will be shown (Default is 'true')
     * @attr default_value - default value to be shown as selected (Default is '')
     * @attr required - boolean value (true/false), if true append required
     * @attr validationmessage - validation message to be shown (Default is 'Required')
     * @attr data-bind - bind with kendo observable
     */

    def dropDownSystemEntityType = { attrs, body ->
        attrs.body = body
        super.executeTag(getDropDownSystemEntityTypeTaglibActionService, attrs)
        out << (String) attrs.html
    }

    def dropDownSystemEntity = { attrs, body ->
        attrs.body = body
        super.executeTag(getDropDownSystemEntityTaglibActionService, attrs)
        out << (String) attrs.html
    }
    def dropDownDistrict = { attrs, body ->
        attrs.body = body
        super.executeTag(getDropDownAddressTaglibActionService, attrs)
        out << (String) attrs.html
    }
    def dropDownUnion = { attrs, body ->
        attrs.body = body
        super.executeTag(getDropDownAddressTaglibActionService, attrs)
        out << (String) attrs.html
    }
    def dropDownVillage = { attrs, body ->
        attrs.body = body
        super.executeTag(getDropDownAddressTaglibActionService, attrs)
        out << (String) attrs.html
    }
    def dropDownServiceType = { attrs, body ->
        attrs.body = body
        super.executeTag(getDropDownServiceTypeTagLibActionService, attrs)
        out << (String) attrs.html
    }
    def dropDownDiseaseGroup = { attrs, body ->
        attrs.body = body
        super.executeTag(getDropDownDiseaseGroupTagLibActionService, attrs)
        out << (String) attrs.html
    }
    def dropDownMedicineList = { attrs, body ->
        attrs.body = body
        super.executeTag(getDropDownMedicineListTagLibActionService, attrs)
        out << (String) attrs.html
    }
    def dropDownRegistrationNo = { attrs, body ->
        attrs.body = body
        super.executeTag(getDropDownRegistrationNoTagLibActionService, attrs)
        out << (String) attrs.html
    }
    def dropDownServiceTokenNo = { attrs, body ->
        attrs.body = body
        super.executeTag(getDropDownServiceTokenNoTagLibActionService, attrs)
        out << (String) attrs.html
    }
    def dropDownHospital = { attrs, body ->
        attrs.body = body
        super.executeTag(getDropDownHospitalTagLibActionService, attrs)
        out << (String) attrs.html
    }
    def dropDownVendor = { attrs, body ->
        attrs.body = body
        super.executeTag(getDropDownVendorTagLibActionService, attrs)
        out << (String) attrs.html
    }
    def dropDownServiceProvider = { attrs, body ->
        attrs.body = body
        super.executeTag(getDropDownServiceProviderTagLibActionService, attrs)
        out << (String) attrs.html
    }
    def dropDownReferralCenter = { attrs, body ->
        attrs.body = body
        super.executeTag(getDropDownReferralCenterTagLibActionService, attrs)
        out << (String) attrs.html
    }
    def dropDownSellVoucherNo = { attrs, body ->
        attrs.body = body
        super.executeTag(getDropDownSellVoucherNoTagLibActionService, attrs)
        out << (String) attrs.html
    }

}
