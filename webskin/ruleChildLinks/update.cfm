<cfsetting enablecfoutputonly="yes" />
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

<cfimport taglib="/farcry/core/tags/wizard" prefix="wiz" />
<cfimport taglib="/farcry/core/tags/formtools" prefix="ft" />

<cfparam name="refobjectid" default="#url.refobjectid#">

<!--- PROCESS WIZARD SUBMISSION --->
<!--- Always save wizard WDDX data --->


<wiz:processwizard excludeAction="Cancel">

	<!--- Save any Types submitted (including any new ones) --->
	<wiz:processWizardObjects typename="ruleChildLinks" />
	
</wiz:processwizard>


<!--- Save Wizard Data manually to avoid overriding the extended array table data --->
<wiz:processWizard action="Save" RemoveWizard="true" Exit="true">
	<cfset stProperties = stWizard.data[stobj.objectid] />
	<cfset structDelete(stProperties, "aObjects") />
	<cfset stProperties.refobjectid = form.parentID />
	
	<cfset stResult = setData(stProperties=stProperties) />
</wiz:processWizard>

<wiz:processwizard action="Cancel" Removewizard="true" Exit="true" /><!--- remove wizard --->


<!--- RENDER THE WIZARD --->
<wiz:wizard ReferenceID="#stobj.objectid#" r_stWizard="stWizard">

	<wiz:step name="Options">
		<wiz:object stobject="#stobj#" wizardID="#stWizard.ObjectID#" lfields="title,intro,displayMethod" format="edit" legend="Rule Options" />
		
		<cfset oTree = createObject("component","#application.packagepath#.farcry.tree") />
		<cfset qSiteMap = oTree.getDescendants(objectid='#application.navid.home#',bIncludeSelf=1) />

		<cfoutput>	
		<div class="fieldSection webskin">
			<label class="fieldsectionlabel " for="parentID">
				Parent Page:
			</label>
		
			<div class="fieldAlign">	
				<select name="parentID" id="parentID">	
					<option value="">Use current page</value>
				</cfoutput>
		
				<cfloop query="qSiteMap">
					<cfoutput><option value="#qSiteMap.objectid#"<cfif refobjectid IS "#qSiteMap.objectid#"> selected="selected"</cfif>>#RepeatString('-', qSiteMap.nLevel)# #qSiteMap.objectname#</option></cfoutput>
				</cfloop>
		
				<cfoutput>
				</select>				
			</div>
			<br class="clearer">
		</div>
		</cfoutput>	
		
	</wiz:step>
	
</wiz:wizard>

<cfsetting enablecfoutputonly="no" />



