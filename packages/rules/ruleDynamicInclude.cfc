<cfcomponent name="ruleDynamicInclude" displayname="Dynamic Include" extends="farcry.core.packages.rules.rules">

	<cfproperty ftSeq="1" ftFieldset="Rule Details" ftLabel="Heading" bLabel="1" name="label" hint="label" type="string" required="false" default="" />
	<cfproperty ftSeq="2" ftFieldset="Rule Details" ftLabel="Introduction" name="intro" hint="Intro text" type="string" required="false" default="" />
	<cfproperty ftSeq="3" ftFieldset="Rule Details" name="include" type="string" hint="Display of rule content" required="true" default="" ftType="list" ftRenderType="dropdown" ftListData="getIncludeFiles" ftLabel="Include" ftHint="This determines how each of your rule content will render." />

	<cfproperty name="displayMethod" type="string" hint="Display method to render this news rule with." required="yes" default="displayTeaser">
	<cfproperty name="variables" type="string" hint="Display method to render this news rule with." required="yes" default="">
	
	<cffunction name="getIncludeFiles" access="public" output="false" returntype="string">
		<cfset var lGetIncludes = request.fcbObjectBucket.create(typename='dmInclude').getIncludeList() />
		<cfset lGetIncludes = replaceNoCase(lGetIncludes,':none selected,','','one') />
		<cfreturn lGetIncludes />
	</cffunction>
		
</cfcomponent>
