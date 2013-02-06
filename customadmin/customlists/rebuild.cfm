<cfsetting requesttimeout="1800">

<cfimport taglib="/farcry/core/tags/admin/" prefix="admin">

<cfset oLucene = createObject("component","farcry.plugins.fcblib.packages.custom.lucene")>
		
<admin:header>
	<cfoutput><h3>Rebuild Collections</h3></cfoutput>

	<!--- first kill everything --->
	<cfset defaultroot = #application.path.project#>
	<cfset indexDirectory = defaultroot & "/" & "collections">
	<!--- create indexdirectory if it doesn't exist --->
	<cfif not directoryExists(indexDirectory)>
		<cfdirectory action="create" directory="#indexDirectory#">
	</cfif>
	<cfset lucenePath = application.path.project & "/data/lucene.jar">
	
	<cfscript>

		if (NOT StructKeyExists(application, 'analyzer')) {
			application.analyzer = createObject("java", "org.apache.lucene.analysis.standard.StandardAnalyzer").init();
		}
		
		if (NOT StructKeyExists(application, 'indexReader')) {
			application.indexReader = createObject("java", "org.apache.lucene.index.IndexReader");
		}
	</cfscript>
	
	<!--- Remove all contents from the index, so that we can entirely rebuild it from scratch --->
	<cfset application.indexWriter = createObject("java","org.apache.lucene.index.IndexWriter").init(JavaCast('string', indexDirectory), application.analyzer, JavaCast('boolean', true)) />
	<!--- always close so we don't create a memory leak! --->
	<cfset application.indexWriter.close() />
	

	<!--- a place to hold the update information --->
	<cfset stRebuildMetadata = StructNew() />

	<cfquery name="qCollectionData" datasource="#application.dsn#">
		SELECT collectiontypename 
		FROM fcbLucene
	</cfquery>

	<!--- make a list of all the types we want to index  --->	 
	<cfset lRebuildTypes = valueList(qCollectionData.collectiontypename)>
		
	<cftry>
		
		<!--- index each typename required to be indexed --->
		<cfloop list="#lRebuildTypes#" index="listType">
			<cfset stRebuildMetadata[listType] = oLucene.indexCollection(typename=listType, action='update') />
		</cfloop>
		
		<cfcatch><cfdump var="#cfcatch#"></cfcatch>
		
	</cftry>
	
	<!--- let's grab another instance so we can optimise it --->
	<cfset application.indexWriter = createObject("java", "org.apache.lucene.index.IndexWriter").init(JavaCast('string', indexDirectory), application.analyzer, JavaCast('boolean', false)) />
	<cfset application.indexWriter.optimize() />
	
	<!--- always close so we don't create a memory leak! --->
	<cfset application.indexWriter.close() />
	
	<cfloop collection="#stRebuildMetadata#" item="i">
		<cfif stRebuildMetadata[i].update gt 0><cfoutput><p><b>#i#</b><br />#stRebuildMetadata[i].update# documents were updated.</p></cfoutput></cfif>
	</cfloop>
	
<admin:footer>
