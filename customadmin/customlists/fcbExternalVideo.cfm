<cfimport taglib="/farcry/core/tags/admin/" prefix="admin" />
<cfimport taglib="/farcry/core/tags/formtools" prefix="ft" />

<!--- Override the client side validation for the filter fields. --->

<!--- set up page header --->
<admin:header title="External Video URL" />

<ft:objectadmin 
	typename="fcbExternalVideo"
	permissionset="news"
	title="External Video URL"
	columnList="title,datetimelastUpdated,status"
	sortableColumns="title,datetimelastUpdated,status"
	lFilterFields="title"/>

<admin:footer />