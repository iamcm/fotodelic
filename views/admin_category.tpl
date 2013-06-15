
<div class="py30">
    
    %if vd.get('error'):
    <div class="alert alert-error">
        <button class="close" data-dismiss="alert">×</button>
        {{vd['error']}}
    </div>
    %end

    <form autocomplete="off" class="form-horizontal" method='POST' action="/admin/category">
		
	    %if vd.get('cat'):
	    	<input type="hidden" name="id" value="{{vd['cat']._id}}" />
	    %end

        <div class="control-group">
            <label class="control-label" for="name">Name</label>
            <div class="controls">
                <input type="text" class="input-xlarge" name="name" id="name" value="{{vd['cat'].name if vd.get('cat') else ''}}"  />
            </div>
        </div>
        
        <div class="control-group">
            <div class="controls">
                <button type="submit" class="btn btn-info">Save</button>
            </div>
        </div>
        
    </form>
</div>

%rebase base_admin vd=vd