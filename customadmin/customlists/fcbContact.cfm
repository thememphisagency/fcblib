<cfsetting enablecfoutputonly="yes">

<!--- import tag libraries --->
<cfimport taglib="/farcry/core/tags/formtools" prefix="ft" />
<cfimport taglib="/farcry/core/tags/admin/" prefix="admin" />

<!--- set up page header --->
<admin:header title="Contacts" />

<ft:objectAdmin 
	title="Contacts" 
	typename="fcbContact" 
	plugin="fcbLib"
	ColumnList="label,datetimelastUpdated,lastupdatedby"
	SortableColumns="label,datetimelastUpdated,lastupdatedby"
	lFilterFields="label"
	sqlorderby="datetimelastupdated desc" />

<!--- page footer --->
<admin:footer />

<cfsetting enablecfoutputonly="no">
