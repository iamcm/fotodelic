

<div class="title">Login</div>

<div class="p10">
    
    %if vd.get('error'):
    <div class="alert alert-error">
        <button class="close" data-dismiss="alert">×</button>
        {{vd['error']}}
    </div>
    %end

    <form autocomplete="off" class="form-horizontal" id="loginForm" method='POST' action="/login" >
        
        <div class="control-group">
            <label class="control-label" for="email">Email</label>
            <div class="controls">
                <input type="text" class="input-xlarge" name="email" id="email" value="{{vd.get('email') if vd.get('email') else ''}}"  />
            </div>
        </div>
        
        <div class="control-group">
            <label class="control-label" for="password">Password</label>
            <div class="controls">
                <input type="password" class="input-xlarge" name="password" id="password" value="{{vd.get('password') if vd.get('password') else ''}}"  />
            </div>
        </div>
        
        <div class="control-group">
            <div class="controls">
                <button type="submit" class="btn btn-info">Login</button>
                - <a href="/forgotten-password">Forgotten password?</a>
            </div>
        </div>
        
    </form>
</div>

%def css():
    <link rel="stylesheet" href="/static/css/global.css?{{vd['CACHEBREAKER']}}" />
%end


%rebase base_public vd=vd, css=css