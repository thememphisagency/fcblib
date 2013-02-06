
<cfset db = CreateObject('component', '#application.custompackagepath#.custom.dbutility') />
<cfset rDuplicate = db.duplicateTable('fqAudit', 'fqAuditDupe') />
<cfset rRollback = db.rollbackTable('fqAudit', 'fqAuditDupe') />

<cfdump var="#rDuplicate#" />
<cfdump var="#rRollback#" />