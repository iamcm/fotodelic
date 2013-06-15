

<div id="slideshowholder" style="display:none">
%for i in vd['images']:
	<img alt="Slideshow image"  src="/static/{{i.filepath}}"  style="display:none"/>
%end
</div>

{{!vd['text']}}


%def js():
<script src="/static/js/slideshow.min.js"></script>
%end

%rebase base_public vd=vd, js=js