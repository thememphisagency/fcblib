<cfcomponent displayname="FarCry Friendly URL Table" hint="Manages FarCry Friendly URL's" extends="farcry.core.packages.types.farFU" output="false" bDocument="true" scopelocation="application.fc.factory.farFU" bObjectBroker="true" objectBrokerMaxObjects="1000">
	
	<cffunction name="pingFU" returnType="boolean" access="public" output="false" hint="Make sure that friendly URLS are ALWAYS on">
		
		<cfset var bAvailable = true />
		
		<cfreturn bAvailable />
	</cffunction>

</cfcomponent>