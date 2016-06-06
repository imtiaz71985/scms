package scms.usage

import scms.BaseTagLibExecutor
import taglib.GetThemeContentTagLibActionService

/**
 * ThemeTagLib methods used to render theme content(text,css etc.) for a given key
 */
class ThemeTagLib extends BaseTagLibExecutor {

    static namespace = "sec"

    GetThemeContentTagLibActionService getThemeContentTagLibActionService

    /**
     * Shows different contents of theme e.g. companyImage, copyright text
     * attr takes the attribute 'name'
     * example: <sec:themeContent name="copyrightText"></sec:themeContent>
     *
     * @attr name REQUIRED -the key name
     * @attr css -if true, then theme content will be enclosed by style tag
     */

    def themeContent = { attrs, body ->
        attrs.body = body
        attrs.request = request
        super.executeTag(getThemeContentTagLibActionService, attrs)
        out << (String) attrs.html
    }
}
