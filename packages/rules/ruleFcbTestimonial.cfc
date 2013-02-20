<cfcomponent displayname="Utility: Testimonial Rule" extends="farcry.core.packages.rules.rules" hint="">

	<cfproperty ftSeq="1" ftFieldset="Rule Details" name="label" type="nstring" hint="Title of object" required="no" default="" ftLabel="Heading" bLabel=1 />
	<cfproperty ftSeq="2" ftFieldSet="Rule Details" ftlabel="Item(s) per page" name="numItems" hint="The number of items to display per page" type="string" required="true" default="1">
	<cfproperty ftSeq="3" ftFieldSet="Rule Details" ftlabel="Randomise" name="randomise" hint="Choose " type="boolean" ftRenderType="checkbox" required="true" default="1">
	<cfproperty ftSeq="4" ftFieldset="Rule Details" ftLabel="Categories" name="lSelectedCategoryID" type="longchar" default="" hint="A list of category ObjectIDs that the content is to be drawn from" required="false" ftType="category" />
	<cfproperty ftSeq="5" ftFieldset="Rule Details" name="displayMethod" type="string" hint="Display teaser method to render individual content items." required="true" default="displayTeaserStandard" ftType="webskin" fttypename="fcbTestimonial" ftprefix="displayTeaser" ftLabel="Display Method" ftHint="This determines how each of your content will render." />

</cfcomponent>