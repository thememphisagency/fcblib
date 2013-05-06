<cfoutput>
	<html>
		<head>
			<title>SVN Revisions Exporter</title>
			<style type="text/css">
				body{
					font-family: verdana;
				}
			</style>
		</head>
		<body>
<h2>SVN Revisions Exporter</h2>
<cfif isDefined("form.filePathToProject")>
	<cfset dirPath = "">
	<cfset filePath = "">
	<cfset filePathToProject = form.filePathToProject />
	<cfset filePathToExportFolder = form.filePathToExportFolder />
	<cfset svnPathToFiles = form.svnPathToFiles />
	<cfset svnHistoryLog = form.svnHistoryLog />
	<cfset aSVNData = listToArray(svnHistoryLog,chr(13)) />
	
	<cfloop from="1" to="#arrayLen(aSVNData)#" index="i">
		<cfset sData = trim(aSVNData[i]) />
	
		<cfif left(sData,2) IS "M " OR left(sData,2) IS "A ">
			<cfset filePath = replaceNoCase(sData,"M #svnPathToFiles#","","ALL") />
			<cfset filePath = replaceNoCase(filePath,"A #svnPathToFiles#","","ALL") />
			<cfset filePath = replaceNoCase(filePath,"/","\","ALL") />
			<cfset dirPath = replaceNoCase(filePath,listLast(filePath,"\"),"","ALL") />
		</cfif>
		<cftry>
		
			<cfif len(dirPath) AND directoryExists("#filePathToExportFolder##dirpath#") IS 0>
				<cfdirectory action="create" directory="#filePathToExportFolder##dirpath#" />
			</cfif>
			<cfif fileExists("#filePathToProject##filePath#")>
				<cffile action="copy" source="#filePathToProject##filePath#" destination="#filePathToExportFolder##filePath#" />
			</cfif>
			<cfoutput>#filePath#</cfoutput>
			
			<cfcatch type="any">
				<cfoutput>#filePath#</cfoutput>
				<cfdump var="#cfcatch#">
			</cfcatch>
		</cftry>
		
	</cfloop>

<cfelse>
	<form name="svn" method="POST">
		<label for="filePathToProject">
			File Path To Project:
			<input type="text" name="filePathToProject" value="E:\websites\{projectname}\" />
		</label>
		<label for="filePathToExportFolder">
			File Path To Export Folder:
			<input type="text" name="filePathToExportFolder" value="E:\temp\{projectname}\" />
		</label>
		<label for="svnPathToFiles">
			SVN Path To Files:
			<input type="text" name="svnPathToFiles" value="/trunk/website/" />
		</label>
		<label for="svnHistoryLog">
			SVN History Log:
			<textarea name="svnHistoryLog" cols="120" rows="20"></textarea>
		</label>
		<input type="submit" />
	</form>
</cfif>
		
		</body>
	</html>
</cfoutput>
