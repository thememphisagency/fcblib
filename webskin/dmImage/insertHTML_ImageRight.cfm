<cfsetting enablecfoutputonly="true">
<!--- @@Copyright: Enpresiv Pty Ltd 2004-2008, http://www.enpresiv.com --->
<!--- @@License:--->
<!--- @@displayname: Source Image Right --->
<!--- @@description:   --->
<!--- @@author: Sandy Trinh --->



<cfoutput>
<img class="imgRight" src="#application.url.imageroot##stobj.SourceImage#" alt="#stobj.alt#" title="#stobj.title#" />
</cfoutput>

<cfsetting enablecfoutputonly="false">