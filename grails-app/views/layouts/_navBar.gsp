<!-- Navigation -->
<nav id="navbar" class="navbar navbar-default navbar-static-top" role="navigation"
     style="margin-bottom: 0;height: 2px;">
    <div class="xnavbar-header" >
        <a style="padding-right: 2px;padding-top: 0;" class="navbar-brand" href="#login/dashBoard"><img src="images/logo.png" style="height: inherit;"/></a>
        <i id="spinner" class="navbar-brand fa fa-2x fa-refresh fa-spin" style="margin: 2px 4px;color:#9F9F9F"></i>
        <i class="navbar-brand" style="padding-left:35%;margin: 2px 4px;color:#004992"><sec:hospitalName></sec:hospitalName></i>
    </div>
    <!-- /.navbar-header -->

    <ul class="nav navbar-top-links navbar-right">
        <!-- /.dropdown -->
        <li class="dropdown">
    <li style="text-align: center">Welcome &nbsp;<strong><font color="green"> <sec:username property='username'></sec:username>&nbsp;</font></strong></li>

    <a class="dropdown-toggle" data-toggle="dropdown" href="#">
                <i class="fa fa-user" style="font-size: 20px;"></i>  <i class="fa fa-caret-down"></i>
            </a>
            <ul class="dropdown-menu dropdown-user">
                <li>
                    <a href="#login/resetPassword"><i class="fa fa-gear"></i>&nbsp;Reset password</a>
                </li>
                <li><a href="<g:createLink controller="logout"/>"><span
                        class="fa fa-sign-out"></span>&nbsp;Logout</a>
                </li>
            </ul>
            <!-- /.dropdown-user -->
        </li>
        <!-- /.dropdown -->
    </ul>
    <!-- /.navbar-top-links -->

    <div class="navbar-default sidebar" role="navigation">
        <div class="sidebar-nav navbar-collapse">
            <ul class="nav" id="side-menu">
                <sec:ifAnyUrls urls="/registrationInfo/show,/counselorAction/show">
                    <li>
                        <a href="#"><i class="fa fa-h-square"></i>&nbsp;Health Clinic<span class="fa arrow"></span></a>
                        <ul class="nav nav-second-level">
                            <sec:access url="/registrationInfo/show">
                                <li>
                                    <a href="#registrationInfo/show"><i class="fa fa-user-plus"></i>&nbsp;Registration</a>
                                </li>
                            </sec:access>
                            <sec:access url="/counselorAction/show">
                                <li>
                                    <a href="#counselorAction/show"><i class="fa fa-user-times"></i>&nbsp;Counselor Action</a>
                                </li>
                            </sec:access>
                        </ul>
                        <!-- /.nav-second-level -->
                    </li>
                </sec:ifAnyUrls>

                <sec:ifAnyUrls urls="/medicineSellInfo/show">
                    <li>
                        <a href="#"><i class="fa fa-medkit"></i>&nbsp;Dispensary<span class="fa arrow"></span></a>
                        <ul class="nav nav-second-level">
                            <sec:access url="/medicineSellInfo/show">
                                <li>
                                    <a href="#medicineSellInfo/show"><i class="fa fa-shopping-cart"></i>&nbsp;Sale</a>
                                </li>
                            </sec:access>
                        </ul>
                        <!-- /.nav-second-level -->
                    </li>
                </sec:ifAnyUrls>
                <sec:ifAnyUrls
                        urls="/reports/showMonthlyStatus,/reports/listMonthlyStatus,/reports/downloadMonthlyDetails">
                    <li>
                        <a href="#"><i class="fa fa-file"></i>&nbsp;Reports<span class="fa arrow"></span></a>
                        <ul class="nav nav-second-level">
                            <sec:access url="/reports/showMonthlyStatus">
                                <li>
                                    <a href="#reports/showMonthlyStatus"><i
                                            class="fa fa-file-pdf-o"></i>&nbsp;Monthly Status</a>
                                </li>
                            </sec:access>
                        </ul>
                    </li>
                </sec:ifAnyUrls>
                <sec:ifAnyUrls urls="/medicineInfo/stock">
                    <li>
                        <a href="#"><i class="fa fa-database"></i>&nbsp;Inventory<span class="fa arrow"></span></a>
                        <ul class="nav nav-second-level">
                            <sec:access url="/medicineInfo/stock">
                                <li>
                                    <a href="#medicineInfo/stock"><i class="fa fa-university"></i>&nbsp;Medicine Stock</a>
                                </li>
                            </sec:access>
                        </ul>
                        <!-- /.nav-second-level -->
                    </li>
                </sec:ifAnyUrls>
                <sec:ifAnyUrls urls="/requisition/show,/requisition/showHO,/requisitionReceive/show,
                /requisitionReceive/showList">
                    <li>
                        <a href="#"><i class="fa fa-cart-arrow-down"></i>&nbsp;Requisition<span class="fa arrow"></span></a>
                        <ul class="nav nav-second-level">
                            <sec:access url="/requisition/show">
                                <li>
                                    <a href="#requisition/show"><i class="fa fa-hand-paper-o"></i>&nbsp;Requisition</a>
                                </li>
                            </sec:access>
                            <sec:access url="/requisition/showHO">
                                <li>
                                    <a href="#requisition/showHO"><i class="fa fa-hand-pointer-o"></i>&nbsp;Requisition HO</a>
                                </li>
                            </sec:access>
                            <sec:access url="/requisitionReceive/show">
                                <li>
                                    <a href="#requisitionReceive/show"><i class="fa fa-hand-rock-o"></i>&nbsp;Receive</a>
                                </li>
                            </sec:access>
                            <sec:access url="/requisitionReceive/showList">
                                <li>
                                    <a href="#requisitionReceive/showList"><i class="fa fa-hand-lizard-o"></i>&nbsp;Receive Details</a>
                                </li>
                            </sec:access>
                        </ul>
                        <!-- /.nav-second-level -->
                    </li>
                </sec:ifAnyUrls>

                <sec:ifAnyUrls urls="/serviceType/show,/systemEntity/show,/serviceHeadInfo/show,/diseaseGroup/show,
                                    /diseaseGroup/show,/diseaseInfo/show,/medicineInfo/show,/hospitalLocation/show">
                    <li>
                        <a href="#"><i class="fa fa-wrench fa-fw"></i>&nbsp;Setting<span class="fa arrow"></span></a>
                        <ul class="nav nav-second-level">
                            <sec:access url="/systemEntity/show">
                                <li>
                                    <a href="#systemEntity/show"><i class="fa fa-cogs"></i>&nbsp;System Entity</a>
                                </li>
                            </sec:access>
                            <sec:access url="/serviceType/show">
                                <li>
                                    <a href="#serviceType/show"><i class="fa fa-battery-4"></i>&nbsp;Service Type</a>
                                </li>
                            </sec:access>
                            <sec:access url="/serviceHeadInfo/show">
                                <li>
                                    <a href="#serviceHeadInfo/show"><i class="fa fa-cube"></i>&nbsp;Service Head Info</a>
                                </li>
                            </sec:access>
                            <sec:access url="/diseaseGroup/show">
                                <li>
                                    <a href="#diseaseGroup/show"><i class="fa fa-cubes"></i>&nbsp;Disease Group</a>
                                </li>
                            </sec:access>
                            <sec:access url="/diseaseInfo/show">
                                <li>
                                    <a href="#diseaseInfo/show"><i class="fa fa-crosshairs"></i>&nbsp;Disease Info</a>
                                </li>
                            </sec:access>
                            <sec:access url="/medicineInfo/show">
                                <li>
                                    <a href="#medicineInfo/show"><i class="fa fa-hospital-o"></i>&nbsp;Medicine</a>
                                </li>
                            </sec:access>
                            <sec:access url="/calendar/show">
                                <li>
                                    <a href="#calendar/show"><i class="fa fa-calendar-o"></i>&nbsp;Office Calendar</a>
                                </li>
                            </sec:access>
                            <sec:access url="/hospitalLocation/show">
                                <li>
                                    <a href="#hospitalLocation/show"><i class="fa fa-hospital-o"></i>&nbsp;Clinic</a>
                                </li>
                            </sec:access>
                            <sec:access url="/requisitionAuthority/show">
                                <li>
                                    <a href="#requisitionAuthority/show"><i class="fa fa-user-secret"></i>&nbsp;Req Authority</a>
                                </li>
                            </sec:access>
                        </ul>
                        <!-- /.nav-second-level -->
                    </li>
                </sec:ifAnyUrls>
                <sec:ifAnyUrls urls="/secUser/show,/secRole/show,/secUserSecRole/show,/featureManagement/show,/theme/show">
                    <li>
                        <a href="#"><i class="fa fa-users"></i>&nbsp;User management<span class="fa arrow"></span></a>
                        <ul class="nav nav-second-level">
                            <sec:access url="/secUser/show">
                                <li>
                                    <a href="#secUser/show"><i class="fa fa-user"></i>&nbsp;User</a>
                                </li>
                            </sec:access>
                            <sec:access url="/secRole/show">
                                <li>
                                    <a href="#secRole/show"><i class="fa fa-cog"></i>&nbsp;Role</a>
                                </li>
                            </sec:access>
                            <sec:access url="/featureManagement/show">
                                <li>
                                    <a href="#featureManagement/show"><i class="fa fa-cogs"></i>&nbsp;Role Right</a>
                                </li>
                            </sec:access>
                        </ul>
                        <!-- /.nav-second-level -->
                    </li>
                </sec:ifAnyUrls>
            </ul>
        </div>
        <!-- /.sidebar-collapse -->
    <div class="copy-right"><b> &#9400; </b>&nbsp;Developed by<b> MIS </b>department.</div>
</div>
    <!-- /.navbar-static-side -->
</nav>