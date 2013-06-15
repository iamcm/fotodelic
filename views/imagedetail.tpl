
<div class="image-detail">
    <div>
        <script src="http://connect.facebook.net/en_US/all.js#xfbml=1"></script>
        <fb:like href="?" layout="standard" show_faces="false" font="arial"></fb:like>
        
        <span class="right mypagination">
            %if vd['previous']:
            <a class="p10" href="/gallery/{{vd['slug']}}/{{vd['previous']}}">&lt;Previous</a>
            %end
            
            %if vd['next']:
            <a class="p10" href="/gallery/{{vd['slug']}}/{{vd['next']}}">Next&gt;</a>
            %end
        </span>
        <div class="clear"></div>
    </div>
    
    <img class="theimage" src="/static/{{vd['image'].filepath}}"/>
    
    
    <hr />
    
    <form class="form-horizontal" method='POST' action="/gallery/{{vd['slug']}}/{{vd['image']._id}}/comment">

        <div class="control-group">
            <label class="control-label" for="name">Name</label>
            <div class="controls">
                <input type="text" class="input-xlarge" name="name" id="name" placeholder="Anonymous" />
            </div>
        </div>

        <div class="control-group">
            <label class="control-label" for="name">Comment</label>
            <div class="controls">
              <textarea id="id_comment" rows="3" name="comment"  class="input-xlarge"></textarea>
            </div>
        </div>
        
        <div class="control-group">
            <div class="controls">
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


%rebase base_public vd=vd
