<cfsetting enablecfoutputonly="true" />
<!--- allow developers to close custom tag by exiting on end --->
<cfif thistag.ExecutionMode eq "end">
	<cfexit method="exittag" />
</cfif>

<cfimport taglib="/farcry/plugins/fcblib/tags/fcb/ui" prefix="ui" />
<cfimport taglib="/farcry/core/tags/webskin" prefix="skin" />

<cfparam name="attributes.criteria" default="">
<cfparam name="attributes.perPage" default="10">
<cfparam name="attributes.currentPage" default="1">

<cfset oLucene = createObject("component","farcry.plugins.fcblib.packages.custom.lucene") />
<cfif len(trim(attributes.criteria)) AND (attributes.criteria NEQ "Enter Keywords...")>	
	
	<cfset qResults = oLucene.searchCollection(attributes.criteria) />
	<cfset stPagination = structNew() />
	<cfset numItems = attributes.perPage />
	<cfset iTotal = qResults.recordCount />
		
    <cfif isDefined("qResults") AND qResults.recordCount gt 0>
	
		<cfif url.currentPage GT 1>
			<cfset url.startRow = (url.currentPage -1) * numItems + 1 >
		<cfelse>
			<cfset url.startRow = 1 />	
		</cfif>	
		<cfset url.endRow = url.startRow + numItems - 1 />

		<cfset sURL = "" />
	
		<cfif iTotal GT numItems>
			<cfset oUtilities = request.fcbObjectBucket.create(fullPath='farcry.plugins.fcblib.packages.custom.utility') />
			<cfset stPagination = oUtilities.renderSmartPagination(
											currentPage=url.currentPage,
											itemsPerPage=numItems,
											totalRecs=iTotal,
											url="#sURL#?criteria=#urlEncodedFormat(attributes.criteria)#",
											anchor="##primary",
											urlHasParam=1,
											enableAjax="true") />
									
		</cfif>

		<cfoutput>		
		<div class="result-details pagination-top">
		 	<p class="result-info">Your search for <span class="criteria">#attributes.criteria#</span> returned <span class="criteria">#iTotal#</span> results across our site.</p>
		 	<div class="row">
		 		<div class="column six">
		 			<cfif structKeyExists(stPagination, "paginationHTML")>#stPagination.paginationHTML#</cfif>
		 		</div>
		 		<div class="column six paginationData" data-criteria="#attributes.criteria#" data-perPage="#attributes.perPage#" data-container=".searchResultsWrapper" data-paginationHandler="ajaxSearchPaginator">
		 			<cfif structKeyExists(stPagination, "pagingHTML")>#stPagination.pagingHTML#</cfif>
		 		</div>
		 	</div>
		</div>
		
		<ul class="result result-search">
		</cfoutput>	
		
	        <!--- output results --->
	        <cfloop query="qResults" startrow="#startRow#" endrow="#endRow#">
				<skin:view objectid="#qResults.objectid#"  typename="#qResults.typename#" template="displaySearch" score="#qResults.score#" />
	        </cfloop>
	        		
		<cfoutput>
		</ul>
		<div class="pagination-bottom result-details">
			<div class="row">
		 		<div class="column six">
		 			<cfif structKeyExists(stPagination, "paginationHTML")>#stPagination.paginationHTML#</cfif>
		 		</div>
		 		<div class="column six paginationData" data-criteria="#attributes.criteria#" data-perPage="#attributes.perPage#" data-container=".searchResultsWrapper" data-paginationHandler="ajaxSearchPaginator">
		 			<cfif structKeyExists(stPagination, "pagingHTML")>#stPagination.pagingHTML#</cfif>
		 		</div>
		 	</div>
		</div>
		</cfoutput>
	
    <cfelse>
        <cfoutput>
			<div class="result-details">
            	<p>Your search for <span class="criteria">#attributes.criteria#</span> produced no results.</p>
			</div>
        </cfoutput>
    </cfif>
	
<cfelse>
	<cfoutput>  
		<div class="result-details"><p>Please enter a search term in the box above.</p></div>
	</cfoutput>
</cfif>
<cfsetting enablecfoutputonly="false" />

