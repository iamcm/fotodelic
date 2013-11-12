<!DOCTYPE html>
<html>
    <head>
        <title>Fotodelic</title>
        <link rel="stylesheet" href="/static/css/bootstrap.min.css?12" />
        <link rel="stylesheet" href="/static/css/generic.css?12" />
        <link rel="stylesheet" href="/static/css/global.css?12" />
        <link href="http://fonts.googleapis.com/css?family=Nunito" rel="stylesheet" type="text/css">
        %if defined('css'):
            %css()
        %end
    </head>

    <body>
        
        <div id="adminbar">
            Logged in: {{vd['user'].email}}
            <span class="right">
                <a href="/">Home</a>
                -
                <a href="/admin">Control panel</a>
                -
                <a href="/auth/logout">Logout</a>
            </span>
        </div>
            
            <div class="maincontent container">
                
                %include
                
            </div>
            
            <div class="footer container">
                <div class="footercontent">
                    Fotodelic - All rights reserved
                </div>
            </div>
        </div>
        
        <script src="http://codeorigin.jquery.com/jquery-1.10.2.min.js"></script>
        <script src="/static/js/global.js?12"></script>
        %if defined('js'):
            %js()
        %end
    </body>
</html>

