<cfsetting enablecfoutputonly="true" />
<!--- @@Copyright: Daemon Pty Limited 2002-2008, http://www.daemon.com.au --->
<!--- @@License:
    This file is part of FarCry CMS Plugin.

    FarCry CMS Plugin is free software: you can redistribute it and/or modify
    it under the terms of the GNU Lesser General Public License as published by
    the Free Software Foundation, either version 3 of the License, or
    (at your option) any later version.

    FarCry CMS Plugin is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
    GNU Lesser General Public License for more details.

    You should have received a copy of the GNU Lesser General Public License
    along with FarCry CMS Plugin.  If not, see <http://www.gnu.org/licenses/>.
--->

<cfimport taglib="/farcry/core/tags/webskin" prefix="skin" />
<cfimport taglib="/farcry/core/tags/formtools" prefix="ft" />

	<cfif structKeyExists(arguments.stParam, 'stObj')>
		<cfset arguments.stObj = arguments.stParam.stObj />
	</cfif>

	<cfset q = getRuleData(stObj) />

	<cfif arrayLen(q) GT 0>
	
		<cfoutput>
		<div class="module">
		</cfoutput>
		
			<cfif len(trim(stObj.label)) AND stObj.label NEQ "(incomplete)">
				<cfoutput><h3 class="heading">#stObj.label#</h3></cfoutput>
			</cfif>
			
			<cfif len(trim(stObj.intro))>
				<cfoutput><p class="intro">#stObj.intro#</p></cfoutput>
			</cfif>
			
			<cfoutput>
			<ul class="tweets">
			</cfoutput>

			<cfloop from="1" to="#arrayLen(q)#" index="j">
				<cfset request.i = j />
				<!--- This grabs the display teasers from the rule webskin  --->
				<skin:view objectID="#stObj.objectid#" typename="#this.getTypeName()#" webskin="#stObj.displaymethod#" alternateHTML="<p>WEBSKIN NOT AVAILABLE</p>" stData="#q[j]#" twitterAccount="#stObj.twitterAccount#" />
			</cfloop>
			
			<cfoutput>
			</ul>
			<a class="morelink" href="#application.config.socialLinks.twitterURL##application.config.socialLinks.twitterAccount#" target="_blank">More updates...</a>
		</div>
		</cfoutput>
	</cfif>

<cfsetting enablecfoutputonly="false" />

<cffunction name="getRuleData" access="private" returntype="array" output="false">
	<cfargument name="ruledata" type="struct" required="true" />

	<cfset var oSimpleRSSConsumer = request.fcbObjectBucket.create(fullPath='farcry.plugins.fcblib.packages.custom.SimpleRSSConsumer') />	
	<cfset var aRSSData = oSimpleRSSConsumer.getFeed(arguments.ruleData.twitterRSS,application.config.socialLinks.twitterUpdateInterval) />
	<cfset var aData = arrayNew(1) />
	<cfset var iTotal = arguments.ruleData.numTwitterFeeds />
	
	<cfif arrayLen(aRSSData) GT 0>
		<cfif arrayLen(aRSSData) LT iTotal>
			<cfset iTotal = arrayLen(aRSSData) />
		</cfif>		
		<cfloop from="1" to="#iTotal#" index="i">
			<cfset aData[i] = aRSSData[i] />
		</cfloop>
	</cfif>
	
	<cfreturn aData />
</cffunction>