<cfsetting enablecfoutputonly="true" />
<!--- @@Copyright: Enpresiv 2004-2008, http://www.enpresiv.com --->
<!--- @@License: --->
<!--- @@displayname: contentByCategory rule execute --->

<cfimport taglib="/farcry/core/tags/webskin" prefix="skin" />
<cfimport taglib="/farcry/plugins/fcblib/tags/fcb/ui" prefix="ui" />

<cfparam name="url.criteria" type="string" default="#application.config.fcbWebsite.searchBoxDefaultText#" />
<cfparam name="url.sortBy" type="string" default="date_latest" />
<cfparam name="url.currentPage" type="numeric" default=1 />

<cfset sDisplayTeaser = stObj.displayMethod />
<cfset oLucene = createObject("component","farcry.plugins.fcblib.packages.custom.lucene") />

<cfset lObjIds = '' />
<cfset oCat = application.factory.oCategory />
<cfset qFirstResults = queryNew("title, label, body, teaser, keywords, objectid, typename, score") />
<cfset qResults = queryNew("objectid, typename, label, datetimelastupdated,sortCol") />
<cfset bShowDescendantData = true />
<cfset bHasCriteria = false />

<cfset qTypeName = queryNew('typename') />
<cfset sRuleId = "r#replaceNoCase(stObj.objectid, '-','', 'all')#" />

<cfsavecontent variable="sURL"><ui:buildLink objectid="#request.navid#" urlOnly="1" /></cfsavecontent>

<!--- Set up a list of types to search for --->
<cfloop collection="#application.types#" item="key">
	<cfset stType = application.types[key] />
	
	<cfif structKeyExists(stType, 'bPaginatorSearchByCategory')>
		<cfset temp = QueryAddRow(qTypeName, 1) />
		<cfset temp = QuerySetCell(qTypeName, "typename", '#key#') />			
	</cfif>	 
</cfloop>	

<cfif url.criteria EQ application.config.fcbWebsite.searchBoxDefaultText>
	<cfset url.criteria = '' />
</cfif>

<cfif len(url.criteria) GT 0>
	<!--- If a search criteria keyword has been provide search lucene collection for keyword --->
	<cfset qFirstResults = oLucene.searchCollection(url.criteria)>
	<cfset bHasCriteria = true />
	<!--- Retrieve a list of typename from the search result above --->		
	<cfif qFirstResults.recordCount GT 0>
		<cfquery name="qTypeName" dbtype="query">
			SELECT typename
			FROM qFirstResults
			GROUP BY typename	
		</cfquery>
	</cfif>
</cfif>	

<cfif len(stObj.lSelectedCategoryID) GT 0>
	<!--- If a specific category has been selected, we want to return results just for that category --->
	<cfset bShowDescendantData = false />
</cfif>

