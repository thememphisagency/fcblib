<cfsetting enablecfoutputonly="yes" />

<!--- IMPORT TAG LIBRARIES --->
<cfimport taglib="/farcry/plugins/fcblib/tags/fcb/ui" prefix="ui" />

<!--- allow developers to close custom tag by exiting on end --->
<cfif thistag.ExecutionMode eq "end">
	<cfexit method="exittag" />
</cfif>

<cfif isDefined("request.ver") and request.ver>
	<cfoutput><!-- _FcbNav $Revision: 0.1 $ --></cfoutput>
</cfif>

<!--- params --->
<cfparam name="attributes.navID" default="#request.navID#">
<cfparam name="attributes.depth" default="1">
<cfparam name="attributes.startLevel" default="2">
<cfparam name="attributes.id" default="navMain">
<cfparam name="attributes.bFirst" default="1">
<cfparam name="attributes.bLast" default="1">
<cfparam name="attributes.bActive" default="1">
<cfparam name="attributes.bIncludeHome" default="0">
<cfparam name="attributes.heading" default="">
<cfparam name="attributes.sectionObjectID" default="#request.navID#">
<cfparam name="attributes.functionMethod" default="getDescendants">
<cfparam name="attributes.functionArgs" default="depth=attributes.depth">
<cfparam name="attributes.bDump" default="0">
<cfparam name="attributes.class" default="">
<cfparam name="attributes.style" default="">
<cfparam name="request.sectionObjectID" default="#request.navID#">
<cfparam name="attributes.displayStyle" default="unorderedList">
<cfparam name="attributes.bHideSecuredNodes" default="0"><!--- MJB: check if option to Hide Nav Node Items that user does't have permission to access: default to 0 for backward compatibility --->
<cfparam name="attributes.afilter" default="#arrayNew(1)#">
<cfparam name="attributes.bFirstNodeInLevel" default="0">
<cfparam name="attributes.bIncludeDomain" default="0">
<cfparam name="attributes.bDynamicHomeLabel" default="1">
<cfparam name="attributes.levelOffset" default="0">
<cfparam name="attributes.bMultiColumn" default="0">
<cfparam name="attributes.multiColumnRows" default="6">
<cfparam name="attributes.teaserWebskin" default="displayTeaserNav">

<!--- Check if user is a logged in admin --->
<cfset bAdmin = 0  />

<cfif structKeyExists(session, 'dmSec') AND structKeyExists(session.dmSec, 'authentication') 
	AND structKeyExists(session.dmSec.authentication, 'bAdmin') AND session.dmSec.authentication.bAdmin EQ 1>
		
	<cfset bAdmin = 1  />	
	
</cfif>

<cfset oNav = createObject("component", application.types.dmNavigation.typePath) />
		
<!--- // get navigation items --->
<!--- if nav caching is enable, using custom tree component which incorporates a caching function, but only switch on the cache when user is not logged in! --->
<cfif structKeyExists(application.config.fcbWebsite, 'bEnableNavCache') AND application.config.fcbWebsite.bEnableNavCache AND NOT bAdmin>
	<cfset o = createObject("component", "farcry.plugins.fcblib.packages.farcry.tree") />
<cfelse>
	<cfset o = createObject("component", "farcry.core.packages.farcry.tree")>
</cfif>

<cfset navFilter=duplicate(attributes.afilter)>
<cfset arrayAppend(navFilter, "status IN (#listQualify(request.mode.lvalidstatus, '''')#)") />
<cfset qNav = evaluate("o."&attributes.functionMethod&"(objectid=attributes.navID, lColumns='externallink,externalURL,lNavIDAlias', "&attributes.functionArgs&", afilter=navFilter)")>

<!--- // get ansestors of attributes.navID --->
<cfset qAncestors = o.getAncestors(attributes.sectionObjectID)>
<cfset lAncestors = valuelist(qAncestors.objectid)>

