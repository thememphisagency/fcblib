<cfcomponent displayname="GPS Locator" hint="Utility that allows you to pin point a location on the google map" output="false">
	
	<cffunction name="showLocator" output="true" returntype="string">
		<cfargument name="ftPrefix" type="string" required="true" />
		<cfargument name="latitude" type="string" required="false" default="" />
		<cfargument name="longitude" type="string" required="false" default="" />
		<cfargument name="address" type="string" required="false" default="" />
		<cfargument name="bGeo" type="string" required="false" default="0" />
		
		<cfset var html = "" />
		<cfset var formFieldPrefix = arguments.ftPrefix />
		<cfset var googleAPIKey = createObject("component",application.types['googleMapAPIKeys'].packagepath).getAPIKey(CGI.HTTP_HOST)>				
		<cfset var sAddress = arguments.address />
		<cfset var sLat = -34.92577 />
		<cfset var sLng = 138.599732 />
		<cfset var zoom = 13 />
		
		<cfif len(trim(arguments.latitude)) GT 0 AND len(trim(arguments.latitude)) GT 0>
			<cfset sLat = arguments.latitude />
			<cfset sLng = arguments.longitude />
		</cfif>
	
		<cfsavecontent variable="html">
			<cfoutput>
				
				<style type="text/css">
					
					div.gpsloc {
						width: 620px;
					}
					 
					/* hack to hide form label as attributes to do so do not work for some reason */
					div.gpsloc label.fieldsectionlabel{
						display:none;
					}
					div.gpsloc div label.fieldsectionlabel{
						display:block !important;
						width:120px;
					}
					
					form.formtool div.fieldSection {
						width:800px !important;
					}
					
					form.formtool label {
						text-align:left;
						width: auto;
					}
					
					##content, ##features {
						width: 620px;
						margin: 0;
					}
					
					##map {
						border: 1px solid ##CCCCCC;
						height: 375px;
						width: 620px;
						float: left;
						margin: 0 0 40px 0;
					}
					
					##details {
						width: 100%;
						float: left;
						clear: right;
					}
					
					##details p {
						margin: 5px 0 5px 0;
					}
					
					##advertisement {
						clear: left;
					}
					
					##details ##locationResults {
						
						background-color: ##FFFFCC;
						margin: 0 0 20px 0;
						padding: 8px;
						overflow:hidden;
						float:right;
						width: 250px;
						
					}
					
					span##latitudeValue, span##longitudeValue {
						font-weight: bold;
					}
					
					form.formtool .formSection .fieldAlign {
						width: 622px;
					}
					
					##geoFormWrapper {
						float:left;
						overflow: hidden;
						padding-top: 10px;
					}
					
					p.error {
						display: none;
						padding-left: 10px;
						background: ##7C0303;
					}
					
					p.manual {
						background: ##E6D9D9;
						color: ##000000;
						border: none;
					}
				</style>
			
			<script src="http://maps.google.com/maps?file=api&amp;v=2.x&amp;key=" type="text/javascript"></script>
			<script type="text/javascript" src="/js/K_CrossControl.js"></script>
			
			<script type="text/javascript">
	  
				var map;
				var bInit = false;
				
				jQuery.noConflict();
				
				jQuery(document).ready(function(){
					init();
				});
			  
			  	// Call this function when the page has been loaded
				function init() {
					
					bInit = true;
					
					// setup the map
					map = new GMap2(document.getElementById("map"));
					map.setCenter(new GLatLng(#sLat#, #sLng#), #zoom#);
					map.addControl(new GMapTypeControl());
					map.addControl(new GLargeMapControl());
					
					// setup the cross hairs
					var crossControl = new K_CrossControl();
					map.addControl(crossControl);
					
					google.maps.Event.addListener(map, "move", updateLatLng);
		    		
		    		// Set up the form
				    jQuery('.submitLink').click(function() {
				        geocode(jQuery('##geocodeInput').val());
				        return false;
				    });
					
					// Set up Geocoder
		    		window.geocoder = new google.maps.ClientGeocoder();	
		    		
		    		geocode('#sAddress#');
					updateLatLng();	
				}
				
				function updateLatLng () {
				    var center = map.getCenter();
				    document.getElementById("latitudeValue").innerHTML = center.lat().toString();
				    document.getElementById("longitudeValue").innerHTML = center.lng().toString();
				    
				    document.getElementById('#formFieldPrefix#bGeo').value = 1;
				    document.getElementById('#formFieldPrefix#geoLat').value = center.lat();
				    document.getElementById('#formFieldPrefix#geoLong').value = center.lng();
				    
				    jQuery('p.error').css('display','none');
				}
				
				function geocodeComplete(result) {

				    if (result.Status.code != 200) {
				    	jQuery('p.error').css('display','block');
				    	jQuery('p.error').removeClass('manual');
				        jQuery('p.error').html('Could not find a location for the above address');
				        return;
				    }
				    
				    var placemark = result.Placemark[0]; // Only use first result
				    var accuracy = placemark.AddressDetails.Accuracy;
				    var lon = placemark.Point.coordinates[0];
				    var lat = placemark.Point.coordinates[1];
				    
	 				var dLat = '#arguments.latitude#';
				    var dLon = '#arguments.longitude#';				    
				    				    
				    if((dLon.length > 0 && dLat.length > 0) && (lat != dLat || lon != dLon) && bInit) {
				    	jQuery('p.error').css('display','block');
				    	jQuery('p.error').addClass('manual');
				        jQuery('p.error').html('This location has been manually set');
				        bInit = false;
				        return;
				    }
				    	
				    map.setCenter(new google.maps.LatLng(lat, lon), #zoom#);
				    updateLatLng();
				}
				
				function geocode(location) {
				    geocoder.getLocations(location, geocodeComplete);
				}
			  
			</script>
			
			<div id="details">
				<div id="geoFormWrapper">
	                <label for="geocodeInput">Location: </label>
	                <input type="text" name="q" id="geocodeInput" value="#sAddress#">
	                <input type="hidden" name="output" value="html">
	                <a href="##" class="submitLink">Find</a>	   
		        	<p class="error"></p>
		        </div>				
				<div id="locationResults">
					<p id="latitude">Latitude: <span id="latitudeValue">#arguments.latitude#</span></p>
					<p id="longitude">Longitude: <span id="longitudeValue">#arguments.longitude#</span></p>				
				</div>				
			</div>
			
			<div id="map"></div>
				<input type="hidden" name="#formFieldPrefix#geoLat" id="#formFieldPrefix#geoLat" value="#arguments.latitude#" />
				<input type="hidden" name="#formFieldPrefix#geoLong" id="#formFieldPrefix#geoLong" value="#arguments.longitude#" />
				<input type="hidden" name="#formFieldPrefix#bGeo" id="#formFieldPrefix#bGeo" value="#arguments.bGeo#" />
			</cfoutput>
		</cfsavecontent>
		
		<cfreturn html>		
	
	</cffunction>
</cfcomponent>