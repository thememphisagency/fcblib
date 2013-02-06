<cfsetting enablecfoutputonly="true" />

<!--- @@displayname: Paginated Search Item --->
<!--- @@author: Sandy Trinh --->

		<cfset sAnchor = 'href="#stObj.link#"'>
		<cfif stObj.displayMethod EQ 'displayPageEmail'>
			<cfset sAnchor = 'href="mailto:#stObj.link#"'>
		<cfelseif stObj.displayMethod EQ 'displayPageNewWindow'>	
			<cfset sAnchor = 'href="#stObj.link#" target="_blank"'>
		</cfif>
		
		<cfoutput>
		<li class="teaser">
			<h3><a #sAnchor#>#stObj.label#</a></h3> 
		</cfoutput>
						
			<cfif structKeyExists(stObj, 'teaser') AND len(stobj.teaser) GT 0>
				<cfoutput><p>#stObj.teaser#</p></cfoutput>
			</cfif>	
			<cfif structKeyExists(stObj, 'readMoreText') AND len(stobj.readMoreText) GT 0>
				<cfoutput><a #sAnchor#>#stObj.readMoreText# ...</a></cfoutput>
			</cfif>	
			
		<cfoutput>
		</li>
		</cfoutput>

<cfsetting enablecfoutputonly="false" />