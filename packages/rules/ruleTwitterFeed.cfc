<!--- @@Copyright: Daemon Pty Limited 2002-2008, http://www.daemon.com.au --->
<!--- @@License:
    This file is part of FarCry CMS Plugin.

    FarCry CMS Plugin is free software: you can redistribute it and/or modify
    it under the terms of the GNU Lesser General Public License as published by
    the Free Software Foundation, either version 3 of the License, or
    (at your option) any later version.

    FarCry CMS Plugin is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
    GNU Lesser General Public License for more details.

    You should have received a copy of the GNU Lesser General Public License
    along with FarCry CMS Plugin.  If not, see <http://www.gnu.org/licenses/>.
--->

<!--- 
|| DESCRIPTION || 
$Description: 
News rule publishes news content items in date order, with 
most recently published first.  News content is only visible 
if it is a) approved content; b) time is past the publish date; 
c) time is before the expriy date, and; d) it matches the nominated 
categories.
$

|| DEVELOPER ||
$Developer: Geoff Bowers (modius@daemon.com.au) $
--->
<cfcomponent displayname="Utility: Twitter Feed" extends="farcry.core.packages.rules.rules" hint="Publish latest twitter feed" bObjectBroker="true">
		
	<cfproperty ftSeq="1" ftFieldset="Rule Options" name="title" type="nstring" hint="Title of object" required="no" default="" ftLabel="Heading" bLabel=1 />
	<cfproperty ftSeq="2" ftFieldset="Rule Option" name="intro" type="longchar" hint="Intro text for paginated content. Can be any combination of content and HTML markup." required="false" default="" ftLabel="Intro Text" ftHint="This content will appear above the paginated content." />
	<cfproperty ftSeq="3" ftFieldset="Rule Option" name="displayMethod" type="string" hint="Display teaser method to render individual content items." required="true" default="displayTeaserStandard" ftType="webskin" fttypename="rulePaginatorAnimateByTwitterFeed" ftprefix="displayTeaser" ftLabel="Display Method" ftHint="This determines how each of your content will render." />

	<cfproperty ftSeq="10" ftFieldset="Twitter Details" name="twitterAccount" type="string" hint="Twitter Account Name" required="false" default="" ftvalidation="required" ftLabel="Twitter Account Name" />
	<cfproperty ftSeq="11" ftFieldset="Twitter Details" name="twitterRSS" type="string" hint="URL to Twitter RSS Feed" required="false" default="" ftvalidation="required" ftLabel="Twitter RSS URL" />
	<cfproperty ftSeq="12" ftFieldset="Twitter Details" name="numTwitterFeeds" type="numeric" hint="URL to Twitter RSS Feed" required="false" default=6 ftType="numeric" ftIncludeDecimal="false" ftvalidation="validate-digits" ftDefault=6 ftLabel="## of twitter feeds to retrieve" />

</cfcomponent>