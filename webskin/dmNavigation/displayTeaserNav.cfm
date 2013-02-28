<cfimport taglib="/farcry/core/tags/webskin" prefix="skin">

<cfset o = createObject("component", "#application.packagepath#.farcry.tree") />
<cfset qLeaves = o.getLeaves(lnodeids=stObj.objectid)/>
<cfset childHTMLpage = qLeaves[1] />

<skin:view objectid="#childHTMLpage.teaserImage#" typename="dmImage" template="displaySourceImage" r_html="teaserImageHTML" />

<cfoutput>
	<article class="navTeaser">
		#teaserImageHTML#

		<p class="details">#childHTMLpage.teaser#</p>
	</article>

</cfoutput>