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
	
		<cfif attributes.currentPage GT 1>
			<cfset url.startRow = (attributes.currentPage -1) * numItems + 1 >
		<cfelse>
			<cfset url.startRow = 1 />	
		</cfif>	
		<cfset url.endRow = url.startRow + numItems - 1 />

		<cfset sURL = "" />
		
		<cfset labels = structNew() />
		<cfset labels.prev = '<span class="icon-left-open"></span>'/>
		<cfset labels.next = '<span class="icon-right-open"></span>' />

		<cfif iTotal GT numItems>
			<cfset oUtilities = request.fcbObjectBucket.create(fullPath='farcry.plugins.fcblib.packages.custom.utility') />
			<cfset stPagination = oUtilities.renderSmartPagination(
											currentPage=attributes.currentPage,
											itemsPerPage=numItems,
											totalRecs=iTotal,
											url="#sURL#?criteria=#urlEncodedFormat(attributes.criteria)#",
											urlHasParam=1,
											labels="#labels#",
											enableAjax="true") />
									
		</cfif>
		<cfset session.searchURL = "/search?criteria=#urlEncodedFormat(attributes.criteria)#&currentPage=#attributes.currentPage#" />
		<cfoutput>		
		<div class="result-details pagination-top">
		 
		 	<div class="row">
		 		<div class="column eight">
		 			<p class="result-info">#iTotal# result<cfif iTotal GT 1>s</cfif> found for: <span class="criteria">#attributes.criteria#</span></p>
		 		</div>
		 		<div class="column four paginationData" data-criteria="#attributes.criteria#" data-perPage="#attributes.perPage#" data-container=".searchResultsWrapper" data-paginationHandler="ajaxSearchPaginator">
		 			<cfif structKeyExists(stPagination, "pagingHTML")>#stPagination.pagingHTML#</cfif>
		 		</div>
		 	</div>
		</div>
		
		<ul class="result result-search">
		</cfoutput>	
		
	        <!--- output results --->
	        <cfset currentRow= 1 />
	        <cfloop query="qResults" startrow="#startRow#" endrow="#endRow#">
	        	<cfset class = "teaserAlt" />
	        	<cfif currentrow MOD 2>
	        		<cfset class="" /> 
	        	</cfif>
				<skin:view objectid="#qResults.objectid#"  typename="#qResults.typename#" template="displaySearch" altClass="#class#" score="#qResults.score#" />
				<cfset currentRow++ />
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
				<div class="row">
					<div class="column twelve">
						<p class="result-info"><br />Your search for <span class="criteria">#attributes.criteria#</span> produced no results.</p>
					</div>
				</div>
			</div>
        </cfoutput>
    </cfif>
	
<cfelse>
	<cfoutput>  
		<div class="result-details">
			<div class="row">
				<div class="column twelve">
					<p class="result-info"><br />Please enter a search term in the box above.</p>
				</div>
			</div>
		</div>
	</cfoutput>
</cfif>
<cfsetting enablecfoutputonly="false" />

