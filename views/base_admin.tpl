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


        %if defined('vd') and 'environment' in vd:
          %if vd['environment'] == 'production' or vd['environment'] == 'live':
          <script type="text/javascript">
              var _gaq = _gaq || [];
              _gaq.push(['_setAccount', 'UA-17459669-1']);
              _gaq.push(['_setSiteSpeedSampleRate', 70]);
              _gaq.push(['_trackPageview']);

              (function() {
              var ga = document.createElement('script'); ga.type = 'text/javascript'; ga.async = true;
              ga.src = ('https:' == document.location.protocol ? 'https://ssl' : 'http://www') + '.google-analytics.com/ga.js';
              var s = document.getElementsByTagName('script')[0]; s.parentNode.insertBefore(ga, s);
              })();
          </script>
          %end
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

