package scms

import scms.utility.Tools


/**
 * Created by User on 9/7/15.
 */
class BaseTagLibExecutor {

    protected void executeTag(ActionServiceIntf action, Map params) {
        Map result = this.getServiceResponse(action, params)
        if (result.isError){
            result.html = "<span>${result.message}</span>"
        }
    }

    private Map getServiceResponse(ActionServiceIntf action, Map params) {

        // Set default value of Error flag, turn this on only when Error occurs
        params.put(Tools.IS_ERROR, Boolean.FALSE)

        // check to see if pre-conditions are met
        Map preResult = action.executePreCondition(params);
        Boolean isError = (Boolean) preResult.isError;
        if (isError.booleanValue() == true) {
            return action.buildFailureResultForUI(preResult);
        }

        // executes the action
        Map executeResult = action.execute(preResult);
        isError = (Boolean) executeResult.isError;
        if (isError.booleanValue() == true) {
            return action.buildFailureResultForUI(preResult);
        }
        // executes the post actions
        Map postResult = action.executePostCondition(executeResult);
        isError = (Boolean) postResult.isError;
        if (isError.booleanValue() == true) {
            return action.buildFailureResultForUI(postResult);
        }
        return action.buildSuccessResultForUI(postResult);
    }
}
