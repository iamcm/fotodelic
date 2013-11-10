<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    
    <link rel="shortcut icon" href="/static/favicon.png">

    <title>Fotodelic</title>

    <link rel="stylesheet" href="/static/bootstrap/css/bootstrap.min.css?11" />
    <link rel="stylesheet" href="/static/css/generic.css?11" />
    <link rel="stylesheet" href="/static/css/global.css?11" />
    <link rel="stylesheet" href="/static/css/public.css?11" />
    <link href="http://fonts.googleapis.com/css?family=Nunito" rel="stylesheet" type="text/css">
    %if defined('css'):
        %css()
    %end
    <!-- HTML5 shim and Respond.js IE8 support of HTML5 elements and media queries -->
    <!--[if lt IE 9]>
      <script src="../../assets/js/html5shiv.js"></script>
      <script src="../../assets/js/respond.min.js"></script>
      <![endif]-->
  </head>

  <body>

    <div class="navbar navbar-default">
        <div class="container">
            <div class="navbar-header">
                <button type="button" class="navbar-toggle" data-toggle="collapse" data-target=".navbar-collapse">
                    <span class="icon-bar"></span>
                    <span class="icon-bar"></span>
                    <span class="icon-bar"></span>
                </button>
                <a class="navbar-brand" href="/">
                    <span class="greyout">www.</span>fotodelic<span class="greyout">.co.uk</span>
                </a>
            </div>
            <div class="collapse navbar-collapse">
                <ul class="nav navbar-nav">
                    %if defined('vd') and 'cats' in vd:
                        %for c in vd['cats']:
                        <li><a href="/gallery/{{c.slug}}">{{c.name}}</a></li>
                        %end
                    %end                    
                </ul>
            </div>
        </div>
    </div>

    %include


    <script src="http://codeorigin.jquery.com/jquery-1.10.2.min.js"></script>
    <script src="/static/js/global.js?11"></script>
    <script src="/static/bootstrap/js/bootstrap.min.js?11"></script>
    %if defined('js'):
        %js()
    %end

    <div id="fb-root"></div>
    <script>
      window.fbAsyncInit = function() {
        // init the FB JS SDK
        FB.init({
          appId      : '1436992026521137',                   // App ID from the app dashboard
          status     : true,                                 // Check Facebook Login status
          xfbml      : true                                  // Look for social plugins on the page
        });

        // Additional initialization code such as adding Event Listeners goes here
      };

      // Load the SDK asynchronously
      (function(d, s, id){
         var js, fjs = d.getElementsByTagName(s)[0];
         if (d.getElementById(id)) {return;}
         js = d.createElement(s); js.id = id;
         js.src = "//connect.facebook.net/en_US/all.js";
         fjs.parentNode.insertBefore(js, fjs);
       }(document, 'script', 'facebook-jssdk'));
    </script>

</body>
</html>


