
/*
*
* fcbNav
*
*/

;(function($){
	
	$.fcbNav = {};
	$.fcbNav.defaults = {
		hoverClass	: 'sfHover',
		delay		: 400,
		
		// callback functions:
		onInit		: function(){},
		onBeforeShow: function(){},
		onShow		: function(){},
		onHide		: function(){}
	};
	
	$.fn.fcbNav = function() {
		
		return this.each(function() {

            dm = jQuery(this),
            li = dm.children('li'),
            anchor = li.children('a'),
            navWidth = dm.parent('div')[0].clientWidth,
            totalWidth = 0,
            numTabs = li.size();
			ULs = dm.find('ul');
            
			var fontsize = jQuery('<li id="menu-fontsize">&#8212;</li>').css({
				'padding' : 0,
				'position' : 'absolute',
				'top' : '-999em',
				'width' : 'auto'
			}).appendTo(dm).width(); //clientWidth is faster, but was incorrect here
			// remove em dash
			$('#menu-fontsize').remove();
            
            li.each(function(i) {
            	totalWidth += $(this).outerWidth(true);
            });
            
            totalExpand = (navWidth - totalWidth) / numTabs;
            roundedExpand =  parseInt(totalExpand);
            
            remainder = Math.floor((totalExpand - roundedExpand) * numTabs);
            
            
            anchor.each(function(i) {
    			
                width = roundedExpand + $(this).width();
              
                if(i === (numTabs-1)) {
                    width += remainder;
                }
                $(this).css({ width:width + "px" });
    		});
    		
			// loop through each ul in menu
			ULs.each(function(i) {	
				var ul = ULs.eq(i);
				
				var LIs = ul.children();
				var As = LIs.children('a');

				var liFloat = LIs.css('white-space','nowrap').css('float');
				var emWidth = ul.add(LIs).add(As).css({
					'float' : 'none',
					'width'	: 'auto'
				})
				.end().end()[0].clientWidth / fontsize;
				emWidth += 1;
				
				if (emWidth > 25)		{ emWidth = 25; }
				else if (emWidth < 12)	{ emWidth = 12; }
				emWidth += 'em';
				
				ul.css('width',emWidth);
				
				LIs.css({
					'float' : liFloat,
					'width' : '100%',
					'white-space' : 'normal'
				})
				.each(function(){
					var $childUl = $('>ul',this);
					
					var offsetDirection = 'left';
					$childUl.css(offsetDirection,emWidth);
				});
			
				
			});
    		
    		
			if ($.browser.msie && parseInt($.browser.version) <= 6) {
				$('li',this).hover(function() {
					$(this).addClass('sfHover');
				}, function() {
					$(this).removeClass('sfHover');
				})
			};
		  	
		});
		
	};
})(jQuery);