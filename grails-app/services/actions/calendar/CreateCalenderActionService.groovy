package actions.calendar

import grails.transaction.Transactional
import org.apache.log4j.Logger
import scms.ActionServiceIntf
import scms.BaseService

@Transactional
class CreateCalenderActionService extends BaseService implements ActionServiceIntf {

    private static final String SAVE_SUCCESS_MESSAGE = "Project has been saved successfully"
    private static final String NAME_ALREADY_EXIST = "Same Project already exist"
    private static final String PROJECT_OBJECT = "project"

    private Logger log = Logger.getLogger(getClass())


    /**
     * 1. input validation check
     * 2. duplicate check for role-name
     * @param params - receive role object from controller
     * @return - map.
     */
    @Transactional(readOnly = true)
    public Map executePreCondition(Map params) {
        return params

    }
    /**
     * 1. receive service object from pre execute method
     * 2. create new service
     * This method is in transactional block and will roll back in case of any exception
     * @param result - map received from pre execute method
     * @return - map.
     */
    @Transactional
    public Map execute(Map result) {
        return result

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
     * @param result - map received from executePost method
     * @return - map containing success message
     */
    public Map buildSuccessResultForUI(Map result) {
        return result

    }
    /**
     *
     * @param result - map received from previous method
     * @return - map
     */
    public Map buildFailureResultForUI(Map result) {
        return result
    }

}
