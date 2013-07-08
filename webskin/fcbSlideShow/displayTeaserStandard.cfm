<cfsetting enablecfoutputonly="true" />
<!--- @@Copyright: The Memphis Agency--->
<!--- @@License: --->
<!--- @@displayname: Slideshow (Please only place on home page) --->

<!--- IMPORT TAG LIBRARIES --->
<cfimport taglib="/farcry/core/tags/webskin" prefix="skin">
<cfimport taglib="/farcry/plugins/fcblib/tags/fcb/ui" prefix="ui" />

<cfset oImage = CreateObject("component",application.stcoapi['dmImage'].packagepath)>
<cfset aImageData = ArrayNew(1) />

<cfif arrayLen(stObj.aObjectIDs)>
	<cfloop array="#stObj.aObjectIDs#" index="i">

		<cfset stImage = oImage.getData(objectid=i.data) />
		<cfsavecontent variable="dataLayer">
			<cfoutput>
				<div class="bannerImageContent">
					<h3 class="bannerHeading">#i.title#</h3>
					<p class="bannerSubHeading">#i.subTitle#</p>
					<p class="bannerReadMore"></p>
				</div>
			</cfoutput>
		</cfsavecontent>

		<cfset stData = StructNew() />
		<cfset stData['layer'] = dataLayer/>
		<cfset stData['image'] = "#application.url.imageroot##stImage.SourceImage#" />
		<cfset ArrayAppend(aImageData, stData) />
	</cfloop>

  <cfset sObjectid = 'banner_#replaceNoCase(stObj.objectid, '-', '', 'all')#' />

	<!--- Build Image slideshow settings --->
	<cfoutput>

		<div class="bannerRotator">
			<script>
        addLoadEvent(function() {

          if (typeof bLoadGalleriaTheme === 'undefined'){
            bLoadGalleriaTheme = 1;
            var r = (jQuery.browser.msie)? "?r=" + Math.random(10000) : "";
            Galleria.loadTheme('#application.url.webroot#/js/lib/galleria/themes/dots/galleria.dots.js', r);
          }

          var imageData = #SerializeJSON(aImageData)#;

          Galleria.run('###sObjectid#', {

            imageCrop: #stobj.imageCrop#,
            transition: '#stobj.transition#',
            dummy: '#application.url.webroot#/wsimages/defaultBanner.png',
            responsive:true,
            lightbox: false,
            showInfo: false,
            debug: #stobj.debugMode#,
            showCounter: false,
            thumbnails: false,
            dataSource: imageData,

            extend: function(options){
              this.bind("loadfinish", function(options) {
              	var leftBtn = $('###sObjectid# .galleria-image-nav-left');
              	var rightBtn = $('###sObjectid# .galleria-image-nav-right');
              	if(rightBtn.html().length == 0) rightBtn.html('<i class="icon-right-open"></i>');
              	if(leftBtn.html().length == 0) leftBtn.html('<i class="icon-left-open"></i>');

              });
            }

          });

        });
			</script>
			<div id="#sObjectid#" class="banner"></div>
		</div>

	</cfoutput>
</cfif>
<cfsetting enablecfoutputonly="false" />
