<!--- <cffile action="read" file="C:\websites\projects\repco\www\sqlscript\repcoDealer_baseSite.sql" variable="sqlfile">

<cfset newsqlfile = sqlfile>
<cfset lcoretables = "container_aRules,dmExternalGroupToPolicyGroup,dmGroup,dmPermission,dmPermissionBarnacle,dmPolicyGroup,dmUser,dmUserToGroup,fqAudit,refCategories,refContainers,refDSAS,reffriendlyURL,refObjects,statsCountries,statsDays,statsHours,statsSearch">
<!--- types and rules table rename --->
<cfset lTypes = structKeyList(application.types,",")>
<cfloop index="i" list="#lTypes#">
	<cfset newsqlfile = replaceNoCase(newsqlfile,i,i,"ALL")>
</cfloop>

<cfloop index="i" list="#lTypes#"><cfloop collection="#application.types[i].stProps#" item="st"><cfif application.types[i].stProps[st].metadata.type is 'array'>
	<cfset newsqlfile = replaceNoCase(newsqlfile,i&"_"&st,i&"_"&st,"ALL")>
</cfif></cfloop></cfloop>


<cfset lTypes = structKeyList(application.rules,",")>
<cfloop index="i" list="#lTypes#"><cfoutput>ALTER table #lcase(i)# RENAME _#lcase(i)#;
	<cfset newsqlfile = replaceNoCase(newsqlfile,i,i,"ALL")>
</cfoutput></cfloop>
<cfloop index="i" list="#lTypes#"><cfloop collection="#application.rules[i].stProps#" item="st"><cfif application.rules[i].stProps[st].metadata.type is 'array'>
	<cfset newsqlfile = replaceNoCase(newsqlfile,i&"_"&st,i&"_"&st,"ALL")>
</cfif></cfloop></cfloop>

<cfloop index="i" list="#lcoretables#">
	<cfset newsqlfile = replaceNoCase(newsqlfile,i,i,"ALL")>
</cfloop>

<cffile action="write" file="C:\websites\projects\repco\www\sqlscript\repcoDealer_baseSite_fixed.sql" output="#newsqlfile#">
 --->

<cfset lcoretables = "container_aRules,dmExternalGroupToPolicyGroup,dmGroup,dmPermission,dmPermissionBarnacle,dmPolicyGroup,dmUser,dmUserToGroup,fqAudit,refCategories,refContainers,refDSAS,reffriendlyURL,refObjects,statsCountries,statsDays,statsHours,statsSearch">

<cfloop index="i" list="#lcoretables#">
	<cfoutput>ALTER table #lcase(i)# RENAME _#i#;</cfoutput>
</cfloop>

<cfloop index="i" list="#lcoretables#">
	<cfoutput>ALTER table _#i# RENAME #i#;</cfoutput>
</cfloop>

<cfset lTypes = "#structKeyList(application.types)#">

<cfloop list="#lTypes#" index="st">
	<cfoutput>ALTER table #lcase(st)# RENAME _#st#;</cfoutput>
</cfloop>

<cfloop list="#lTypes#" index="st">
	<cfoutput>ALTER table _#st# RENAME #st#;</cfoutput>
</cfloop>

<cfset lRules = "#structKeyList(application.rules)#">

<cfloop list="#lRules#" index="st">
	<cfoutput>ALTER table #lcase(st)# RENAME _#st#;</cfoutput>
</cfloop>

<cfloop list="#lRules#" index="st">
	<cfoutput>ALTER table _#st# RENAME #st#;</cfoutput>
</cfloop>


<cfloop index="i" list="#lTypes#"><cfloop collection="#application.types[i].stProps#" item="st"><cfif application.types[i].stProps[st].metadata.type is 'array'>
	<cfoutput>ALTER table #lcase(i&"_"&st)# RENAME _#i&"_"&st#;</cfoutput>
</cfif></cfloop></cfloop>

<cfloop index="i" list="#lTypes#"><cfloop collection="#application.types[i].stProps#" item="st"><cfif application.types[i].stProps[st].metadata.type is 'array'>
	<cfoutput>ALTER table _#i&"_"&st# RENAME #i&"_"&st#;</cfoutput>
</cfif></cfloop></cfloop>


<cfloop index="i" list="#lRules#"><cfloop collection="#application.rules[i].stProps#" item="st"><cfif application.rules[i].stProps[st].metadata.type is 'array'>
	<cfoutput>ALTER table #lcase(i&"_"&st)# RENAME #i&"_"&st#;</cfoutput>
</cfif></cfloop></cfloop>

<cfloop index="i" list="#lRules#"><cfloop collection="#application.rules[i].stProps#" item="st"><cfif application.rules[i].stProps[st].metadata.type is 'array'>
	<cfoutput>ALTER table _#i&"_"&st# RENAME #i&"_"&st#;</cfoutput>
</cfif></cfloop></cfloop>
