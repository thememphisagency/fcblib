<cfsetting enablecfoutputonly="true" />
<!--- @@Copyright: Daemon Pty Limited 2002-2008, http://www.daemon.com.au --->
<!--- @@License: --->
<!--- @@displayname: Contact with Map --->
<!--- @@author: --->

<!--- IMPORT TAG LIBRARIES --->
<cfimport taglib="/farcry/plugins/fcblib/tags/fcb/ui" prefix="ui" />

	<cfif NOT structKeyExists(request, 'googlemap') AND stobj.bShowMap>
		<cfset googleAPIKey = application.config.fcbWebsite.googleMapApiKey />
		<cfoutput>
			<script src="http://maps.googleapis.com/maps/api/js?key=#googleAPIKey#&sensor=false"></script>
		</cfoutput>
		<cfset request.googlemap = 1 />
	</cfif>

	<cfset sAddress = '' />
	<cfif len(stObj.locationStreet1) GT 0 OR len(stObj.locationStreet2) GT 0>
		<cfset sAddress = trim(stObj.locationStreet1 & ' ' & stObj.locationStreet2 & ' ' & stObj.locationSuburb & ' ' & stObj.locationState & ' ' & stObj.locationPostcode) />
	</cfif>

	<cfset sPostalAddress = '' />
	<cfif len(stObj.postalStreet1) GT 0 OR len(stObj.postalStreet2) GT 0>
		<cfset sPostalAddress = trim(stObj.postalStreet1 & ' ' & stObj.postalStreet2 & ' ' & stObj.postalSuburb & ' ' & stObj.postalState & ' ' & stObj.postalPostcode) />
	</cfif>

	<cfif request.i EQ 1>
		<cfset sClassName = 'contact first'>
	<cfelse>
		<cfset sClassName = 'contact'>	
	</cfif>
	
	<cfset sObjectid = trim(replaceNoCase(stObj.objectid, '-', '', 'all')) />

	<cfoutput>
	<div class="#sClassName# s#sObjectid#">
		<h3>#stObj.label#</h3>
		<cfif len(trim(stObj.subLabel)) GT 0>
			<p class="subLabel"><strong>#stObj.subLabel#</strong></p>
		</cfif>
		<cfif len(sAddress) GT 1>
			<p class="address"><strong>Address:</strong> #sAddress#</p>
		</cfif>
		<cfif len(sPostalAddress) GT 1>
			<p class="address"><strong>Mailing Address:</strong> #sPostalAddress#</p>
		</cfif>		
		<p class="contacts">
			<cfif len(trim(stObj.phone)) GT 0>
				<span>T</span>#stObj.phone# <br />
			</cfif>
			<cfif len(trim(stObj.fax)) GT 0>
				<span>F</span>#stObj.fax# <br />
			</cfif>
			<cfif len(trim(stObj.email)) GT 0>
				<span>E</span><a href="mailto:#stObj.email#">#stObj.email#</a>
			</cfif>
		</p>
		
		<cfif len(sAddress) GT 0 AND stObj.bShowMap>
			
			<cfsavecontent variable="sMapDiv"><cfoutput><div id="s#sObjectid#_map" class="googlemap"><\/div></cfoutput></cfsavecontent>
			
			<script>
				window.onload = function() {
					$('.s#sObjectid#').append('#trim(sMapDiv)#');
					var myLatlng = new google.maps.LatLng(#stObj.geoLat#,#stObj.geoLong#);
					var myOptions = {
						center: myLatlng,
						zoom: 16,
						mapTypeId: google.maps.MapTypeId.ROADMAP
					};
					var map = new google.maps.Map(document.getElementById('s#sObjectid#_map'), myOptions);	
					var marker = new google.maps.Marker({
						position: myLatlng
					});
					marker.setMap(map);
				}
			</script>	
		
		</cfif>
				
	</div>
	
	</cfoutput>

<cfsetting enablecfoutputonly="false" />