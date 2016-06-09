<!-- Navigation -->
<nav id="navbar" class="navbar navbar-default navbar-static-top" role="navigation"
     style="margin-bottom: 0;">
    <div class="navbar-header">
        <div class="col-md-6">
            <a href="#login/dashBoard"><img src="images/logo.png" style="height: 50px;"/></a>
        </div>
        <div class="col-md-1">
            <i id="spinner" class="navbar-brand fa fa-2x fa-refresh fa-spin" style="height: 40px;margin: 2px 4px;color:#9F9F9F"></i>
        </div>
        <div class="col-md-2">
            <i class="navbar-brand" style="position:fixed;padding-left:35%;margin: 2px 4px;color:#9F9F9F"><sec:hospitalName></sec:hospitalName></i>
        </div>
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
                        urls="/medicineSellInfo/showMonthlyStatus,/medicineSellInfo/listMonthlyStatus,/medicineSellInfo/downloadMonthWiseSell">
                    <li>
                        <a href="#"><i class="fa fa-file"></i>&nbsp;Reports<span class="fa arrow-down"></span></a>
                        <ul class="nav nav-second-level">
                            <sec:access url="/medicineSellInfo/showMonthlyStatus">
                                <li>
                                    <a href="#medicineSellInfo/showMonthlyStatus"><i
                                            class="fa fa-file-pdf-o"></i>&nbsp;Month Status</a>
                                </li>
                            </sec:access>
                        </ul>
                    </li>
                </sec:ifAnyUrls>
                <sec:ifAnyUrls urls="/serviceType/show,/systemEntity/show,/serviceHeadInfo/show,/diseaseGroup/show,
                                    /diseaseGroup/show,/diseaseInfo/show,/medicineInfo/show">
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
    </div>
    <!-- /.navbar-static-side -->
</nav>