<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    
    <link rel="shortcut icon" href="/static/favicon.png">

    <title>Fotodelic</title>

    <link rel="stylesheet" href="/static/bootstrap/css/bootstrap.min.css?{{vd['CACHEBREAKER']}}" />
    <link rel="stylesheet" href="/static/css/generic.css?{{vd['CACHEBREAKER']}}" />
    <link rel="stylesheet" href="/static/css/global.css?{{vd['CACHEBREAKER']}}" />
    <link rel="stylesheet" href="/static/css/public.css?{{vd['CACHEBREAKER']}}" />
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
                    %if vd['cats']:
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
    <script src="/static/js/global.js?{{vd['CACHEBREAKER']}}"></script>
    <script src="/static/bootstrap/js/bootstrap.min.js?{{vd['CACHEBREAKER']}}"></script>
    %if defined('js'):
        %js()
    %end

</body>
</html>


