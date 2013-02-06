<cfcomponent displayname="Social Links" hint="Social Links" extends="farcry.core.packages.forms.forms" output="false" key="socialLinks">
	<cfproperty ftSeq="1" ftFieldset="Twitter" name="twitterURL" type="String" default="http://twitter.com/" hint="" ftLabel="URL" />
	<cfproperty ftSeq="2" ftFieldset="Twitter" name="twitterAccount" type="String" default="" hint="" ftLabel="Account Name" />
	<cfproperty ftSeq="3" ftFieldset="Twitter" name="twitterFeed" type="String" default="" hint="" ftLabel="RSS Feed" />
	<cfproperty ftSeq="4" ftFieldset="Twitter" name="twitterUpdateInterval" type="String" default="30" hint="" ftLabel="Feed Update Frequency (minutes)" />
	<cfproperty ftSeq="5" ftFieldset="Twitter" name="timezoneDifference" type="String" default="9.5" hint="" ftLabel="Timezone Difference" />
	
	<cfproperty ftSeq="10" ftFieldset="Misc" name="facebook" type="String" default="" hint="" ftLabel="Facebook" />
	<cfproperty ftSeq="11" ftFieldset="Misc" name="myspace" type="String" default="" hint="" ftLabel="MySpace" />
	<cfproperty ftSeq="12" ftFieldset="Misc" name="digg" type="String" default="" hint="" ftLabel="Digg" />
</cfcomponent>