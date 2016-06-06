<script language="javascript">
    $(document).ready(function () {
        onLoadSecUserPage();
    });

    function onLoadSecUserPage() {
        $("#userId").val(${userId});
        // initialize form with kendo validator & bind onSubmit event
        initializeForm($("#resetPasswordForm"), onSubmitForm);
        // update page title
        $(document).attr('title', "Reset password");
    }

    function executePreCondition() {
        if (!validateForm($("#resetPasswordForm"))) {
            return false;
        }
        return true;
    }

    function onSubmitForm() {
        if (executePreCondition() == false) {
            return false;
        }

        setButtonDisabled($('#create'), true);
        showLoadingSpinner(true);

        jQuery.ajax({
            type: 'post',
            data: jQuery("#resetPasswordForm").serialize(),
            url:  "${createLink(controller:'secUser', action: 'resetPassword')}",
            success: function (data, textStatus) {
                executePostCondition(data);
                setButtonDisabled($('#create'), false);
            },
            error: function (XMLHttpRequest, textStatus, errorThrown) {
            },
            complete: function (XMLHttpRequest, textStatus) {
                showLoadingSpinner(false);
                window.location = "<g:createLink controller="logout"/>";
            },
            dataType: 'json'
        });
        return false;
    }

    function executePostCondition(result) {
        if (result.isError) {
            showError(result.message);
            showLoadingSpinner(false);
        } else {
            resetForm();
            showSuccess(result.message);
        }
    }

    function resetForm() {
        clearForm($("#resetPasswordForm"), $('#curPassword'));
    }

</script>

<div class="container-fluid">
    <div id="application_top_panel" class="panel panel-primary">
        <div class="panel-heading">
            <div class="panel-title">
                Reset Password
            </div>
        </div>

        <g:form name='resetPasswordForm' id='resetPasswordForm' class="form-horizontal form-widgets" role="form">
            <div class="panel-body">
                <input type="hidden" name="userId" id="userId"/>

                <div class="form-group">
                    <div class="col-md-8">

                        <div class="form-group">
                            <label id="lblPrePassword" class="col-md-3 control-label label-required"
                                   for="curPassword">Current Password:</label>

                            <div class="col-md-6">
                                <input type="password" class="form-control" id="curPassword" name="curPassword"
                                       placeholder="Letters,Numbers & Special Characters" required
                                       data-required-msg="Required" tabindex="1"
                                       validationMessage="Invalid Combination or Length"/>
                            </div>

                            <div class="col-md-3 pull-left">
                                <span class="k-invalid-msg" data-for="curPassword"></span>
                            </div>
                        </div>

                        <div class="form-group">
                            <label id="lblNewPassword" class="col-md-3 control-label label-required"
                                   for="newPassword">New Password:</label>

                            <div class="col-md-6">
                                <input type="password" class="form-control" id="newPassword" name="newPassword"
                                       placeholder="Letters,Numbers & Special Characters" required
                                       data-required-msg="Required" tabindex="2"
                                       validationMessage="Invalid Combination or Length"/>
                            </div>

                            <div class="col-md-3 pull-left">
                                <span class="k-invalid-msg" data-for="newPassword"></span>
                            </div>
                        </div>

                        <div class="form-group">
                            <label id="lblConfirmPassword" class="col-md-3 control-label label-required"
                                   for="retypePassword">Confirm Password:</label>

                            <div class="col-md-6">
                                <input type="password" class="form-control" id="retypePassword" name="retypePassword"
                                       placeholder="Confirm password" required data-required-msg="Required"
                                       validationMessage="Invalid Combination or Length" tabindex="3"/>
                            </div>

                            <div class="col-md-3 pull-left">
                                <span class="k-invalid-msg" data-for="retypePassword"></span>
                            </div>
                        </div>
                    </div>
                </div>
            </div>

            <div class="panel-footer">
                <button id="create" name="create" type="submit" data-role="button"
                        class="k-button k-button-icontext"
                        role="button" tabindex="4"
                        aria-disabled="false"><span class="k-icon k-i-plus"></span>Reset
                </button>

                <button id="clearFormButton" name="clearFormButton" type="button" data-role="button"
                        class="k-button k-button-icontext" role="button" tabindex="5"
                        aria-disabled="false" onclick='resetForm();'><span
                        class="k-icon k-i-close"></span>Cancel
                </button>
            </div>
        </g:form>
    </div>
</div>