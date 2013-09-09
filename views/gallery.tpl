	

<div class="container">
	<h4>Gallery: {{vd['category'].name}}</h4>
	%if vd['category'].description:
		<div class="tinymce-content">{{!vd['category'].description}}</div>
	%end
	<nr />
</div>
<div class="container">
	<div class="gallery  my30">
	%for i in vd['images']:
	    <a href="/gallery/{{vd['slug']}}/{{i._id}}"><img src="/static/{{i.filepath.replace('uploads/','uploads/thumbs/')}}" /></a>
	%end
	</div>
</div>

%rebase base_public vd=vd
