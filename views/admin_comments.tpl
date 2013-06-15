

<div class="title">
	Comments
</div>

<table class="tablelist">
%for c in vd['comments']:

	<tr class="row">
		<td class="col1">
			{{c.comment}}
		</td>
		
		<td class="col2">
			<a href="/gallery/{{c.image.category.slug}}/{{c.imageId}}">View on site</a>
			|
			<a href="/admin/comment/{{c._id}}/delete">Delete</a>
		</td>
		
	</tr>
	
%end
</table>

%rebase base_admin vd=vd
