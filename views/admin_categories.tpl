

<div class="title">
	Categories
	<span class="right">
		+
		<a href="/admin/category">Add a category</a>
	</span>
</div>

<table class="tablelist">
%for c in vd['cats']:

	<tr class="row">
		<td class="col1">{{c.name}}</td>
		<td class="col2">
			<a href="/admin/category/{{c._id}}/edit">Edit</a>
			|
			<a href="/admin/category/{{c._id}}/delete">Delete</a>
		</td>
	</tr>
	
%end
</table>

%rebase base_admin vd=vd