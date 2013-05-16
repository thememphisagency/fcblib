<cfcomponent displayname="Footer Links" extends="farcry.core.packages.rules.rules" hint="A rule for adding Footer Links in a way that works Responsively.">
	<cfproperty ftSeq="1" ftFieldSet="Heading" name="title" type="string" ftType="string" hint="" ftLabel="Heading title" />
	<cfproperty ftSeq="2" ftFieldSet="Heading" name="heading" type="uuid" ftType="uuid" ftJoin="dmLink,dmNews,dmNavigation" hint="Heading link. In mobile view this is all that is shown" ftLabel="Heading link" ftHint="If selected, this will be displayed as the title instead." />
	<cfproperty ftSeq="3" ftFieldSet="Selected Objects" name="aPickedObjects" type="array" ftJoin="dmLink,dmNews,dmNavigation,fcbContact" ftLabel="Select Objects" />
</cfcomponent>