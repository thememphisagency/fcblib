<cfsetting enablecfoutputonly="true" />
<!--- @@Copyright: The Memphis Agency 2010, http://www.thememphisagency.com.au --->
<!--- @@displayname: Lucene Search Results Page --->

<!--- import tag libraries --->
<cfimport taglib="/farcry/plugins/fcblib/tags/fcb/ui" prefix="ui" />

<cfparam name="stParam.score" default="" />

<!--- instantiate the objects --->
<cfset oLucene = request.fcbObjectBucket.create(fullPath='farcry.plugins.fcblib.packages.custom.lucene') />

<cfdirectory action="list" directory="#application.path.defaultFilePath#/dmfile/" filter="#listLast(stObj.filename,'/')#" name="qFileInfo">

<cfif len(qFileInfo.size) LTE 0>
	<cfset fileSize = 0>
<cfelse>		
	<cfset fileSize = int(qFileInfo.size)>
</cfif>	

<cfset fileExt = listLast(stObj.filename,".")>

<cfoutput>
	<li>
		<h3><span class="score">#round(stParam.score * 100)#%</span> #stObj.label#</h3>
 		<p class="summary">
			<a href="#application.url.webroot#/download.cfm?downloadfile=#stObj.objectid#&typename=#stObj.typename#&fieldname=filename">#uCase(fileExt)# Format</a> <span class="fileSize">(#int(fileSize / 1024)#kb)</span>
		</p>
		<p class="summary">#oLucene.cleanSearchResults(stObj.description, form.criteria)#</p>
	</li>
</cfoutput>