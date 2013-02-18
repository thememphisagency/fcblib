<cfcomponent displayname="simpleRSSConsumer">
	
	<cffunction name="getFeed">
		<cfargument name="rssURL" required="true" type="string" />
		<cfargument name="updateFreqMinutes" required="false" type="numeric" default="1440" />
		
		<cfif NOT structKeyExists(application,"simpleRSSConsumer")>
			<cfset application.simpleRSSConsumer = structNew()>
		</cfif>
		
		<cfif NOT structKeyExists(application.simpleRSSConsumer,rssURL)>
			<cfset application.simpleRSSConsumer[rssURL] = structNew()>
		</cfif>
		
		<cfif NOT structKeyExists(application.simpleRSSConsumer[rssURL],"rssLastUpdatedTime")>
			<cfset application.simpleRSSConsumer[rssURL].rssLastUpdatedTime = now()>
		</cfif>
		
		<cfif NOT structKeyExists(application.simpleRSSConsumer[rssURL],"rssData")>
			<cfset application.simpleRSSConsumer[rssURL].rssData = getRSSData(rssURL)>
		</cfif>
		
		<cfif dateCompare(application.simpleRSSConsumer[rssURL].rssLastUpdatedTime,dateAdd("n",updateFreqMinutes,now())) LT 0>
			<cfset application.simpleRSSConsumer[rssURL].rssData = getRSSData(rssURL)>
			<cfset application.simpleRSSConsumer[rssURL].rssLastUpdatedTime = now()>
		</cfif>
		
		<cfreturn application.simpleRSSConsumer[rssURL].rssData>		
	</cffunction>

	<cffunction name="getRSSData" access="private">
		<cfargument name="rssURL" required="true" type="string" />
		<cftry>
			<cfhttp url="#rssURL#" timeout="5" throwonerror="true"></cfhttp>
			<cfset sXML = cfhttp.fileContent>
			<cfif isXML(sXML)>
				<cfset xmlDoc = xmlParse(sXML)>
				<cfset rssItems = xmlSearch(xmlDoc,"//item")>
				<cfreturn rssItems>
			<cfelse>
				<cfreturn arrayNew(1)>
			</cfif>
			<cfcatch>
				<cfreturn application.simpleRSSConsumer[rssURL].rssData>
			</cfcatch>
		</cftry>
	</cffunction>
	
</cfcomponent>