<cfsetting enablecfoutputonly="true" />
<!--- @@displayname: List item --->
<!--- @@author: Sandy Trinh --->

<cfimport taglib="/farcry/core/tags/webskin" prefix="skin">

<cfoutput>
  <li><skin:buildLink objectid="#stobj.objectID#" class="readMore"><span>#stObj.title#</span></skin:buildLink></li>
</cfoutput>

<cfsetting enablecfoutputonly="false" />
