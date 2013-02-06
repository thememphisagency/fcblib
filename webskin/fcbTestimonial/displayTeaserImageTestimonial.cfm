<cfsetting enablecfoutputonly="true" />
<!--- @@Copyright: Daemon Pty Limited 2002-2008, http://www.daemon.com.au --->
<!--- @@License: --->
<!--- @@displayname: Standard - with teaser image --->
<!--- @@author: --->

<!--- IMPORT TAG LIBRARIES --->
<cfimport taglib="/farcry/core/tags/webskin" prefix="skin">
<cfimport taglib="/farcry/plugins/fcblib/tags/fcb/ui" prefix="ui" />

<cfoutput>
	<div class="testimonial">
</cfoutput>

<cfif structKeyExists(stObj, 'teaserImage') AND len(stobj.teaserImage) GT 0>	
	<cfset sHasTeaserImage = ' hasTeaserImage' />	
	<skin:view objectid="#stobj.teaserImage#" typename="dmImage" template="displayStandardImage" r_html="teaserImageHTML" />						
	<ui:buildLink class="thumbnail" objectID="#stobj.objectid#" linktext="#teaserImageHTML#" />		
</cfif>

<cfoutput>
		<div class="teaserContent">
			<blockquote>&ldquo;#stObj.body#&rdquo;</blockquote>
			<span>#stObj.fullname#, #stObj.position#</span>
		</div>
	</div> 
</cfoutput>

<cfsetting enablecfoutputonly="false" />