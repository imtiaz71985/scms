<!DOCTYPE html>
<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge,chrome=1">
    <link rel="shortcut icon" href="${createLinkTo(dir: 'images', file: 'favicon.png')}" type="image/x-icon"/>
    <title>Welcome to Friendship</title>
    <g:layoutHead/>
    <g:render template='/layouts/commonInclude'/>
    <g:render template="/layouts/script"/>
</head>

<body>
<div id="wrapper">
    <g:render template='/layouts/navBar'/>
    <div id="page-wrapper">
        %{--<g:render template='/layouts/dashBoard'/>--}%
    </div>
</div>
</body>
</html>
