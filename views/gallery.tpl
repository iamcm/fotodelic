	
<div class="gallery">
%for i in vd['images']:
    <a href="/gallery/{{vd['slug']}}/{{i._id}}"><img src="/static/{{i.filepath.replace('uploads/','uploads/thumbs/')}}" /></a>
%end
</div>

%rebase base_public vd=vd
