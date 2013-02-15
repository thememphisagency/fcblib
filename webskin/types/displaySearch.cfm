<cfsetting enablecfoutputonly="true" />
<!--- @@Copyright: The Memphis Agency 2010, http://www.thememphisagency.com.au --->
<!--- @@displayname: Lucene Search Results Page --->

<!--- import tag libraries --->
<cfimport taglib="/farcry/plugins/fcblib/tags/fcb/ui" prefix="ui" />

<cfparam name="stParam.score" default="" />

<!--- instantiate the objects --->
<cfset oLucene = request.fcbObjectBucket.create(fullPath='farcry.plugins.fcblib.packages.custom.lucene') />

<cfoutput>
	<li class="teaser">
		<h3><span class="score">#round(stParam.score * 100)#%</span><ui:buildLink objectId=#stObj.objectid# linkText="#stObj.label#" /></h3>
	<cfif StructKeyExists(stObj,"teaser") GT 0 AND len(trim(stObj.teaser)) GT 0>
		<p class="summary">#oLucene.cleanSearchResults(stObj.teaser, form.criteria)#</p>
	</cfif>
	</li>
</cfoutput>