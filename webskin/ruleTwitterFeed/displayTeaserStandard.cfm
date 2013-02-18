<cfsetting enablecfoutputonly="true" />
<!--- @@Copyright: Daemon Pty Limited 2002-2008, http://www.daemon.com.au --->
<!--- @@License: --->
<!--- @@displayname: Standard --->
<!--- @@author: --->

<!--- IMPORT TAG LIBRARIES --->
<cfimport taglib="/farcry/core/tags/webskin" prefix="skin">
<cfimport taglib="/farcry/plugins/fcblib/tags/fcb/ui" prefix="ui" />

<cfparam name="stParam.stData" default="structNew()" />
<cfparam name="stParam.twitterAccount" default="" />


	<cfset oUtilities = request.fcbObjectBucket.create(fullPath='farcry.plugins.fcblib.packages.custom.utility') />
	<cfset rssData = stParam.stData />

	
	<cfset twitterLink = rssData.link.xmlText />
	
	<cfset twitterPost = replaceNoCase(rssData.title.XMLText,"#stParam.twitterAccount#:","","ALL") />
	
	<!--- link to href --->
	<cfset twitterPost = REReplace(twitterPost,'http([s]?):\/\/([^\ \)$]*)','<a href="http\1://\2" rel="nofollow" title="\2" target="_blank">http\1://\2</a>','ALL') />
	
	<!--- link for targeting twitter user --->
	<cfset twitterPost = REReplace(twitterPost,'(^|\s)@(\w+)','\1<a href="http://www.twitter.com/\2" target="_blank">@\2</a>','ALL') />
	
	<!--- link for targeting hashtags --->
	<cfset twitterPost = REReplace(twitterPost,'(^|\s)##(\w+)','\1<a href="http://search.twitter.com/search?q=%23\2" target="_blank">##\2</a>','ALL') />

	<cfoutput>
		<li class="tweet">
			<p>#twitterPost# <a href="#trim(twitterLink)#" class="twitterLink" target="_blank">#oUtilities.formatTwitterDate(rssData.pubDate.XMLText)#</a></p>
		</li>
	</cfoutput>

<cfsetting enablecfoutputonly="false" />