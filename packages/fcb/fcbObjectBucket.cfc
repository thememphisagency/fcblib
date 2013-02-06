<!--- 
|| DESCRIPTION || 
$Description: fcbObjectBucket - object creation singleton $

|| DEVELOPER ||
$Developer: Benjamin Dry (ben@enpresiv.com) $
--->
<!--- 
|| USAGE ||
		Add to the OnRequestStart of application.cfc or to _serverSpecificRequestScope.cfm:		
			fcbObjectBucket = createObject("component","farcry.plugins.fcblib.packages.fcb.fcbObjectBucket");
			fcbObjectBucket.init();

		Create Objects as follows:
		
			Typename: o = request.fcbObjectBucket.create(typename='dmHTML');

				OR

			Fullpath: o = request.fcbObjectBucket.create(fullPath='farcry.projects.venturecapitalsa.packages.types.fcbFLV');
 --->

<cfcomponent displayname="FCB Object Bucket" hint="">
	<cfproperty name="typename" type="string" hint="" required="yes" />

	<cffunction name="init" returntype="fcbObjectBucket">
	
		<cfset request.fcbObjectBucket = this />
		<cfreturn this>
		
	</cffunction>
	
	<cffunction name="create" returntype="Any">
		<cfargument name="typename" required="false" type="string" default=""/>
		<cfargument name="fullPath" required="false" type="string" default=""/>
		<cfargument name="initFunction" required="false" type="string" default=""/>
		
		<!--- make sure soemthing is being passed in --->
		<cfif len(arguments.typename) IS 0 AND len(arguments.fullPath) IS 0>
			<cfthrow message="You must specify either a typename or fullPath" />
		</cfif>
		
		<!--- check to see struct to store objects exists, if not then create--->
		<cfif NOT structKeyExists(request.fcbObjectBucket,'objects')>
			<cfset request.fcbObjectBucket.objects = structNew() />
		</cfif>
		
		<!--- check to see objects exists in struct, if not then add and return--->
		<cfif len(arguments.typename) AND structKeyExists(application.types, arguments.typename)>
			<cfif NOT structKeyExists(request.fcbObjectBucket.objects,arguments.typename)>
				<cfif len(arguments.initFunction) GT 0>
					<cfset o = evaluate('createObject("component",application.types[arguments.typename].typepath).#arguments.initFunction#()') />
				<cfelse>
					<cfset o = createObject("component",application.types[arguments.typename].typepath) />
				</cfif>			
				<cfset request.fcbObjectBucket.objects[arguments.typename] = o />
			</cfif>
			<cfreturn request.fcbObjectBucket.objects[arguments.typename] />
		<cfelseif len(arguments.fullPath)>
			<cfif NOT structKeyExists(request.fcbObjectBucket.objects,arguments.fullPath)>
				<cfif len(arguments.initFunction) GT 0>
					<cfset o = evaluate('createObject("component",arguments.fullPath).#arguments.initFunction#()') />
				<cfelse>
					<cfset o = createObject("component",arguments.fullPath) />
				</cfif>			
				<cfset request.fcbObjectBucket.objects[arguments.fullPath] = o />
			</cfif>
			<cfreturn request.fcbObjectBucket.objects[arguments.fullPath] />
		</cfif>

	</cffunction>

</cfcomponent>




