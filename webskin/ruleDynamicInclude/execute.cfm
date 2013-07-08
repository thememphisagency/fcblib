<cfsetting enablecfoutputonly="true" />
<!--- @@displayname: Dynamic Rule execute --->

<cfif len(stObj.include) GT 0>
	<cfif len(trim(stObj.label)) AND stObj.label NEQ "(incomplete)">
		<cfoutput><h3 class="heading">#stObj.label#</h3></cfoutput>
	</cfif>

	<cfif len(stObj.dynamicVariables) GT 0>
		<cfset aVariables = listToArray(stObj.dynamicVariables,"#chr(10)#")>
		<cfloop from="1" to="#arrayLen(aVariables)#" index="i">
			<cfset "#listGetAt(aVariables[i],1,"=")#" = evaluate(de(listGetAt(aVariables[i],2,"=")))>
		</cfloop>
	</cfif>
	<cfinclude template="#stObj.include#" />
</cfif>
