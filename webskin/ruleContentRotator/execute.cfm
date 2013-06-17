<cfsetting enablecfoutputonly="true" />
<!--- @@displayname: Content Rotator execute --->

<cfimport taglib="/farcry/core/tags/webskin" prefix="skin">

<cfif arrayLen(stObj.aObjectIDs) GT 0>

    <cfquery name="q" datasource="#application.dsn#">
      SELECT * FROM refObjects where objectid IN (<cfqueryparam value="#arrayToList(stObj.aObjectIDs)#" cfsqltype="cf_sql_longvarchar" list="true" />)
    </cfquery>

<cfelseif len(stObj.contentType) GT 0>

  <cfset stFilters = structNew() />

  <cfswitch expression="#stObj.contentType#">
    <cfcase value="dmNews">

      <cfif len(stobj.bMatchAllKeywords) GT 0>
        <cfset stFilters['catNews_eq'] = stObj.categories />
      <cfelseif len(stObj.categories) GT 0>
        <cfset stFilters['catNews_in'] = stObj.categories />
      </cfif>

      <cfset stFilters['publishdate_lte'] = now() />
      <cfset stFilters['expirydate_gte'] = now() />

    </cfcase>
    <cfcase value="dmEvent">

      <cfif len(stobj.bMatchAllKeywords) GT 0>
        <cfset stFilters['catEvent_eq'] = stObj.categories />
      <cfelseif len(stObj.categories) GT 0>
        <cfset stFilters['catEvent_in'] = stObj.categories />
      </cfif>

      <cfset stFilters['publishdate_lte'] = now() />
      <cfset stFilters['expirydate_gte'] = now() />
      <cfset stFilters['orderby'] = 'startDate DESC, label ASC' />
    </cfcase>
    <cfdefaultcase>
        <!--- do nothing --->
    </cfdefaultcase>
  </cfswitch>

  <cfinvoke component="farcry.core.packages.lib.fapi" method="getContentObjects" returnvariable="q">
    <cfinvokeargument name="typename" value="#stObj.contentType#" />

      <cfloop collection="#stFilters#" item="key">
        <cfinvokeargument name="#key#" value="#stFilters[key]#" />
      </cfloop>

  </cfinvoke>

</cfif>

<cfif  q.recordCount GT 0>

  <cfset aImageData = ArrayNew(1) />
  <cfset iStartRow = 1 />
  <cfset iEndROw = q.recordCount />

  <cfif stObj.numItems GT 0>
    <cfset iEndROw = stObj.numItems />
  </cfif>

  <cfloop query="q" startrow="#iStartRow#" endrow="#iEndRow#">
    <skin:view objectid="#q.objectid#" typename="#q.typename#" webskin="#stObj.displayMethod#" r_html="sTeaserMarkup" alternateHTML="<!-- #stObj.displayMethod# does not exist for #q.typename# -->" />

    <cfset stData = StructNew() />
    <cfset stData['layer'] = sTeaserMarkup />
    <cfset stData['image'] = "#application.url.imageroot#/wsimages/blank.gif" />
    <cfset ArrayAppend(aImageData, stData) />
  </cfloop>

  <cfset sObjectid = 'banner_#replaceNoCase(stObj.objectid, '-', '', 'all')#' />

  <!--- Build Image slideshow settings --->
  <cfoutput>
    <div class="module contentRotator">
      <cfoutput><h3 class="heading">#stObj.intro#</h3></cfoutput>
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

            imageCrop: true,
            transition: 'fade',
            responsive:true,
            lightbox: false,
            showInfo: false,
            debug: false,
            showCounter: false,
            thumbnails: true,
            dataSource: imageData
          });

        });
        </script>
        <div id="#sObjectid#" class="banner"></div>
      </div>
    </div>
  </cfoutput>

</cfif>
<cfsetting enablecfoutputonly="false" />
