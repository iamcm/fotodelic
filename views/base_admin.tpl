<!DOCTYPE html>
<html>
    <head>
        <title>Fotodelic</title>
        <link rel="stylesheet" href="/static/css/bootstrap.min.css?" />
        <link rel="stylesheet" href="/static/css/generic.css?" />
        <link rel="stylesheet" href="/static/css/global.css?" />
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
                <a href="/logout">Logout</a>
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
        
        <script src="https://ajax.googleapis.com/ajax/libs/jquery/1.6.4/jquery.min.js"></script>
        <script src="/static/js/global.js?"></script>
        %if defined('js'):
            %js()
        %end
    </body>
</html>

