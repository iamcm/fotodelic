

var Slideshow = {
	originalEl : '',
	holder : '',
	lenPics : 0,
	activePic : 0,
	arrEls : [],
	
	init:function(objSetup){
		this.originalEl = $('#nojs');
		this.holder = $('#slideshowholder')[0];
		this.arrEls = $('#slideshowholder').children();
		this.lenPics = this.arrEls.length;
		this.activePic = Math.floor(Math.random() * (this.lenPics - 1 + 1)) + 1;


		this.startTimer();
	},
	
	updatePic:function(){
		var self = this;
		
		if($(this.arrEls[this.activePic])[0])
		{
			$('#slideshowholder').css('background-image','url('+ ($(this.arrEls[this.activePic])[0]).src +')')
		}
		this.activePic = (this.activePic == (this.lenPics - 1) ) ? 0 : this.activePic + 1 ;
	},
	
	startTimer:function(){
		this.updatePic();
		
		var self = this;		
		setTimeout( function(){ self.startTimer.call(self) },7000);
	}
};

$(document).ready(function(){
	
	Slideshow.init();
	
});



