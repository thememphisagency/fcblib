<cfsetting enablecfoutputonly="true" />
<!--- @@displayname: Handpicked rule execute --->

<cfif len(trim(stObj.label)) AND stObj.label NEQ "(incomplete)">
	<cfoutput><h3 class="heading">#stObj.label#</h3></cfoutput>
</cfif>

<cfinclude template="#stObj.include#" />