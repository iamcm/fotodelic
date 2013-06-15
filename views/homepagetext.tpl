
<div class="py30">
    
    %if vd.get('error'):
    <div class="alert alert-error">
        <button class="close" data-dismiss="alert">×</button>
        {{vd['error']}}
    </div>
    %end

    
    <form autocomplete="off" class="form-horizontal" method='POST' action="">
        
        <div class="control-group">
            <label class="control-label" for="name">Name</label>
            <div class="controls">
                <textarea name="content">{{!vd['content']}}</textarea>
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