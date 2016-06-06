package taglib

import com.scms.Theme
import grails.transaction.Transactional
import org.apache.log4j.Logger
import scms.ActionServiceIntf
import scms.BaseService

@Transactional
class GetThemeContentTagLibActionService extends BaseService implements ActionServiceIntf {

    private static final String STR_NAME = 'name'
    private static final String STR_CSS = 'css'
    private static final String STYLE_TAG_START = "<style>\n"
    private static final String STYLE_TAG_END = "\n</style>"

    private Logger log = Logger.getLogger(getClass())

    /**
     * check required parameter
     * @param params - parameter from UI
     * @return - a map consisting necessary information
     */
    public Map executePreCondition(Map params) {
        String name = params.get(STR_NAME)
        if(!name){
            return super.setError(params, INVALID_INPUT_MSG)
        }
        return params
    }

    /**
     *
     * @param result
     * @return
     */
    public Map execute(Map result) {
        try {
            String name = result.get(STR_NAME)
            Theme theme = Theme.findByName(name)
            if (!theme) {
                result.html = EMPTY_SPACE
                return result
            }
            // now check if CSS content
            boolean isCss = false   // default value
            if (result.css) {
                isCss = Boolean.parseBoolean(result.get(STR_CSS).toString())
            }
            if (!isCss) {
                result.html = theme.value
                return result
            }
            // enclose style tag
            result.html = STYLE_TAG_START + theme.value + STYLE_TAG_END
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

}
