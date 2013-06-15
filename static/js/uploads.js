$(document).ready(function() {
     //return
         
     $('#id_filename').uploadify({
         'uploader'  : '/static/js/uploadify/uploadify.swf',
         'script'    : '/admin/images/add',
         'cancelImg' : '/static/js/uploadify/cancel.png',
         'folder'    : '/uploads',
         'auto'      : false,
         'multi'		: true,
         'fileDataName':'filename',
         'fileExt'     : '*.jpg;*.gif;*.png;*.JPG;*.GIF;*.PNG',
         'fileDesc'    : 'Image Files',
         'scriptData': {},
         'onAllComplete':function(){
             window.location = '/admin/images'
         }
     });
     
     $('#submit_image').click(function(ev){
         ev.preventDefault();
         
         var objData = {
             category :  $('#id_category')[0].value
         }
         /*
         if( $('#id_description')[0] && $('#id_description')[0].value != '' ) objData.description = $('#id_description')[0].value;
         */
         $('#id_filename').uploadifySettings('scriptData',objData);
         $('#id_filename').uploadifyUpload();
     })
     
     
 });