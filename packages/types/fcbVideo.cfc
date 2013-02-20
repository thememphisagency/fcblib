<cfcomponent extends="farcry.plugins.fcblib.packages.types.fcbVersions" displayname="fcbVideo" hint="HTML 5 Video">

	<cfproperty ftSeq="1" ftFieldSet="General Details" bCleanHTML="1" name="title" type="string" hint="Title of content item." required="no" default="" ftlabel="Title" ftvalidation="required" />
	<cfproperty ftSeq="2" ftFieldSet="General Details" bCleanHTML="1" name="teaser" type="longchar" hint="Teaser text." required="no" default="" ftlabel="Teaser" />
	<cfproperty ftSeq="10" ftFieldSet="General Details" name="mp4" type="UUID" hint="." required="no" default="" ftLabel="Chrome/Safari (.mp4)" ftSelectMultiple="false" ftJoin="dmFile" bSyncStatus="true">
	<cfproperty ftSeq="12" ftFieldSet="General Details" name="ogv" type="UUID" hint="." required="no" default="" ftLabel="Firefox (.ogv)" ftSelectMultiple="false" ftJoin="dmFile" bSyncStatus="true">
	<cfproperty ftSeq="13" ftFieldSet="General Details" name="poster" type="UUID" hint="." required="no" default="" ftLabel="Poster" ftSelectMultiple="false" ftJoin="dmImage" bSyncStatus="true">

	<cfproperty name="status" type="string" hint="" required="no" default="draft" />
	
	<cffunction name="getData" access="public" output="true" returntype="struct" hint="Get data for a specific objectid and return as a structure, including array properties and typename.">
		<cfargument name="objectid" type="uuid" required="true">
		<cfargument name="dsn" type="string" required="false" default="#application.dsn#">
		<cfargument name="dbowner" type="string" required="false" default="#ucase(application.dbowner)#">
		<cfargument name="bShallow" type="boolean" required="false" default="false" hint="Setting to true filters all longchar property types from record.">
		<cfargument name="bFullArrayProps" type="boolean" required="false" default="true" hint="Setting to true returns array properties as an array of structs instead of an array of strings IF IT IS AN EXTENDED ARRAY.">
		<cfargument name="bUseInstanceCache" type="boolean" required="false" default="true" hint="setting to use instance cache if one exists">
		<cfargument name="bArraysAsStructs" type="boolean" required="false" default="false" hint="Setting to true returns array properties as an array of structs instead of an array of strings.">
		
		<cfset var stresult = super.getData(objectid=arguments.objectid) />
		<cfset var oFile = request.fcbObjectBucket.create(typename='dmFile') />
		<cfset var oImage = request.fcbObjectBucket.create(typename='dmImage') />
		
		<cfset stResult.mp4Path = "" />
		<cfset stResult.ogvPath = "" />
		
		<cfif isValid('UUID',stResult.mp4)>
			<cfset stResult.mp4Path = oFile.getData(objectid=stResult.mp4).filename />
		</cfif>
		<cfif isValid('UUID',stResult.ogv)>
			<cfset stResult.ogvPath = oFile.getData(objectid=stResult.ogv).filename />
		</cfif>
		<cfif isValid('UUID',stResult.poster)>
			<cfset stResult.posterPath = oImage.getData(objectid=stResult.poster).sourceImage />
		</cfif>		
		<cfreturn stresult>
	
	</cffunction>
	
</cfcomponent>
