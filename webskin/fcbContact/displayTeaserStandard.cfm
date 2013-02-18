<cfsetting enablecfoutputonly="true" />
<!--- @@Copyright: Daemon Pty Limited 2002-2008, http://www.daemon.com.au --->
<!--- @@License: --->
<!--- @@displayname: Standard (Footer)--->
<!--- @@author: --->

<!--- IMPORT TAG LIBRARIES --->
<cfimport taglib="/farcry/core/tags/webskin" prefix="skin">

<cfset sLocationAddress = '#stObj.locationStreet1# #stObj.locationStreet2#, #stObj.locationSuburb# <br /> #stObj.locationState#, #stObj.locationPostcode#' />
<cfset sPostAddress = '#stObj.postalStreet1# #stObj.postalStreet2#, #stObj.postalSuburb# <br /> #stObj.postalState#, #stObj.postalPostcode#' />

<cfoutput>			
			<p><strong>#sLocationAddress#</strong></p>
			<p>#sPostAddress#</p>
			<p><strong>Phone</strong> #stObj.phone# <br /> <strong>Fax</strong> #stObj.fax#</p>
			<p><strong>E-mail</strong> <a href="mailto:#stObj.email#">#stObj.email#</a></p>
</cfoutput>

<cfsetting enablecfoutputonly="false" />