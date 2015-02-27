// Convert divs to queue widgets when the DOM is ready
$(function() {
    var uploader = $("#uploader").pluploadQueue({
        // General settings
        runtimes : 'html5,flash',
        url : '/admin/image',
        max_file_size : '10mb',
        //chunk_size : '1mb',
        unique_names : true,
        multipart_params : {},
        // Resize images on clientside if we can
        //resize : {width : 320, height : 240, quality : 90},

        // Flash settings
        flash_swf_url : '/static/plupload/js/plupload.flash.swf',

        // PreInit events, bound before any internal events
        preinit : {
            UploadFile: function(up, file) {
                up.settings.multipart_params = {"catId":$('#id_category option:selected').val()};
            }
        },

        init : {
            UploadComplete: function(up) {
                window.location = '/admin/images';
            },
        }
    });

});