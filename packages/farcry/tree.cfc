
<cfcomponent extends="farcry.core.packages.farcry.tree" displayname="Nested Tree Model" hint="Database tree management based on Joe Celko's nested tree model.">


<!--- 
		
		This is an adjusted version of getDescendants that can cache the navquery
		much more effectively. It works by populating 2 application scoped variables:
		
			bInvalidateNavQueryCache (1/0)
			navQueryCache
		
		To reinitialise the nav query after performing an update simply set lColumns
		
		application.bInvalidateNavQueryCache = 1
		
		The next time the nav query runs it will get a fresh copy and place it into cache!
		
		Apart from that the function is exactly the same as the one used in the tree.cfc
 --->
<cffunction name="getDescendants" access="public" output="false" returntype="query" hint="Get the entire branch with the option to hide empty nodes from the results">
    <cfargument name="objectid" required="yes" type="UUID" />
    <cfargument name="depth" required="false" type="string" default="0" />
    <cfargument name="lColumns" required="false" type="string" default="" />
    <cfargument name="aFilter" required="false" type="array" default="#arrayNew(1)#" />
    <cfargument name="dsn" required="false" type="string" default="#application.dsn#" />
    <cfargument name="bIncludeSelf" required="false" type="boolean" default="0" hint="set this to 1 if you want to include the objectid you are passing" />
    <cfargument name="bHideEmptyNodes" required="false" type="boolean" hint="Hides empty nodes from results." default="0" />
    <cfargument name="l404Check" required="false" type="string" default="externalLink,dmHTML,dmLink,dmInclude,dmFlash,dmImage,dmFile" />
    <cfargument name="dbowner" required="false" type="string" default="#application.dbowner#" />
	<cfset var qreturn = queryNew("blah") />
    <cfset var sql = structNew() />
    <cfset var nlevel = 0 /> <!--- unlikely that we should ever have a table this deep --->
    <cfset var q = queryNew("blah") />
    <cfset var i = 1 />
    <cfset var columns = "" />
	<cfset var stLocal = StructNew()>


	
    <!--- Get descendants of supplied object, optionally to a supplied depth (1 = 1 level down, etc)
    returns a recordset of ids and labels, in order of "birth". If no rowcount, no descendants
    get details of node passed in --->

    <cfquery datasource="#arguments.dsn#" name="q">
     SELECT nleft, nright, typename, nlevel
     FROM #arguments.dbowner#nested_tree_objects
     where objectid = '#arguments.objectid#'
    </cfquery>

    <!--- determine additional columns --->
    <cfset columns = "" />
    <cfif len(arguments.lColumns)>
      <cfset columns = "," & arguments.lColumns />
    </cfif>

	<cfif q.typename EQ "categories">
		<cfset stLocal.primaryKeyField = "categoryid">
	<cfelse>
		<cfset stLocal.primaryKeyField = "objectid">
	</cfif>
    <cfif q.recordCount>
    	<!--- set reset nlevel based on arguments.depth --->
   		<cfset nlevel = q.nlevel + arguments.depth />

		<cfsavecontent variable="stLocal.sql">
		<cfoutput>
		SELECT ntm.objectid,ntm.parentid,ntm.typename,ntm.nleft,ntm.nright,ntm.nlevel,ntm.ObjectName #columns#
		FROM #arguments.dbowner#nested_tree_objects ntm
		INNER JOIN #arguments.dbowner##q.typename# t ON t.#stLocal.primaryKeyField# = ntm.objectid
		AND ntm.nleft
		<cfif arguments.bIncludeSelf>
			>=			
		<cfelse>
			>		
		</cfif>
		#q.nleft#
		AND ntm.nleft < #q.nright#
		AND ntm.typename = '#q.typename#'
		
		<cfif arguments.depth GT 0>
			AND ntm.nlevel <= #nlevel#
		</cfif>
		
		<cfif arrayLen(arguments.afilter)>
			<cfloop from="1" to="#arrayLen(arguments.afilter)#" index="i">
				AND #replace(arguments.afilter[i],"''","'","all")#
			</cfloop>
		</cfif>				

		<cfif arguments.bHideEmptyNodes and len(arguments.l404Check)>
		AND (<cfif listFindNoCase(arguments.l404Check,'externalLink')>
		     (t.externalLink <> '')
		     OR</cfif>
		     t.objectId in (SELECT da.parentid
		                    FROM #q.typename#_aObjectIds da
		                    INNER JOIN refObjects r ON da.data = r.objectid
		                    AND r.typename in (#listQualify(arguments.l404Check,"'")#)))
		     </cfif>

				
		ORDER BY ntm.nleft
				
		</cfoutput>
		</cfsavecontent>
			
		<!--- this is where the nav query magic happens --->
		<cfif NOT structKeyExists(application,"bInvalidateNavQueryCache")>
			<cfset application.bInvalidateNavQueryCache = 1>
		</cfif>
		<cfif application.bInvalidateNavQueryCache IS 1 OR NOT structKeyExists(application,"navQueryCache") OR (structKeyExists(url, 'updateNav') AND url.updateNav EQ 1)>
			<cfquery datasource="#arguments.dsn#" name="qNav">#preservesinglequotes(stLocal.sql)#</cfquery>
			<cfset application.navQueryCache = qNav>
			<cfset application.bInvalidateNavQueryCache = 0>
		</cfif>
		<cfset qReturn = duplicate(application.navQueryCache)>
		
    <cfelse>
      <cfthrow message="#arguments.objectid# is not a valid objectID for getDescendants()">
    </cfif>
	
    <cfreturn qReturn />
  </cffunction>

</cfcomponent>