<cfif attributes.bIncludeHome>
	<cfif attributes.navID NEQ application.navid.home>
		<!--- Get details of the start node if it is not equal to home node --->
		<cfset homeNode = o.getNode(objectid=attributes.navID) />
	<cfelse>
		<!--- // get application.navid.home objectName --->
		<cfset homeNode = o.getNode(objectID=#application.navid.home#)>
	</cfif>	
</cfif>

<cfif attributes.bLast>
	<!--- here we get the most right nav so we can add a last class to it if needed --->
	<cfquery name="qMaxRight" dbtype="query">
		select max(nRight) as maxRight from qNav
	</cfquery>
</cfif>



<cffunction name="dump">
	<cfargument name="arg">
	<cfdump var="#arg#">
	<cfabort/>
</cffunction>

<cfoutput>
	<div id='fcbNavWrap'>
		<div id='#attributes.id#' class='clearfix'>
</cfoutput>

<cfif len(attributes.heading) GT 0><cfoutput><h3 class="heading">#attributes.heading#</h3></cfoutput></cfif>

<cfoutput>
<nav id="menu" role="navigation">
</cfoutput>

<cfif attributes.displayStyle EQ "aLink">
	<cfloop query="qNav">

		<cfset strhref = getURL(objectid=object,bIncludeDomain=attributes.bIncludeDomain) />
		
		<cfif qNav.currentRow GT 1>
			<cfoutput> | </cfoutput>		
		</cfif>
		<cfoutput><a href="#strhref#" title="#qNav.objectName#">#qNav.objectName#</a></cfoutput>
	</cfloop>
<cfelse>


<cfset aParents =  ArrayNew(1) />
<cfloop query="qNav">
	
	<cfif nRight - nLeft GT 1>

		<cfset aSiblings = ArrayNew (1) />
		<cfset stParent = StructNew () />
		
		<cfquery name="qChildren" dbtype="query">
			SELECT objectid,objectname,nlevel
			FROM qNav
			WHERE nLeft > #qNav.nLeft#
			AND nRight < #qNav.nRight#
			AND nLevel != 4
		</cfquery>
		
		<cfloop query="qChildren">
			<cfset arrayAppend(aSiblings, objectid)>
		</cfloop>	
		
		<cfif qChildren.recordCount GT 0>
			<cfset stParent[objectid] = aSiblings />
		</cfif>
		
		<cfset arrayAppend(aParents, stParent)>
	</cfif>
	
</cfloop>

<cfscript>
	// initialise counters
	currentlevel=0; // nLevel counter
	ul=0; // nested list counter
	bHomeFirst = false; // used to stop the first node being flagged as first if home link is inserted.
	bFirstNodeInLevel = true; // used to track the first node in each level.	
	// build menu [bb: this relies on nLevels, starting from nLevel 2]
	
	
	for(i=1; i lt incrementvalue(qNav.recordcount); i=i+1){
		
		bMultiColumnChild = false;	// used to track if we should display a multicolumn layout 					
		
		
		if (attributes.bHideSecuredNodes EQ 0) {
			iHasViewPermission = 1;
		}
		else{
			iHasViewPermission = application.security.checkPermission(object=qNav.ObjectID[i],permission="View");
		}
		
		if (iHasViewPermission EQ 1)
		{
		
					
			if(qNav.nLevel[i] gte attributes.startLevel){
				//dump("test");
				//check external links
				if(structkeyexists(qNav,'externallink') and len(qNav.externallink[i])){
					object = trim(qNav.externallink[i]);
				}
				else{
					object = trim(qNav.ObjectID[i]);
				}

				href = getURL(objectid=object,bIncludeDomain=attributes.bIncludeDomain);	
					
				itemclass='';
				
				if(qNav.nLevel[i] lt attributes.startlevel+attributes.depth - 1  and qNav.nRight[i]-qNav.nleft[i] neq 1 AND qNav.nLevel[i+1] GT qNav.nLevel[i]) {
					itemclass=itemclass & 'parent ';	
				}
				

				//this means it is the last column in nav
				if(attributes.bLast and qNav.nRight[i] eq qMaxRight.maxRight){
					itemclass=itemclass & 'last ';
				}
				if(attributes.bActive and (trim(qNav.ObjectID[i]) eq request.sectionObjectID or listfind(lAncestors, trim(qNav.ObjectID[i])))){
					itemclass=itemclass & 'active ';
				}
				// update counters
				previouslevel=currentlevel;
				currentlevel=qNav.nLevel[i];
				
				// build nested list
				// if first item, open first list
				
			
				
				
				if(previouslevel eq 0) {
					writeOutput("<ul");
					// add id or class if specified
					attributes.class = 'lvl#currentlevel-1-attributes.levelOffset# ' & attributes.class;
					
					if(len(attributes.class)){
						writeOutput(" class=""#attributes.class#""");
					}
					if(len(attributes.style)){
						writeOutput(" style=""#attributes.style#""");
					}
					writeOutput(">");
					//include home if requested
					if(attributes.bIncludeHome){
						homeclass = 'home ';
						
						if(attributes.bFirst){
							homeclass=homeclass & ' first ';
							bHomeFirst = true;
						}				
						//check for friendly urls
						if(attributes.navID neq application.navid.home)
							href2 = getURL(objectid=homeNode.objectid,bIncludeDomain=attributes.bIncludeDomain);							
						else
							href2 = getURL(objectid=application.navid.home,bIncludeDomain=attributes.bIncludeDomain);	
																			
						writeOutput("<li");
						if(request.sectionObjectID eq application.navid.home){
							homeclass=homeclass & ' active ';
						}
						writeOutput(" class="""&trim(homeclass)&"""");
						
						if(attributes.bDynamicHomeLabel){
							writeOutput("><a href=""#href2#""><span class=""toplevel"">#homeNode.objectName#</span></a></li>");
						} else {
							writeOutput("><a href=""#href2#""><span class=""toplevel"">Home</span></a></li>");
						}
					}
					
					ul=ul+1;
				}
				
				else if(currentlevel gt previouslevel){
	
					if(attributes.bMultiColumn) {
						for(x=1; x <= ArrayLen(aParents); x++){
							stCurrentParent = aParents[x];
				
							for(key in stCurrentParent) {
									
								for (j = 1; j lte arraylen(stCurrentParent[key]); j = j + 1)
								{
									if(stCurrentParent[key][j] EQ object && arraylen(stCurrentParent[key]) > attributes.multiColumnRows) 													{
										bMultiColumnChild = true;	
										break;		
									}
								}
							}				
						}
					}
							
					// if new level, open new list
					if(bMultiColumnChild) {

						navTeaserOutput = oNav.getView(objectID=qNav.objectid[i-1],template=attributes.teaserWebskin);

						writeOutput("<div class=""multicolumn lvl#i# lvl#currentlevel-1-attributes.levelOffset# clearfix""><div class=""wrapper"">#navTeaserOutput#<ul class=""lvl#currentlevel-1-attributes.levelOffset#"">");

					} else {
						writeOutput("<div class=""singlecolumn lvl#currentlevel-1-attributes.levelOffset# clearfix""><div class=""wrapper""><ul class=""lvl#currentlevel-1-attributes.levelOffset#"">");
					}
					ul=ul+1;
					bFirstNodeInLevel = true;
				}
				else if(currentlevel lt previouslevel){
					
					if(attributes.bMultiColumn) {
					
						for(x=1; x <= ArrayLen(aParents); x++){
							stCurrentParent = aParents[x];
						
							for(key in stCurrentParent) {					
								for (j = 1; j lte arraylen(stCurrentParent[key]); j = j + 1)
								{				
									if(stCurrentParent[key][j] EQ qNav.objectid[i - 1] && arraylen(stCurrentParent[key]) > attributes.multiColumnRows) {
										bMultiColumnChild = true;
										break;		
									}
								}
							}		
						}
					}
											
								
					// if end of level, close current item
					writeOutput("</li>");
					// close lists until at correct level
					
					writeOutput(repeatString("</ul></div></div></li>",previousLevel-currentLevel));
	
					ul=ul-(previousLevel-currentLevel);
				}
				else{
					// close item
					writeOutput("</li>");
					
				}
				if(attributes.bFirst){
					if(previouslevel eq 0 AND bHomeFirst) {
						//top level and home link is first
					} else {
						if(bFirstNodeInLevel){
							itemclass=itemclass & 'lvl#currentlevel-1-attributes.levelOffset#First ';
							bFirstNodeInLevel=false;
						}
					}
					
				}
				// open a list item
				bMatch = false;
				
				pos = 0;
				
				
				if(attributes.bMultiColumn) {
				
					for(x=1; x <= ArrayLen(aParents); x++){
						stCurrentParent = aParents[x];
			
						for(key in stCurrentParent) {
							
							
							for (j = 1; j lte arraylen(stCurrentParent[key]); j = j + 1)
							{
								if(stCurrentParent[key][j] EQ object) {
									if(j mod attributes.multiColumnRows EQ 1 && j != 1) {
									
										bMatch = true;
										break;
									}
								}	
				
							}
						
							if(bMatch) break;	
						}				
					}
					
					if(bMatch) {
		
						writeOutput("</ul><ul");
								
						attributes.class = 'lvl#currentlevel-1-attributes.levelOffset# ' & attributes.class;
	
						if(len(attributes.class)){
							writeOutput(" class=""#attributes.class#""");
						}
				
						writeOutput(">");	
					}
				}
			
			
				writeOutput("<li");
				if(len(trim(itemclass))){
					// add a class
					writeOutput(" class="""&trim(itemclass)&"""");
				}
				//Check if node contains an external URL
				if(structkeyexists(qNav,'externalURL') and len(qNav.externalURL[i]) gt 0){
					writeOutput("><a href='#trim(qNav.externalURL[i])#' target='_blank'>#trim(qNav.ObjectName[i])#</a>");
				}
				else{
					// write the link				
					if (qNav.nLevel[i] eq attributes.startlevel) {
					    writeOutput("><a href="""&href&"""><span class=""toplevel"">"&trim(qNav.ObjectName[i]) & "</span></a>");
					} else {
					    writeOutput("><a href="""&href&""">"&trim(qNav.ObjectName[i]));
					    if(qNav.nLevel[i] lt attributes.startlevel+attributes.depth - 1  and qNav.nRight[i]-qNav.nleft[i] neq 1) {
					    	 writeOutput(" <span class=""indicator"">&##187;</span>");
					    }
					    writeOutput("</a>");
					}
				}
				
	
				
			
			}
		}
	}
	

	// end of data, close open items and lists
	//writeOutput("</li></ul></div></div></li></ul>");

	//writeOutput(repeatString("</li></ul></div></div>",ul));
	writeOutput(repeatString("</li></ul>",ul));
	

	if (attributes.bIncludeHome AND ul EQ 0)
		{
			writeOutput("<ul");
			
			// add id or class if specified
			if(len(attributes.id))
			{
				writeOutput(" id=""#attributes.id#""");
			}
			if(len(attributes.class))
			{
				writeOutput(" class=""#attributes.class#""");
			}
			writeOutput(">");
						
			writeOutput("<li");
			if(request.sectionObjectID eq application.navid.home)
			{
				writeOutput(" class=""active""");
			}
			writeOutput("><a href=""#application.url.webroot#/"">#homeNode.objectName#</a></li></ul>");
		}
			
</cfscript>
</cfif>

<cfoutput></nav></div></div></cfoutput>

<cfsetting enablecfoutputonly="no" />

<cffunction name="getURL" output="false" returntype="string">
	<cfargument name="objectid" type="uuID" required="true" />
	<cfargument name="bIncludeDomain" type="boolean" required="false" default=0 />
	
	<cfset var sHref = '' />
			
	<cfsavecontent variable="sHref"><ui:buildLink objectid="#arguments.objectid#" urlOnly="1" includeDomain="#arguments.bIncludeDomain#" /></cfsavecontent>
	
	<cfreturn trim(sHref) />
</cffunction>