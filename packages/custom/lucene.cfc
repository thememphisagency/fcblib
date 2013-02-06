<cfcomponent displayname="lucene" output="false">
	
	<cffunction name="init" returntype="void" hint="Get Lucene ready to use">
		
		<cfset var collectionName = application.path.project & "/collections">
		
		<cfif NOT StructKeyExists(application, 'analyzer')>
			<cfset application.analyzer = createObject("java", "org.apache.lucene.analysis.standard.StandardAnalyzer").init()>
		</cfif>
			
	</cffunction>
	
	<cffunction name="checkForTypeInCollection" returntype="boolean">
		<cfargument name="typename" hint="The FarCry typename to index" />	
		<cfquery name="qCollectionData" datasource="#application.dsn#">
			SELECT objectId 
			FROM fcbLucene
			WHERE collectiontypename = '#arguments.typename#'
		</cfquery>
		<cfif qCollectionData.recordCount GT 0>
			<cfreturn true />
		<cfelse>
			<cfreturn false />		
		</cfif>	
	</cffunction>
	
	<cffunction name="getIndexDirectory" returntype="string">
		
		<cfset var sReturn = application.path.project & "/collections" />
		
		<!--- create indexdirectory if it doesn't exist --->
		<cfif not directoryExists(sReturn)>
			<cfdirectory action="create" directory="#sReturn#">
		</cfif>
		
		<cfreturn sReturn />
	
	</cffunction>
	
	<cffunction name="indexCollection" returntype="struct">
		<cfargument name="typename" hint="The FarCry typename to index" />
		<cfargument name="action" hint="The action we should perform on the type, (update|delete|optimize)">
	
		<cfset var qGetRefObjects = QueryNew('objectid') />
		<cfset var nCount = 0 />
		<cfset var stReturn = StructNew() />
		
		<cfquery name="qGetRefObjects" datasource="#application.dsn#">
			SELECT DISTINCT objectid
			FROM refObjects
			WHERE typeName = '#arguments.typename#'
		</cfquery>
		
		<!--- Delete any items in trash  --->
		<cfset qList = application.factory.oTree.getDescendants(objectid=application.navid.rubbish,bIncludeSelf=true)>
		<cfset lNodeIDS = valueList(qList.objectid)>
		<cfset aExcludeObjectID = application.factory.oTree.getLeaves(lNodeIDS)>
		<cfset lExcludeObjectID = "">
		
		<cfloop index="i" from="1" to="#ArrayLen(aExcludeObjectID)#">
			<cfset lExcludeObjectID = ListAppend(lExcludeObjectID, aExcludeObjectID[i].objectid)>
		</cfloop>

		<cfloop query="qGetRefObjects">
			
			<cfset bTrash = ListFind(lExcludeObjectID, qGetRefObjects.objectid) />
			<cfif bTrash>
				<cfset bIndexed = indexItem(qGetRefObjects.objectid, arguments.typename, "delete") />
			<cfelse>
				<cfset bIndexed = indexItem(qGetRefObjects.objectid, arguments.typename, arguments.action) />
			</cfif>
		
			<cfif bIndexed eq true><cfset nCount = nCount + 1 /></cfif>
		</cfloop>
		
		<cfset stReturn[arguments.action] = nCount />
		
		<cfreturn stReturn />
		
	</cffunction>
	
	<cffunction name="indexItem" returntype="Boolean">
		<cfargument name="objectid" hint ="The struct containing all the page information we obtain when editing a page">
		<cfargument name="typename" hint = "The struct containing all the page information we obtain when editing a page">
		<cfargument name="action" hint = "Tells us whever we call update/delete/optimize at the end of the function">
		
		<cfset var bReturn = false />								<!--- Return a struct containing how many items were created, deleted --->
		<cfset var indexDirectory = getIndexDirectory() />					<!--- The name of the folder created to store collections --->
		<cfset var lStoreAndIndex = getIndexColumns(arguments.typename)><!--- create list to store columns that we will store and index  --->
		<cfset var lTypeColumns = '' />
		<cfset var oField = createObject("java","org.apache.lucene.document.Field")>
		<cfset var lStoreOnly = 'objectid,typename' />
		<cfset var bSuccess = false>
		<cfset var lExpiringTypes = 'dmEvent, dmNews'>
		
		<cfif NOT len(lStoreAndIndex)><cfreturn bReturn /></cfif>
	
		<!--- Manually Add the 'typeName' and  'objectid' column for indexing --->
		<cfset lStoreAndIndex = ListAppend(lStoreAndIndex, "typename")>
		<cfset lStoreAndIndex = ListAppend(lStoreAndIndex, "objectid")>
		
		<cfquery name="qStatusCheck" datasource="#application.dsn#">
			SELECT *
			FROM #arguments.typename#
			WHERE objectid = '#arguments.objectid#'
		</cfquery>

		<!--- List to check if 'status' is in the database for this object--->
		<cfset lTypeColumns = qStatusCheck.ColumnList>
		
		<!--- we don't want anything that is in draft, or expired! --->
		<cfif qStatusCheck.recordCount eq 0 OR listFindNoCase(lTypeColumns, "status") AND qStatusCheck.status is "draft" OR (listFindNoCase(lExpiringTypes, arguments.typename) AND isValid('date', qStatusCheck.expiryDate) AND qStatusCheck.expiryDate LT now())>
			<cfreturn bReturn />
		</cfif>
		
		<!--- get lucene ready to use! --->
		<cfset init() />

		<!--- get an instance of index writer so that we can index some content! --->
				
		<cfset application.indexWriter = createObject("java", "org.apache.lucene.index.IndexWriter").init(indexDirectory, application.analyzer, JavaCast('boolean', false)) />
				
		<cfset fs = createObject("java", "org.apache.lucene.document.Field$Store")>
		<cfset fi = createObject("java", "org.apache.lucene.document.Field$Index")>
		
		<!--- get a document instance --->
	    <cfset doc = createObject("java", "org.apache.lucene.document.Document").init()>
	
		<cfloop index="col" list="#lTypeColumns#">
			
			<cfset stored = fs.NO />
			
			<!--- are we indexing? --->
			<cfif listFindNoCase(lStoreAndIndex, col) AND NOT listContains(lStoreOnly, col)>
				<cfset indexed = fi.TOKENIZED>	<!--- Tokenized: index the field so it can be searched --->
				<cfset stored = fs.YES>
			<cfelse>
				<!--- Do not index the field so it cannot be search but value can be access provided it is stored. --->				
				<cfset indexed = fi.NO>
				<cfset stored = fs.NO>
			</cfif>
	
			<!--- are we storing? --->
			<cfif stored eq fs.YES>
				
				<!--- get the value --->
				<cfset value = qStatusCheck[col]>
				
				<!--- put all objectids to lowercase - we found we had to do this for it to work properly, Lucene must have a bug! --->
				<cfif lcase(col) IS 'objectid'><cfset value = lcase(value) /></cfif>
							
				<!--- create the field and index it! --->				
			    <cfset field = oField.init(javaCast("string", lcase(col)), javaCast("string",value), stored, indexed)>			    
			    <!--- add to document --->
			    <cfset doc.add(field)>
			    	    		   			
			</cfif>
			
		</cfloop>		
	
 		<cfif arguments.typename EQ 'dmFile' AND structKeyExists(application.stcoapi['dmFile'].stProps, 'bIndex') AND qStatusCheck.bIndex EQ 1 AND len(qStatusCheck.filename) GT 0>
			<cfset oReader = request.fcbObjectBucket.create(fullPath='farcry.plugins.fcbresourcemanager.packages.custom.filereader').init() />
			<cfset sFileContent = oReader.read('#application.path.defaultFilePath#' & qStatusCheck.filename) />
			<cfif len(sFileContent) GT 0>
				<!--- manually add an indexing for document content, this currently works with just PDF document --->
				<cfset field = oField.init(javaCast("string", "filename"), javaCast("string", sFileContent), fs.YES, fi.TOKENIZED)>
				<cfset doc.add(field)>
			</cfif>	
		</cfif>
	
		<!--- manually add an indexing on 'typename'--->
		<cfset field = oField.init(javaCast("string", "typename"), javaCast("string", arguments.typename), fs.YES, fi.TOKENIZED)>
		<cfset doc.add(field)>
		
		<!--- Set bSensitive to 0, if it hasn't already been added above i.e. if it doesn't exists for this type --->
		<cfif listFindNoCase(lStoreAndIndex, "bsensitive") is 0>
			<cfset field = oField.init(javaCast("string", "bsensitive"), javaCast("string","0"), fs.YES, fi.TOKENIZED)>
			<cfset doc.add(field)>		
		</cfif>

