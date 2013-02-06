<cfcomponent displayname="Utility" hint="A set of custom FCB functions">

	<cffunction name="encodeHTMLEntity" returntype="struct" output="false" hint="Encode any special characters (e.g. '&') to valid HTML entity for each property that has a metadata 'bCleanHTML'.">
		<cfargument name="stProperties" required="true" type="struct">
		<cfargument name="tableName" required="true" />
		
		<cfset var stData = arguments.stProperties />
		<cfset var stProps = application.types[arguments.tableName].stProps />
		
		<!--- Loop through metadata and find properties we flagged to be cleaned  --->
		<cfloop list="#structKeyList(stProps)#" index="i">
			<cfif structKeyExists(stProps[i].metadata,"bCleanHTML") AND stProps[i].metadata.bCleanHTML IS 1>			
				<!--- To avoid encoding existing encoded characters, let's decode the characters back to it's native state, then re-encode the characters --->	
				<cfset stData[stProps[i].metadata.name] = HTMLEditFormat(HtmlUnEditFormat(stData[stProps[i].metadata.name])) />
			</cfif>
		</cfloop>		
		
		<cfreturn stData />
		
	</cffunction>

	<cffunction name="decodeHTMLEntity" returntype="struct" output="false" hint="Encode any special characters (e.g. '&') to valid HTML entity for each property that has a metadata 'bCleanHTML'.">
		<cfargument name="stProperties" required="true" type="struct">
		<cfargument name="tableName" required="true" />
		
		<cfset var stData = arguments.stProperties />
		<cfset var stProps = application.types[arguments.tableName].stProps />
		
		<!--- Loop through metadata and find properties we flagged to be cleaned  --->
		<cfloop list="#structKeyList(stProps)#" index="i">
			<cfif structKeyExists(stProps[i].metadata,"bCleanHTML") AND stProps[i].metadata.bCleanHTML IS 1>			
				<!--- To avoid encoding existing encoded characters, let's decode the characters back to it's native state, then re-encode the characters --->	
				<cfset stData[stProps[i].metadata.name] = HtmlUnEditFormat(stData[stProps[i].metadata.name]) />
			</cfif>
		</cfloop>		
		
		<cfreturn stData />
		
	</cffunction>

	<cffunction name="HtmlUnEditFormat" access="public" returntype="string" output="false" displayname="HtmlUnEditFormat" hint="Undo escaped characters">
		<cfargument name="str" type="string" required="Yes" />
		<cfscript>
		   var lEntities = "&##xE7;,&##xF4;,&##xE2;,&Icirc;,&Ccedil;,&Egrave;,&Oacute;,&Ecirc;,&OElig,&Acirc;,&laquo;,&raquo;,&Agrave;,&Eacute;,&le;,&yacute;,&chi;,&sum;,&prime;,&yuml;,&sim;,&beta;,&lceil;,&ntilde;,&szlig;,&bdquo;,&acute;,&middot;,&ndash;,&sigmaf;,&reg;,&dagger;,&oplus;,&otilde;,&eta;,&rceil;,&oacute;,&shy;,&gt;,&phi;,&ang;,&rlm;,&alpha;,&cap;,&darr;,&upsilon;,&image;,&sup3;,&rho;,&eacute;,&sup1;,&lt;,&cent;,&cedil;,&pi;,&sup;,&divide;,&fnof;,&iquest;,&ecirc;,&ensp;,&empty;,&forall;,&emsp;,&gamma;,&iexcl;,&oslash;,&not;,&agrave;,&eth;,&alefsym;,&ordm;,&psi;,&otimes;,&delta;,&ouml;,&deg;,&cong;,&ordf;,&lsaquo;,&clubs;,&acirc;,&ograve;,&iuml;,&diams;,&aelig;,&and;,&loz;,&egrave;,&frac34;,&amp;,&nsub;,&nu;,&ldquo;,&isin;,&ccedil;,&circ;,&copy;,&aacute;,&sect;,&mdash;,&euml;,&kappa;,&notin;,&lfloor;,&ge;,&igrave;,&harr;,&lowast;,&ocirc;,&infin;,&brvbar;,&int;,&macr;,&frac12;,&curren;,&asymp;,&lambda;,&frasl;,&lsquo;,&hellip;,&oelig;,&pound;,&hearts;,&minus;,&atilde;,&epsilon;,&nabla;,&exist;,&auml;,&mu;,&frac14;,&nbsp;,&equiv;,&bull;,&larr;,&laquo;,&oline;,&or;,&euro;,&micro;,&ne;,&cup;,&aring;,&iota;,&iacute;,&perp;,&para;,&rarr;,&raquo;,&ucirc;,&omicron;,&sbquo;,&thetasym;,&ni;,&part;,&rdquo;,&weierp;,&permil;,&sup2;,&sigma;,&sdot;,&scaron;,&yen;,&xi;,&plusmn;,&real;,&thorn;,&rang;,&ugrave;,&radic;,&zwj;,&there4;,&uarr;,&times;,&thinsp;,&theta;,&rfloor;,&sub;,&supe;,&uuml;,&rsquo;,&zeta;,&trade;,&icirc;,&piv;,&zwnj;,&lang;,&tilde;,&uacute;,&uml;,&prop;,&upsih;,&omega;,&crarr;,&tau;,&sube;,&rsaquo;,&prod;,&quot;,&lrm;,&spades;";
		   var lEntitiesChars = "ç,ô,â,Î,Ç,È,Ó,Ê,Œ,Â,«,»,À,É,?,ý,?,?,?,Ÿ,?,?,?,ñ,ß,„,´,·,–,?,®,‡,?,õ,?,?,ó,­,>,?,?,?,?,?,?,?,?,³,?,é,¹,<,¢,¸,?,?,÷,ƒ,¿,ê,?,?,?,?,?,¡,ø,¬,à,ð,?,º,?,?,?,ö,°,?,ª,‹,?,â,ò,ï,?,æ,?,?,è,¾,&,?,?,“,?,ç,ˆ,©,á,§,—,ë,?,?,?,?,ì,?,?,ô,?,¦,?,¯,½,¤,?,?,?,‘,…,œ,£,?,?,ã,?,?,?,ä,?,¼, ,?,•,?,«,?,?,€,µ,?,?,å,?,í,?,¶,?,»,û,?,‚,?,?,?,”,?,‰,²,?,?,š,¥,?,±,?,þ,?,ù,?,?,?,?,×,?,?,?,?,?,ü,’,?,™,î,?,?,?,˜,ú,¨,?,?,?,?,?,?,›,?,"",?,?";
		</cfscript>
		<cfreturn ReplaceList(arguments.str, lEntities, lEntitiesChars) />
	</cffunction>
	
	<cffunction name="formatTwitterDate">
		<cfargument name="date" required="true" type="date">
		
		<cfset var dateout = '' />
		<!--- Get offset hours from UTC/GMT from server, because the result is a negative number, we need to convert that to positive --->		
		<cfset var utcOffsetSeconds = GetTimeZoneInfo().utcTotalOffset * -1 />
		<cfset date = DateAdd('s',utcOffsetSeconds,date) />		
		
		<!--- displays how many days or weeks or months or years ago, eg: 3 weeks ago --->
		<cfif dateDiff("h",date,now()) LTE 24>
			<cfset hoursDiff = dateDiff("h",date,now())>
			<cfif hoursDiff is 1>
				<cfset dateout = "1 hour ago">
			<cfelse>
				<cfset dateout = "#hoursDiff# hours ago">
			</cfif>
			<cfif hoursDiff is 0>
				<cfset minsDiff = dateDiff("n",date,now())>
				<cfset dateout = "#minsDiff# mins ago">
				<cfif minsDiff is 0>
					<cfset dateout = "just then!">					
				</cfif>
				<cfif minsDiff is 1>
					<cfset dateout = "1 min ago">					
				</cfif>
			</cfif>
		<cfelseif dateDiff("d",date,now()) LTE 7>
			<cfset daysDiff = dateDiff("d",date,now())>
			<cfif daysDiff is 1>
				<cfset dateout = "1 day ago">
			<cfelse>
				<cfset dateout = "#daysDiff# days ago">
			</cfif>
		<cfelseif dateDiff("ww",date,now()) LTE 4>
			<cfset weeksDiff = dateDiff("ww",date,now())>
			<cfif weeksDiff is 1>
				<cfset dateout = "1 wk ago">
			<cfelse>
				<cfset dateout = "#weeksDiff# wks ago">
			</cfif>
		<cfelseif dateDiff("m",date,now()) LTE 12>
			<cfset monthsDiff = dateDiff("m",date,now())>
			<cfif monthsDiff is 1>
				<cfset dateout = "1 mth ago">
			<cfelse>
				<cfset dateout = "#monthsDiff# mths ago">
			</cfif>			
		<cfelse>
			<cfset yearsDiff = dateDiff("yyyy",date,now())>
			<cfif yearsDiff is 1>
				<cfset dateout = "1 yr ago">
			<cfelse>
				<cfset dateout = "#yearsDiff# yrs ago">
			</cfif>
		</cfif>

		<cfreturn dateout>		
	</cffunction>		

	<cffunction name="renderPaging" output="true" hint="Creates the paging links, tricky paging...">
		<cfargument name="currentPage" required="true" type="string">
		<cfargument name="maxRows" required="true" type="string">
		<cfargument name="totalRecs" required="true" type="string">
		<cfargument name="maxPaging" required="true" type="string">
		<cfargument name="url" required="true" type="string">
		<cfargument name="urlHasParam" required="false" type="boolean" default="0">
		<cfargument name="anchor" required="false" type="string" />
		<cfargument name="bShowPreviousFirst" required="false" type="boolean" default="1" />
		
		<cfset var pagingHTML = "">
		<cfset var postPagingHTML = "">
		<cfset var prePagingHTML = "">
		<cfset var prevpagingArrowsHTML = "">
		<cfset var nextpagingArrowsHTML = "">
		<cfset var pages = 0>
		<cfset var middleMaxPages = int(maxPaging/2)>
		<cfset var middleOffSet = int(maxPaging/2)>
		<cfset var pageFrom = 1>
		<cfset var pageTo = 1>	
		<cfset var i = 0>			
		
		<cfif totalRecs gt 0>
			<cfset pages = int(totalRecs/maxRows)>
			<cfif pages LT totalRecs/maxRows>
				<cfset pages = pages +1>
			</cfif>
			
			<cfif middleMaxPages LT maxPaging/2>
				<cfset middleMaxPages = middleMaxPages+1>
			</cfif>		
			
			<cfif currentPage gt pages-middleOffSet>
				<cfset pageFrom = (pages-maxPaging)+1>
				<cfset pageTo = pages>			
			<cfelseif currentPage gt middleMaxPages>
				<cfset pageFrom = currentPage-middleOffSet>
				<cfset pageTo = currentPage+middleOffSet>
				<cfif pageTo GT pages>
					<cfset pageTo = pages>
				</cfif>
			<cfelse>
				<cfset pageFrom = 1>
				<cfset pageTo = maxPaging>			
			</cfif>
			
	<!--- 		<cfif pageFrom GT 1>
				<cfset prePagingHTML = "<span class='pagingDots'>...</span>">
			</cfif>
			<cfif pageTo LT pages>
				<cfset postPagingHTML = "<span class='pagingDots'>...</span>">
			</cfif> --->
	
			<cfset sDelimiter = '?'>
			<cfif arguments.urlHasParam>
				<cfset sDelimiter = '&amp;'>	
			</cfif>

			<cfif currentPage GT 1>
				<cfset prevpagingArrowsHTML = prevpagingArrowsHTML&'<a href="#arguments.url##sDelimiter#currentPage=#currentPage-1##arguments.anchor#" class="prev"><span>Previous</span></a>'>		
			<cfelse>
				<cfset prevpagingArrowsHTML = prevpagingArrowsHTML&'<span class="prev"><span>Previous</span></span>'>					
			</cfif>
			<cfif currentPage LT pages>
				<cfset nextpagingArrowsHTML = nextpagingArrowsHTML&'<a href="#arguments.url##sDelimiter#currentPage=#currentPage+1##arguments.anchor#" class="next"><span>Next</span></a>'>		
			<cfelse>
				<cfset nextpagingArrowsHTML = nextpagingArrowsHTML&'<span class="next"><span>Next</span></span>'>					
			</cfif>
	
			<!--- just in case pages are less than maxPaging --->		
			<cfif pageFrom lte 0>
				<cfset pageFrom = 1>
			</cfif>
			<cfif pageTo gt pages>
				<cfset pageTo = pages>
			</cfif>			
			<cfsavecontent variable="pagingHTML">
				<cfloop from="#pageFrom#" to="#pageTo#" index="i">
					<cfoutput>
						<cfif i neq currentPage>
							<a href="#arguments.url##sDelimiter#currentPage=#i##arguments.anchor#"><cfif i is pageFrom>#prePagingHTML#</cfif>#i#<cfif i is pageTo>#prePagingHTML#</cfif></a>
						<cfelse>
							<span class="current"><cfif i is pageFrom>#prePagingHTML#</cfif>#i#<cfif i is pageTo>#prePagingHTML#</cfif></span>
						</cfif>
					</cfoutput>
				</cfloop>
			</cfsavecontent>
			
			<cfif arguments.bShowPreviousFirst>
				<cfset pagingHTML = prevpagingArrowsHTML&pagingHTML&nextpagingArrowsHTML>				
			<cfelse>	
				<cfset pagingHTML = pagingHTML&prevpagingArrowsHTML&nextpagingArrowsHTML>				
			</cfif>

		</cfif>
		
		<cfreturn pagingHTML>		

	</cffunction>

	<cffunction name="parseAsBoolean" output="false">
		<!--- accept any simple type, return true if equal to 1 otherwise return false --->
		<cfargument name="boolInt" type="string" required="true" />
		<cfif boolInt IS 1>
			<cfreturn true>
		<cfelse>
			<cfreturn false>
		</cfif>
	</cffunction>

	<cffunction name="blogPaging" output="true" hint="Creates the paging links for blog">
		<cfargument name="currentPage" required="true" type="string">
		<cfargument name="maxRows" required="true" type="string">
		<cfargument name="totalRecs" required="true" type="string">
		<cfargument name="url" required="false" type="string" default="" />
		<cfargument name="urlHasParam" required="false" type="boolean" default=0 />
		<cfargument name="anchor" required="false" type="string" default="" />

		<cfset var pagingHTML = "">
		<cfset var prevpagingArrowsHTML = "">
		<cfset var nextpagingArrowsHTML = "">
		<cfset var pages = 0>
		<cfset var i = 0>

		<cfif totalRecs gt 0>
			<cfset pages = int(totalRecs/maxRows)>
			<cfif pages LT totalRecs/maxRows>
				<cfset pages = pages +1>
			</cfif>
	
			<cfset sDelimiter = '?'>
			<cfif arguments.urlHasParam>
				<cfset sDelimiter = '&amp;'>	
			</cfif>

			<cfif currentPage GT 1>
				<cfoutput><a href='#arguments.url##sDelimiter#currentPage=#currentPage-1##arguments.anchor#' class='prev'>&laquo; Newer Entries</a></cfoutput>				
			</cfif>
			<cfif currentPage LT pages>
				<cfoutput><a href='#arguments.url##sDelimiter#currentPage=#currentPage+1##arguments.anchor#' class='next'>Older Entries &raquo;</a></cfoutput>	
			</cfif>
		</cfif>	
	</cffunction>
	
	<cffunction name="getRelatedTypenames" output="false" hint="gets typename from related objects table" returntype="query">
		<cfargument name="table" required="true" type="string" />
		<cfargument name="lRelatedIDs" required="true" type="string" />
		
		<cfset var qResults = queryNew('data,typename') />
		
		<cfquery name="qTemp" datasource="#application.dsn#">
			SELECT data, typename
			FROM #arguments.table#_aRelatedIDs
			WHERE data IN (<cfqueryparam list="true" value="#arguments.lRelatedIDs#" />)
		</cfquery>
		
		<cfif qTemp.recordCount>
			<cfset qResults = qTemp />
		</cfif>
		
		<cfreturn qResults />
		
	</cffunction>

	<cffunction name="renderSmartPagination" output="true" hint="Creates the smart paging links" returntype="string">
		<cfargument name="currentPage" required="true" type="string">
		<cfargument name="itemsPerPage" required="true" type="string">
		<cfargument name="totalRecs" required="true" type="string">
		<cfargument name="url" required="true" type="string">
		<cfargument name="urlHasParam" required="false" type="boolean" default="0">
		<cfargument name="anchor" required="false" type="string" default="" />
		
		<cfset var maxPaging = totalRecs />			
		<cfset var pagingHTML = "">
		<cfset var pages = 0>
		<cfset var middleMaxPages = int(maxPaging/2)>
		<cfset var middleOffSet = int(maxPaging/2)>
		<cfset var pageFrom = 1>
		<cfset var pageTo = 1>	
		<cfset var sURLParam = '' />
		<cfset var sAnchor = arguments.anchor />
		<cfset var startrow = getStartRow(itemsPerPage) />
		<cfset var endrow = getEndRow(itemsPerPage,totalRecs) />		
		<cfif totalRecs gt 0>
			<cfset pages = int(totalRecs/itemsPerPage)>
			<cfif pages LT totalRecs/itemsPerPage>
				<cfset pages = pages +1>
			</cfif>
			
			<cfif middleMaxPages LT maxPaging/2>
				<cfset middleMaxPages = middleMaxPages+1>
			</cfif>		
			
			<cfif currentPage gt pages-middleOffSet>
				<cfset pageFrom = (pages-maxPaging)+1>
				<cfset pageTo = pages>			
			<cfelseif currentPage gt middleMaxPages>
				<cfset pageFrom = currentPage-middleOffSet>
				<cfset pageTo = currentPage+middleOffSet>
				<cfif pageTo GT pages>
					<cfset pageTo = pages>
				</cfif>
			<cfelse>
				<cfset pageFrom = 1>
				<cfset pageTo = maxPaging>			
			</cfif>
			
			<cfset sDelimiter = '?'>
			<cfif arguments.urlHasParam>
				<cfset sDelimiter = '&amp;'>	
			</cfif>
			
			<cfset sURLParam = '#arguments.url##sDelimiter#' />
	
			<!--- just in case pages are less than maxPaging --->		
			<cfif pageFrom lte 0>
				<cfset pageFrom = 1>
			</cfif>
			<cfif pageTo gt pages>
				<cfset pageTo = pages>
			</cfif>			

			<cfsavecontent variable="pagingHTML">
				<cfif currentPage EQ 1>
					<!--- If this is first page, pagination formation would be (1),2,3,4,5 (if there are 5 or more pages) --->
					<cfoutput>
						<span class="first"><span>First</span></span>
						<span class="prev"><span>Previous</span></span>
						<span class="current">#currentPage#</span>
					</cfoutput>
					
					<cfset tempPageFrom = currentPage + 1 />
					<cfset tempPageTo = currentPage + 4>
					
					<cfif tempPageFrom GT pageTo>
						<cfset tempPageFrom = pageTo />
					</cfif>
					<cfif tempPageTo GT pageTo>
						<cfset tempPageTo = pageTo />
					</cfif>
					
					<cfif tempPageFrom LTE tempPageTo AND tempPageTo NEQ 1>
						<cfloop from="#tempPageFrom#" to="#tempPageTo#" index="i">
							<cfoutput><a href="#sURLParam#currentPage=#i##sAnchor#">#i#</a></cfoutput>
						</cfloop>				
					</cfif>

					<cfif tempPageTo LT PageTo>
						<span class="more">...</span>	
					</cfif>
					
					<cfif PageTo GT 1>
						<cfoutput><a href="#sURLParam#currentPage=#currentPage + 1##sAnchor#" class="next"><span>Next</span></a></cfoutput>
					<cfelse>
						<cfoutput><span class="next"><span>Next</span></span></cfoutput>	
					</cfif>
					<cfif currentPage NEQ pageTo>
						<cfoutput><a href="#sURLParam#currentPage=#pageTo##sAnchor#" class="last"><span>Last</span></a></cfoutput>
					<cfelse>	
						<cfoutput><span class="last"><span>Last</span></span></cfoutput>
					</cfif>
	
				<cfelseif currentPage IS 2>
					<!--- If this is second page, pagination formation would be 1,(2),3,4,5 (if there are 5 or more pages) --->
					<cfoutput>
						<a href="#sURLParam#currentPage=1#sAnchor#" class="first"><span>First</span></a>
						<a href="#sURLParam#currentPage=#currentPage - 1##sAnchor#" class="prev"><span>Previous</span></a>	
						<a href="#sURLParam#currentPage=#currentPage - 1##sAnchor#">#currentPage - 1#</a>
						<span class="current">#currentPage#</span>
					</cfoutput>
					
					<cfset tempPageFrom = currentPage + 1 />
					<cfset tempPageTo = currentPage + 3>
					
					<cfif tempPageFrom GT pageTo>
						<cfset tempPageFrom = pageTo />
					</cfif>
					<cfif tempPageTo GT pageTo>
						<cfset tempPageTo = pageTo />
					</cfif>
	
					<cfif tempPageFrom LTE tempPageTo AND tempPageTo NEQ 2>
						<cfloop from="#tempPageFrom#" to="#tempPageTo#" index="i">
							<cfoutput><a href="#sURLParam#currentPage=#i##sAnchor#">#i#</a></cfoutput>
						</cfloop>				
					</cfif>				
	
					<cfif currentPage + 2 LT pageTo>
						<span class="more">...</span>	
					</cfif>
	
					<cfif currentPage + 1 LTE pageTo>
						<cfoutput><a href="#sURLParam#currentPage=#currentPage + 1##sAnchor#" class="next"><span>Next</span></a></cfoutput>
					<cfelse>
						<cfoutput><span class="next"><span>Next</span></span></cfoutput>
					</cfif>
					<cfif currentPage NEQ pageTo>
						<cfoutput><a href="#sURLParam#currentPage=#pageTo##sAnchor#" class="last"><span>Last</span></a></cfoutput>
					<cfelse>	
						<cfoutput><span class="last"><span>Last</span></span></cfoutput>
					</cfif>
				<cfelseif currentpage EQ pageTo - 1>
					<!--- If this is second last page, pagination formation would be 1,2,3,(4),5 (if there are 5 or more pages) --->
					
					<cfoutput>
						<a href="#sURLParam#currentPage=#1##sAnchor#" class="first"><span>First</span></a>
						<a href="#sURLParam#currentPage=#currentPage - 1##sAnchor#" class="prev"><span>Previous</span></a>
					</cfoutput>

					<cfif currentPage - 2 GT 2>
						<span class="more">...</span>	
					</cfif>
					
					<cfset tempPageFrom = currentPage - 3 />
					<cfset tempPageTo = currentPage - 1>
					
					<cfif tempPageFrom LTE 0>
						<cfset tempPageFrom = 1 />
					</cfif>
					<cfif tempPageTo LTE 0>
						<cfset tempPageTo = currentPage />
					</cfif>
	
					<cfif tempPageFrom NEQ tempPageTo>
						<cfloop from="#tempPageFrom#" to="#tempPageTo#" index="i">
							<cfoutput><a href="#sURLParam#currentPage=#i##sAnchor#">#i#</a></cfoutput>
						</cfloop>				
					</cfif>			
	
					<cfoutput>
						<span class="current">#currentPage#</span>
						<a href="#sURLParam#currentPage=#currentPage + 1##sAnchor#">#currentPage + 1#</a>
						<a href="#sURLParam#currentPage=#currentPage + 1##sAnchor#" class="next"><span>Next</span></a>
						<a href="#sURLParam#currentPage=#pageTo##sAnchor#" class="last"><span>Last</span></a>
					</cfoutput>		
										
				<cfelseif currentPage EQ pageTo>
					<!--- If this is last page, pagination formation would be 1,2,3,4,(5) (if there are 5 or more pages) --->
					
					<cfoutput>
						<a href="#sURLParam#currentPage=1#sAnchor#" class="first"><span>First</span></a>
						<a href="#sURLParam#currentPage=#currentPage - 1##sAnchor#" class="prev"><span>Previous</span></a>
					</cfoutput>
													
					<cfset tempPageFrom = currentPage - 4 />
					<cfset tempPageTo = currentPage - 1>
					
					<cfif tempPageFrom LTE 0>
						<cfset tempPageFrom = 1 />
					</cfif>
					<cfif tempPageTo LTE 0>
						<cfset tempPageTo = currentPage />
					</cfif>

					<cfif tempPageFrom NEQ 1>
						<span class="more">...</span>	
					</cfif>	
	
					<cfif tempPageFrom NEQ tempPageTo>
						<cfloop from="#tempPageFrom#" to="#tempPageTo#" index="i">
							<cfoutput><a href="#sURLParam#currentPage=#i##sAnchor#">#i#</a></cfoutput>
						</cfloop>				
					</cfif>
	
					<cfoutput>
						<span class="current">#currentPage#</span>
						<span class="next"><span>Next</span></span>
						<span class="last"><span>Last</span></span>
					</cfoutput>
	
				<cfelse>
					<cfoutput>
						<a href="#sURLParam#currentPage=1#sAnchor#" class="first"><span>First</span></a>
						<a href="#sURLParam#currentPage=#currentPage - 1##sAnchor#" class="prev"><span>Previous</span></a>
						<cfif currentPage - 2 GTE 2>
						<span class="more">...</span>	
						</cfif>
						<cfif currentPage - 2 GT 0><a href="#sURLParam#currentPage=#currentPage - 2##sAnchor#">#currentPage - 2#</a></cfif>
						<cfif currentPage - 1 GT 0><a href="#sURLParam#currentPage=#currentPage - 1##sAnchor#">#currentPage - 1#</a></cfif>
						<span class="current">#currentPage#</span>
						<cfif currentPage + 1 LTE pageTo><a href="#sURLParam#currentPage=#currentPage + 1##sAnchor#">#currentPage + 1#</a></cfif>
						<cfif currentPage + 2 LTE pageTo><a href="#sURLParam#currentPage=#currentPage + 2##sAnchor#">#currentPage + 2#</a></cfif>
						<cfif currentPage + 3 LTE pageTo>
							<span class="more">...</span>						
						</cfif>
						<a href="#sURLParam#currentPage=#currentPage + 1##sAnchor#" class="next"><span>Next</span></a>				
						<a href="#sURLParam#currentPage=#pageTo##sAnchor#" class="last"><span>Last</span></a>
					</cfoutput>
								
				</cfif>
				<cfoutput>
					<p class="pagination">Displaying #startrow#<cfif itemsPerPage GT 1>-#endrow#</cfif> of #totalRecs# results</p>
				</cfoutput>
			</cfsavecontent>

		</cfif>
		
		<cfreturn trim(pagingHTML)>		

	</cffunction>

	<cffunction name="getStartRow" returntype="numeric">
		<cfargument name="itemsPerPage" type="numeric">
		<cfset var startrow = (currentpage-1)*itemsPerPage+1>
		<cfreturn startrow>
	</cffunction>
	<cffunction name="getEndRow" returntype="numeric">
		<cfargument name="itemsPerPage" type="numeric">
		<cfargument name="totalRecs" type="numeric">
		<cfset endrow=getStartRow(itemsPerPage)+itemsPerPage-1>
		<cfif endrow gt totalRecs>
			<cfset endrow=totalRecs>
		</cfif>
		<cfreturn endrow />
	</cffunction>

</cfcomponent>