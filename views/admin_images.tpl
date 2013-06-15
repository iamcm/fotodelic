

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
		%for c in vd['cats']:
			<option value="{{c.slug}}">{{c.name}}</option>
		%end
	</select>

	<label for="id_order" id="id_order_label">Order by:</label>
	<select name="order" id="id_order">
		<option value="date" selected="selected">Date added</option>
		<option value="comments">Comments</option>
	</select>

	<input type="submit" value="Filter images" style="width:auto;">
</form>

<div id="imagelistcontainer" class="imagelist tablelist">
		
	<table>
	%for i in vd['images']:
		<tr class="row">
			<td class="col1">
				<img src="/static/{{i.filepath.replace('uploads/','uploads/thumbs/')}}" />
				 {{i.nicename}}
				({{i.comment_count}} comment(s))
			</td>
			
			<td class="col2">
				<a href="/gallery/{{i.category['slug']}}/{{i._id}}">View on site</a>
				|
				%if i.isHomepagePic:
				<a style="cursor:pointer" data-href="/admin/image/{{i._id}}/toggle-homepage/" onclick="toggleHompagePic(this)">Remove from homepage pics</a>
				%else:
				<a style="cursor:pointer" data-href="/admin/image/{{i._id}}/toggle-homepage/" onclick="toggleHompagePic(this)">Set as homepage pic</a>
				%end
				|
				<a href="/admin/image/{{i._id}}/delete" onclick="return confirm('Are you sure you want to permanently delete this image?')">Delete</a>
			</td>
		</tr>
	%end
	</table>
</div>

%rebase base_admin vd=vd