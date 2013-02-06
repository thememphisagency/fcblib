<cfcomponent displayname="Database Utility CFC" hint="Database Utility CFC" output="false">

	<cffunction name="duplicateTable" displayname="Duplicate" hint="Used to duplicate a database table" access="public" output="false" returntype="Numeric">
		
		<cfargument name="tableName" displayName="Table name" type="String" hint="The name of the table to duplicate" required="true" />
		<cfargument name="duplicateName" displayName="Duplicate name" type="String" hint="The name of the resulting duplicate" required="true" />
		<cfargument name="uniqueColumnName" displayname="Unique column name" type="String" hint="The name of the column to count on for varification" required="false" default="objectid" />
		<cfargument name="objectList" displayname="Object list" type="String" hint="A list of objects which the backup should be limited to" required="false" default="" />
		
		<cfset var nReturn = 0 />
		<cfset var qCount = QueryNew('recordsCount') />
		
		<cfquery name="qDrop" datasource="#application.dsn#">
			DROP TABLE IF EXISTS #arguments.duplicateName#
		</cfquery>
		
		<cfquery name="qDuplicate" datasource="#application.dsn#">
			CREATE TABLE #arguments.duplicateName# SELECT * FROM #arguments.tableName#<cfif len(arguments.objectList)> WHERE objectid IN (#listQualify(arguments.objectList, "'", ",", "ALL")#)</cfif>
		</cfquery>
		
		<cfquery name="qCount" datasource="#application.dsn#">
			SELECT count(#arguments.uniqueColumnName#) as recordsCount FROM #arguments.duplicateName#
		</cfquery>
		
		<cfreturn qCount.recordsCount />
		
	</cffunction>

	<cffunction name="rollbackTable" displayname="Rollbak" hint="Used to rollback to a table" access="public" output="false" returntype="Numeric">
		
		<cfargument name="tableName" displayName="Table name" type="String" hint="The name of the table to duplicate" required="true" />
		<cfargument name="duplicateName" displayName="Duplicate name" type="String" hint="The name of the resulting duplicate" required="true" />
		<cfargument name="uniqueColumnName" displayname="Unique column name" type="String" hint="The name of the column to count on for varification" required="false" default="objectid" />
		
		<cfset var nReturn = 0 />
		<cfset var qCount = QueryNew('recordsCount') />
		
		<cfquery name="qDrop" datasource="#application.dsn#">
			DROP TABLE IF EXISTS #arguments.tablename#
		</cfquery>
		
		<cfquery name="qDuplicate" datasource="#application.dsn#">
			CREATE TABLE #arguments.tablename# SELECT * FROM #arguments.duplicateName#
		</cfquery>
		
		<!--- now we need to go through refObjects and delete everything for that type and reinstate them --->
		<cfquery name="qDelete" datasource="#application.dsn#">
			DELETE FROM refObjects WHERE typename = '#arguments.tablename#'
		</cfquery>
		
		<cfquery name="qDelete" datasource="#application.dsn#">
			INSERT INTO refObjects (typename,objectid) SELECT '#arguments.tablename#', objectid FROM #arguments.tablename#
		</cfquery>
		
		<cfquery name="qCount" datasource="#application.dsn#">
			SELECT count(#arguments.uniqueColumnName#) as recordsCount FROM #arguments.tablename#
		</cfquery>
		
		<cfreturn qCount.recordsCount />
		
	</cffunction>

	<cffunction name="ISOToDateTime" access="public" returntype="string" output="false" hint="Converts an ISO 8601 date/time stamp with optional dashes to a ColdFusion date/time stamp.">
	 
		<!--- Define arguments. --->
		<cfargument
			name="Date"
			type="string"
			required="true"
			hint="ISO 8601 date/time stamp."
			/>
	 
		<!---
			When returning the converted date/time stamp,
			allow for optional dashes.
		--->
		<cfreturn ARGUMENTS.Date.ReplaceFirst(
			"^.*?(\d{4})-?(\d{2})-?(\d{2})T([\d:]+).*$",
			"$1-$2-$3 $4"
			) />
	</cffunction>

	<cffunction name="cfDateToISODate" access="public" returntype="string" output="false" hint="Converts a ColdFusion date/time stamp to ISO 8601 date/time stamp.">
	 
		<!--- Define arguments. --->
		<cfargument name="Date" type="string" required="true" hint="ISO 8601 date/time stamp." />
	 
		<!---
			When returning the converted date/time stamp,
			allow for optional dashes.
		--->
		<cfreturn "#dateFormat(arguments.date,"yyyy-mm-dd")#T#timeFormat(arguments.date,"HH:mm")#:00"/>
	</cffunction>

	<cffunction name="parseJSDate" returntype="date">
		<cfargument name="dateString" type="string" required="true" />
		<cfset var date = ListSetAt(dateString, 1, listLast(dateString, " "), " ") />
		<cfset date = listFirst(date, "+") />
		<cfreturn ParseDateTime(date) />
	</cffunction>

</cfcomponent>