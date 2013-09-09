

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
        
        <form autocomplete="off" class="form-horizontal" method='POST' action="/gallery/{{vd['slug']}}/{{vd['image']._id}}/comment">

            <div class="form-group">
                <label class="control-label col-sm-2" for="name">Name</label>
                <div class="col-sm-5">
                    <input type="text" class="form-control" name="name" id="name" placeholder="Anonymous" />
                </div>
            </div>

            <div class="form-group">
                <label class="control-label col-sm-2" for="name">Comment</label>
                <div class="col-sm-5">
                  <textarea id="id_comment" name="comment"  class="form-control"></textarea>
                </div>
            </div>
            
            <div class="form-group">
                <div class="col-sm-offset-2 col-sm-1">
                    <button type="submit" class="btn btn-info">Add comment</button>
                </div>
            </div>
            
        </form>
        


        %for c in vd['comments']:
        <div class="comment">
            <h4>
                <span class="right">{{c.niceAdded()}}</span>
                {{c.name}}
            </h4>
            <p>{{c.comment}}</p>
        </div>
        %end
    </div>
</div>

%rebase base_public vd=vd
