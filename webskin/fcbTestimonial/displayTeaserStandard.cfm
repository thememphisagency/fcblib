<cfsetting enablecfoutputonly="true" />
<!--- @@Copyright: Daemon Pty Limited 2002-2008, http://www.daemon.com.au --->
<!--- @@License: --->
<!--- @@displayname: Standard --->
<!--- @@author: --->

<!--- IMPORT TAG LIBRARIES --->
<cfimport taglib="/farcry/core/tags/webskin" prefix="skin">

<cfoutput>
	<div class="testimonial">
		<h4>&ldquo;#stObj.body#&rdquo;</h4>
		<span>#stObj.fullname#</span> <br />
		<span>#stObj.position#</span>
	</div> 
</cfoutput>

<cfsetting enablecfoutputonly="false" />