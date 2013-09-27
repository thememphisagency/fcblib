
<cfimport taglib="/farcry/core/tags/webskin" prefix="skin" />

<cfif isDefined('url.ruleId') AND isValid('UUID', url.ruleId) AND isDefined('url.navId') AND isValid('UUID', url.navId)>
	
	<cfset request.navid = url.navId />	
	<skin:view typename="ruleHandpicked" objectid="#trim(url.ruleId)#" webskin="execute" bShowJS="0" />
	
</cfif>

