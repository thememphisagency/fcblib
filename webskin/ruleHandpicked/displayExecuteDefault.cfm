<!--- @@displayname: Default --->

<cfimport taglib="/farcry/core/tags/webskin" prefix="skin" />

<cfif arrayLen(stobj.aPickedObjects)>

<cfoutput>
<div class="module">
</cfoutput>

	<cfif len(trim(stObj.label)) AND stObj.label NEQ "(incomplete)">
		<cfoutput><h3 class="heading">#stObj.label#</h3></cfoutput>
	</cfif>
	
	<cfif len(trim(stObj.intro))>
		<cfoutput><p class="intro">#stObj.intro#</p></cfoutput>
	</cfif>
	
	<cfset request.iRuleTotalItems = arrayLen(stobj.aPickedObjects) />
	<cfset iTotal = arrayLen(stobj.aPickedObjects) />

	<cfif stObj.bRandom>
		<!--- randomise value in array --->
		<cfset CreateObject("java","java.util.Collections").Shuffle(stobj.aPickedObjects) />
		<cfset iTotal = 1 />
	</cfif>
	
	<cfloop from="1" to="#iTotal#" index="i">
		<cfset request.i = i />		
		<skin:view objectID="#stobj.aPickedObjects[i].data#" typename="#stobj.aPickedObjects[i].typename#" webskin="#stobj.aPickedObjects[i].webskin#" alternateHTML="<p>WEBSKIN NOT AVAILABLE</p>" />
	</cfloop>
	
<cfoutput>
</div>
</cfoutput>

	
</cfif>

<cfsetting enablecfoutputonly="false" />