<!--- @@Copyright: Daemon Pty Limited 2002-2008, http://www.daemon.com.au --->
<!--- @@License:
    This file is part of FarCry CMS Plugin.

    FarCry CMS Plugin is free software: you can redistribute it and/or modify
    it under the terms of the GNU Lesser General Public License as published by
    the Free Software Foundation, either version 3 of the License, or
    (at your option) any later version.

    FarCry CMS Plugin is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
    GNU Lesser General Public License for more details.

    You should have received a copy of the GNU Lesser General Public License
    along with FarCry CMS Plugin.  If not, see <http://www.gnu.org/licenses/>.
--->

<!--- @@displayname: Link Content Type --->
<!--- @@Description: Records links to external web assets. --->
<!--- @@Developer: Geoff Bowers (modius@daemon.com.au) --->
<cfcomponent extends="farcry.plugins.farcrycms.packages.types.dmLink" displayname="Link" bSchedule="true" bUseInTree="true" bFriendly="true" bObjectBroker="true" bPaginatorSearchByCategory="1" bPaginatorAnimateByTypeRule="1">

	<cfproperty ftseq="1" ftFieldset="Link Information" bCleanHTML="1" name="title" type="string" hint="Meaningful reference title for link" required="no" default="" ftlabel="Title" blabel="true" ftvalidation="required" />
	<cfproperty ftseq="2" ftfieldset="Link Information" bCleanHTML="1" name="teaser" type="longchar" hint="A brief description of the link" required="no" default="" ftlabel="Teaser" />
	<cfproperty ftSeq="7" ftfieldset="Sensitive Data?" ftLabel="Sensitive" name="bSensitive" type="boolean" hint="" required="no" default="0" ftRenderType="checkbox" />
	
	<!--- 	Fix the checkPermission error. This occurs because bUseInTree is set to true for this type
			as it needs to display in the site tree --->
	<cftry>
		<cfset application.navid.dmLink = application.fc.utils.createJavaUUID() />
		
		<cfcatch>
			<!--- this is to stop errors on install --->
		</cfcatch>
	</cftry>

	<cfimport taglib="/farcry/core/tags/formtools/" prefix="ft" />
	<cfimport taglib="/farcry/core/tags/wizard/" prefix="wiz" />
	<cfimport taglib="/farcry/core/tags/navajo/" prefix="nj" />
	<cfimport taglib="/farcry/core/tags/admin/" prefix="admin" />
	<cfimport taglib="/farcry/core/tags/webskin/" prefix="skin" />

	<cffunction name="setData" access="public" output="true" hint="Update the record for an objectID including array properties.  Pass in a structure of property values; arrays should be passed as an array.">
		<cfargument name="stProperties" required="true">
		<cfargument name="user" type="string" required="true" hint="Username for object creator" default="">
		<cfargument name="auditNote" type="string" required="true" hint="Note for audit trail" default="Updated">
		<cfargument name="bAudit" type="boolean" required="No" default="1" hint="Pass in 0 if you wish no audit to take place">
		<cfargument name="dsn" required="No" default="#application.dsn#">
		<cfargument name="bSessionOnly" type="boolean" required="false" default="false"><!--- This property allows you to save the changes to the Temporary Object Store for the life of the current session. ---> 
		<cfargument name="bAfterSave" type="boolean" required="false" default="true" hint="This allows the developer to skip running the types afterSave function.">	
		<cfargument name="bSetDefaultCoreProperties" type="boolean" required="false" default="true" hint="This allows the developer to skip defaulting the core properties if they dont exist.">	
						
		<cfset stresult = super.setData(argumentCollection="#arguments#") />
		
		<!--- Do Lucene Code - Call Lucene Object and method before we return the Super argument --->
		<cfset oLucene = request.fcbObjectBucket.create(fullPath="farcry.plugins.fcblib.packages.custom.lucene") />
		<cfif oLucene.checkForTypeInCollection(arguments.stProperties.typename)>
			<cfset indexCollection = oLucene.indexItem(arguments.stProperties.objectid,arguments.stProperties.typename, "update") />
		</cfif>							
		<cfreturn stresult>
	</cffunction>

	<cffunction name="delete" access="public" hint="Basic delete method for all objects. Deletes content item and removes Verity entries." returntype="struct" output="false">
		<cfargument name="objectid" required="yes" type="UUID" hint="Object ID of the object being deleted">
		<cfargument name="user" type="string" required="true" hint="Username for object creator" default="#session.dmSec.authentication.userlogin#">
		<cfargument name="auditNote" type="string" required="true" hint="Note for audit trail" default="">

		<cfset stResult = super.delete(argumentCollection="#arguments#") />
		
		<!---Do lucene call: remove corresponding item from collection based on object id  --->
		<cfset oLucene = request.fcbObjectBucket.create(fullPath="farcry.plugins.fcblib.packages.custom.lucene") />
		<cfif oLucene.checkForTypeInCollection(this.getTypeName())>
			<cfset deleteCollectionItem = oLucene.deleteItem(arguments.objectid) />
		</cfif>
		
		<cfreturn stResult>
	</cffunction>	

	<cffunction name="BeforeSave" access="public" output="false" returntype="struct">
		<cfargument name="stProperties" required="true" type="struct">
		<cfargument name="stFields" required="true" type="struct">
		<cfargument name="stFormPost" required="false" type="struct">		
	
		<cfset var oUtility = request.fcbObjectBucket.create(fullPath='farcry.plugins.fcblib.packages.custom.utility') />	
		<cfset arguments.stProperties = oUtility.encodeHTMLEntity(arguments.stProperties, this.getTypeName()) />
		
		<cfreturn super.BeforeSave(argumentCollection="#arguments#") />
	</cffunction>

	<cffunction name="Edit" access="public" output="true" returntype="void" hint="Default edit handler.">
		<cfargument name="ObjectID" required="yes" type="string" default="" />
		<cfargument name="onExitProcess" required="no" type="any" default="Refresh" />
		
		<cfset var stObj = getData(objectid=arguments.objectid) />
		<cfset var qMetadata = application.types[stobj.typename].qMetadata />
		<cfset var lWizardSteps = "" />
		<cfset var iWizardStep = "" />
		<cfset var lFieldSets = "" />
		<cfset var iFieldSet = "" />

		<cfset var oUtility = request.fcbObjectBucket.create(fullPath='farcry.plugins.fcblib.packages.custom.utility') />	
		<!--- Decode HTML entity upon edit --->
		<cfset stObj = oUtility.decodeHTMLEntity(stObj, this.getTypeName()) />
				
		<!--- 
			Always locking at the beginning of an edit 
			Forms need to be manually unlocked. Wizards will unlock automatically.
		--->
		<cfset setLock(stObj=stObj,locked=true) />
			
		<cfif structkeyexists(url,"iframe")>
			<cfset onExitProcess = structNew() />
			<cfset onExitProcess.Type = "HTML" />
			<cfsavecontent variable="onExitProcess.content">
				<cfoutput>
					<script type="text/javascript">
						<!--- parent.location.reload(); --->
						parent.location = parent.location;
						parent.closeDialog();		
					</script>
				</cfoutput>
			</cfsavecontent>
		</cfif>
		
		<!-------------------------------------------------- 
		WIZARD:
		- build default formtool wizard
		--------------------------------------------------->		
		<cfquery dbtype="query" name="qwizardSteps">
		SELECT ftwizardStep
		FROM qMetadata
		WHERE lower(ftwizardStep) <> '#lcase(stobj.typename)#'
		ORDER BY ftSeq
		</cfquery>
		
		<cfset lWizardSteps = "" />
		<cfoutput query="qWizardSteps" group="ftWizardStep" groupcasesensitive="false">
			<cfif NOT listFindNoCase(lWizardSteps,qWizardSteps.ftWizardStep)>
				<cfset lWizardSteps = listAppend(lWizardSteps,qWizardSteps.ftWizardStep) />
			</cfif>
		</cfoutput>
		
		<!------------------------ 
		Work out if we are creating a wizard or just a simple form.
		If there are multiple wizard steps then we will be creating a wizard
		 ------------------------>
		<cfif listLen(lWizardSteps) GT 1>
			
			<!--- Always save wizard WDDX data --->
			<wiz:processwizard excludeAction="Cancel">
			
				<!--- Save the Primary wizard Object --->
				<wiz:processwizardObjects typename="#stobj.typename#" />	
					
			</wiz:processwizard>
			
			<wiz:processwizard action="Save" Savewizard="true" Exit="true" /><!--- Save wizard Data to Database and remove wizard --->
			<wiz:processwizard action="Cancel" Removewizard="true" Exit="true" /><!--- remove wizard --->
			
			
			<wiz:wizard ReferenceID="#stobj.objectid#">
			
				<cfloop list="#lWizardSteps#" index="iWizardStep">
						
					<cfquery dbtype="query" name="qwizardStep">
					SELECT *
					FROM qMetadata
					WHERE lower(ftwizardStep) = '#lcase(iWizardStep)#'
					ORDER BY ftSeq
					</cfquery>
				
					<wiz:step name="#iWizardStep#">
						

						<cfquery dbtype="query" name="qFieldSets">
						SELECT ftFieldset
						FROM qMetadata
						WHERE lower(ftwizardStep) = '#lcase(iWizardStep)#'
						AND lower(ftFieldset) <> '#lcase(stobj.typename)#'				
						ORDER BY ftSeq
						</cfquery>
						<cfset lFieldSets = "" />
						<cfoutput query="qFieldSets" group="ftFieldset" groupcasesensitive="false">
							<cfif NOT listFindNoCase(lFieldSets,qFieldSets.ftFieldset)>
								<cfset lFieldSets = listAppend(lFieldSets,qFieldSets.ftFieldset) />
							</cfif>
						</cfoutput>
						
						
						<cfif listlen(lFieldSets)>
											
							<cfloop list="#lFieldSets#" index="iFieldSet">
							
								<cfquery dbtype="query" name="qFieldset">
								SELECT *
								FROM qMetadata
								WHERE lower(ftwizardStep) = '#lcase(iWizardStep)#' 
								and lower(ftFieldset) = '#lcase(iFieldSet)#'
								ORDER BY ftSeq
								</cfquery>
								
								<wiz:object typename="#stobj.typename#" ObjectID="#stobj.objectID#" lfields="#valuelist(qFieldset.propertyname)#" format="edit" intable="false" legend="#iFieldSet#" helptitle="#qFieldset.fthelptitle#" helpsection="#qFieldset.fthelpsection#" />
							</cfloop>
							
						<cfelse>
							
							<wiz:object typename="#stobj.typename#" ObjectID="#stobj.objectID#" lfields="#valuelist(qwizardStep.propertyname)#" format="edit" intable="false" />
						
						</cfif>
						
						
					</wiz:step>
				
				</cfloop>
				
			</wiz:wizard>	
				
				
				
				
		<!------------------------ 
		If there is only 1 wizard step (typename by default) then we will be creating a simple form
		 ------------------------>		 
		<cfelse>
		
			<cfquery dbtype="query" name="qFieldSets">
			SELECT ftFieldset
			FROM qMetadata
			WHERE lower(ftFieldset) <> '#lcase(stobj.typename)#'
			ORDER BY ftseq
			</cfquery>
			
			<cfset lFieldSets = "" />
			<cfoutput query="qFieldSets" group="ftFieldset" groupcasesensitive="false">
				<cfif NOT listFindNoCase(lFieldSets,qFieldSets.ftFieldset)>
					<cfset lFieldSets = listAppend(lFieldSets,qFieldSets.ftFieldset) />
				</cfif>
			</cfoutput>
		
			<!--- PERFORM SERVER SIDE VALIDATION --->
			<!--- <ft:serverSideValidation /> --->
		
			<!---------------------------------------
			ACTION:
			 - default form processing
			---------------------------------------->
			<ft:processForm action="Save" Exit="true">
				<ft:processFormObjects typename="#stobj.typename#" />
				<cfset setLock(objectid=stObj.objectid,locked=false) />
			</ft:processForm>

			<ft:processForm action="Cancel" Exit="true" >
				<cfset setLock(objectid=stObj.objectid,locked=false) />
			</ft:processForm>
			
			
			
			<ft:form bFocusFirstField="true">
				
					
				<cfoutput><h1><skin:icon icon="#application.stCOAPI[stobj.typename].icon#" default="farcrycore" size="32" />#stobj.label#</h1></cfoutput>
				
				<cfif listLen(lFieldSets)>
					
					<cfloop list="#lFieldSets#" index="iFieldset">
						
						<cfquery dbtype="query" name="qFieldset">
						SELECT *
						FROM qMetadata
						WHERE lower(ftFieldset) = '#lcase(iFieldset)#'
						ORDER BY ftSeq
						</cfquery>
						
						<ft:object typename="#stobj.typename#" ObjectID="#stobj.objectID#" format="edit" lExcludeFields="label" lFields="#valuelist(qFieldset.propertyname)#" inTable="false" IncludeFieldSet="true" Legend="#iFieldset#" helptitle="#qFieldset.fthelptitle#" helpsection="#qFieldset.fthelpsection#" />
					</cfloop>
					
					
				<cfelse>
				
					<!--- All Fields: default edit handler --->
					<ft:object typename="#stobj.typename#" ObjectID="#stobj.objectID#" format="edit" lExcludeFields="label" lFields="" IncludeFieldSet="false" />
					
				</cfif>
				
				<ft:buttonPanel>
					<ft:button value="Save" color="orange" /> 
					<ft:button value="Cancel" validate="false" />
				</ft:buttonPanel>
				
			</ft:form>
		</cfif>
	</cffunction>

</cfcomponent>