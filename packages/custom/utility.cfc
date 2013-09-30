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

	<cffunction name="renderSmartPagination" output="true" hint="Creates the smart paging links" returntype="struct">
		<cfargument name="currentPage" required="true" type="string">
		<cfargument name="itemsPerPage" required="true" type="string">
		<cfargument name="totalRecs" required="true" type="string">
		<cfargument name="url" required="true" type="string">
		<cfargument name="urlHasParam" required="false" type="boolean" default="0">
		<cfargument name="anchor" required="false" type="string" default="" />
		<cfargument name="labels" required="false" type="struct" default="#{prev="&##60;&##60;",next="&##62;&##62;"}#" />
		<cfargument name="enableAjax" required="false" type="boolean" default="0">

		<cfset var maxPaging = totalRecs />
		<cfset var pagingHTML = "">
		<cfset var pages = 0>
		<cfset var middleMaxPages = int(maxPaging/2)>
		<cfset var middleOffSet = int(maxPaging/2)>
		<cfset var pageFrom = 1>
		<cfset var pageTo = 1>
		<cfset var sURLParam = '' />
		<cfset var sAnchor = arguments.anchor />
		<cfset var startrow = getStartRow(itemsPerPage, arguments.currentPage) />
		<cfset var endrow = getEndRow(itemsPerPage,totalRecs, arguments.currentPage) />
		<cfset var stReturn = structNew() />

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

				<cfoutput><ul class="pagination <cfif arguments.enableAjax EQ 1>ajaxPagination</cfif>"></cfoutput>

				<cfif currentPage EQ 1>
					<!--- If this is first page, pagination formation would be (1),2,3 (if there are 3 or more pages) --->
					<cfoutput>
						<li class="prev unavailable"><span>#labels.prev#</span></li>
						<li class="current"><span>#currentPage#</span></li>
					</cfoutput>

					<cfset tempPageFrom = currentPage + 1 />
					<cfset tempPageTo = currentPage + 2>

					<cfif tempPageFrom GT pageTo>
						<cfset tempPageFrom = pageTo />
					</cfif>
					<cfif tempPageTo GT pageTo>
						<cfset tempPageTo = pageTo />
					</cfif>

					<cfif tempPageFrom LTE tempPageTo AND tempPageTo NEQ 1>
						<cfloop from="#tempPageFrom#" to="#tempPageTo#" index="i">
							<cfoutput><li><a href="#sURLParam#currentPage=#i##sAnchor#">#i#</a></li></cfoutput>
						</cfloop>
					</cfif>

					<cfif PageTo GT 1>
						<cfoutput><li class="next"><a href="#sURLParam#currentPage=#currentPage + 1##sAnchor#">#labels.next#</a></li></cfoutput>
					<cfelse>
						<cfoutput><li class="next unavailable"><span>&##62;</span></li></cfoutput>
					</cfif>

				<cfelseif currentPage IS 2>
					<!--- If this is second page, pagination formation would be 1,(2),3 (if there are 3 or more pages) --->
					<cfoutput>
						<li class="prev"><a href="#sURLParam#currentPage=#currentPage - 1##sAnchor#">#labels.prev#</a></li>
						<li><a href="#sURLParam#currentPage=#currentPage - 1##sAnchor#">#currentPage - 1#</a></li>
						<li class="current"><span>#currentPage#</span></li>
					</cfoutput>

					<cfset tempPageFrom = currentPage + 1 />
					<cfset tempPageTo = currentPage + 1>

					<cfif tempPageFrom GT pageTo>
						<cfset tempPageFrom = pageTo />
					</cfif>
					<cfif tempPageTo GT pageTo>
						<cfset tempPageTo = pageTo />
					</cfif>

					<cfif tempPageFrom LTE tempPageTo AND tempPageTo NEQ 2>
						<cfloop from="#tempPageFrom#" to="#tempPageTo#" index="i">
							<cfoutput><li><a href="#sURLParam#currentPage=#i##sAnchor#">#i#</a></li></cfoutput>
						</cfloop>
					</cfif>

					<cfif currentPage + 1 LTE pageTo>
						<cfoutput><li class="next"><a href="#sURLParam#currentPage=#currentPage + 1##sAnchor#">#labels.next#</a></li></cfoutput>
					<cfelse>
						<cfoutput><li class="next unavailable"><span>#labels.next#</span></li></cfoutput>
					</cfif>
				<cfelseif currentpage EQ pageTo - 1>
					<!--- If this is second last page, pagination formation would be 3,(4),5 (if there are 3 or more pages) --->

					<cfoutput>
						<li class="prev"><a href="#sURLParam#currentPage=#currentPage - 1##sAnchor#">#labels.prev#</a></li>
					</cfoutput>

					<cfset tempPageFrom = currentPage - 1 />
					<cfset tempPageTo = currentPage - 1 >

					<cfif tempPageFrom LTE 0>
						<cfset tempPageFrom = 1 />
					</cfif>
					<cfif tempPageTo LTE 0>
						<cfset tempPageTo = currentPage />
					</cfif>

					<cfloop from="#tempPageFrom#" to="#tempPageTo#" index="i">
						<cfoutput><li><a href="#sURLParam#currentPage=#i##sAnchor#">#i#</a></li></cfoutput>
					</cfloop>

					<cfoutput>
						<li class="current"><span>#currentPage#</span></li>
						<li><a href="#sURLParam#currentPage=#currentPage + 1##sAnchor#">#currentPage + 1#</a></li>
						<li class="next"><a href="#sURLParam#currentPage=#currentPage + 1##sAnchor#">#labels.next#</a></li>
					</cfoutput>

				<cfelseif currentPage EQ pageTo>
					<!--- If this is last page, pagination formation would be 1,2,(3) (if there are 3 or more pages) --->

					<cfoutput>
						<li class="prev"><a href="#sURLParam#currentPage=#currentPage - 1##sAnchor#">#labels.prev#</a></li>
					</cfoutput>

					<cfset tempPageFrom = currentPage - 2 />
					<cfset tempPageTo = currentPage - 1>

					<cfif tempPageFrom LTE 0>
						<cfset tempPageFrom = 1 />
					</cfif>
					<cfif tempPageTo LTE 0>
						<cfset tempPageTo = currentPage />
					</cfif>

					<cfif tempPageFrom NEQ tempPageTo>
						<cfloop from="#tempPageFrom#" to="#tempPageTo#" index="i">
							<cfoutput><li><a href="#sURLParam#currentPage=#i##sAnchor#">#i#</a></li></cfoutput>
						</cfloop>
					</cfif>

					<cfoutput>
						<li class="current"><span>#currentPage#</span></li>
						<li class="next unavailable"><span>#labels.next#</span></li>
					</cfoutput>

				<cfelse>
					<cfoutput>
						<li class="prev"><a href="#sURLParam#currentPage=#currentPage - 1##sAnchor#">#labels.prev#</a></li>
						<cfif currentPage - 1 GT 0><li><a href="#sURLParam#currentPage=#currentPage - 1##sAnchor#">#currentPage - 1#</a></li></cfif>
						<li class="current"><span>#currentPage#</span></li>
						<cfif currentPage + 1 LTE pageTo><li><a href="#sURLParam#currentPage=#currentPage + 1##sAnchor#">#currentPage + 1#</a></li></cfif>
						<li class="next"><a href="#sURLParam#currentPage=#currentPage + 1##sAnchor#">#labels.next#</a></li>
					</cfoutput>
				</cfif>

				<cfoutput></ul></cfoutput>
			</cfsavecontent>

			<cfsavecontent variable="paginationHTML">
				<cfoutput>
					<p class="pagination-text">Displaying <span class="criteria">#startrow#</span><cfif itemsPerPage GT 1><span class="criteria">- #endrow#</span></cfif> of <span class="criteria">#totalRecs#</span> results</p>
				</cfoutput>
			</cfsavecontent>
		</cfif>

		<cfif len(pagingHTML) AND len(paginationHTML) >
			<cfset stReturn.pagingHTML = trim(pagingHTML) />
			<cfset stReturn.paginationHTML = trim(paginationHTML) />
		<cfelse>
			<cfset stReturn.pagingHTML = "" />
			<cfset stReturn.paginationHTML = "" />
		</cfif>

		<cfreturn stReturn>
	</cffunction>

	<cffunction name="getStartRow" returntype="numeric">
		<cfargument name="itemsPerPage" type="numeric">
		<cfargument name="currentPage" type="numeric">
		<cfset var startrow = (arguments.currentPage-1)*itemsPerPage+1>
		<cfreturn startrow>
	</cffunction>
	<cffunction name="getEndRow" returntype="numeric">
		<cfargument name="itemsPerPage" type="numeric">
		<cfargument name="totalRecs" type="numeric">
		<cfargument name="currentPage" type="numeric">
		<cfset endrow=getStartRow(itemsPerPage, arguments.currentPage)+itemsPerPage-1>
		<cfif endrow gt totalRecs>
			<cfset endrow=totalRecs>
		</cfif>
		<cfreturn endrow />
	</cffunction>

  <cffunction name="ISOToDateTime" access="public" returntype="string" output="false" hint="Converts an ISO 8601 date/time stamp with optional dashes to a ColdFusion date/time stamp.">

    <!--- Define arguments. --->
    <cfargument
      name="Date"
      type="string"
      required="true"
      hint="ISO 8601 date/time stamp."
      />

    <!---
      When returning the converted date/time stamp,
      allow for optional dashes.
    --->
    <cfreturn ARGUMENTS.Date.ReplaceFirst(
      "^.*?(\d{4})-?(\d{2})-?(\d{2})T([\d:]+).*$",
      "$1-$2-$3 $4"
      ) />
  </cffunction>

  <cffunction name="cfDateToISODate" access="public" returntype="string" output="false" hint="Converts a ColdFusion date/time stamp to ISO 8601 date/time stamp.">

    <!--- Define arguments. --->
    <cfargument name="Date" type="string" required="true" hint="ISO 8601 date/time stamp." />

    <!---
      When returning the converted date/time stamp,
      allow for optional dashes.
    --->
    <cfreturn "#dateFormat(arguments.date,"yyyy-mm-dd")#T#timeFormat(arguments.date,"HH:mm")#:00"/>
  </cffunction>

  <cffunction name="trueFalseFormat" returntype="String">
    <cfargument name="booleanValue" type="boolean" required="true" />
    <cfscript>
      var trueString="true";
      var falseString="false";
      return arguments.booleanValue ? trueString : falseString;
    </cfscript>
  </cffunction>

  <cffunction name="renderMorePagination" output="true" hint="Creates the smart paging links" returntype="struct">
    <cfargument name="currentPage" required="true" type="string">
    <cfargument name="itemsPerPage" required="true" type="string">
    <cfargument name="totalRecs" required="true" type="string">
    <cfargument name="url" required="true" type="string">
    <cfargument name="urlHasParam" required="false" type="boolean" default="0">
    <cfargument name="anchor" required="false" type="string" default="" />
    <cfargument name="labels" required="false" type="struct" default="#{prev="&##60;&##60;",next="&##62;&##62;"}#" />
    <cfargument name="enableAjax" required="false" type="boolean" default="0">


    <cfset var maxPaging = totalRecs />
    <cfset var pagingHTML = "">
    <cfset var pages = 0>
    <cfset var middleMaxPages = int(maxPaging/2)>
    <cfset var middleOffSet = int(maxPaging/2)>
    <cfset var pageFrom = 1>
    <cfset var pageTo = 1>
    <cfset var sURLParam = '' />
    <cfset var sAnchor = arguments.anchor />
    <cfset var startrow = getStartRow(itemsPerPage, arguments.currentPage) />
    <cfset var endrow = getEndRow(itemsPerPage,totalRecs, arguments.currentPage) />
    <cfset var stReturn = structNew() />

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
          <cfoutput>

          <Cfif currentPage EQ pageTo>

          <cfelse>
          <div class="morePagination <cfif arguments.enableAjax EQ 1>ajaxPagination</cfif> " >
            <a href="#sURLParam#currentPage=#currentPage+1##sAnchor#">
              <div class="diamondPosition">
                <div class="diamond">
                  <i class="icon-plus"></i>
                </div>
              </div>
            </a>
          </div>
          </Cfif>
          </cfoutput>
       </cfsavecontent>
      <cfsavecontent variable="paginationHTML">
        <cfoutput>
          <p class="pagination-text">Displaying <span class="criteria">#startrow#</span><cfif itemsPerPage GT 1><span class="criteria">- #endrow#</span></cfif> of <span class="criteria">#totalRecs#</span> results</p>
        </cfoutput>
      </cfsavecontent>
    </cfif>

    <cfif len(pagingHTML) AND len(paginationHTML) >
      <cfset stReturn.pagingHTML = trim(pagingHTML) />
      <cfset stReturn.paginationHTML = trim(paginationHTML) />
    <cfelse>
      <cfset stReturn.pagingHTML = "" />
      <cfset stReturn.paginationHTML = "" />
    </cfif>

    <cfreturn stReturn>
  </cffunction>

  <cffunction name="setPaginatorValues" access="public" returntype="struct" output="false">
      <cfargument name="currentPage" type="numeric" required="true" />
      <cfargument name="numItems" type="numeric" required="true" />
      <cfargument name="objectId" type="string" required="true" />
      <cfargument name="ruleId" type="string" required="true" />
      <cfargument name="iTotal" type="numeric" required="true" />
      <cfset var stReturn = structNew() />

      <cfif arguments.currentPage GT 1 AND arguments.objectId eq arguments.ruleId>
          <cfset stReturn.currentPage = arguments.currentPage />
          <cfset stReturn.startRow = (arguments.currentPage -1) * numItems + 1 />
      <cfelse>
          <cfset stReturn.currentPage = 1 />
          <cfset stReturn.startRow = 1 />
      </cfif>


      <cfset stReturn.endRow = stReturn.startRow + arguments.numItems - 1 />

      <cfif stReturn.endRow GT arguments.iTotal>
          <cfset stReturn.endRow = arguments.iTotal />
      </cfif>
      <cfset stReturn.iTotal = arguments.iTotal />

      <cfreturn stReturn />
  </cffunction>

  <cffunction name="isMobileDevice" returntype="boolean">
  	<cfset var bReturn = false />

  	<cfif reFindNoCase("(android|bb\d+|meego).+mobile|avantgo|bada\/|blackberry|blazer|compal|elaine|fennec|hiptop|iemobile|ip(hone|od)|iris|kindle|lge |maemo|midp|mmp|mobile.+firefox|netfront|opera m(ob|in)i|palm( os)?|phone|p(ixi|re)\/|plucker|pocket|psp|series(4|6)0|symbian|treo|up\.(browser|link)|vodafone|wap|windows (ce|phone)|xda|xiino",CGI.HTTP_USER_AGENT) GT 0 OR reFindNoCase("1207|6310|6590|3gso|4thp|50[1-6]i|770s|802s|a wa|abac|ac(er|oo|s\-)|ai(ko|rn)|al(av|ca|co)|amoi|an(ex|ny|yw)|aptu|ar(ch|go)|as(te|us)|attw|au(di|\-m|r |s )|avan|be(ck|ll|nq)|bi(lb|rd)|bl(ac|az)|br(e|v)w|bumb|bw\-(n|u)|c55\/|capi|ccwa|cdm\-|cell|chtm|cldc|cmd\-|co(mp|nd)|craw|da(it|ll|ng)|dbte|dc\-s|devi|dica|dmob|do(c|p)o|ds(12|\-d)|el(49|ai)|em(l2|ul)|er(ic|k0)|esl8|ez([4-7]0|os|wa|ze)|fetc|fly(\-|_)|g1 u|g560|gene|gf\-5|g\-mo|go(\.w|od)|gr(ad|un)|haie|hcit|hd\-(m|p|t)|hei\-|hi(pt|ta)|hp( i|ip)|hs\-c|ht(c(\-| |_|a|g|p|s|t)|tp)|hu(aw|tc)|i\-(20|go|ma)|i230|iac( |\-|\/)|ibro|idea|ig01|ikom|im1k|inno|ipaq|iris|ja(t|v)a|jbro|jemu|jigs|kddi|keji|kgt( |\/)|klon|kpt |kwc\-|kyo(c|k)|le(no|xi)|lg( g|\/(k|l|u)|50|54|\-[a-w])|libw|lynx|m1\-w|m3ga|m50\/|ma(te|ui|xo)|mc(01|21|ca)|m\-cr|me(rc|ri)|mi(o8|oa|ts)|mmef|mo(01|02|bi|de|do|t(\-| |o|v)|zz)|mt(50|p1|v )|mwbp|mywa|n10[0-2]|n20[2-3]|n30(0|2)|n50(0|2|5)|n7(0(0|1)|10)|ne((c|m)\-|on|tf|wf|wg|wt)|nok(6|i)|nzph|o2im|op(ti|wv)|oran|owg1|p800|pan(a|d|t)|pdxg|pg(13|\-([1-8]|c))|phil|pire|pl(ay|uc)|pn\-2|po(ck|rt|se)|prox|psio|pt\-g|qa\-a|qc(07|12|21|32|60|\-[2-7]|i\-)|qtek|r380|r600|raks|rim9|ro(ve|zo)|s55\/|sa(ge|ma|mm|ms|ny|va)|sc(01|h\-|oo|p\-)|sdk\/|se(c(\-|0|1)|47|mc|nd|ri)|sgh\-|shar|sie(\-|m)|sk\-0|sl(45|id)|sm(al|ar|b3|it|t5)|so(ft|ny)|sp(01|h\-|v\-|v )|sy(01|mb)|t2(18|50)|t6(00|10|18)|ta(gt|lk)|tcl\-|tdg\-|tel(i|m)|tim\-|t\-mo|to(pl|sh)|ts(70|m\-|m3|m5)|tx\-9|up(\.b|g1|si)|utst|v400|v750|veri|vi(rg|te)|vk(40|5[0-3]|\-v)|vm40|voda|vulc|vx(52|53|60|61|70|80|81|83|85|98)|w3c(\-| )|webc|whit|wi(g |nc|nw)|wmlb|wonu|x700|yas\-|your|zeto|zte\-",Left(CGI.HTTP_USER_AGENT,4)) GT 0>
  		<cfset bReturn = true />
  	</cfif>

  	<cfreturn bReturn />
  </cffunction>

</cfcomponent>
