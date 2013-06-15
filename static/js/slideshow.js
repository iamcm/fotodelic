

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
		
		this.startTimer();
	},
	
	getBodyHeight:function(){
		return parseInt($('#slideshowholder img').css('height')) + 200 + 'px';
	},
	
	setBodyHeight:function(h){
		$('body').css('height', h);
	},
	
	updatePic:function(){
		var self = this;
		this.originalEl.hide();
		$(this.holder).show();
		
		/*
          to prevent the screen scrolling back up to the top when a pic is
		 faded out we need to get the actual body height from before the pic
		 goes (rather than its default of 100%)
		 and assign that height to the body.
		 Then when the next pic is faded in we set body back to 100% so it fits
		 nicely
        */
		self.setBodyHeight(self.getBodyHeight());
		
		$(this.arrEls[this.activePic]).fadeOut(1000,function(){ self.changePic.call(self); });
	},
	
	changePic:function(){
		var self = this;
		
		this.activePic = (this.activePic == (this.lenPics - 1) ) ? 0 : this.activePic + 1 ;
		
		$(this.arrEls[this.activePic]).fadeIn(1000, function(){
				self.setBodyHeight('100%');
			});				
	},
	
	startTimer:function(){
		this.updatePic();
		
		var self = this;		
		setTimeout( function(){ self.startTimer.call(self) },5000);
	}
};

$(document).ready(function(){
	
	Slideshow.init();
	
});



