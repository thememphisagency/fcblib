<cfsetting enablecfoutputonly="true" />
<!--- @@Copyright: The Memphis Agency --->
<!--- @@License: --->
<!--- @@displayname: Video Body --->
<!--- @@author: Matthew Attanasio --->

<!--- IMPORT TAG LIBRARIES --->
<cfimport taglib="/farcry/plugins/fcblib/tags/fcb/ui" prefix="ui" />
	<cfset stObj.link = replaceNoCase(stObj.link, '&', '&amp;', 'all') />

	<cfoutput>
    <div class="video">
		<iframe class="youtube-player" type="text/html" src="#stObj.link#">
		</iframe>
    </div>
	</cfoutput>
<cfsetting enablecfoutputonly="false" />
