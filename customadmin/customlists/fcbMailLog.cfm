<cfsetting enablecfoutputonly="yes">

<!--- import tag libraries --->
<cfimport taglib="/farcry/core/tags/formtools" prefix="ft" />
<cfimport taglib="/farcry/core/tags/admin/" prefix="admin" />

<!--- set up page header --->
<admin:header title="Contacts" />

<ft:objectAdmin
	title="Mail Log" 
	typename="fcbMail" 
	plugin="fcbLib"
	ColumnList="label,emailAddress,datetimeCreated,status"
	SortableColumns="label,datetimeCreated,emailAddress,status"
	lFilterFields="label"
	sqlorderby="datetimeCreated desc"
	lButtons=""
	bCheckAll="0"
    bSelectCol="0"
    bEditCol="0"
    bViewCol="0"
    bFlowCol="0"
    bPreviewCol="1"/>

<!--- page footer --->
<admin:footer />

<cfsetting enablecfoutputonly="no">
