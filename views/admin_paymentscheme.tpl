
<div class="py30">
    
    %if vd.get('error'):
    <div class="alert alert-error">
        <button class="close" data-dismiss="alert">×</button>
        {{vd['error']}}
    </div>
    %end

    <form autocomplete="off" class="form-horizontal" method='POST' action="/admin/paymentscheme">
		
	    %if vd.get('scheme'):
	    	<input type="hidden" name="id" value="{{vd['scheme']._id}}" />
	    %end

        <div class="alert alert-info">'Name' is just a label for you to remember a given payment scheme, it wont be shown on the public site, for example: My Landscapes</div>  

        <div class="control-group">
            <label class="control-label" for="name">Name</label>
            <div class="controls">
                <input type="text" class="input-xlarge" name="name" id="name" value="{{vd['scheme'].name if vd.get('scheme') else ''}}"  />
            </div>
        </div>

        <div class="alert alert-info">'Options' are the actual payment options, for example: name=6x4, amount=6</div>

        <div class="control-group">
            <label class="control-label" for="name">Options</label>
            <div class="controls">
                <div>
                    <input type="text" placeholder="text" id="text"   />
                    &nbsp;-&nbsp;
                    <span class="input-group-addon">&pound;</span>
                    <input type="text" placeholder="amount" id="amount"   />
                    <a class="btn btn-info" id="add-option">Add</a>
                </div>
                <div id="options">
                </div>
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
    <script type="text/javascript">
        $('#add-option').on('click', function(){
            var text = $('#text').val();
            var amount = $('#amount').val();

            $('#text').val('');
            $('#amount').val('');

            if(text != '' && parseFloat(amount) > 0){
                amount = parseFloat(amount);
                $('#options').append('<p><a onclick="$(this).parent().remove()" class="btn btn-default btn-xs">x</a><input name="option[]" value="'+text+':::'+amount+'" type="hidden" /> '+ text +' - £'+ amount +'</p>');
            } else {
                alert('Invalid name or amount');
            }
        });

        $(document).on('keypress', function(ev){
            if(ev.keyCode == 13){
                ev.preventDefault();
                return false;
            }
        });

    </script>
%end

%rebase base_admin vd=vd, js=js