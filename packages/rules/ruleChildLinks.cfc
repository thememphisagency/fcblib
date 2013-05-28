<!--- @@displayname: Display Title for the Template --->
<!--- @@Description: List teasers for the current navigation folders children.  Children types are restricted to dmHTML, dmLink and dmInclude content types. --->
<!--- @@Developer: Geoff Bowers (modius@daemon.com.au) --->
<cfcomponent displayname="Utility: Child Links Rule" extends="farcry.plugins.farcrycms.packages.rules.ruleChildLinks"
	hint="List teaser displays for the current navigation folders children.
		Children content types are restricted to dmHTML, dmLink and dmInclude.
		This publishing rule is commonly used on section landing pages to
		build a summary for the pages in the section.">

	<cfproperty ftSeq="1" ftFieldset="Rule Options" name="title" ftType="string" type="nstring" hint="Title of object" required="no" default="" ftLabel="Heading" bLabel=1 />
	<cfproperty ftSeq="2" ftFieldSet="Rule Options" name="intro" type="longchar" ftType="longchar" hint="Intro text placed in front of the handpicked rule results.  Can be any relevant content and HTML markup." ftLabel="Introduction" />
	<cfproperty ftSeq="3" ftFieldset="Rule Options" name="bRHSColumn" type="boolean" ftType="boolean" hint="Determine render method based on location of the rule." required="no" ftLabel="RHS column?" ftHint="If selected, content will be displayed in a bulleted list." />

	<cfproperty name="refobjectid" type="UUID" hint="" required="false" default="" />

</cfcomponent>