<!--- filter on these categories. --->
<cfif len(stObj.lSelectedCategoryID)> 

	<cfif qTypeName.recordCount GT 0>
	
		<cfif qFirstResults.recordCount GT 0>	
			<!--- If a search criteria exists and that it returns a query of results, we want filter them by category --->
			<cfloop query="qTypeName">
				<!--- Retrieve objectids of each type in the listed categories --->
				<cfset qLookup = oCat.getDataQuery(lcategoryIds=stObj.lSelectedCategoryID,typename='#qTypeName.typename#',bHasDescendants=bShowDescendantData)>
				<cfif qLookup.recordCount GT 0>
					<cfset lTemp = QuotedValueList(qLookup.objectid)>
					<!--- Retrieve the objects in list to get the label, datetimelastupdate for sorting --->
					<cfif qTypeName.typename EQ 'dmNews' OR qTypeName.typename EQ 'dmEvent' OR qTypeName.typename EQ 'fcbJob'>
						<cfquery name="qTemp" datasource="#arguments.dsn#">
							SELECT objectid, label, publishDate AS datetimelastupdated, '#qTypeName.typename#' AS typename, upper(label) AS sortCol
							FROM #qTypeName.typename#
							WHERE objectid IN (#preserveSingleQuotes(lTemp)#)
							AND (expiryDate > #createODBCDateTime(now())# OR expiryDate IS NULL)
							AND publishDate <= #createODBCDateTime(now())#
						</cfquery>		
					<cfelse>
						<cfquery name="qTemp" datasource="#arguments.dsn#">
							SELECT objectid, label, datetimelastupdated, '#qTypeName.typename#' AS typename, upper(label) AS sortCol
							FROM #qTypeName.typename#
							WHERE objectid IN (#preserveSingleQuotes(lTemp)#)
						</cfquery>	
					</cfif>	
		
					<cfloop query="qTemp">					
						<cfset temp = QueryAddRow(qResults, 1)>
						<cfset temp = QuerySetCell(qResults, "objectid", '#uCase(qTemp.objectid)#')>
						<cfset temp = QuerySetCell(qResults, "typename", '#qTemp.typename#')>
						<cfset temp = QuerySetCell(qResults, "label", '#qTemp.label#')>
						<cfset temp = QuerySetCell(qResults, "datetimelastupdated", '#qTemp.datetimelastupdated#')>
						<cfset temp = QuerySetCell(qResults, "sortCol", '#qTemp.sortCol#')>
					</cfloop>
				</cfif>				
				
			</cfloop>
						
			<cfset lObjIds = uCase(QuotedValueList(qFirstResults.objectid))>
			
			<!--- Filter search result to return records that has the same objectid in the list --->
			<cfquery name="qTempResult" dbtype="query">
				SELECT *
				FROM qResults
				WHERE objectid IN (#preserveSingleQuotes(lObjIds)#)
				<cfswitch expression="#url.sortBy#">
					<cfcase value="label_asc">
						ORDER BY sortCol ASC
					</cfcase>
					<cfcase value="label_desc">
						ORDER BY sortCol DESC
					</cfcase>	
					<cfcase value="date_oldest">
						ORDER BY datetimelastupdated ASC
					</cfcase>									
					<cfdefaultcase>
						ORDER BY datetimelastupdated DESC
					</cfdefaultcase>
				</cfswitch>				
			</cfquery>
						
			<cfset qResults = qTempResult>	
		
		<cfelseif qFirstResults.recordCount LTE 0 AND bHasCriteria EQ false>
			<!--- Otherwise just retrieve a list of result from the specified category --->
			<cfloop query="qTypeName">
				<!--- Retrieve objectids of each type in the listed categories --->
				<cfset qLookup = oCat.getDataQuery(lcategoryIds=stObj.lSelectedCategoryID,typename='#qTypeName.typename#',bHasDescendants=bShowDescendantData) />
				<!--- Add results to query --->
				<cfif qLookup.recordCount GT 0>
					<cfset lTemp = QuotedValueList(qLookup.objectid)>
					<cfif qTypeName.typename EQ 'dmNews' OR qTypeName.typename EQ 'dmEvent' OR qTypeName.typename EQ 'fcbJob'>
						<cfquery name="qTemp" datasource="#arguments.dsn#">
							SELECT objectid, label, publishDate AS datetimelastupdated, '#qTypeName.typename#' AS typename, upper(label) AS sortCol
							FROM #qTypeName.typename#
							WHERE objectid IN (#preserveSingleQuotes(lTemp)#)
							AND (expiryDate > #createODBCDateTime(now())# OR expiryDate IS NULL)
							AND publishDate <= #createODBCDateTime(now())#
						</cfquery>		
					<cfelse>
						<cfquery name="qTemp" datasource="#arguments.dsn#">
							SELECT objectid, label, datetimelastupdated, '#qTypeName.typename#' AS typename, upper(label) AS sortCol
							FROM #qTypeName.typename#
							WHERE objectid IN (#preserveSingleQuotes(lTemp)#)
						</cfquery>	
					</cfif>	

					<cfloop query="qTemp">					
						<cfset temp = QueryAddRow(qResults, 1)>
						<cfset temp = QuerySetCell(qResults, "objectid", '#qTemp.objectid#')>
						<cfset temp = QuerySetCell(qResults, "typename", '#qTemp.typename#')>
						<cfset temp = QuerySetCell(qResults, "label", '#qTemp.label#')>
						<cfset temp = QuerySetCell(qResults, "datetimelastupdated", '#qTemp.datetimelastupdated#')>
						<cfset temp = QuerySetCell(qResults, "sortCol", '#qTemp.sortCol#')>
					</cfloop>
				</cfif>	
			</cfloop>	
							
			<!--- Sort result, because the sorting for query of a query is sensitive, therefore, we have added the first letter of the label into a new columne
					name sortCol and we'll be sorting the result on this column --->
			<cfquery name="qTempResult" dbtype="query">
				SELECT *
				FROM qResults
 				<cfswitch expression="#url.sortBy#">
					<cfcase value="label_asc">
						ORDER BY sortCol ASC
					</cfcase>
					<cfcase value="label_desc">
						ORDER BY sortCol DESC
					</cfcase>	
					<cfcase value="date_oldest">
						ORDER BY datetimelastupdated ASC
					</cfcase>				
					<cfdefaultcase>
						ORDER BY datetimelastupdated DESC
					</cfdefaultcase>
				</cfswitch> 	
			</cfquery>	

			<cfset qResults = qTempResult>		
			
		</cfif>	
	</cfif>
	
	<cfset numItems = stObj.numItems />
	
	<cfset iTotal = qResults.recordCount />
	<cfif url.currentPage GT 1>
		<cfset url.startRow = (url.currentPage -1) * numItems + 1 >
	<cfelse>
		<cfset url.startRow = 1 />	
	</cfif>	
	<cfset url.endRow = url.startRow + numItems - 1 />

	<!--- If keyword is blank set to display default --->
	<cfif len(url.criteria) LTE 0>
		<cfset url.criteria = application.config.fcbWebsite.searchBoxDefaultText />
	</cfif>	

	<!--- Change double quotes to corrent html entity --->
	<cfif len(url.criteria) GT 0 AND findNoCase('"',url.criteria) GT 0>
		<cfset url.criteria = replaceNoCase(url.criteria, '"', '&quot;', 'all') />
	</cfif>

	<cfoutput>
	<div id="#sRuleId#" class="categorySearch">
		<div class="optionBar">
			<form name="quickSearch" id="quickSearch" method="get" action="#sURL#">				
				<label for="criteria">Enter Keywords</label>
				<input type="text" class="text" name="criteria" id="criteria" placeholder="#application.config.fcbWebsite.searchBoxDefaultText#" value="#url.criteria#" />
				<input type="submit" class="submit" id="quickSearchSubmit" name="quickSearchSubmit" value="Search" />
			</form>
			<form name="searchSort" id="searchSort" method="get" action="#sURL#" >
				<label for="sortBy">Sort By</label>
				<select name="sortBy" id="sortBy">
					<option value="date_latest" <cfif url.sortBy EQ "date_latest">selected="selected"</cfif>>Date - Latest First</option>
					<option value="date_oldest" <cfif url.sortBy EQ "date_oldest">selected="selected"</cfif>>Date - Oldest First</option>
					<option value="label_asc" <cfif url.sortBy EQ "label_asc">selected="selected"</cfif>>Alphabetically A-Z</option>
					<option value="label_desc" <cfif url.sortBy EQ "label_desc">selected="selected"</cfif>>Alphabetically Z-A</option>
				</select>
				<input type="hidden" name="criteria" value="#url.criteria#" />
				<input type="submit" class="submit" id="searchSortSubmit" name="searchSortSubmit" value="Sort" />
			</form>
		</div><!-- .controls -->
	</cfoutput>
	
	<cfset sPaginator = '' />
	<cfset sPaginatorClass = '' />
	<cfif iTotal GT numItems>
		<cfset sPaginatorClass = ' hasPaginator' />
		<cfset oUtilities = createObject("component","farcry.plugins.fcblib.packages.custom.utility") />
		<cfsavecontent variable="sPaginator">
			<cfoutput>
			<p class="pagination">
				#oUtilities.renderPaging(currentPage=url.currentPage,
											maxRows=numItems,
											totalRecs=iTotal,
											maxPaging=10,
											url="#sURL#?criteria=#urlEncodedFormat(url.criteria)#&amp;sortBy=#urlEncodedFormat(url.sortBy)#",
											anchor="###sRuleId#",
											urlHasParam=1)#
			</p>
			</cfoutput>
		</cfsavecontent>					
	</cfif>
	
	<cfif stObj.bAnimate>
		
		<cfoutput>
			<script type="text/javascript">
				//<![CDATA[
				
				//SET UP GLOBAL VARIABLES
	        	#sRuleId# = new Object();
				#sRuleId#.divId = '###sRuleId#';
				#sRuleId#.bPaginate = 1;
				#sRuleId#.iHeight = 0;
				
				var queryObj = jQuery(#sRuleId#.divId);
				
				jQuery(document).ready(function(){
					
					#sRuleId#.iHeight = queryObj.find("##teasers").height();
					queryObj.find("##teasers").wrap('<div id="teasersWrap" style="overflow: hidden; height:' + #sRuleId#.iHeight + 'px" />');
					assignPagination(queryObj);
					
				});
				
				function assignPagination (obj) {
					
					obj.find("p.pagination a").click(function(){
						
						if (#sRuleId#.bPaginate == 1) {
							
							var aHref = jQuery(this).attr("href").split("##");
							var sURL = "/apps/ajaxPaginatorSearchByCategory.cfm" + aHref[0] + "&ruleId=#stObj.objectid###" + aHref[1];
	
							setPaginatorStatus(0);
							
							jQuery.ajax({
								type: "GET",
								url: sURL,
								dataType: "json",
								success: function(response){
							  	 	parseAjaxContent(response);
							  	 	assignPagination(queryObj);
									assignTeaserHover('##teasers li.teaser');
								}
							 
							});
							
						}
						
						return false;	
					});
				}
				
				function parseAjaxContent(responseObj){
					var iHeight = 0;
					var iNewHeight = 0;
					
					queryObj.find("##teasers").addClass("oldTeasers");
					queryObj.find("##teasers").after(responseObj.STEASERS);
					
					#sRuleId#.iHeight = queryObj.find(".oldTeasers").height();
					#sRuleId#.iNewHeight = queryObj.find(".newTeasers").height();
					
					queryObj.find(".oldTeasers").animate({top: -#sRuleId#.iHeight}, "slow");
					queryObj.find(".newTeasers").animate({top: -#sRuleId#.iHeight}, "slow", function() {
						
					   // Animation complete.
					   queryObj.find(".newTeasers").css("top","0");
					   queryObj.find(".oldTeasers").remove();
					   queryObj.find("##teasers").removeClass("newTeasers");
					    
					});
					    
					queryObj.find("##teasersWrap").animate({height: #sRuleId#.iNewHeight}, "slow", function() {
						setPaginatorStatus(1);
					});
					queryObj.find(".pagination").replaceWith(responseObj.SPAGINATOR);
				}
				
				function setPaginatorStatus(bool) {
					#sRuleId#.bPaginate = bool;
				}
				
				//]]>		
			</script>
		</cfoutput>
	</cfif>
	
	<!--- Output results --->	
	<cfoutput>
		<div class="results#sPaginatorClass#">
			</cfoutput>

			<cfif qResults.recordCount IS 0>
				<cfoutput>
				<div class="resultDetails">
					<p>Your search for <span class="criteria">#url.criteria#</span> produced no results.</p>
				</div>
				</cfoutput>
			<cfelseif url.criteria NEQ application.config.fcbWebsite.searchBoxDefaultText>
				<cfoutput>
				<div class="resultDetails">
					<p>Your search for <span class="criteria">#url.criteria#</span> returned <span class="criteria">#qResults.recordCount#</span> results.</p>
				</div>
				</cfoutput>
			<cfelse>
				<cfoutput>
				<div class="resultDetails">
					<p><span class="criteria">#qResults.recordCount#</span> results found.</p>
				</div>
				</cfoutput>
			</cfif>			
			
			<cfoutput>#sPaginator#</cfoutput>	
			
			<cfif qResults.recordCount GT 0>
				<cfoutput><ul id="teasers"></cfoutput>
				
				<!--- From here onward, stObj will be used to store individual objectid data --->
				<cfloop query="qResults" startRow="#url.startRow#" endRow="#url.endRow#">
					<cfset request.i = qResults.currentRow />
					<cfset oType = createObject("component", application.types['#qResults.typename#'].typePath) />
					<cfset stObj = oType.getData(objectid=qResults.objectid) />
					
					<skin:view objectID="#stObj.objectid#" typename="#stObj.typename#" webskin="#sDisplayTeaser#" alternateHTML="<p>WEBSKIN NOT AVAILABLE</p>" />	
				</cfloop>
				
				<cfoutput></ul></cfoutput>
			</cfif>		
				
			<cfoutput>
		</div>
	</div><!-- ##categorySearch -->
	</cfoutput>

</cfif> 		

<cfsetting enablecfoutputonly="false" />