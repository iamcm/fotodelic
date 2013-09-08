	

<div class="container">
	<div class="row">
		<h4>Gallery: {{vd['category']}}</h4>
		<nr />
	</div>
</div>
<div class="container">
	<div class="row">
		<div class="gallery  my30">
		%for i in vd['images']:
		    <a href="/gallery/{{vd['slug']}}/{{i._id}}"><img src="/static/{{i.filepath.replace('uploads/','uploads/thumbs/')}}" /></a>
		%end
		</div>
	</div>
</div>

%rebase base_public vd=vd
