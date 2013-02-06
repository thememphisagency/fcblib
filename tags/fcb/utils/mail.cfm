<cfsetting enablecfoutputonly="true" /> 
<cfif thistag.ExecutionMode eq "end">
	<cfexit method="exittag" />
</cfif>
<cfparam name="attributes.to" default="">
<cfparam name="attributes.from" default="">
<cfparam name="attributes.replyTo" default="">
<cfparam name="attributes.failto" default="">
<cfparam name="attributes.cc" default="">
<cfparam name="attributes.bcc" default="">
<cfparam name="attributes.mailContent" default="">
<cfparam name="attributes.subject" default="">
<cfparam name="attributes.type" default="plain">
<cfparam name="attributes.attachment" default="">

<cftry>
<cfif attributes.attachment NEQ '' AND FileExists("#attributes.attachment#")>
	<cfmail 
		to="#attributes.to#"
		from="#attributes.from#"
		replyTo="#attributes.replyTo#"
		failto="#attributes.failto#"
		cc="#attributes.cc#"
		bcc="#attributes.bcc#"
		subject="#attributes.subject#"
		type="#attributes.type#"
		mimeattach="#attributes.attachment#"
		>

	#attributes.mailContent#

	</cfmail>
<cfelse>
	<cfmail 
	to="#attributes.to#"
	from="#attributes.from#"
	replyTo="#attributes.replyTo#"
	failto="#attributes.failto#"
	cc="#attributes.cc#"
	bcc="#attributes.bcc#"
	subject="#attributes.subject#"
	type="#attributes.type#"
	>

	#attributes.mailContent#

	</cfmail>
</cfif>

	<cfset request.fcbObjectBucket.create(typename="fcbMail").createRecord(attributes) />

	<cfcatch type="any">
		<cfset request.fcbObjectBucket.create(typename="fcbMail").createFailRecord(cfcatch,attributes) />
 	</cfcatch>

</cftry>

<cfsetting enablecfoutputonly="false" /> 