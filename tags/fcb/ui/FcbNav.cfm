<cfsetting enablecfoutputonly="yes" />

<!--- IMPORT TAG LIBRARIES --->
<cfimport taglib="/farcry/plugins/fcblib/tags/fcb/ui" prefix="ui" />

<!--- allow developers to close custom tag by exiting on end --->
<cfif thistag.ExecutionMode eq "end">
	<cfexit method="exittag" />
</cfif>

<cfif isDefined("request.ver") and request.ver>
	<cfoutput><!-- _FcbNav $Revision: 0.2 $ --></cfoutput>
</cfif>

<!--- params --->
<cfparam name="attributes.navID" default="#request.navID#">
<cfparam name="attributes.depth" default="1">
<cfparam name="attributes.startLevel" default="2">
<cfparam name="attributes.id" default="">
<cfparam name="attributes.bFirst" default="1">
<cfparam name="attributes.bLast" default="1">
<cfparam name="attributes.bActive" default="1">
<cfparam name="attributes.bIncludeHome" default="0">
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
<cfparam name="attributes.styleSecureNodes" default=""><!--- Applies a class to the nodes that are specifed with a certain role and permission --->

<cfset oBarnacle = createObject('component', "#application.fapi.getPackagePath("types","farBarnacle")#" ) />

<!--- Check if user is a logged in admin --->
<cfset bAdmin = 0  />

<cfif structKeyExists(session, 'dmSec') AND structKeyExists(session.dmSec, 'authentication') 
	AND structKeyExists(session.dmSec.authentication, 'bAdmin') AND session.dmSec.authentication.bAdmin EQ 1>
		
	<cfset bAdmin = 1  />	
	
</cfif>
		
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

<cfif len(attributes.styleSecureNodes)>
	<cfquery name="qRoles" datasource="#application.dsn#">
		SELECT objectid
		FROM farRole
		WHERE label = <cfqueryparam value="#attributes.styleSecureNodes#" cfsqltype="CF_SQL_VARCHAR" />
	</cfquery>
</cfif>

<cfif attributes.bLast>
	<!--- here we get the most right nav so we can add a last class to it if needed --->
	<cfquery name="qMaxRight" dbtype="query">
		select max(nRight) as maxRight from qNav
	</cfquery>
</cfif>

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

<cfscript>
	// initialise counters
	currentlevel=0; // nLevel counter
	ul=0; // nested list counter
	bHomeFirst = false; // used to stop the first node being flagged as first if home link is inserted.
	bFirstNodeInLevel = true; // used to track the first node in each level.						
	// build menu [bb: this relies on nLevels, starting from nLevel 2]
	for(i=1; i lt incrementvalue(qNav.recordcount); i=i+1){

		sSecureText = "";
		secureNode = 1;
		//check if node is secure to be used later for adding a class to secure links
		if(len(attributes.styleSecureNodes)) {
			secureNode = application.security.checkPermission(object=qNav.ObjectID[i],permission="View",role="#qRoles.objectID#");
			if( NOT secureNode) {
				sSecureText = "secure";
			}
		}


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
				
				if(qNav.nLevel[i] lt attributes.startlevel+attributes.depth - 1  and qNav.nRight[i]-qNav.nleft[i] neq 1) {
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
					if(len(attributes.id)){
						writeOutput(" id=""#attributes.id#""");
					}
					if(len(attributes.class)){
						writeOutput(" class=""#attributes.class# lvl#currentlevel-1#""");
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
						writeOutput("><a href=""#href2#""><span class=""toplevel"">#homeNode.objectName#</span></a></li>");
					}
					ul=ul+1;
				}
				else if(currentlevel gt previouslevel){
					// if new level, open new list
					writeOutput("<ul class=""lvl#currentlevel-1#"">");
					ul=ul+1;
					bFirstNodeInLevel = true;
				}
				else if(currentlevel lt previouslevel){
					// if end of level, close current item
					writeOutput("</li>");
					// close lists until at correct level
					writeOutput(repeatString("</ul></li>",previousLevel-currentLevel));
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
							itemclass=itemclass & 'lvl#currentlevel-1#First ';
							bFirstNodeInLevel=false;
						}
					}
					
				}
				// open a list item
				writeOutput("<li");

				// account for different variations
				if( len(trim(itemclass)) OR len(trim(sSecureText)) ){
					// add a class
					writeOutput(' class="'&trim(itemclass)&' '&trim(sSecureText)&'"');
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

<cfoutput></nav></cfoutput>

<cfsetting enablecfoutputonly="no" />

<cffunction name="getURL" output="false" returntype="string">
	<cfargument name="objectid" type="uuID" required="true" />
	<cfargument name="bIncludeDomain" type="boolean" required="false" default=0 />
	
	<cfset var sHref = '' />
			
	<cfsavecontent variable="sHref"><ui:buildLink objectid="#arguments.objectid#" urlOnly="1" includeDomain="#arguments.bIncludeDomain#" /></cfsavecontent>
	
	<cfreturn trim(sHref) />
</cffunction>