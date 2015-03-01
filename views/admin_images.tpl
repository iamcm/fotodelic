

<div class="title">
	Images
	<span class="right">
		+
		<a href="/admin/image">Add image(s)</a>
	</span>
</div>

<form autocomplete="off" id="imagefilterform" class="form-inline">

	<label for="id_category" id="id_category_label">Filter for:</label>
	<select name="category" id="id_category">
			<option value="homepagepics" {{'selected' if vd['category']=='homepagepics' else ''}}>Homepage Pics</option>
		%for c in vd['cats']:
			<option value="{{c.slug}}" {{'selected' if vd['category']==c.slug else ''}}>{{c.name}}</option>
		%end
	</select>

	<input type="submit" value="Filter images" style="width:auto;">
</form>

<div id="imagelistcontainer" class="imagelist tablelist">
		
	<form action="/admin/image/bulkdelete" method="post">
		<input type="hidden" name="category" value="{{vd['category']}}" />	
	%for i in vd['images']:
		<div class="row-fluid my5">
			<div class="span4">
				<img title="{{i.nicename}}" src="/static/{{i.filepath.replace('uploads/','uploads/thumbs/')}}" />
			</div>
			
			<div class="span8">
				<span class="right">
					<a href="/gallery/{{i.category.slug if i.category else ''}}/{{i._id}}">View on site</a>
					|
					<a href="/admin/image/{{i._id}}/description">Add description</a>
					|
					%if i.isHomepagePic:
					<a style="cursor:pointer" data-href="/admin/image/{{i._id}}/toggle-homepage/" onclick="toggleHompagePic(this)">Remove from homepage pics</a>
					%else:
					<a style="cursor:pointer" data-href="/admin/image/{{i._id}}/toggle-homepage/" onclick="toggleHompagePic(this)">Set as homepage pic</a>
					%end
					|
					<input value="{{i._id}}" name="imageId" type="checkbox" />
				</span>
			</div>
		</div>
	%end
		<div class="well" style="display:none;">
			<input id="bulk-delete-btn" type="submit" value="Bulk Delete images" />	
		</div>
	</form>
</div>

%def js():
	<script type="text/javascript">
		$('input[type="checkbox"]').on('change', function(){
			var checkedItems = 0;
			$('input[type="checkbox"]').each(function(){ 
				if($(this).is(':checked')){
					checkedItems += 1;
				}

				var txt = 'Bulk Delete '+ checkedItems +' Image';
				if(checkedItems > 1){
					txt += 's';
				}

				$('#bulk-delete-btn').attr('value', txt).parent().show();
			});

			if(checkedItems == 0){
				$('#bulk-delete-btn').parent().hide();
			}
		})
	</script>
%end

%rebase base_admin vd=vd, js=js