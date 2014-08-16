

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

        <div class="well">
            <div class="col-sm-3">
                <input type="radio" disabled="disabled" checked="checked"> Full quality original print - £0.01
            </div>
            <div class="col-sm-3">
                <form method="post" action="/basket/add">
                    <input type="hidden" name="returnTo" value="{{vd['url']}}">
                    <input type="hidden" name="id" value="{{vd['image']._id}}">
                    <input type="hidden" name="name" value="{{vd['image'].nicename}}">
                    <input type="submit" class="btn btn-primary" value="Add to basket" />
                </form>
            </div>
            <div class="clearfix"></div>
        </div>


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
