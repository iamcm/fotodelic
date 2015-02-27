

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
		<option value="all" selected="selected">All</option>
			<option value="homepagepics">Homepage Pics</option>
		%for c in vd['cats']:
			<option value="{{c.slug}}">{{c.name}}</option>
		%end
	</select>

	<input type="submit" value="Filter images" style="width:auto;">
</form>

<div id="imagelistcontainer" class="imagelist tablelist">
		
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
					<a href="/admin/image/{{i._id}}/delete" onclick="return confirm('Are you sure you want to permanently delete this image?')">Delete</a>
				</span>
			</div>
		</div>
	%end

</div>

%rebase base_admin vd=vd