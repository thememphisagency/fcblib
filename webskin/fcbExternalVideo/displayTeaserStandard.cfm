<cfsetting enablecfoutputonly="true" />
<!--- @@Copyright: The Memphis Agency --->
<!--- @@License: --->
<!--- @@displayname: Video (RHS) --->
<!--- @@author: Matthew Attanasio--->

<cfparam name="stParam.width" default=247 />
<cfparam name="stParam.height" default=179 />

<!--- IMPORT TAG LIBRARIES --->
<cfimport taglib="/farcry/plugins/fcblib/tags/fcb/ui" prefix="ui" />
	<cfset stObj.link = replaceNoCase(stObj.link, '&', '&amp;', 'all') />
	
	<cfoutput>
		<iframe class="youtube-player" type="text/html" src="#stObj.link#" frameborder="0">
		</iframe>	
	</cfoutput>		
<cfsetting enablecfoutputonly="false" />