<cfsetting enablecfoutputonly="true" />
<!--- @@displayname: Display page child links --->

<cfimport taglib="/farcry/core/tags/webskin" prefix="skin" />

<cfset oNav = CreateObject("component", application.stcoapi.dmNavigation.packagepath) />
<cfset sDisplayMethod = 'displayTeaserStandard' />

<cfif stObj.bRHSColumn>
  <cfset sDisplayMethod = 'displayTeaserBullet' />
</cfif>

<!--- assumes existance of request.navid  --->
<cfparam name="request.navid">

<cfset sNav = stObj.refobjectid />

<cfif len(stObj.refobjectid) IS 0>
	<cfset sNav = request.navid />
</cfif>

<!--- get the children of this object --->
<cfset qGetChildren = application.factory.oTree.getChildren(objectid=sNav) />
<cfset sContent = '' />
<cfset sTeaserContent = '' />

<cfoutput>
<div class="module ruleChildLinks">
</cfoutput>

  <cfif qGetChildren.recordcount GT 0>

  	<!--- loop over children --->
  	<cfloop query="qGetChildren">

  		<!--- get child nav details --->
  		<cfset stCurrentNav = oNav.getData(objectid=qGetChildren.objectID) />

  		<!--- check for sim link --->
  		<cfif len(stCurrentNav.externalLink)>
  			<!--- get sim link details --->
  			<cftry>
  				<cfset stCurrentNav = oNav.getData(objectid=stCurrentNav.externalLink) />

  				<cfcatch><!--- Ignore if the object doesnt exist ---></cfcatch>
  			</cftry>
  		</cfif>

  		<cfquery datasource="#application.dsn#" name="qNavPages">
  		SELECT * FROM dmNavigation_aObjectIDs
  		where parentid = '#stCurrentNav.objectid#'
  		order by seq
  		</cfquery>

  		<cfif qNavPages.recordCount>
  			<cfloop query="qNavPages">
  				<cfset stNavTemp = application.fapi.getContentObject(qNavPages.parentID) />
  				<cfif StructKeyExists(stNavTemp,"status") AND ListContains(request.mode.lValidStatus, stNavTemp.status)>
  					<cfset stObjTemp = application.fapi.getContentObject(objectid=qNavPages.data) />

  					<cfif NOT structIsEmpty(stObjTemp)>
  						<!--- request.lValidStatus is approved, or draft, pending, approved in SHOWDRAFT mode --->
  						<cfif (StructKeyExists(stObjTemp,"status") AND ListContains(request.mode.lValidStatus, stObjTemp.status) OR NOT StructKeyExists(stObjTemp,"status")) >

  							<!--- if in draft mode grab underlying draft page --->
  							<cfif IsDefined("stObjTemp.versionID") AND request.mode.showdraft>
  								<cfquery datasource="#application.dsn#" name="qHasDraft">
  									SELECT objectID,status from #application.dbowner##stObjTemp.typename# where versionID = '#stObjTemp.objectID#'
  								</cfquery>

  								<cfif qHasDraft.recordcount gt 0>
  									<cfset stObjTemp = application.fapi.getContentObject(objectid=qHasDraft.objectid) />
  								</cfif>
  							</cfif>

                <cfif stObj.bRHSColumn>
                  <cfset sTeaserContent = '<li><a href="#application.fAPI.getLink(objectid=stNavTemp.objectid)#">#stNavTemp.label#</a></li>' />
                </cfif>


  							<cfbreak>
  						</cfif>
  					<cfelse>
  						<!--- structure is blank; ie tree reference is borked --->
  						<skin:bubble title="site tree error" message="#qNavPages.data# not in tree" sticky="true" />
  					</cfif>

  				</cfif>
  			</cfloop>
  		<cfelse>
  			<skin:view objectid="#stCurrentNav.objectid#" webskin="#sDisplayMethod#" r_html="sTeaserContent" alternateHTML="<!-- #sDisplayMethod# does not exist for #stObjTemp.typename# -->" />
  		</cfif>

      <cfset sContent &= trim(sTeaserContent) />

  	</cfloop>

  </cfif>

  <cfif len(trim(sContent)) GT 0>

    <cfif len(trim(stObj.label)) AND stObj.label NEQ '(incomplete)'>
      <cfoutput><h3 class="heading">#stObj.label#</h3></cfoutput>
    </cfif>

    <cfif stObj.bRHSColumn>
      <cfoutput>
        <ul>#sContent#</ul>
      </cfoutput>
    <cfelse>
      <cfoutput>
        <div class="index">
          <cfif len(trim(stObj.intro))> <p class="intro">#stObj.intro#</p> </cfif>
          #sContent#
          </div>
      </cfoutput>
    </cfif>

  </cfif>

<cfoutput>
</div>
</cfoutput>

<cfsetting enablecfoutputonly="false" />
