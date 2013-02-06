
/*
 * Superbump v0.1b - jQuery plugin
 *
 * Dual licensed under the MIT and GPL licenses:
 * 	http://www.opensource.org/licenses/mit-license.php
 * 	http://www.gnu.org/licenses/gpl.html
 *
 *
 * This plugin automatically adjusts submenu widths of suckerfish-style menus to that of
 * their longest list item children. If you use this, please expect bugs and report them
 * to the jQuery Google Group with the word 'Superfish' in the subject line.
 *
 */

;(function($){ // $ will refer to jQuery within this closure

	$.fn.superbump = function(options){
		// return original object to support chaining
		
		return this.each(function() {
			var $$ = $(this);
			pos = 15;
			
			$LIs = $$.children('li');
			
			//loop first level nav
			$LIs.each(function(i) {
				
				//get node width
				nodewidth = $(this).width();

				//get total node tree width
				x = 0;
				x = x + pos;
				
				// console.log($(this).children('a').html() + ': ' + x);
				
				$ULs = $(this).find('>ul');
				
				
				// Second Level Navigation
				$ULs.each(function(y) {	
					secondLevelWidth = x + $(this).width();
					//console.log( $(this).siblings('a').html() + ' - secondLevelWidth: ' + secondLevelWidth);
					
					// Third Level Navigation
					$(this).children('li').find('>ul').each(function() {
						
						thirdLevelWidth = secondLevelWidth + $(this).width();
						//console.log( $(this).siblings('a').html() + ' - thirdLevelWidth: ' + thirdLevelWidth);
						
					 	offset = $(this).parent().css('width');
				 		if (thirdLevelWidth > pageWidth ) {
				 			offset = '-' + $(this).css('width');
				 		};
				 		$(this).css('left', offset);
						
						
						// Fourth Level Navigation
						$(this).children('li').find('>ul').each(function() {
							
							fourthLevelWidth = thirdLevelWidth + $(this).width();
							//console.log( $(this).siblings('a').html() + ' - fourthLevelWidth: ' + fourthLevelWidth);
							
							offset = $(this).parent().css('width');
							if (fourthLevelWidth > pageWidth ) {
					 			offset = '-' + $(this).css('width');
					 		};
					 		$(this).css('left', offset);
							
						})
						
					})
					
				});
				
				//set end position
				pos = pos + nodewidth;
			
			});
		});
	};
	
	$.fn.extend({
		bThirdLevel : function(el){
			
			return this;
		},
		bFourthLevel : function(el){
			
			
			return this;
		}
	});
	
})(jQuery); // plugin code ends
