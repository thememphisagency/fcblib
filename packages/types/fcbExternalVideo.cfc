<cfcomponent extends="farcry.core.packages.types.types" displayname="External Video URL" hint="Provide access to external video such as youtube and veoh" bObjectBroker="true">

	<cfproperty ftseq="1" ftFieldset="Link Information" name="title" type="string" hint="Meaningful reference title for link" required="no" default="" ftlabel="Title" blabel="true" ftvalidation="required" />
	<cfproperty ftseq="2" ftfieldset="Link Information" name="link" type="string" hint="URL of Video" required="no" default="" ftlabel="Link" ftvalidation="required" />
	<cfproperty ftseq="3" ftfieldset="Link Information" name="videoType" type="string" hint="Type of video" required="no" default="" ftlabel="Video Type" fttype="list" ftlist="youtube:Youtube" ftSelectMultiple="false" trendertype="dropdown" />


	<cffunction name="BeforeSave" access="public" output="false" returntype="struct">
		<cfargument name="stProperties" required="true" type="struct">
		<cfargument name="stFields" required="true" type="struct">
		<cfargument name="stFormPost" required="false" type="struct">		

		<cfset arguments.stProperties = super.beforeSave(argumentCollection="#arguments#") />
		
		<cfif findNoCase("http://youtu.be/",arguments.stProperties.link) GT 0>
			<!--- rewrite short url to correct embed url. --->
			<cfset arguments.stProperties.link = replaceNoCase(arguments.stProperties.link,"http://youtu.be/","http://www.youtube.com/embed/") />
		</cfif>
		
		<cfreturn arguments.stProperties>
	</cffunction>

</cfcomponent>