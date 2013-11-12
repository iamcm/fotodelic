
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


function positionHomepageText(){
    if($(window).width() > 768){

        var h = $('.homepage-text').height() + 40;
        var w = $('.homepage-text').width() + 40;

        $('.homepage-text').css({
            'position':'fixed',
            'top':'100%',
            'left':'100%',
            'margin-top': '-'+ h +'px',
            'margin-left': '-'+ w +'px'
        });
    }else {

        $('.homepage-text').attr('style','');
    }

}

$(document).ready(function(){
    positionHomepageText();
    setTimeout(function(){
        positionHomepageText();        
    },10);
});

$(window).on('resize', function(){
    positionHomepageText();
});