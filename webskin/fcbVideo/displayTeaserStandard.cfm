<cfsetting enablecfoutputonly="true">
<!--- @@Copyright: Enpresiv Pty Ltd 2004-2008, http://www.enpresiv.com --->
<!--- @@License:--->
<!--- @@displayname: Display Flash --->
<!--- @@description:   --->
<!--- @@author: Sandy Trinh --->

<cfimport taglib="/farcry/core/tags/webskin" prefix="skin" />

<cfparam name="stParam.width" default="400" />
<cfparam name="stParam.height" default="200" />
<cfparam name="stParam.bIncludeJQueryLibrary" default="0" />

<cfset sFlashID = 's' & replaceNoCase(stObj.objectid, '-', '', 'all') />

<cfset sFlashURL = 'http://#CGI.SERVER_NAME#/files#stObj.mp4Path#' />

<cfset sPosterURL = ''  />

<cfif len(stObj.posterPath) GT 0>
	<cfset sPosterURL = 'http://#CGI.SERVER_NAME##stObj.posterPath#'  />
</cfif>

<cfsavecontent variable="sFMP">
	<cfoutput>
	<object width="#int(stParam.width)#" height="#int(stParam.height)#"> 
		<param name="movie" value="http://fpdownload.adobe.com/strobe/FlashMediaPlayback.swf"></param>
		<param name="flashvars" value="src=#urlEncodedFormat(sFlashURL)#&poster=#urlEncodedFormat(sPosterURL)#"></param>
		<param name="allowFullScreen" value="true"></param>
		<param name="allowscriptaccess" value="always"></param>
		<embed src="http://fpdownload.adobe.com/strobe/FlashMediaPlayback.swf" type="application/x-shockwave-flash" allowscriptaccess="always" allowfullscreen="true" width="#int(stParam.width)#" height="#int(stParam.height)#" flashvars="src=#urlEncodedFormat(sFlashURL)#&poster=#urlEncodedFormat(sPosterURL)#"></embed>
	</object>		
	</cfoutput>
</cfsavecontent>

<cfoutput>
	<cfif stParam.bIncludeJQueryLibrary>
	<script type="text/javascript" src="#application.url.webroot#/js/jquery-1.4.2.min.js"></script>
	</cfif>
	<script type="text/javascript">
		jQuery(document).ready(function() {
			var v = document.createElement("video"); // Are we dealing with a browser that supports <video>? 
			if ( !v.play ) { // If no, use Flash.
			 	jQuery('###sFlashID#').html('#JSStringFormat(trim(sFMP))#');
			 }  
		});
	</script>				

	<div id="#sFlashID#">	
		<video width="#int(stParam.width)#" height="#int(stParam.height)#" controls preload<cfif len(stObj.posterPath) GT 0> poster="#stObj.posterPath#"</cfif> />
			<source src="/files#stObj.mp4Path#" type='video/mp4; codecs="avc1.42E01E, mp4a.40.2"' />
			<source src="/files#stObj.ogvPath#" type='video/ogg; codecs="theora, vorbis"' />
		</video>		
	</div>
</cfoutput>
 	
<cfsetting enablecfoutputonly="false">