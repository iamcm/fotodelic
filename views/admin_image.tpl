
<div class="py30">
    
    %if vd.get('error'):
    <div class="alert alert-error">
        <button class="close" data-dismiss="alert">×</button>
        {{vd['error']}}
    </div>
    %end

    <form class="form-horizontal" method='POST' action="/admin/image">

        <div class="control-group">
            <label class="control-label" for="name">Category</label>
            <div class="controls">
            	<select name="category" id="id_category">
					%for c in vd['cats']:
						<option value="{{c._id}}">{{c.name}}</option>
					%end
				</select>
            </div>
        </div>

        <div class="control-group">
            <label class="control-label" for="name">Select image(s)</label>
            <div class="controls">
            	<div id="uploader"></div>
            </div>
        </div>
        
    </form>
</div>

%def css():
	<style type="text/css">@import url(/static/plupload/js/jquery.plupload.queue/css/jquery.plupload.queue.css);</style>
%end

%def js():
	<script type="text/javascript" src="/static/plupload/js/plupload.full.js"></script>
	<script type="text/javascript" src="/static/plupload/js/jquery.plupload.queue/jquery.plupload.queue.js"></script>
	<script type="text/javascript" src="/static/js/uploader.js"></script>
%end

%rebase base_admin vd=vd, js=js, css=css