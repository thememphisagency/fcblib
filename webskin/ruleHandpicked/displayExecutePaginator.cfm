<!--- @@displayname: Content with Paginator --->

<cfimport taglib="/farcry/core/tags/webskin" prefix="skin" />
<cfimport taglib="/farcry/plugins/fcblib/tags/fcb/ui" prefix="ui" />

<cfparam name="url.currentPage" type="numeric" default=1 />
<cfparam name="stParam.bShowJS" type="boolean" default=1 />

<cfif arrayLen(stobj.aPickedObjects)>

	<cfsavecontent variable="sURL"><ui:buildLink objectid="#request.navid#" urlOnly="1" /></cfsavecontent>
	
	<cfset sRuleId = "r#replaceNoCase(stObj.objectid, '-','', 'all')#" />
	<cfset numItems = 1 />
	<cfset request.iRuleTotalItems = arrayLen(stobj.aPickedObjects) />
	<cfset iTotal = request.iRuleTotalItems />
	
	<cfif url.currentPage GT 1>
		<cfset url.startRow = (url.currentPage -1) * numItems + 1 >
	<cfelse>
		<cfset url.startRow = 1 />	
	</cfif>	
	
	<cfset url.endRow = url.startRow + numItems - 1 />
	
	<cfset sPaginator = '' />
	<cfset sPaginatorClass = '' />
	<cfif iTotal GT numItems>
		<cfset sPaginatorClass = ' hasPaginator' />
		<cfset oUtilities = request.fcbObjectBucket.create(fullPath="farcry.plugins.fcblib.packages.custom.utility") />
		<cfsavecontent variable="sPaginator">
			<cfoutput>
			<div class="carousel">	
				<p class="pagination">
					#oUtilities.renderPaging(currentPage=url.currentPage,
												maxRows=numItems,
												totalRecs=iTotal,
												maxPaging=10,
												url="#trim(sURL)#",
												anchor="###sRuleId#",
												urlHasParam=0)#
				</p>
			</div>	
			</cfoutput>
		</cfsavecontent>			
	</cfif>	


	<cfif stParam.bShowJS>	
		<cfoutput>
		<script type="text/javascript">
			//<![CDATA[
			
			//SET UP GLOBAL VARIABLES
	       	#sRuleId# = new Object();
			#sRuleId#.divId = '###sRuleId#';
			#sRuleId#.bPaginate = 1;
			#sRuleId#.objectid = '#stObj.objectid#';
			#sRuleId#.total = #iTotal#;
			
			jQuery(document).ready(function(){
				#sRuleId#_assignPagination(jQuery(#sRuleId#.divId));			
			});
			
			function #sRuleId#_assignPagination (obj) {
				
				obj.find("p.pagination a,p.pagination span").click(function(){

					if (#sRuleId#.bPaginate == 1) {
						var sURL = '/apps/ajaxPaginatorHandpicked.cfm';
						
						if(jQuery(this).attr("href") == undefined){
							
							/*since href is not defined, this must be a span element, check if this is a prev or next 
								button and add the associated data for the ajax url. */
								
							if(jQuery(this).hasClass('next'))
								sURL += '?currentPage=1';
							else if(jQuery(this).hasClass('prev'))
								sURL += '?currentPage=' + #sRuleId#.total;
														
							sURL += '&ruleId=' + #sRuleId#.objectid + '&navid=#request.navid#';	
							
						}
						else{
							
							var aHref = jQuery(this).attr("href").split("##");
							
							//Fixed IE6 issue where it prepends the domain URL to each url in the response 
							aHref[0] = aHref[0].replace('http://#CGI.SERVER_NAME#','');
								
							sURL = "/apps/ajaxPaginatorHandpicked.cfm" + aHref[0] + "&ruleId=" + #sRuleId#.objectid + '&navid=#request.navid#';
		
						}
						
						#sRuleId#_setPaginatorStatus(0);

						jQuery.ajax({
							type: "GET",
							url: sURL,
							success: function(response){
						  	 	#sRuleId#_parseAjaxContent(obj,trim(response));
						  	 	#sRuleId#_assignPagination(obj);
								assignTeaserHover('##teasers li.teaser');
								#sRuleId#_setPaginatorStatus(1);
							},
							error : function (XMLHttpRequest, textStatus, errorThrown){
								alert('An error has occurred please try again later.');
								//alert('XMLHttpRequest: ' + XMLHttpRequest + ' textStatus: '+ textStatus + ' errorThrown: ' + errorThrown);
							}		 
						});
						
					}
					
					return false;	
				});
			}
			
			function #sRuleId#_parseAjaxContent(obj,responseObj){
				obj.html(trim(responseObj));
			}
			
			function #sRuleId#_setPaginatorStatus(bool) {
				#sRuleId#.bPaginate = bool;
			}
			
			//]]>		
		</script>		
			
		</cfoutput>
	</cfif>
	
	<cfoutput>	
	<div id="#sRuleId#" class="module#sPaginatorClass#">
	</cfoutput>

		<cfloop from="#url.startRow#" to="#url.endRow#" index="i">
			<cfset request.i = i />		
			<skin:view objectID="#stobj.aPickedObjects[i].data#" typename="#stobj.aPickedObjects[i].typename#" webskin="#stobj.aPickedObjects[i].webskin#" alternateHTML="<p>WEBSKIN NOT AVAILABLE</p>" />
		</cfloop>
		
	<cfoutput>
		#sPaginator#
	</div>
	</cfoutput>
	
</cfif>

<cfsetting enablecfoutputonly="false" />