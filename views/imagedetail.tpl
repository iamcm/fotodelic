

<div class="container">
    <div class="image-detail">
        <div>
            <span class="right mypagination">
                %if vd['previous']:
                <a class="p10 btn btn-default" href="/gallery/{{vd['slug']}}/{{vd['previous']}}">Previous</a>
                %end
                
                %if vd['next']:
                <a class="p10 btn btn-default" href="/gallery/{{vd['slug']}}/{{vd['next']}}">Next</a>
                %end
            </span>
            <div class="clear"></div>
        </div>
        
        <img class="theimage" src="/static/{{vd['image'].filepath}}"/>
        
        %if vd['image'].description:
        <div class="well tinymce-content my10">{{!vd['image'].description}}</div>
        %end

        <hr />


        <div class="fb-wrapper"></div>

    </div>
</div>

%def js():
<script>
    var w = $('.fb-wrapper').width();
    $('.fb-wrapper').append('<div class="fb-like" data-href="{{vd['comments_url']}}" data-width="'+w+'" data-layout="standard" data-action="like" data-show-faces="true" data-share="true"></div>');
    $('.fb-wrapper').append('<div class="fb-comments" data-href="{{vd['comments_url']}}" data-numposts="5" data-width="'+w+'"></div>');
        

</script>
%end

%rebase base_public vd=vd, js=js
