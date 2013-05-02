<cfsetting enablecfoutputonly="true" />
<!--- @@displayname: Display page child links --->

<cfimport taglib="/farcry/core/tags/webskin" prefix="skin" />

<cfset oNav = CreateObject("component", application.stcoapi.dmNavigation.packagepath) /> 

<!--- assumes existance of request.navid  --->
<cfparam name="request.navid">

<cfset sNav = stObj.refobjectid />

<cfif len(stObj.refobjectid) IS 0>
	<cfset sNav = request.navid />
</cfif>

<!--- get the children of this object --->
<cfset qGetChildren = application.factory.oTree.getChildren(objectid=sNav) />

<cfoutput>
<div class="module">
</cfoutput>

	<cfif len(trim(stObj.label)) AND stObj.label NEQ '(incomplete)'>
		<cfoutput><h3 class="heading">#stObj.label#</h3></cfoutput>
	</cfif>
	
	<cfoutput>
		<div class="index">
	</cfoutput>
	
	<cfif len(trim(stObj.intro))>
		<cfoutput><p class="intro">#stObj.intro#</p></cfoutput>
	</cfif>
	
	
<cfif qGetChildren.recordcount GT 0>
	<!--- loop over children --->
	<cfloop query="qGetChildren">
	
		<!--- get child nav details --->
		<cfset stCurrentNav = oNav.getData(objectid=qGetChildren.objectID) />
		
		<!--- check for sim link --->
		<cfif len(stCurrentNav.externalLink)>
			<!--- get sim link details --->
			<cftry>
				<cfset stCurrentNav = oNav.getData(objectid=stCurrentNav.externalLink) />
				
				<cfcatch><!--- Ignore if the object doesnt exist ---></cfcatch>
			</cftry>
		</cfif>
		
		<cfquery datasource="#application.dsn#" name="qNavPages">
		SELECT * FROM dmNavigation_aObjectIDs
		where parentid = '#stCurrentNav.objectid#'
		order by seq
		</cfquery>
	
		<cfif qNavPages.recordCount>
			<cfloop query="qNavPages">
				<cfset stNavTemp = application.fapi.getContentObject(qNavPages.parentID) />
				<cfif StructKeyExists(stNavTemp,"status") AND ListContains(request.mode.lValidStatus, stNavTemp.status)>
					<cfset stObjTemp = application.fapi.getContentObject(objectid=qNavPages.data) />
				
					<cfif NOT structIsEmpty(stObjTemp)>
						<!--- request.lValidStatus is approved, or draft, pending, approved in SHOWDRAFT mode --->
						<cfif (StructKeyExists(stObjTemp,"status") AND ListContains(request.mode.lValidStatus, stObjTemp.status) OR NOT StructKeyExists(stObjTemp,"status")) >
				
							<!--- if in draft mode grab underlying draft page --->			
							<cfif IsDefined("stObjTemp.versionID") AND request.mode.showdraft>
								<cfquery datasource="#application.dsn#" name="qHasDraft">
									SELECT objectID,status from #application.dbowner##stObjTemp.typename# where versionID = '#stObjTemp.objectID#' 
								</cfquery>
						
								<cfif qHasDraft.recordcount gt 0>
									<cfset stObjTemp = application.fapi.getContentObject(objectid=qHasDraft.objectid) />
								</cfif>
							</cfif>

							<skin:view objectid="#stObjTemp.objectid#" webskin="#stObj.displaymethod#" alternatehtml="<!-- #stObj.displaymethod# does not exist for #stObjTemp.typename# -->" />

							<cfbreak>
						</cfif>
					<cfelse>
						<!--- structure is blank; ie tree reference is borked --->
						<skin:bubble title="site tree error" message="#qNavPages.data# not in tree" sticky="true" />
					</cfif>
				</cfif>
			</cfloop>
		<cfelse>
			<skin:view objectid="#stCurrentNav.objectid#" webskin="#stObj.displaymethod#" alternateHTML="<!-- #stObj.displaymethod# does not exist for #stObjTemp.typename# -->" />
		</cfif>
		
	</cfloop>
	
</cfif>
	
<cfoutput>
	</div>
</div>
</cfoutput>

<cfsetting enablecfoutputonly="false" />