


<div id="slideshowholder">
%for i in vd['images']:
	<img alt="Slideshow image"  src="/static/{{i.filepath}}"  style="display:none"/>
%end
</div>

<div class="container">
	<div class="row my30">
		<div class="homepage-text col-sm-8 col-sm-offset-2 rc10">
			{{!vd['text']}}
		</div>
	</div>
</div>

%def js():
<script src="/static/js/slideshow.js"></script>
%end

%rebase base_public vd=vd, js=js