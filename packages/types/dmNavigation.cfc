<cfcomponent name="dmNavigation" extends="farcry.core.packages.types.dmNavigation" displayname="Navigation" hint="Navigation nodes are combined with the ntm_navigation table to build the site layout model for the FarCry CMS system." bUseInTree="1" bFriendly="1" bObjectBroker="true">

	<cfproperty ftSeq="1" ftFieldSet="General Details" bCleanHTML="1" name="title" type="nstring" hint="Object title.  Same as Label, but required for overview tree render." required="no" default="" ftLabel="Title" />
	<!--- New property --->
	<cfproperty ftSeq="18" ftFieldSet="Advanced" ftLabel="External URL" name="externalURL" type="nstring" hint="If populated this will open the URL in a new window" default="">

	<cffunction name="AfterSave" access="public" output="false" returntype="struct" hint="Called from setData and createData and run after the object has been saved.">
		<cfargument name="stProperties" required="yes" type="struct" hint="A structure containing the contents of the properties that were saved to the object.">
		
		<!--- call the nav query resetting the cache time span --->	
		<cfset application.bInvalidateNavQueryCache = 1>		
		
		<cfreturn super.AfterSave(argumentCollection="#arguments#") />
	</cffunction>

	<cffunction name="delete" access="public" hint="Specific delete method for dmNavigation. Removes all descendants">
		<cfargument name="objectid" required="yes" type="UUID" hint="Object ID of the object being deleted">
		<cfargument name="dsn" required="yes" type="string" default="#application.dsn#">

		<!--- Reset navigation query caching --->
		<cfset application.bInvalidateNavQueryCache = 1>		
		<cfreturn super.delete(argumentCollection="#arguments#") />
	</cffunction>	

	<cffunction name="BeforeSave" access="public" output="false" returntype="struct">
		<cfargument name="stProperties" required="true" type="struct">
		<cfargument name="stFields" required="true" type="struct">
		<cfargument name="stFormPost" required="false" type="struct">		
	
		<cfset var oUtility = request.fcbObjectBucket.create(fullPath='farcry.plugins.fcblib.packages.custom.utility') />	
		<cfset arguments.stProperties = oUtility.encodeHTMLEntity(arguments.stProperties, this.getTypeName()) />
		
		<cfreturn super.BeforeSave(argumentCollection="#arguments#") />
	</cffunction>

</cfcomponent>