<!---  		 <cfdump var="#doc.getFields()#"><cfoutput><br /><br /></cfoutput> 
		
		<cfset aFields = doc.getFields()>
		
		<cfloop from="1" to="#arrayLen(aFields)#" index="i">
			
			<cfoutput><p>#aFields[i].name()# #i#</p></cfoutput>
		</cfloop>   --->
					
		<cfset oTerm = createObject("java", "org.apache.lucene.index.Term")>
		<cfset termUpdate = oTerm.init(javaCast("string", "objectid"), javaCast("string", lcase(qStatusCheck.objectid)))>
		
		<cfswitch expression="#action#">
			<cfcase value="update">
				<cfset application.indexWriter.updateDocument(termUpdate, doc, application.analyzer)>
			</cfcase>
			<cfcase value="delete">
				<cftry>
					<cfset application.indexWriter.deleteDocuments(termUpdate)>
					<cfcatch type="any">
						<cfdump var="#cfcatch#">
					</cfcatch>
				</cftry>
			</cfcase>
		</cfswitch>
		
		<cfset application.indexWriter.flush() />
		<cfset application.indexWriter.close() />
		
		<cfif arrayLen(doc.getFields()) GT 0>	
			<cfset bSuccess = true>
		</cfif>
		
		<cfreturn bSuccess>
	
	</cffunction>

	<cffunction name="deleteItem" hints="Delete an index item from collection based on object id" returntype="void">
		<cfargument name="objID" type="string" required="yes">
		
		<cfset var indexDirectory = getIndexDirectory() />					<!--- The name of the folder created to store collections --->	
		
		<cfset init() />		

		<cfset application.indexWriter = createObject("java", "org.apache.lucene.index.IndexWriter").init(indexDirectory, application.analyzer, JavaCast('boolean', false)) />		

		<cfset oTerm = createObject("java", "org.apache.lucene.index.Term")>
		<cfset termUpdate = oTerm.init(javaCast("string", "objectid"), javaCast("string", lcase(arguments.objID)))>
		
		<cftry>
			<cfset application.indexWriter.deleteDocuments(termUpdate)>
			<cfcatch type="any">
				<cfdump var="#cfcatch#">
			</cfcatch>
		</cftry>
		
			<cfset application.indexWriter.flush() />
			<cfset application.indexWriter.close() />	
	</cffunction>	
	
	<cffunction name="deleteTrashItem" hints="Deletes ann index item when it has been moved to the trash navigation node" returntype="void">
		<cfargument name="objectid" required="yes" type="String" hint="Object ID of the object being deleted">
		
		<cfquery name="qTypename" datasource="#application.dsn#">
			SELECT typename
			FROM refObjects
			WHERE objectid = '#arguments.objectid#'
		</cfquery>

		<cfif qTypename.typename EQ 'dmNavigation'>
			<cfset qList = application.factory.oTree.getDescendants(objectid=arguments.objectid,bIncludeSelf=true)>
			<cfset lNodeIDS = valueList(qList.objectid)>
			<cfset aExcludeObjectID = application.factory.oTree.getLeaves(lNodeIDS)>
	
			<cfloop index="i" from="1" to="#ArrayLen(aExcludeObjectID)#">
				<cfquery name="qResult" datasource="#application.dsn#">
					SELECT typename
					FROM refObjects
					WHERE objectid = '#aExcludeObjectID[i].objectid#'
				</cfquery>
				<cfif qResult.recordcount GT 0>
					<cfif checkForTypeInCollection(qResult.typename)>
						<cfset deleteCollectionItem = deleteItem(aExcludeObjectID[i].objectid)>
					</cfif>
				</cfif>
			</cfloop>
		<cfelse>
			<cfif checkForTypeInCollection(qTypename.typename)>
				<cfset deleteCollectionItem = deleteItem(arguments.objectid)>
			</cfif>
		</cfif>

	</cffunction>
	
	<cffunction name="getIndexColumns" hint="Return a list of columns we are indexing, based on the Lucene Config">
		
		<cfargument name="documentType" type="string" required="false" default="" hint="The name of the document type (e.g dmHTML) that we are searching for columns to index. If you don't pass this in, it will return columns for all types.">
		<cfargument name="returnType" type="string" required="false" default="list" />
		
		<cfset var lReturn = "" />
		<cfif len(arguments.documentType) gt 0>
			<cfquery name="qCollectionData" datasource="#application.dsn#">
				SELECT objectId 
				FROM fcbLucene
				WHERE collectiontypename = '#documentType#'
			</cfquery>
			

			
			<cfset stConfig=createobject("component", "farcry.plugins.fcblib.packages.types.fcbLucene").getData(objectid=qCollectionData.objectid)>
			<cfset lIndexProperties = stConfig.lIndexProperties>
	
			<cfloop collection="#application.types[documentType].stProps#" item="Field">
	
				<!--- check fields aren't of type array or uuid and aren't derived from types.types --->
				<cfif application.types[documentType].stProps[field].metaData.type neq "array"
					AND application.types[documentType].stProps[field].metaData.type neq "UUID"
					AND findnocase("types.types",application.types[documentType].stProps[field].origin) eq 0>
			
					<!--- check against config setup --->
					<cfset checked = false>
					<cfif listcontainsnocase(lIndexProperties,#field#) gt 0>
						<cfset lReturn = ListAppend(lReturn, #lcase(field)#) />
					</cfif>
					
				</cfif>
			</cfloop>
		<cfelse>
			<cfquery name="qCollectionData" datasource="#application.dsn#">
				SELECT lIndexProperties 
				FROM fcbLucene
			</cfquery>
			<cfloop query="qCollectionData">
				<cfloop list="#qCollectionData.lIndexProperties#" index="i">
					<cfif listFindNoCase(lReturn,i) IS 0>
						<cfset lReturn = listAppend(lReturn,i)>								
					</cfif>
				</cfloop>
			</cfloop>
		</cfif>
		<cfif lcase(arguments.returnType) eq 'list'>
			<cfreturn lReturn />
		<cfelse>
			<cfreturn listToArray(lReturn) />
		</cfif>
			
	</cffunction>
	
	<cffunction name="searchCollection">
		<cfargument name="searchCriteria" type="string" hint="use object id as unique search criteria">
		
		<cfset var collectionName = application.path.project & "/collections"> 
		<cfset var results = queryNew("title,objectid,typename,score,bSensitive")>
		<cfset var aColumnsToSearch = ArrayNew(1) />

		<!--- Grab a list of all available typename--->
		<cfquery name="qIndexedTypes" datasource="#application.dsn#">
			SELECT collectiontypename
			FROM fcbLucene
		</cfquery>

		<cfif qIndexedTypes.recordCount IS 0>
			<!--- If no collection type has been added, let's stop the search--->
			<cfreturn results />
		</cfif>
		
		<cfset aColumnsToSearch = listToArray(lcase(getIndexColumns())) />		

		<!--- Make sure search column contains 'typename' in order to the search to work! --->
		<cfset temp = ArrayAppend(aColumnsToSearch,"typename")>

		<cfscript>

			// let's load the java class, using java loader, but we need to create it in server scope, so that it never times out

			if (NOT StructKeyExists(application, 'analyzer')) {
				application.analyzer = createObject("java", "org.apache.lucene.analysis.standard.StandardAnalyzer").init();
			}
			
			if (NOT StructKeyExists(application, 'indexReader')) {
				application.indexReader = createObject("java", "org.apache.lucene.index.IndexReader");
			}
			
			if (NOT StructKeyExists(application, 'searcher')) {
				application.searcher = createObject("java", "org.apache.lucene.search.IndexSearcher");
			}
			
			if (NOT StructKeyExists(application, 'parser')) {
				application.parser = createObject("java", "org.apache.lucene.queryParser.MultiFieldQueryParser");
			}
		</cfscript>

		<cfset application.searcher.init(collectionName)>
		
		<cfset application.parser.init(aColumnsToSearch, application.analyzer)>
		
		<cfset lSpecial = "+,&&,||,\,(,),{,},[,],^,~,*,?,:,!">
		
		<!--- filter out special characters --->
		<cfloop list="#lSpecial#" index="key">
			<cfset replaceKey = "\" & key>
			<cfset arguments.searchCriteria = ReplaceNoCase(arguments.searchCriteria,key,replaceKey, "all")>
		</cfloop>

		<cfset newCriteria = arguments.searchCriteria>
				
		<cfif application.config.lucene.bMultiCharWildCard>
			<cfset Regex = "([A-Za-z0-9-]+)(.*)" />
			
			<cfset result = ReReplace(newCriteria,Regex,"\2") />
			
			<cfif NOT len(result)>
				<cfset newCriteria = arguments.searchCriteria & '*'>
			</cfif>
		</cfif>
				
		<cfset query = application.parser.parse(newCriteria)>
		
		<cfset hits = application.searcher.search(query)>
							
		<cfif hits.length() gte 0>
			<cfloop index="x" from="1" to="#hits.length()#">
				<cfset hit = hits.doc(javacast('int',x-1))>
				<cfset fields = hit.getFields()>
				<cfset queryAddRow(results)>
		
				<cfloop index="y" from="1" to="#arrayLen(fields)#">
					<cfset field = fields[y]>
					<!--- build the query up manually --->
					<cfif listFindNoCase(results.columnlist, javacast('string',field.name())) GT 0>
						<cfset querySetCell(results, field.name(), javacast('string',hit.get(field.name()))) />
					</cfif>						
				</cfloop>			
				<cfset querySetCell(results, "score", hits.score(javacast('int',x-1)))>			
			</cfloop>
		</cfif>

		<cfif NOT structKeyExists(session,"dmSec") AND results.recordCount GT 0>
			<!--- If viewer is not logged in, remove sensitive data --->
			<cfquery name="q" dbtype="query">
				SELECT *
				FROM results
				WHERE bSensitive = 0
			</cfquery>
			
			<cfset results = q />
		</cfif>

		<cfset sListOfAllType = valueList(qIndexedTypes.collectiontypename) />
		<cfset sListCheckStatus = ''>		
		<!--- Check on each typename in the list to find if the typename table contains a colum name  'status'--->
		<cfloop list="#sListOfAllType#" index="i" delimiters=",">
			<cfset sListOfColumnName = structKeyList(evaluate("application.types.#i#.stProps"))>		
			<cfif listFindNoCase(sListOfColumnName,"status") GT 0>			
				<cfset sListCheckStatus = listAppend(sListCheckStatus, '#i#', ',')>
			</cfif>	
		</cfloop>
		
		<cfif listLen(sListCheckStatus) GT 0>
			<cfset lTemp = ''>
			<cfloop list="#sListCheckStatus#" index="sTypename">
				<cfquery name="qCheckStatus" datasource="#application.dsn#">
					SELECT objectId
					FROM #sTypename#
					WHERE objectid IN (<cfqueryparam cfsqltype="cf_sql_longvarchar" list="true" value="#valueList(results.objectid)#" />)
					AND status = 'draft'
					<cfif sTypename EQ 'dmNews' OR sTypename EQ 'dmEvent'>
						OR expirydate <= #now()# OR publishdate >= #now()#
					</cfif>					
				</cfquery>
				<cfif qCheckStatus.recordCount GT 0>
					<!--- let's build a list of objectids for all the 'draft' and expired objects --->
					<cfset lTemp = listAppend(lTemp,valuelist(qCheckStatus.objectid))>					
				</cfif>
			</cfloop>

			<cfif listLen(lTemp) GT 0>
				<cfquery name="qTemp" dbtype="query">
					SELECT *
					FROM results
					WHERE UPPER(objectid) NOT IN (<cfqueryparam cfsqltype="cf_sql_longvarchar" list="true" value="#uCase(lTemp)#" />)
				</cfquery>
				<cfset results = qTemp>
			</cfif>					
		</cfif>

		<cfreturn results>			
	</cffunction>

	<cffunction name="cleanSearchResults" hint="Clean up the hardcoded styling inserted in the results by the default Farcry Verity search" returntype="string" output="false">
		<cfargument name="inStr" type="string" />
		<cfargument name="searchCriteria" type="string" />
	
		<cfset var replaceStr = "" />
		<cfset var outStr = "" />
	
		<cfset arguments.searchCriteria = replaceNoCase(arguments.searchCriteria, '"', '', 'all') />
		<cfset arguments.searchCriteria = replaceNoCase(arguments.searchCriteria, "'", '', 'all') />	
		<cfset replaceStr = "<span>" & searchCriteria & "</span>" />
		<cfset outStr = replaceNoCase(arguments.inStr, arguments.searchCriteria,replaceStr,"all") />
		
		<cfreturn outStr />
	</cffunction>	
			
</cfcomponent>