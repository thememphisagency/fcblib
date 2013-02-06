<cfsetting enablecfoutputonly="true" />

<cfimport taglib="/farcry/core/tags/webskin" prefix="skin" />

<cfparam name="url.criteria" type="string" default="#application.config.fcbWebsite.searchBoxDefaultText#" />
<cfparam name="url.sortBy" type="string" default="date_lastest" />
<cfparam name="url.currentPage" type="numeric" default="1" />
<cfparam name="url.ruleId" type="string" default="" />

<cfset lObjIds = '' />
<cfset oCat = application.factory.oCategory />
<cfset qFirstResults = queryNew("title, label, body, teaser, keywords, objectid, typename, score") />
<cfset qResults = queryNew("objectid, typename, label, datetimelastupdated,sortCol") />
<cfset bShowDescendantData = true />
<cfset bHasCriteria = false />

<cfset oJson = CreateObject("component", "farcry.plugins.fcbLib.packages.custom.json") />
<cfset oRule = CreateObject("component", "farcry.plugins.fcbLib.packages.rules.rulePaginatorSearchByCategory") />

<cfset stObj = oRule.getData(objectid=url.ruleId) />
<cfset sDisplayTeaser = stObj.displayMethod />
<cfset qTypeName = queryNew('typename') />

<cfset stReturn = structNew() />
<cfset stReturn.sPaginator = '' />
<cfset stReturn.sTeasers = '' />

<cfsavecontent variable="sURL"><ui:buildLink objectid="#stObj.objectid#" urlOnly="1" /></cfsavecontent>

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
							AND expiryDate > #createODBCDateTime(now())#
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
						<cfquery name="qTemp" datasource="#application.dsn#">
							SELECT objectid, label, publishDate AS datetimelastupdated, '#qTypeName.typename#' AS typename, upper(label) AS sortCol
							FROM #qTypeName.typename#
							WHERE objectid IN (#preserveSingleQuotes(lTemp)#)
							AND (expiryDate > #createODBCDateTime(now())# OR expiryDate IS NULL)
							AND publishDate <= #createODBCDateTime(now())#
						</cfquery>		
					<cfelse>
						<cfquery name="qTemp" datasource="#application.dsn#">
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
											anchor="##categorySearch",
											urlHasParam=1)#
			</p>
			</cfoutput>
		</cfsavecontent>					
	</cfif>
	
	<cfsavecontent variable="sTeasers">
		<cfoutput>
		<ul id="teasers" class="newTeasers">
		</cfoutput>	
		
		<cfif qResults.recordCount GT 0>
			<!--- From here onward, stObj will be used to store individual objectid data --->
			<cfloop query="qResults" startRow="#url.startRow#" endRow="#url.endRow#">
				<cfset request.i = qResults.currentRow />
				<cfset oType = createObject("component", application.types['#qResults.typename#'].typePath) />
				<cfset stObj = oType.getData(objectid=qResults.objectid) />
				
				<skin:view objectID="#stObj.objectid#" typename="#stObj.typename#" webskin="#sDisplayTeaser#" alternateHTML="<p>WEBSKIN NOT AVAILABLE</p>" />	
			</cfloop>
		</cfif>		
			
		<cfoutput>
		</ul>
		</cfoutput>
	</cfsavecontent>
</cfif>

<cfset stReturn.sPaginator = trim(sPaginator) />
<cfset stReturn.sTeasers = trim(sTeasers) />

<!--- OUTPUT THE RESULT --->
<cfset sReturn = '' />
<cfset sReturn = oJson.encode(data=stReturn) />

<cfoutput>#sReturn#</cfoutput>

<cfsetting enablecfoutputonly="false" />