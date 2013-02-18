<cfsetting enablecfoutputonly="true">
<!--- @@Copyright: Enpresiv Pty Ltd 2004-2008, http://www.enpresiv.com --->
<!--- @@License:--->
<!--- @@displayname: Display Flash --->
<!--- @@description:   --->
<!--- @@author: Sandy Trinh --->

<cfimport taglib="/farcry/core/tags/webskin" prefix="skin" />

<cfif len(stobj.flashURL) GT 0>
	<cfset swfpath = stobj.flashURL />
<cfelse>
	<cfset swfpath = application.url.fileroot & stobj.flashMovie />
</cfif>

<cfset oUtil = request.fcbObjectBucket.create(fullPath='farcry.plugins.fcblib.packages.custom.utility') />

<cfset sFlashID = 's' & replaceNoCase(stObj.objectid, '-', '', 'all') />

<cfoutput>
	<script type="text/javascript">
		jQuery(document).ready(function() {
		  <cfif isValid('UUID',stObj.altVideo)>
		  var v = document.createElement("video"); // Are we dealing with a browser that supports <video>? 
		  if ( !v.play ) { // If no, use Flash.
		  </cfif>
			var #sFlashID# = new Object();
			#sFlashID#.flashvars = { #stObj.flashParams# };
			#sFlashID#.attributes = {};
			#sFlashID#.params = {
				play: "#oUtil.parseAsBoolean(stObj.flashPlay)#",
				loop: "#oUtil.parseAsBoolean(stObj.flashLoop)#",
				menu: "#oUtil.parseAsBoolean(stObj.flashMenu)#",
				quality: "#stObj.flashQuality#",
				wmode: "#stObj.wsmode#",
				bgcolor: "#stObj.flashBgColor#",
				allowscriptaccess : "always" 
			};		
			swfobject.embedSWF("#swfpath#", "#sFlashID#", "#stObj.flashWidth#", "#stObj.flashHeight#", "#stObj.flashVersion#","/wsflash/expressInstall.swf", #sFlashID#.flashvars, #sFlashID#.params, #sFlashID#.attributes);
		  <cfif isValid('UUID',stObj.altVideo)>
		  }
		  </cfif>
		});
	</script>
	
	<div id="#sFlashID#" style="width: #stObj.flashWidth#px; height: #stObj.flashHeight#px;">
</cfoutput>
	
	<cfif isValid('UUID',stObj.altVideo)>
		<cfset oVideo = request.fcbObjectBucket.create(fullPath='farcry.plugins.fcblib.packages.types.fcbVideo') />
		<cfset stVideo = oVideo.getData(objectid=stObj.altVideo) />
		
		<cfoutput>
			<video id="movie" width="#stObj.flashWidth#" height="#stObj.flashHeight#" controls preload>
				<source src="/files#stVideo.mp4Path#" type='video/mp4; codecs="avc1.42E01E, mp4a.40.2"'>
				<source src="/files#stVideo.ogvPath#" type='video/ogg; codecs="theora, vorbis"'>
			</video>
		</cfoutput>
	<cfelseif len(stObj.altImage) GT 0>
		<skin:view objectid="#stobj.altImage#" typename="dmImage" template="displaySourceImage" />
	</cfif>
		
<cfoutput>
	</div>
</cfoutput> 
	
<cfsetting enablecfoutputonly="false">