<script type="text/javascript">
    var router = false;
    $(document).ready(function() {
        initRouter();
        $.ajaxSetup({
            error: function (x, e) {
                redirectToLogoutPage();
            }
        });
        showLoadingSpinner(false);
    });

    function initRouter() {
        router = new kendo.Router();
        router.route("/:controller/:action", function (controller, action, params) {
        });
        router.bind("change", function (e) {
            var url = e.url;
            if ((url == "/") || (url == "")) {
                return false;
            }else{
                load(url);
            }
        });
        router.start();
    }

    function load(loc) {
        jQuery.ajax({
            type: 'post',
            url: loc,
            success: function (data, textStatus) {
                $('#page-wrapper').height(window.height-20);
                $('#page-wrapper').html(data);
                markLeftMenu(loc);
            },
            complete: function (XMLHttpRequest, textStatus) {
                showLoadingSpinner(false);
            }
        });
    }
    function markLeftMenu(loc){
        $("#navbar a").removeClass('active');
        $("#navbar a[href='" + '#'+loc + "']").addClass('active').focus();

    }

    function redirectToLogoutPage() {
        window.location = "<g:createLink controller="logout"/>";
    }
</script>