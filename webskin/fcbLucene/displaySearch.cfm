<cfsetting enablecfoutputonly="yes">
<!--- 
		Enpresiv Group Pty Limited 2006, http://www.enpresiv.com
--->

<!--- @@displayname: Standard - Search Teaser Display] --->
<!--- @@author: Enpresiv (support@enpresiv.com) --->

<cfimport taglib="/farcry/core/tags/webskin" prefix="skin">

<cfparam name="resultTitle" type="string" default="" />

	<cfset sListOfColumnName = qResults.columnList>	
	<cfif listFindNoCase(sListOfColumnName,"title") GT 0 AND len(qResults.title)>		
		<cfset resultTitle = "#qResults.title#" />
	<cfelseif listFindNoCase(sListOfColumnName,"label")>
		<cfset resultTitle = "#qResults.label#">
	</cfif>
		<cfif qResults.typename is 'resourceManager'>
			<cfoutput>
			<li>
				<h3><span class="score">#round(qResults.score * 100)#%</span> #resultTitle#</h3>
			</cfoutput>	
			
			<cfif listFindNoCase(sListOfColumnName,"teaser") GT 0 AND len(trim(qResults.teaser)) GT 0>
				<cfoutput><p class="summary">#cleanSearchResults(qResults.teaser, form.criteria)#</p></cfoutput>
			</cfif>
			<cfset stResourceObj=createObject("component",application.types['resourceManager'].typePath).getData(qResults.objectid) />

				<cfoutput>
					<ul class="files">
					</cfoutput>
					
					<cfif structKeyExists(stResourceObj, 'aObjectIds')>
						<cfif arrayLen(stResourceObj.aObjectIds) GT 0>
							<cfset oNav = createObject("component",application.types['dmNavigation'].typePath) >
							<cfloop from="1" to="#arrayLen(stResourceObj.aObjectIds)#" index="i">
								<cfset sType = oNav.findType(stResourceObj.aObjectIds[i])>
								<cfif len(sType) GT 0>
									<cfset oType = createObject("component",application.types[sType].typePath)>
									<cfset stData = oType.getData(objectid=stResourceObj.aObjectIds[i])>
									<cfif NOT structIsEmpty(stData)>
										<cfdirectory action="list" directory="#application.path.defaultFilePath#/dmfile/" filter="#listLast(stData.filename,'/')#" name="qFileInfo">
										
										<cfif len(qFileInfo.size) LTE 0>
											<cfset fileSize = 0>
										<cfelse>		
											<cfset fileSize = int(qFileInfo.size)>
										</cfif>	
										
										<cfset fileExt = listLast(stData.filename,".")>
										<cfoutput><li class="#lCase(fileExt)#"></cfoutput><skin:buildLink objectid="#stData.objectID#">
										<cfoutput>#uCase(fileExt)# Format</cfoutput>
										</skin:buildLink><cfoutput> <span>(#int(fileSize / 1024)#kb)</span></li></cfoutput>		
									</cfif>	
								</cfif>							
							</cfloop>
						</cfif>	

					</cfif>
	
				<cfoutput>
	
				</ul>
			</li>

			</cfoutput>
		<cfelse>
			<cfoutput>
				<li>
					<h3><span class="score">#round(qResults.score * 100)#%</span> </cfoutput><skin:buildLink objectId=#qResults.objectid#><cfoutput>#resultTitle#</cfoutput></skin:buildLink><cfoutput></h3>
				<cfif listFindNoCase(sListOfColumnName,"teaser") GT 0 AND len(trim(qResults.teaser)) GT 0>
					<p class="summary">#cleanSearchResults(qResults.teaser, form.criteria)#</p>
				</cfif>
				</li>		
			</cfoutput>
		</cfif>
		



<cfsetting enablecfoutputonly="no">