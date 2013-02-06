<cfcomponent name="fcbMail" displayname="Mail" hint="" extends="farcry.core.packages.types.types">

	<cfproperty name="label" hint="Label" type="string" default="" />
	<cfproperty name="emailAddress" hint="" type="longchar" default="" />
	<cfproperty name="dumpWDDX" hint="WDDX version of dump" type="longchar" default="" />
	<cfproperty name="mailContent" hint="" type="longchar" default="" />
	<cfproperty name="status" hint="" type="boolean" default="0" />

	<cffunction name="createFailRecord">
		<cfargument name="error" type="any" required="true" />
		<cfargument name="attributes" type="struct" required="true" />

		<cfset var sError = '' />
		<cfsavecontent variable="sError"><cfdump var="#arguments.error#"></cfsavecontent>

		<cfscript>
		stProps =  structNew();
		stProps.label  = "Fail Email to #arguments.attributes.to#";
		stProps.subject = arguments.attributes.from;
		stProps.emailAddress = arguments.attributes.to;
		stProps.dumpWDDX = sError;
		stProps.mailContent = arguments.attributes.mailContent;
		stProps.status = 0;
		
		createData(stProperties=stProps);
		</cfscript>

		<cfmail to="#application.config.fcbForms.enquiryRecipient#" from="#application.config.fcbForms.enquiryFromEmail#" subject="#application.config.general.sitetitle#: Failure to send email" type="html">
			This email has failed to send due to the following reasons

			#sError#
		</cfmail>

	</cffunction>


	<cffunction name="createRecord">
		<cfargument name="attributes" type="struct" required="true" />

		<cfscript>
		stProps =  structNew();
		stProps.label = "Successfull Email to #arguments.attributes.to#";
		stProps.subject = arguments.attributes.from;
		stProps.emailAddress = arguments.attributes.to;
		stProps.mailContent = arguments.attributes.mailContent;
		stProps.status = 1;
		createData(stProperties=stProps);
		</cfscript>

	</cffunction>


</cfcomponent>