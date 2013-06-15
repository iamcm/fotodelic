
function toggleHompagePic(el){
    if($(el).text() == 'Set as homepage pic'){
        var url = $(el).data('href') + '1';
        var text = 'Remove from homepage pics';
    } else {
        var url = $(el).data('href') + '0';
        var text = 'Set as homepage pic';
    }

    $.ajax(url,{
            type:'GET',
            complete:function(xhr){
                $(el).text(text);
            }
    })
}
