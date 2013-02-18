<cfsetting enablecfoutputonly="true" />

<!--- @@displayname: Paginated Search Item --->
<!--- @@author: Sandy Trinh --->

<!--- IMPORT TAG LIBRARIES --->
<cfimport taglib="/farcry/core/tags/webskin" prefix="skin">
<cfimport taglib="/farcry/plugins/fcblib/tags/fcb/ui" prefix="ui" />

		<cfoutput>
		<li class="teaser">
			<h3><ui:buildLink objectID="#stobj.objectid#" linktext="#stObj.label#" /></h3> 
		</cfoutput>
		
			<cfif structKeyExists(stObj, 'publishDate')>
				<cfoutput><p class="publishDate"><strong>Publish Date: </strong>#DateFormat(stObj.publishDate, "dd mmmm yyyy")#</p></cfoutput>
			</cfif>
		
			<cfif structKeyExists(stObj, 'teaserImage') AND len(stobj.teaserImage)>
				<cfoutput><span class="thumbnail"></cfoutput>
				<skin:view objectid="#stobj.teaserImage#" typename="dmImage" template="displayStandardImage" r_html="teaserImageHTML" />						
				<ui:buildLink objectID="#stobj.objectid#" linktext="#teaserImageHTML#" />	
				<cfoutput></span></cfoutput>			
			</cfif>
		
			<cfif structKeyExists(stObj, 'teaser') AND len(stobj.teaser)>
				<cfoutput><p>#stObj.teaser#</p></cfoutput>
			</cfif>	
			<cfif structKeyExists(stObj, 'readMoreText') AND len(stobj.readMoreText)>
					<ui:buildLink objectid="#stobj.objectID#" linkText="#stObj.readMoreText# ..." />
			</cfif>	
			
		<cfoutput>
		</li>
		</cfoutput>

<cfsetting enablecfoutputonly="false" />