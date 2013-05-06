<cfsetting enablecfoutputonly="true">


<cfparam name="url.module" default="" />

<!--- set your authentication details here --->
<cfset bUseAuthentication = false />
<cfset sName = 'developer' />
<cfset sPassword = 'developer' />
<!--- You're done customising! Yay! --->

<cfset bDump = false />
<cfset bOrphans = false />
<cfset stDepths = StructNew() />

<cffunction name="requestAuthenticationDetails" output="false">
	
	<cfheader statuscode="401" />
	<cfheader name="WWW-Authenticate" value="Basic realm=""Tree Inspector""" />
	<cfabort />
	
</cffunction>

<cffunction name="init" access="public" output="true" returntype="query">
	
	<cfargument name="treeType" required="no" default="dmNavigation">
	
	<cfset qReturn = QueryNew('objectid,parentid,objectName,nleft,nright,nlevel') />
	
	<cfquery name="qReturn" datasource="#application.dsn#">
		SELECT *
		FROM nested_tree_objects
		WHERE typename = '#arguments.treeType#'
		ORDER BY nleft
	</cfquery>
	
	<cfreturn qReturn />

</cffunction>

<cffunction name="isLastChild" output="false" returntype="boolean">
	
	<cfargument name="objectid" type="string" />
	
	<cfset var bReturn = false />
	
	<!--- is this the last of the children? --->
	<cfquery name="qChildren" dbtype="query">
		SELECT *
		FROM qNav
		WHERE parentid = '#qNav.parentid#'
		ORDER BY nleft DESC
	</cfquery>
	
	<cfif qChildren.objectid eq arguments.objectid><cfset bReturn = true /></cfif>
	
	<cfreturn bReturn />
	
</cffunction>

<cfscript>
/**
* modified from Nathan Dintenfass queryToStruct function from cflib
*/
function queryRowToStruct(q, row){
        //a variable to hold the struct
        var st = structNew();
        //two variable for iterating
        var ii = 1;
        var cc = 1;
        //grab the columns into an array for easy looping
        var cols = listToArray(q.columnList);
        //iterate over the columns of the query and create the arrays of values
        for(ii = 1; ii lte arrayLen(cols); ii = ii + 1){
            //now loop for the recordcount of the query and insert the values
            for(cc = row; cc lte row; cc = cc + 1)
                st[cols[ii]] = q[cols[ii]][cc];
        }
        //return the struct
        return st;
    }
</cfscript>

<!--- are we logged in? --->
<cfif bUseAuthentication eq true>
<cflogin>

	<cfif NOT isDefined('cflogin')>
	
		<cfset requestAuthenticationDetails() />
		
	<cfelse>
		
		<cfif cflogin.name eq sName AND cflogin.password eq sPassword>
			<cfloginuser name="#cflogin.name#" password="#cflogin.password#" roles="developer">
		<cfelse>
			<cfset requestAuthenticationDetails() />
		</cfif>
		
	</cfif>

</cflogin>
</cfif>

<!--- Which tree are we supposed to inspect?  --->
<cfif isDefined('form.inspect') AND form.treeType EQ 'dmCategory' OR isDefined('url.treeType') AND url.treeType EQ 'dmCategory' >
	<cfset treeType = 'dmCategory' />
<cfelse>
	<cfset treeType = 'dmNavigation' />
</cfif>

