package actions.theme

import com.model.ListThemeActionServiceModel
import com.scms.Theme
import grails.transaction.Transactional
import org.apache.log4j.Logger
import scms.ActionServiceIntf
import scms.BaseService

@Transactional
class UpdateThemeActionService extends BaseService implements ActionServiceIntf {

    private static final String UPDATE_SUCCESS_MESSAGE = "Theme has been updated successfully"
    private static final String THEME_OBJ = "theme"

    private Logger log = Logger.getLogger(getClass())

    public Map executePreCondition(Map params) {
        try {
            //Check parameters
            if (!params.name && !params.value) {
                return super.setError(params, INVALID_INPUT_MSG)
            }
            long id = Long.parseLong(params.id.toString())

            //Check existing of Obj and version matching
            Theme oldTheme = (Theme) Theme.read(id)

            Theme theme = buildObject(params, oldTheme)
            params.put(THEME_OBJ, theme)
            return params
        } catch (Exception ex) {
            log.error(ex.getMessage())
            throw new RuntimeException(ex)
        }
    }

    @Transactional
    public Map execute(Map result) {
        try {
            Theme theme = (Theme) result.get(THEME_OBJ)
            theme.save()
            return result
        } catch (Exception ex) {
            log.error(ex.getMessage())
            throw new RuntimeException(ex)
        }
    }
    /**
     *
     * @param result - map received from execute method
     * @return - map
     */
    public Map executePostCondition(Map result) {
        return result
    }
    /**
     *
     * @param result - map received from execute method
     * @return - map with success message
     */
    public Map buildSuccessResultForUI(Map result) {
        Theme theme = (Theme) result.get(THEME_OBJ)
        ListThemeActionServiceModel model = ListThemeActionServiceModel.read(theme.id)
        result.put(THEME_OBJ, model)
        return super.setSuccess(result, UPDATE_SUCCESS_MESSAGE)
    }

    /**
     *
     * @param result - map received from previous method
     * @return - map
     */
    public Map buildFailureResultForUI(Map params) {
        return params
    }

    private static Theme buildObject(Map parameterMap, Theme oldTheme) {
        Theme theme = new Theme(parameterMap)
        oldTheme.name = theme.name
        oldTheme.value = theme.value
        return oldTheme
    }
}
