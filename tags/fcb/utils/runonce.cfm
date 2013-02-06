<cfparam name="attributes.id" default="runonce#replace(CreateUUID(), '-', '', 'all')#" />

<!--- quit tag if running in end mode --->
<cfif thistag.executionmode eq "end">
	<cfexit />
</cfif>

<cfif thisTag.ExecutionMode is 'start'>

	<cfif isDefined('request.#attributes.id#')>
		<cfexit />
	</cfif>

	<cfset request['#attributes.id#'] = true />

</cfif>