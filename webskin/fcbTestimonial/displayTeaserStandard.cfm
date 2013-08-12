<cfsetting enablecfoutputonly="true" />
<!--- @@Copyright: Daemon Pty Limited 2002-2008, http://www.daemon.com.au --->
<!--- @@License: --->
<!--- @@displayname: Standard --->
<!--- @@author: --->

<!--- IMPORT TAG LIBRARIES --->
<cfimport taglib="/farcry/core/tags/webskin" prefix="skin">

<cfoutput>
<div class="teaser">
  <div class="teaserBody">
    <h3><skin:buildLink objectID="#stobj.objectid#" linkText="#stObj.label#" /></h3>
    <p>#stObj.Teaser#</p>
  </div>
  <skin:buildLink objectid="#stobj.objectID#" class="readMore">#stObj.readMoreText#<i class="icon-right"></i></skin:buildLink>
</div><!-- END .teaser -->
</cfoutput>

<cfsetting enablecfoutputonly="false" />
