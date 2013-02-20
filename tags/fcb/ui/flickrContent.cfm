<cfparam name="attributes.photosetID" default="" />
<cfparam name="attributes.numItems" default="" />
<cfparam name="attributes.bSetPhotoNum" default=0 />
<cfparam name="attributes.objectId" default="" />
<cfparam name="attributes.cacheLimit" default="24" />

<cfimport taglib="/farcry/core/tags/webskin" prefix="skin" />

<!--- quit tag if running in end mode --->
<cfif thistag.executionmode eq "end">
	<cfexit />
</cfif>

<cfif thisTag.ExecutionMode is 'start'>

	
	<cfset dCurrentDate = now() />

	<cfif structKeyExists(application.config.enpFlickr,"cacheLimit")>
		<cfset attributes.cacheLimit = application.config.enpFlickr.cacheLimit />
	</cfif>
	
	<!--- check for application.flickrSet (struct), if it doesn't exist create it --->
	<cfif NOT structKeyExists(application, 'flickrSet')>
		<cfset application.flickrSet = structNew() />
	</cfif>

	
	<cfif NOT structKeyExists(application.flickrSet, attributes.objectid)>
		<cfset application.flickrSet['#attributes.objectid#'] = structNew() />
	</cfif>
	
	<cfif NOT structKeyExists(application.flickrSet[attributes.objectid], 'dFlickrContentLastUpdated')>
		<!--- Set date flickr last update to the day before, so that if this script is run for the first time, it'll retrieve data from flickr first--->
		<cfset application.flickrSet[attributes.objectid].dFlickrContentLastUpdated = dateAdd('h', -attributes.cacheLimit,dCurrentDate) />
	</cfif>
	
	<cfif NOT structKeyExists(application.flickrSet[attributes.objectid], 'aFlickrContent')>
		<cfset application.flickrSet[attributes.objectid].aFlickrContent = arrayNew(1) />	
	</cfif>


	<!--- Only update the content once a day --->
	<cfif (isDefined('url.initFlickr') AND url.initFlickr IS 1) OR application.flickrSet[attributes.objectid].dFlickrContentLastUpdated neq dCurrentDate>
		<!--- Since we are updating the flickr images, let clear the application variable --->
		<cfset application.flickrSet[attributes.objectid].aFlickrContent = arrayNew(1) />
		
		<cftry>
			<cfif attributes.bSetPhotoNum>
				<!--- Get list of image ids, if bSetPhotoNum is true, limit the number of images returned from request --->
				<cfhttp url="http://api.flickr.com/services/rest/?method=flickr.photosets.getPhotos&api_key=#application.config.enpFlickr.apiKey#&photoset_id=#attributes.photosetID#&per_page=#attributes.numItems#" timeout="3" throwonerror="true" />
			<cfelse>
				<!--- otherwise, get all images from request --->
				<cfhttp url="http://api.flickr.com/services/rest/?method=flickr.photosets.getPhotos&api_key=#application.config.enpFlickr.apiKey#&photoset_id=#attributes.photosetID#" timeout="3" throwonerror="true" />	
			</cfif>
						
			<cfset xPhotos = XMLPArse(cfhttp.FileContent) />
			<cfset aPhotos = XMLSearch(xPhotos, '//photo') />

			<cfif arrayLen(aPhotos) GT 0>
				<cfset iCount = 1 />
				<cfloop array="#aPhotos#" index="i">
					<cfset sImageLabel = i.xmlAttributes.title />
					
					<cfhttp url="http://api.flickr.com/services/rest/?method=flickr.photos.getSizes&api_key=#application.config.enpFlickr.apiKey#&photo_id=#i.xmlAttributes.id#" timeout="3" throwonerror="true" />

					<cfset xImages = XMLPArse(cfhttp.FileContent) />
					<cfset aImageLarge = XMLSearch(xImages, "//size[@label='Large']") />
					
					<cfif arraylen(aImageLarge) EQ 0>
						<!--- Since large image is not available, try Medium size image --->
						<cfset aImageLarge = XMLSearch(xImages, "//size[@label='Medium']") />
					</cfif>
					
					<cfset aImageSquare = XMLSearch(xImages, "//size[@label='Square']") />		
						
 					<cfif arrayLen(aImageLarge) GT 0 AND arrayLen(aImageSquare) GT 0>
						<!--- Add label of each image into it's corresponding array --->
						<cfset aImageLarge[1].xmlAttributes.label = sImageLabel />
						<!--- Add source of image thumbnail --->
						<cfset aImageLarge[1].xmlAttributes.thumbnail = aImageSquare[1].xmlAttributes.source />
						<!--- Add info of each images into an application variable --->
						<cfset arrayAppend(application.flickrSet[attributes.objectid].aFlickrContent, aImageLarge[1].xmlAttributes) />
						
						<cfoutput>
							<li <cfif iCount EQ 1> class="active"</cfif>><a href="#aImageLarge[1].xmlAttributes.source#" target="_blank" title="#aImageLarge[1].xmlAttributes.label#"><img src="#aImageLarge[1].xmlAttributes.thumbnail#" alt="#aImageLarge[1].xmlAttributes.label#" /></a></li>
						</cfoutput>
					</cfif> 
					
					<cfset iCount = iCount + 1 />	
				</cfloop>
			</cfif>

			<!--- Update current date, so that we know when the flickr content was last updated --->
			<cfset application.flickrSet[attributes.objectid].dFlickrContentLastUpdated = dCurrentDate />

 			<cfcatch type="any">
				<p>Error obtaining flickr images.</p>
			</cfcatch>
		</cftry>
	
	<cfelse>
		<cfif arrayLen(application.flickrSet[attributes.objectid].aFlickrContent) GT 0>
			<cfset iCount = 1 />
			<cfloop array="#application.flickrSet[attributes.objectid].aFlickrContent#" index="i">
				<cfoutput>
					<li <cfif iCount EQ 1> class="active"</cfif>><a href="#i.source#" target="_blank" title="#i.label#"><img src="#i.thumbnail#" alt="#i.label#" /></a></li>
				</cfoutput>
				<cfset iCount = iCount + 1 />
			</cfloop>
		</cfif> 

	</cfif>

</cfif>