<!--- Do we need to update the database?  --->
<cfif isDefined('form.submit')>
	
	<!--- do we need to delete orphans? --->
	<cfif isDefined('form.deleteOrphans')>
	
		<!--- YEP! --->
		<cfquery name="qOrphans" datasource="#application.dsn#">
		   SELECT nested_tree_objects.objectid AS delIds
		   FROM nested_tree_objects 
		   LEFT JOIN #treeType# ON nested_tree_objects.objectid = #treeType#.objectId
		   WHERE typename = '#treeType#'
		   AND #treeType#.objectid IS NULL
		</cfquery>

		<cfif qOrphans.recordCount gt 0>
		   <cfquery datasource="#application.dsn#" name="q">
			       DELETE
			       FROM nested_tree_objects WHERE nested_tree_objects.objectid IN (#quotedValueList(qOrphans.delIds,",")#)
		   </cfquery>	   
		</cfif>
	
	</cfif>
	
	<!--- find anything that we need to update! --->
	<cfif lcase(form.fieldnames) contains 'b_'>
		
		<cfoutput><p>Updating the nested_tree_objects table.</p></cfoutput>
		
		<!--- let's get the changes! --->
		<cfloop list="#form.fieldnames#" index="fieldname">
			
			<cfif lcase(left(fieldname, 2)) eq 'b_'>
				
				<cfset objectid = right(fieldname, len(fieldname)-2) />
				
				<cfquery name="qVariable" datasource="#application.dsn#">
					UPDATE nested_tree_objects
					SET nleft = #form['nleft_#objectid#']#, nright = #form['nright_#objectid#']#, nlevel = #form['nlevel_#objectid#']#
					WHERE objectid = '#objectid#'
				</cfquery>
				
				<cfoutput>
					UPDATE nested_tree_objects
					SET nleft = #form['nleft_#objectid#']#, nright = #form['nright_#objectid#']#, nlevel = #form['nlevel_#objectid#']#
					WHERE objectid = '#objectid#'<br />
				</cfoutput>
				
			</cfif>
			
		</cfloop>
		
		<cfoutput><p>Update complete!</p></cfoutput>
	
	</cfif>

</cfif>

<cfoutput>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml" xml:lang="en">
<head>
	
	<title>Tree Inspector</title>
	
	<style type="text/css">
	
		body, p, td {
			font-family: Arial;
			font-size: 11px;
		}
		
		table {
			border-collapse: collpase;
			border-spacing: 0px;
			margin: 0px;
			padding: 10px 0 0;
		}
		
		td, th {
			padding: 5px 10px 5px 10px;
			margin: 0px;
			border-bottom: 1px solid black;
		}
		
		td.depth0 {
			background-color: ##FFFF99;
		}
		td.depth1 {
			background-color: ##F5FFAD;
		}
		td.depth2 {
			background-color: ##EBFFC2;
		}
		td.depth3 {
			background-color: ##E0FFD6;
		}
		td.depth4 {
			background-color: ##D6FFEB;
		}
		td.depth5 {
			background-color: ##CCFFFF;
		}
		
		span.error {
			background-color: ##CC0000;
			color: ##FFFFFF;
			padding: 5px;
			font-weight: bold;
		}
		
		dl.table-display
		{
			margin: 2em 0;
			padding: 0;
		}
		
		.table-display dt
		{
			width: 12em;
			float: left;
			margin: 0 0 0 0;
			padding: .5em;
			border-top: 1px solid ##999;
			font-weight: bold;
		}
		
		/* commented backslash hack for mac-ie5 \*/
		dt { clear: both; }
		/* end hack */
		
		.table-display dd
		{
			float: left;
			width: 24em;
			margin: 0 0 0 0;
			padding: .5em;
			border-top: 1px solid ##999;
		}
		
		dl.nodeInfo dt {
			float: left;
			font-weight: bold;
			width: 8em;
		}
		
		.clear {
			clear: both;
		}
		
	
	</style>
		
</head>
<body>
	
<h1>Tree Inspector</h1>
<h4>Version 0.4</h4>
	
</cfoutput>

<cfset qNav = init(treeType) />

<cfif bDump eq true>

	<cfoutput>
		<table>
			<tr>
				<th>nleft</th>
				<th>nlevel</th>
				<th>nright</th>
				<th>objectid</th>
				<th>objectname</th>
				<th>parentid</th>
			</tr>
	</cfoutput>
	
		<cfloop query="qNav">
			<cfoutput>
				<tr>
					<td>#qNav.nleft#</td>
					<td>#qNav.nlevel#</td>
					<td>#qNav.nright#</td>
					<td>#qNav.objectid#</td>
					<td>#qNav.objectname#</td>
					<td>#qNav.parentid#</td>
				</tr>
			</cfoutput>
		</cfloop>
	
	<cfoutput>
		</table>	
	</cfoutput>

</cfif>
	<cfoutput>
		
		<form method="get" action="">
			<select name="treeType">
				<option value="dmNavigation" <cfif treeType EQ 'dmNavigation'>selected="1"</cfif>>Navigation Tree</option>
				<option value="dmCategory" <cfif treeType EQ 'dmCategory'>selected="1"</cfif>>Category Tree</option>
			</select>
			
			<input type="hidden" name="module" value="#url.module#" />
			<input type="submit" name="inspect" value="Inspect !" />
		</form>
		
	</cfoutput>
	
	<cfquery name="qDepth" dbtype="query">
		SELECT DISTINCT nlevel
		FROM qNav
		ORDER BY nlevel DESC
	</cfquery>
	
	<cfset nDepth = qDepth.nlevel />
	
	<cfoutput>
		<form method="post" action="">
		
		<table>
	</cfoutput>

	<cfloop query="qNav">
	
		<cfset stNode = StructNew() />
		
		<cfloop list="#qNav.columnList#" index="key">
			<cfset stNode[key] = qNav[key][qNav.currentRow] />
		</cfloop>
	
		<cfset stDepths[qNav.nlevel + 1] = stNode />
	
		<cfoutput><tr></cfoutput>
	
		<cfloop from="1" to="#nDepth+1#" index="i">
			
			<cfif i-1 eq qNav.nlevel>
				
				<cfset bError = false />
				<cfset bLastChild = false />
				<cfset bOrphaned = false />
				<cfset bSiblingError = false />
				
				<!--- let's determine if the numbers add up! --->
				<cfquery name="qCheck" dbtype="query">
					SELECT *
					FROM qNav
					WHERE objectid = '#qNav.parentid#'
				</cfquery>
				
				<!--- is this the last of the children? --->
				<cfquery name="qChildren" dbtype="query">
					SELECT *
					FROM qNav
					WHERE parentid = '#qNav.parentid#'
					ORDER BY nleft DESC
				</cfquery>
				
				<cfquery name="qOrphaned" datasource="#application.dsn#">
					SELECT *
					FROM #treeType#
					WHERE objectid = '#qNav.objectid#'
				</cfquery>
				
				<cfquery name="qSibling" dbtype="query">
					SELECT *
					FROM qNav
					WHERE nlevel = #qNav.nlevel#
					AND parentid = '#qNav.parentid#'
					AND nleft < #qNav.nleft#
					ORDER BY nLeft DESC
				</cfquery>
				
				<!--- check the parentid --->
				<cfquery name="qParent" dbtype="query">
					SELECT *
					FROM qNav
					WHERE objectid = '#qNav.parentid#'
					AND nleft < #qNav.nleft#
					AND nright > #qNav.nleft#
				</cfquery>
				
				<cfif qChildren.objectid eq qNav.objectid><cfset bLastChild = true /></cfif>
				<cfif bLastChild eq true AND qCheck.nright neq qNav.nright+1><cfset bError = true /></cfif>
				<cfif qSibling.recordCount gt 0 AND qSibling.nright+1 neq qNav.nleft><cfset bSiblingError = true /></cfif>
				
				<cfoutput><td class="depth#i-1#" style="white-space: nowrap;"><input type="checkbox" name="b_#qNav.objectid#" value="1" onchange="if (this.checked == true) { document.getElementById('#replace(qNav.objectid, '-', '', 'all')#').style.display = 'block' } else { document.getElementById('#replace(qNav.objectid, '-', '', 'all')#').style.display = 'none' };" /> <cfif bSiblingError eq true><span class="error"></cfif>(#qNav.nleft#)<cfif bSiblingError eq true></span></cfif> <a href="###replace(qNav.objectid, '-', '', 'all')#" onclick="if (document.getElementById('#replace(qNav.objectid, '-', '', 'all')#Dump').style.display == 'none') { document.getElementById('#replace(qNav.objectid, '-', '', 'all')#Dump').style.display = 'block' } else { document.getElementById('#replace(qNav.objectid, '-', '', 'all')#Dump').style.display = 'none' };">#qNav.objectname#</a> <cfif bLastChild AND bError><span class="error"></cfif>(#qNav.nright#)<cfif bLastChild AND bError></span></cfif>
				
				<cfif qOrphaned.recordCount eq 0><cfset bOrphans = true /><span class="error">I'm an orphan!</span></cfif>
				
				<cfif qNav.nleft NEQ 1 AND qParent.recordCount EQ 0><span class="error">Missing parent?!</span></cfif>
				
				<div id="#replace(qNav.objectid, '-', '', 'all')#" style="display: none;">nleft: <input type="text" name="nleft_#qNav.objectid#" value="#qNav.nleft#" /><br />
				nright: <input type="text" name="nright_#qNav.objectid#" value="#qNav.nright#" /><br />
				nlevel: <input type="text" name="nlevel_#qNav.objectid#" value="#qNav.nlevel#" /></div>
				
				<cfset stRow = queryRowToStruct(qNav, qNav.currentRow) />
				
				<div id="#replace(qNav.objectid, '-', '', 'all')#Dump" style="display: none;">
					<dl class="nodeInfo">
						<dt>nleft</dt>
						<dd>#stRow.nleft#</dd>
						<dt>nlevel</dt>
						<dd>#stRow.nlevel#</dd>
						<dt>nright</dt>
						<dd>#stRow.nright#</dd>
						<dt>objectid</dt>
						<dd>#stRow.objectid#</dd>
						<dt>objectname</dt>
						<dd>#stRow.objectname#</dd>
						<dt>parentid</dt>
						<dd>#stRow.parentid#</dd>
						<dt>typename</dt>
						<dd>#stRow.typename#</dd>
					</dl>
				</div>
				
				</td></cfoutput>
				
				<cfflush>
				
			<cfelse>
				
				<cfset icon = '' />
				
				<cfif structCount(stDepths) GTE qNav.nlevel AND qNav.nlevel GT 0 AND structKeyExists(stDepths[qNav.nlevel],"objectID") AND stDepths[qNav.nlevel].objectid EQ qNav.parentid>
					
					<cfif i eq qNAv.nlevel AND stDepths[qNav.nlevel].nright EQ qNAv.nright+1>
						<cfset icon = '-' />
					</cfif>
					
					<cfif i eq qNAv.nlevel AND stDepths[qNav.nlevel].nright NEQ qNAv.nright+1>
						<cfset icon = '+' />
					</cfif>
					
					<cfif (i EQ qNAv.nlevel-1 AND qNav.nright-1 EQ qNav.nleft) OR (i LTE qNAv.nlevel-1 AND len(icon) EQ 0)>
						<cfset icon = '|' />
					</cfif>
					
				</cfif>
				
				<cfoutput><td class="depth#i-1#">#icon#</td></cfoutput>
			
			</cfif>
		
		</cfloop>
		
		<cfoutput></tr></cfoutput>
	
	</cfloop>
	
	<cfoutput>
		</table>
	</cfoutput>

	<cfif bOrphans eq true>
		<cfoutput>
		<p><label for="deleteOrphans">
			<input type="checkbox" name="deleteOrphans"> Delete orphans?
		</label></p>
		</cfoutput>
	</cfif>

	<cfoutput>
		
		<input type="submit" name="submit" value="Make Changes">
		</form>
	</cfoutput>
	
	<cfoutput>
	
	<h2>Key</h2>
	
	<dl class="table-display">
		
		<dt><span class="error">(10)</span> objectname (15)</dt>
		<dd><b>nleft highlighted.</b> This means that the upper sibling's nright is not equal to the current node's nleft+1. The nleft of any node should be the the same as the nright of the upper sibling, plus 1.</dd>
		
		<dt>(10) objectname <span class="error">(15)</span></dt>
		<dd><b>nright highlighted.</b> This will only happen on the last node in a group of children. This means that the parent node's nright is not equal to the current node's nright+1.</dd>
		
		<dt><span class="error">I'm an orphan!</span></dt>
		<dd>This means that the objectid doesn't exist in refObjects (usually) and there is no record in dmNavigation</dd>
		
		<dt><span class="error">Missing parent?!</span></dt>
		<dd>This means that the parentid doesn't match the parent nodes objectid.</dd>
		
	</dl>
	
	<p class="clear">&nbsp;</p>
	
	</cfoutput>

<cfoutput>
	</body>
</html>
</cfoutput>

<cfsetting enablecfoutputonly="false">