<cfcomponent displayname="Paginator: Search by Category" extends="farcry.core.packages.rules.rules" 
		hint="Publish approved content in selected category. If selected content is News or Event content, they will only be displayed if it is 
			a) time is past the publish date; 
			b) time is before the expriy date.">


	<cfproperty ftSeq="1" ftFieldSet="Rule Details" ftlabel="Item(s) per page" name="numItems" hint="The number of items to display per page" type="string" required="true" default="5" />
	<cfproperty ftSeq="2" ftFieldSet="Rule Details" ftlabel="Animate?" name="bAnimate" hint="Check to allow animation" type="boolean" default=0 />
	<cfproperty ftSeq="3" ftFieldset="Rule Details" ftLabel="Categories" name="lSelectedCategoryID" type="longchar" default="" hint="A list of category ObjectIDs that the content is to be drawn from" required="false" ftType="category" />
	<cfproperty name="displayMethod" type="string" hint="Display method to render this news rule with." required="yes" default="displayPaginatedSearchItem" />

</cfcomponent>