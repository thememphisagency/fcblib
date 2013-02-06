<cfsetting enablecfoutputonly="true" />
<!--- @@Copyright: Daemon Pty Limited 2002-2008, http://www.daemon.com.au --->
<!--- @@License:
    This file is part of FarCry CMS Plugin.

    FarCry CMS Plugin is free software: you can redistribute it and/or modify
    it under the terms of the GNU Lesser General Public License as published by
    the Free Software Foundation, either version 3 of the License, or
    (at your option) any later version.

    FarCry CMS Plugin is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
    GNU Lesser General Public License for more details.

    You should have received a copy of the GNU Lesser General Public License
    along with FarCry CMS Plugin.  If not, see <http://www.gnu.org/licenses/>.
--->

<cfimport taglib="/farcry/core/tags/webskin" prefix="skin" />
<cfimport taglib="/farcry/core/tags/formtools" prefix="ft" />

	<cfset q = getRuleData(stObj) />
	
	<cfif q.recordCount GT 0>
		
		<cfset sRuleId = "r#replaceNoCase(stObj.objectid, '-','', 'all')#" />
		
		<cfif stObj.bArchive>

			<cfif len(stObj.scrollInterval) EQ 0>
				<!--- Data default doesn't work, so let's set it to default of 3 intially --->
				<cfset stObj.scrollInterval = 3 />
			</cfif>
			<cfif len(stObj.sliderSpeed) EQ 0>
				<!--- Data default doesn't work, so let's set it to default of 3 intially --->
				<cfset stObj.sliderSpeed = 1.5 />
			</cfif>
				
			<!--- Javascript required for the rotating effects --->		
			<cfoutput>
		    <script type="text/javascript">
			    <!--- Wrap all javascript content in a CDATA section so that any html syntaxs in the script are ignore by the W3C validator --->
				//<![CDATA[
				       		        			        	     			
		        	//SET UP GLOBAL VARIABLES
		        	//Set initail value for screen height
		        	#sRuleId# = new Object();
		        	#sRuleId#.divId = '###sRuleId#';
		        	#sRuleId#.iScreenPosition = 0;					
					#sRuleId#.iNumberOfItems = 0;
		        	//Number of item to be displayed in each slide
					<cfif stObj.sliderDirection EQ 'horizontal'>
						#sRuleId#.iDisplayNum = 1;
					<cfelse>
			        	#sRuleId#.iDisplayNum = #int(stObj.numItems)#;
					</cfif>	

		        	//Slide counter
		        	#sRuleId#.iCount = #sRuleId#.iDisplayNum;	   
			        #sRuleId#.aItems = new Array();
	
					/*--Global variables for horizontal scrolling--*/
					#sRuleId#.iItemWidth = 0;
					//Set default value
					#sRuleId#.iTotalWidth = 0;
					#sRuleId#.iCurrentPos = 0;
					#sRuleId#.iSlidingWidth = 0;
		  	  	
			        #sRuleId#.iInitialHeight = 0;     
			        #sRuleId#.bScrolling = 0; 
					#sRuleId#.bInitAutoSlide = 0;
					#sRuleId#.sliderDirection = '#stObj.sliderDirection#';
					#sRuleId#.sliderSpeed = #int(stObj.sliderSpeed) * 1000#;
					<!--- Get scrolling interval in miliseconds --->
					#sRuleId#.scrollInterval = #int(stObj.scrollInterval) * 1000#;

			        
			        jQuery(document).ready(function(){
			        	
			        	if((jQuery('body').attr('class')).indexOf('browserSafar') < 0){
				 			//Only check if css is disabled for other browsers accept safari, if CSS is disabled, stop all javascript executions
					       	if(jQuery('##wrap').css('fontSize') == '16px'){
					       		return;
					       	}       	
			        	}	
			        			        	
						var queryObj = jQuery(#sRuleId#.divId);

		        		//Number of items in the slider
		        		#sRuleId#.iNumberOfItems = queryObj.find('.slider').children().length;
			      	  	//Retrieve a jQuery object that contains an array of all the items in the slider
						#sRuleId#.aItems = queryObj.find('.slider').children();   
						
						if(#sRuleId#.sliderDirection == 'horizontal'){
							queryObj.find('.slider').addClass('horizontal');
						
							//Get item width and totalWidth
							#sRuleId#.iItemWidth = #sRuleId#.aItems[0].offsetWidth;
				        	for(var i = 0; i < #sRuleId#.aItems.length; i++){
				        		#sRuleId#.iTotalWidth += #sRuleId#.aItems[i].offsetWidth;
				        	}
							queryObj.find('.horizontal').width(#sRuleId#.iTotalWidth);						
						}	

						//if the set of number of items to be displayed per slide is greater than the total number of items, we should reset the iDisplayNum
						if(#sRuleId#.iDisplayNum >#sRuleId#.iNumberOfItems)
							#sRuleId#.iDisplayNum = #sRuleId#.iNumberOfItems;
											
			        	layoutSlider(#sRuleId#);
			        	loadPageNumber(#sRuleId#);			
			        		        					
						//this will return the total height (including padding and margin) of the DOM element from the array inside jquery object aItems for the first set of items
						//to be displayed.
			
			        	for(var i = 0; i < #sRuleId#.iDisplayNum; i++){
			        		#sRuleId#.iInitialHeight += #sRuleId#.aItems[i].offsetHeight;
			
			        	}
			
			        	//Set initial height of the viewing frame to be the same as first item		        	
			        	queryObj.find('.viewFrame').height(#sRuleId#.iInitialHeight);
			        	
						queryObj.find('.prevAnnouce').click(function(){
							prevScreen(#sRuleId#);
							return false;				
						});
			
						queryObj.find('.nextAnnouce').click(function(){
							nextScreen(#sRuleId#);
							return false;							
						});
						
						<cfif stObj.bAutoScroll>autoScroll(#sRuleId#);</cfif>
					});
					
				<cfif NOT structKeyExists(request, 'bRulePaginatorAnimateByType')>
					
					function autoScroll(obj){
						if(obj.bInitAutoSlide==1){ // we have set this to 0 initially as we want the random start to do the first scroll...
							nextScreen(obj);
						}	
						obj.bInitAutoSlide=1;
						var t = setTimeout(function(){autoScroll(obj);}, obj.scrollInterval);
					}
									
					function prevScreen(obj){

						if(obj.sliderDirection == 'horizontal'){
							//Since we are at first screen, let's break of the function
							if(obj.iSlidingWidth <= 0)
								return;
						}	

						if(obj.bScrolling==0){
							obj.bScrolling=1;
							var sButtonState = jQuery(obj.divId).find('.prevAnnouce').attr("class");
							
							//if prev button is inactive, don't rotate the content
							if(sButtonState == 'prevInactive')
								return;
														
							//working out the height of the viewFrame
							var iScreenHeight = 0;
							//Retrieve height of the previous item
							var iNewInterval = 0;
							var emValue = '0.0em';
			
							if(obj.iCount < 0){
								obj.iScreenPosition = 0;
								obj.iCount = obj.iDisplayNum;
							}
							else{
								
								var iIterator = obj.iCount - 1 - obj.iDisplayNum;
				
								for(var i = iIterator; i > iIterator - obj.iDisplayNum; i--){								
									//obj.aItems[obj.iCount - 2].offsetHeight;
				        			iNewInterval += obj.aItems[i].offsetHeight;     			
				        		}
				
								
								if( (iIterator >=  0) && (iIterator - obj.iDisplayNum >= 0) ){
									for(var i = iIterator; i > (iIterator - obj.iDisplayNum); i--){
										 iScreenHeight += obj.aItems[i].offsetHeight;
									}
									
									//Convert value to em
									//emValue = iScreenHeight.pxToEm({scope: 'body'});
									emValue = iScreenHeight;
								
									jQuery(obj.divId).find('.viewFrame').animate({height: emValue}, obj.sliderSpeed);		
								}
								else{
									//Convert value to em
									//emValue = obj.iInitialHeight.pxToEm({scope: 'body'});	
									emValue = obj.iInitialHeight;
														
									//Reset the height of the view frame to height of the first item
									jQuery(obj.divId).find('.viewFrame').animate({height: emValue}, obj.sliderSpeed);	
								}				
							
								obj.iScreenPosition = jQuery(obj.divId).find('.slider').css("top");
								//Retrive the value of the current position of the slider
								obj.iScreenPosition = obj.iScreenPosition.replace("px","");	
								//Increment the position to slide the screen downward					
								obj.iScreenPosition = parseInt(obj.iScreenPosition) + parseInt(iNewInterval);
			
								obj.iCount -= obj.iDisplayNum;  		
							}
												
							loadPageNumber(obj);
	
							if(obj.sliderDirection == 'horizontal'){
								if(obj.iSlidingWidth > 0){
									obj.iCurrentPos += obj.iItemWidth; 	
									obj.iSlidingWidth -= obj.iItemWidth;	
									jQuery(obj.divId).find('.slider').animate({left: obj.iCurrentPos}, obj.sliderSpeed, function(){ obj.bScrolling=0; updatePaginatorState(obj); } );										
								}													
							}
							else{
								//Hide prev button if slide is at the beginning displaying item one.
								if(obj.iCount == obj.iDisplayNum){
									jQuery(obj.divId).find('.prevAnnouce').removeClass('prevActive');
									jQuery(obj.divId).find('.prevAnnouce').addClass('prevInactive');					
								}
								else{
									jQuery(obj.divId).find('.prevAnnouce').removeClass('prevInactive');
									jQuery(obj.divId).find('.prevAnnouce').addClass('prevActive');
								}
								jQuery(obj.divId).find('.slider').animate({top: obj.iScreenPosition}, obj.sliderSpeed, function(){ obj.bScrolling=0;} );								
							}
									
						}
					}
		
					function nextScreen(obj){

						if(obj.sliderDirection == 'horizontal'){
							//Since we are on the last screen, let's go back to the start
							if(obj.iSlidingWidth + obj.iItemWidth >= obj.iTotalWidth) {
								jQuery(obj.divId).find('.slider').css('left',0);
								obj.iCurrentPos = 0;
								obj.iSlidingWidth = 0;
								obj.iCount = 1;
								loadPageNumber(obj);
								updatePaginatorState(obj);
								return;
							}
						}

						if(obj.bScrolling==0){
							obj.bScrolling=1;
							//Start height for viewing frame
							var iScreenHeight = 0;
							//Retrieve height of the previous set of items defined by iDisplayNum
							var iNewInterval = 0;
														
							if(obj.iCount >= obj.iNumberOfItems){
								obj.iScreenPosition = 0;
								obj.iCount = obj.iDisplayNum;
								
								//Convert value to em
								//emValue = obj.iInitialHeight.pxToEm({scope: 'body'});
								emValue = obj.iInitialHeight;
														
								jQuery(obj.divId).find('.viewFrame').animate({height: emValue}, obj.sliderSpeed);
							}		
			
							else{	
								for(var i = obj.iCount-1; i >= obj.iCount - obj.iDisplayNum; i--){
				
				        			iNewInterval += obj.aItems[i].offsetHeight;     			
				        		}
								//alert(iNewInterval);
								if( (obj.iCount >=  0) && ((obj.iCount) + obj.iDisplayNum < obj.iNumberOfItems) ){				
									//Deduct 1 form iCount because js array starts at position 0	
									for(var i = obj.iCount; i < ((obj.iCount) + obj.iDisplayNum); i++){					
										 iScreenHeight += obj.aItems[i].offsetHeight;
									}	
								}
								
								else if(obj.iCount + obj.iDisplayNum >= obj.iNumberOfItems){
									var iRemove = (obj.iCount + obj.iDisplayNum) - obj.iNumberOfItems;
									for(var i = obj.iCount; i < ((obj.iCount - iRemove) + obj.iDisplayNum); i++){					
										 iScreenHeight += obj.aItems[i].offsetHeight;
									}		
								}
									
								else{
									//Reset the height of the view frame to height of the first item
									iScreenHeight = obj.iInitialHeight;
								}
			
								//emValue = iScreenHeight.pxToEm({scope: 'body'});
								emValue = iScreenHeight;
	
								jQuery(obj.divId).find('.viewFrame').animate({height: emValue}, obj.sliderSpeed);	
								
								obj.iScreenPosition = jQuery(obj.divId).find('.slider').css("top");
								//Retrive the value of the current position of the slider
								obj.iScreenPosition = obj.iScreenPosition.replace("px","");
								//Decrement the position to slide the screen upward
								//alert('iScreenPosition before: '+iScreenPosition);
								obj.iScreenPosition = parseInt(obj.iScreenPosition) - parseInt(iNewInterval);
								//alert('obj.iScreenPosition after '+iScreenPosition);
								obj.iCount += obj.iDisplayNum;  
							}
							
							loadPageNumber(obj);

							if(obj.sliderDirection == 'horizontal'){
								if(obj.iSlidingWidth + obj.iItemWidth <= obj.iTotalWidth ){			
									obj.iCurrentPos += -obj.iItemWidth;
									obj.iSlidingWidth += obj.iItemWidth;					
									jQuery(obj.divId).find('.slider').animate({left: obj.iCurrentPos}, obj.sliderSpeed, function(){ obj.bScrolling=0; updatePaginatorState(obj); } );	
								}								
							}	
							else{
								//Hide prev button if slide is at the beginning displaying item one.
								if(obj.iCount == obj.iDisplayNum){
									jQuery(obj.divId).find('.prevAnnouce').removeClass('prevActive');
									jQuery(obj.divId).find('.prevAnnouce').addClass('prevInactive');						
								}
								else{
									jQuery(obj.divId).find('.prevAnnouce').removeClass('prevInactive');
									jQuery(obj.divId).find('.prevAnnouce').addClass('prevActive');						
								}	
								scrollspeed = obj.sliderSpeed;
								if(obj.iScreenPosition==0){
									scrollspeed = 10;
								}	
											
								jQuery(obj.divId).find('.slider').animate({top: obj.iScreenPosition}, scrollspeed, function(){ obj.bScrolling=0;} );									
							}	

						}
					
					}			
			
					function loadPageNumber(obj){
						var iTotalScreenNum = Math.ceil(obj.iNumberOfItems / obj.iDisplayNum);
						var iCurrentScreenNum = obj.iCount / obj.iDisplayNum;
						var sText = iCurrentScreenNum + ' of ' + iTotalScreenNum;
						jQuery(obj.divId).find('.screenNumber').html(sText);
					}
			
					function layoutSlider(obj){
						//If the total of items to be dipslayed is less than the number of items per slide , do not show paginator
						if(obj.iNumberOfItems <= obj.iDisplayNum)
							return;
		
						var sPaginator = '';
						sPaginator += '<div class="pageWrap"><a href="##" class="prevAnnouce prevInactive"><span>Previous<\/span><\/a>';
						sPaginator += '<a href="##" class="nextAnnouce nextActive"><span>Next<\/span><\/a><\/div>';
						sPaginator += '<p class="screenNumber"><\/p>';
						//Draw divElement for paginatior and screen number
						jQuery(obj.divId).find('.paginator').html(sPaginator);
						jQuery(obj.divId).find('.viewFrame').addClass("setHeight");
						jQuery(obj.divId).find('.slider').addClass('placement');
					}
					
					function updatePaginatorState(obj){						
						//Prev State
						if(obj.iSlidingWidth <= 0){
							jQuery(obj.divId).find('.prevAnnouce').removeClass('prevActive');
							jQuery(obj.divId).find('.prevAnnouce').addClass('prevInactive');
						}	
						else{
							jQuery(obj.divId).find('.prevAnnouce').removeClass('prevInactive');
							jQuery(obj.divId).find('.prevAnnouce').addClass('prevActive');
						}			
					}
					
					<cfset request.bRulePaginatorAnimateByType = 1 />				
					
				</cfif>	
				
				<!--- Closing tag for CDATA  --->	
				//]]>
		    </script>
	
			</cfoutput>
			
			<!--- set num of record to display all records of the query --->
			<cfset iEndRow = q.recordCount />
		<cfelse>	
			<cfset iEndRow = stObj.numItems />
		</cfif>
		
		<cfoutput>
			<div id="#sRuleId#" class="paginatedContent">
				<div class="header">
					<cfif len(trim(stObj.intro)) GT 0>
						<div class="introContent">#stObj.intro#</div>
					</cfif>
					<div class="paginator"></div><!-- ##paginator -->	
				</div><!-- ##header -->	      
				<div class="viewFrame">
					<div class="slider">		
		</cfoutput>		

		<cfloop query="q" startRow="1" endRow="#iEndRow#">
			<cfset request.i = q.currentRow>
			<skin:view objectID="#q.objectid#" typename="#stObj.type#" webskin="#stObj.displaymethod#" alternateHTML="<p>WEBSKIN NOT AVAILABLE</p>" />
		</cfloop>	
	
		<cfoutput>
				</div><!-- ##slider -->	
			</div><!-- ##viewFrame -->		
		</div><!-- ##paginatedContent -->
		</cfoutput>	

	</cfif>

<cfsetting enablecfoutputonly="false" />

<cffunction name="getRuleData" access="private" returntype="query" output="false">
	<cfargument name="ruledata" type="struct" required="true" />
	<cfset var q = queryNew('objectid') />
	
	<!--- check if filtering by categories --->
	<cfif len(trim(arguments.ruledata.metadata)) GT 0>
		
		<cfset sWhereClause = '1=1' />
		<cfset sOrderClause = 'label ASC' />
		
		<cfif arguments.ruledata.bRandomStart>
			<cfset sOrderClause = 'RAND()' />
		<cfelseif arguments.ruledata.type EQ 'dmNews' OR arguments.ruledata.type EQ 'dmEvent'>	
			<cfset sOrderClause = 'publishDate DESC' />
			<cfset sWhereClause = 'publishdate <= #now()# AND (expiryDate >= #now()# OR expiryDate IS NULL)' />
		</cfif>

		<cfset q = application.factory.oCategory.getDataQuery( lCategoryIDs = arguments.ruledata.metadata,
																typename = arguments.ruledata.type,
																sqlWhere = sWhereClause,
																sqlOrderBy = sOrderClause ) />		
		
		
	<cfelse>
	
		<cfquery name="q" datasource="#application.dsn#">
			SELECT objectid
			FROM #arguments.ruledata.type#
			WHERE status = 'Approved'
			
			<cfif arguments.ruledata.type EQ 'dmNews' OR arguments.ruledata.type EQ 'dmEvent'>
				AND publishdate <= #now()#
				AND (expiryDate >= #now()# OR expiryDate IS NULL)		
			</cfif>
			
			<cfif arguments.ruledata.bRandomStart>
				ORDER BY RAND()
			</cfif>
		</cfquery>	
		
	</cfif>
	
	<cfreturn q />
</cffunction>