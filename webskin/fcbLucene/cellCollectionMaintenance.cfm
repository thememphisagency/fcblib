<cfsetting enablecfoutputonly="true" />
<!----------------------------------------
ENVIRONMENT
----------------------------------------->
<cfparam name="url.module" type="string" />

<cfoutput>
<a href="##" onclick="selectObjectID('#stobj.objectid#');btnSubmit('#Request.farcryForm.Name#','optimize');" title="Optimise Documents">O</a>
<a href="##" onclick="selectObjectID('#stobj.objectid#');btnSubmit('#Request.farcryForm.Name#','deleteCollection');" title="Delete Documents">D</a>
</cfoutput>

<cfsetting enablecfoutputonly="false" />