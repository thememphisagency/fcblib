<cfsetting enablecfoutputonly="yes">
<!--- 
		Enpresiv Group Pty Limited 2006, http://www.enpresiv.com
		NOTES: Teaser to display link in a mail client
--->

<!--- @@displayname: Standard - Email --->
<!--- @@author: Enpresiv Group (support@enpresiv.com) --->

<cfoutput>
<script>
	window.location.href = '#stObj.link#';
	window.close();
</script>
</cfoutput>

<cfsetting enablecfoutputonly="no">