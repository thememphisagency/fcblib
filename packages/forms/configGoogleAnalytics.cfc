<cfcomponent displayname="Google Analytics" hint="Configuration for Google Analytics" extends="farcry.core.packages.forms.forms" output="false" key="googleAnalytics">
	<cfproperty ftSeq="1" ftFieldset="" name="keyid" type="String" default="" hint="" ftLabel="Key ID" />
	<cfproperty ftSeq="2" ftFieldSet="" name="bActive" type="boolean" fttype="boolean" ftrendertype="checkbox" hint="" ftLabel="Active" default="0" />
</cfcomponent>