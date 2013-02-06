<cfimport taglib="/farcry/core/tags/admin" prefix="admin" />
<cfimport taglib="/farcry/core/tags/formtools" prefix="ft" />

<!----------------------------------------
ENVIRONMENT
----------------------------------------->
<cfscript>
	// apply custom cell renderers
	aCustomColumns = arrayNew(1);
	sttmp = structNew();
	sttmp.webskin = "cellCollectionUpdate.cfm"; // located in the webskin of the type the controller is listing on
	sttmp.title = "Update"; 
	sttmp.sortable = false; //optional
	arrayAppend(aCustomColumns, sttmp);
	sttmp = structNew();
	sttmp.webskin = "cellCollectionMaintenance.cfm"; // located in the webskin of the type the controller is listing on
	sttmp.title = "Maintenance"; 
	sttmp.sortable = false; //optional
	// sttmp.property = ""; //mandatory is sortable=true
	arrayAppend(aCustomColumns, sttmp);
</cfscript>

<!----------------------------------------
ACTION
----------------------------------------->
<ft:processForm action="create">
	<cfset oLucene=createobject("component", "farcry.plugins.fcblib.packages.custom.luceneService").init() />
	<cfset stConfig=createobject("component", "farcry.plugins.fcblib.packages.types.fcbLucene").getData(objectid=form.selectedobjectid) />
	<cfset stresult=oLucene.createCollection(collection=stconfig.collectionname) />
	<cfdump var="#stResult.message#" />
</ft:processForm>

<ft:processForm action="deleteCollection" >
	<cfset oLucene=createobject("component", "farcry.plugins.fcblib.packages.custom.lucene") />
	<cfscript>
		oLucene.init();
	</cfscript>
	<cfset stConfig=createobject("component", "farcry.plugins.fcblib.packages.types.fcbLucene").getData(objectid=form.selectedobjectid) />
	<cfset typename = stConfig.collectiontypename>
	<cfset stresult = oLucene.indexCollection(typename,'delete')>
	<cfdump var="#stResult.delete# documents were deleted" />
</ft:processForm>

<ft:processForm action="optimize" >
	<cfset oLucene=createobject("component", "farcry.plugins.fcblib.packages.custom.lucene") />
	<cfscript>
		oLucene.init();
	</cfscript>
	<cfset stConfig=createobject("component", "farcry.plugins.fcblib.packages.types.fcbLucene").getData(objectid=form.selectedobjectid) />
	<cfset typename = stConfig.collectiontypename>
	<cfset stresult = oLucene.indexCollection(typename,'optimize')>
	<cfdump var="#stResult.optimize# documents were optimised" />

</ft:processForm>

<ft:processForm action="update" >
	<cfset oLucene=createobject("component", "farcry.plugins.fcblib.packages.custom.lucene") />
	<cfscript>
		oLucene.init();
	</cfscript>
	<cfset stConfig=createobject("component", "farcry.plugins.fcblib.packages.types.fcbLucene").getData(objectid=form.selectedobjectid) />
	<cfset typename = stConfig.collectiontypename>
	<cfset stresult = oLucene.indexCollection(typename,'update')>
	<cfdump var="#stResult.update# documents were updated" />
</ft:processForm>

<!----------------------------------------
VIEW
----------------------------------------->
<!--- set up page header --->
<admin:header title="Lucene Collections" />

<ft:objectadmin 
	typename="fcbLucene"
	permissionset="news"
	title="Lucene Collections"
	columnList="title,collectiontypename,hostname,lIndexProperties"
	aCustomColumns="#aCustomColumns#"
	sortableColumns="title,collectiontypename"
	lFilterFields="title"
	sqlorderby="datetimelastupdated desc"
	plugin="fcbLib"
	module="customlists/fcbLucene.cfm"
	bFlowCol="false"
	bViewCol="false"
	<!--- lCustomActions="duplicate:Duplicate,remove:Remove Me" ---> />

<!--- setup footer --->
<admin:footer />