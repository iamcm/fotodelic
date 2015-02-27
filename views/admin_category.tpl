
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
            <label class="control-label" for="description">Description</label>
            <div class="controls">
                <textarea class="input-xlarge" name="description" id="description">{{vd['cat'].description if vd.get('cat') and vd['cat'].description else ''}}</textarea>
            </div>
        </div>

        <div class="control-group">
            <label class="control-label" for="scheme">Payment Scheme</label>
            <div class="controls">
                <select name="scheme">
                    <option value="">No payment scheme</option>
                    %for s in vd['schemes']:
                    <option value="{{s._id}}" {{"selected" if str(s._id) == str(vd['cat'].payment_scheme_id) else ''}}>{{s.name}}</option>
                    %end
                </select>
            </div>
        </div>
        
        <div class="control-group">
            <div class="controls">
                <button type="submit" class="btn btn-info">Save</button>
            </div>
        </div>
        
    </form>
</div>


%def js():
    <script type="text/javascript" src="/static/js/tiny_mce/tiny_mce.js"></script>
    <script type="text/javascript">
     tinyMCE.init({
         mode : "textareas",
         theme : "advanced",
         height: '200',
         width: '700',
         
         content_css: '/static/css/tinymce-overrides.css',

         theme_advanced_buttons1 : "bold,italic,underline,|,bullist,numlist,link,|,styleselect",
         theme_advanced_buttons2 : "",
         theme_advanced_buttons3 : "",
         theme_advanced_buttons4 : "",
         theme_advanced_toolbar_location : "top",
         theme_advanced_toolbar_align : "left",
         theme_advanced_resizing : true,
             style_formats : [                                                
             {title : 'Heading', inline : 'span', styles : {fontSize:'120%',fontWeight:'bold',marginBottom:'5px'}},  
             {title : 'Indent', inline : 'span', styles : {marginLeft:'2%',marginRight:"2%"}}
         ]
     });
    </script>
%end

%rebase base_admin vd=vd, js=js