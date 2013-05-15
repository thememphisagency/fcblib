<cfsetting enablecfoutputonly="true">
<!--- @@License:--->
<!--- @@displayname: Source Image --->
<!--- @@description:   --->
<!--- @@author: Sandy Trinh --->

<cfoutput>
<img class="imgNormal" src="#application.url.imageroot##stobj.SourceImage#" alt="#stobj.alt#" title="#stobj.title#" />
</cfoutput>

<cfsetting enablecfoutputonly="false">