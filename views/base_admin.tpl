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



        %if defined('vd'):
          %if vd['environment'] == 'production' or vd['environment'] == 'live':
          <script>
            (function(i,s,o,g,r,a,m){i['GoogleAnalyticsObject']=r;i[r]=i[r]||function(){
              (i[r].q=i[r].q||[]).push(arguments)},i[r].l=1*new Date();a=s.createElement(o),
              m=s.getElementsByTagName(o)[0];a.async=1;a.src=g;m.parentNode.insertBefore(a,m)
            })(window,document,'script','//www.google-analytics.com/analytics.js','ga');
            ga('create', 'UA-17459669-1', 'auto');
            ga('send', 'pageview');
          </script>
          %end
        %end
    </body>
</html>

