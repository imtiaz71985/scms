<!-- Load Pako ZLIB library to enable PDF compression -->
<script type="text/javascript" src="${resource(dir: 'js', file: 'jquery/jquery-1.11.2.min.js')}"></script>
<script type="text/javascript" src="${resource(dir: 'js', file: 'jquery/iframe-post-form.js')}"></script>
<script type="text/javascript" src="${resource(dir: 'js', file: 'jquery/featureList-1.0.0.js')}"></script>
<script type="text/javascript" src="${resource(dir: 'js', file: 'kendo/kendo.all.min.js')}"></script>
<script type="text/javascript" src="${resource(dir: 'js', file: 'bootstrap/bootstrap.min.js')}"></script>
<script type="text/javascript" src="${resource(dir: 'js', file: 'bootstrap/bootbox.min.js')}"></script>
<script type="text/javascript" src="${resource(dir: 'js', file: 'application.js')}"></script>
<script type="text/javascript" src="${resource(dir: 'js', file: 'dateutil.js')}"></script>
<script type="text/javascript" src="${resource(dir: 'js', file: 'kendo/jszip.min.js')}"></script>
<script type="text/javascript" src="${resource(dir: 'js', file: 'kendo/pako_deflate.min.js')}"></script>
<script type="text/javascript" src="${resource(dir: 'js', file: 'moment.js')}"></script>

<link rel="stylesheet" href="${resource(dir: 'css', file: 'jquery/featurelist.css')}"/>
<link rel="stylesheet" href="${resource(dir: 'css', file: 'kendo/kendo.common.min.css')}"/>
<link rel="stylesheet" href="${resource(dir: 'css', file: 'kendo/kendo.dataviz.min.css')}"/>
<link rel="stylesheet" href="${resource(dir: 'css', file: 'kendo/kendo.silver.min.css')}"/>
<link rel="stylesheet" href="${resource(dir: 'css', file: 'font-awesome-4.4.0/css/font-awesome.min.css')}"/>
<link rel="stylesheet" href="${resource(dir: 'css', file: 'bootstrap/css/bootstrap.min.css')}"/>
<link rel="stylesheet" href="${resource(dir: 'css', file: 'bootstrap/css/bootstrap-theme.min.css')}"/>
<link rel="stylesheet" href="${resource(dir: 'css', file: 'custom.css')}"/>

%{--<sec:themeContent name="app.theme.common.css" css="true"></sec:themeContent>--}%

<!-- MetisMenu CSS -->
<link rel="stylesheet" href="${resource(dir: 'components', file: 'metisMenu/dist/metisMenu.min.css')}">

<!-- Custom CSS -->
<link rel="stylesheet" href="${resource(dir: 'dist', file: 'css/sb-admin-2.css')}">

<!-- Metis Menu Plugin JavaScript -->
<script type="text/javascript" src="${resource(dir: 'components', file: 'metisMenu/dist/metisMenu.min.js')}"></script>

<!-- Custom Theme JavaScript -->
<script type="text/javascript" src="${resource(dir: 'dist', file: 'js/sb-admin-2.js')}"></script>

<g:render template='/layouts/commonTemplates'/>