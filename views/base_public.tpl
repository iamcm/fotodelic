<!DOCTYPE html>
<html>
    <head>
        <title>Fotodelic</title>
        <link rel="stylesheet" href="/static/css/bootstrap.min.css?{{vd['CACHEBREAKER']}}" />
        <link rel="stylesheet" href="/static/css/global.css?{{vd['CACHEBREAKER']}}" />
        <link href="http://fonts.googleapis.com/css?family=Nunito" rel="stylesheet" type="text/css">
    </head>
    
    <body>
        
        <div class="header">
            
            <div class="container">
                
                <a href="/">
                    <img src="/static/images/header.jpg" alt="Fotodelic" />
                </a>
                
            </div>
            
        </div>
        
        
        
        <div class="container">
            <div id="main-nav">
                <ul>
                %if vd['cats']:
                    %for c in vd['cats']:
                        <li><a href="/gallery/{{c.slug}}">{{c.name}}</a></li>
                    %end
                %end
                </ul>
            </div>
            
            <div class="maincontent">
                
                %include
                
            </div>
            
            <div class="footer">
                <div class="footercontent">
                    Fotodelic - All rights reserved
                </div>
            </div>
        </div>
        
        <script src="https://ajax.googleapis.com/ajax/libs/jquery/1.6.4/jquery.min.js"></script>
        <script src="/static/js/global.js?{{vd['CACHEBREAKER']}}"></script>
        %if defined('js'):
            %js()
        %end
    </body>
</html>

