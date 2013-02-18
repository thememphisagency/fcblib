<cfsetting enablecfoutputonly="true" />
<!--- @@Copyright: Enpresiv 2004-2008, http://www.enpresiv.com --->
<!--- @@License: --->
<!--- @@displayname: FcbTestimonial rule execute --->

<cfimport taglib="/farcry/core/tags/webskin" prefix="skin" />

<cfif len(stObj.lSelectedCategoryID) GT 0>
	<cfset oCat = application.factory.oCategory />
	<cfset qData = oCat.getDataQuery(lcategoryIds=stObj.lSelectedCategoryID,typename='fcbTestimonial',sqlOrderBy='RAND()',maxRows=stObj.numItems) />
<cfelse>
	<cfquery name="qData" datasource="#application.dsn#">
		SELECT objectid
		FROM fcbTestimonial
		<cfif stObj.randomise>
		ORDER by RAND()
		 </cfif>
		LIMIT #stObj.numItems#
	</cfquery>
</cfif>

<cfif qData.recordCount GT 0>
	<cfloop query="qData">
		<skin:view objectID="#qData.objectid#" typename="fcbTestimonial" webskin="displayTeaserStandard" alternateHTML="<p>WEBSKIN NOT AVAILABLE</p>" />	
	</cfloop>
</cfif>

<cfsetting enablecfoutputonly="false" />