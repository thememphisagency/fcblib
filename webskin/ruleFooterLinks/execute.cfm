<!--- @@displayname: Default --->

<cfimport taglib="/farcry/core/tags/webskin" prefix="skin" />
<cfimport taglib="/farcry/plugins/fcblib/tags/fcb/ui" prefix="ui" />

<cfif isValid('uuid',stobj.heading)>
	<cfset typenameObj = application.fapi.getContentObject(objectid=stobj.heading) />
	<cfif isDefined('typenameObj.label')>
		<cfoutput><h4><ui:buildLink objectid="#typenameObj.objectid#" linkText="#typenameObj.label#" /></h4></cfoutput>
	</cfif>
<cfelseif len(stObj.title) GT 0>
	<cfoutput><h4><span>#stObj.title#</span></h4></cfoutput>	
</cfif>	

<cfif arrayLen(stobj.aPickedObjects)>
	<cfset iTotal = arrayLen(stobj.aPickedObjects) />
	<cfset request.iRuleTotalItems = iTotal />
	
	<cfset sLinks = '' />
	
	<cfloop from="1" to="#iTotal#" index="i">	
		<cfset typenameObj = application.fapi.getContentObject(objectid=stobj.aPickedObjects[i]) />
		<cfsavecontent variable="sLink">
			<cfoutput><li<cfif i EQ iTotal> class="lastListItem"</cfif>><ui:buildLink objectid="#typenameObj.objectid#" linkText="#typenameObj.label#" /></li></cfoutput>
		</cfsavecontent>

		<cfset sLinks &= sLink />								
	</cfloop>
	<cfif len(sLinks) GT 0>
		<cfoutput><ul>#sLinks#</ul></cfoutput>
	</cfif>			
</cfif>

<cfsetting enablecfoutputonly="false" />