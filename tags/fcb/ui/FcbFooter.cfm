<cfsetting enablecfoutputonly="yes" />

<!--- // get navigation items --->
<cfset o = createObject("component", "#application.packagepath#.farcry.tree")>

<cfset qNav = QueryNew('') />
<cfset qTitles = QueryNew('') />
<cfset fu = createObject("component","#application.packagepath#.farcry.fu")>
<cfset sClass = "" />

<cfif StructKeyExists(application.navid,"fcbfooter")>
	<cfset qNav = o.getDescendants(objectid=application.navid.fcbfooter, lColumns='externallink', depth=2) />
	<cfquery name="qTitles" dbtype="query">
		select * from qNav
		where nLevel = 3
	</cfquery>
</cfif>

<cfif qNav.recordcount GT 0>
	<cfoutput>
		<div id="fcbFooter">
	</cfoutput>
	
	<cfloop query="qTitles">
	
		<cfset sClass = " item#qTitles.currentRow#">
		<cfif qTitles.currentRow EQ qTitles.recordCount>
			<cfset sClass = sClass & " last" />
		</cfif>
		<cfoutput><div class="fcbNavCol#sClass#"><h3>#qTitles.ObjectName#</h3><ul></cfoutput>
		<cfloop query="qNav">
			<cfif qNav.nLeft GT qTitles.nLeft AND qNav.nRight LT qTitles.nRight AND qNav.nLevel GT qTitles.nLevel>
				<cfif application.config.plugins.fu>
					<cfset strhref = fu.getFU(qNav.objectid)>
				<cfelse>
					<cfset strhref = application.url.conjurer & "?objectid=" & qNav.objectid>
				</cfif>
				<cfoutput><li><a href="#strhref#">#qNav.objectname#</a></li></cfoutput>
			</cfif>
		</cfloop>
		<cfoutput></ul></div></cfoutput>
		
	</cfloop>
	<cfoutput></div></cfoutput>
</cfif>

<cfsetting enablecfoutputonly="no" />