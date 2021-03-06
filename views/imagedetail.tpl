

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

        %if vd['image'].category.payment_scheme_id is not None and vd['image'].category.payment_scheme_id != '':
            <div class="well">
                <div class="col-sm-12">
                    Images you see on this site are watermarked and optimised to provide a low file size and fast loading web pages. The full high quality original copies of these images are available to purchase. These will be emailed to you after payment and provide you with a permanent image file that you can print or share as many times as you like for non-commercial use.
                </div>
                <div class="col-sm-12">
                    <form method="post" action="/basket/add">
                        %for o in vd['payment_options']:
                        <div class="checkbox">
                            <label>
                                <input type="radio" name="option" value="{{o._id}}" > {{o.name}} - £{{o.price}}
                            </label>
                        </div>
                        %end
                        <input type="hidden" name="returnTo" value="{{vd['url']}}">
                        <input type="hidden" name="id" value="{{vd['image']._id}}">
                        <input type="hidden" name="name" value="{{vd['image'].nicename}}">
                        <input type="submit" class="btn btn-primary" value="Add to basket" />
                    </form>
                </div>
                <div class="clearfix"></div>
            </div>
        %end


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
