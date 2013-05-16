<!--- @@displayname: Footer Content --->

<cfimport taglib="/farcry/core/tags/webskin" prefix="skin" />

<cfif arrayLen(stobj.aPickedObjects)>

	<cfif len(trim(stObj.intro))>
		<cfoutput><cfoutput><h4><span>#stObj.intro#</span></h4></cfoutput></cfoutput>
	</cfif>

	<skin:view objectID="#stobj.aPickedObjects[1].data#" typename="#stobj.aPickedObjects[1].typename#" webskin="#stobj.aPickedObjects[1].webskin#" alternateHTML="<p>WEBSKIN NOT AVAILABLE</p>" />
	
</cfif>

<cfsetting enablecfoutputonly="false" />