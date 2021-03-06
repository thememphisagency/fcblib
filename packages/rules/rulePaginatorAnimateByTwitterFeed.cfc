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
<cfcomponent displayname="Paginator: Animated By Twitter Feed" extends="farcry.core.packages.rules.rules" 
	hint="Publish latest twitter feed in a rotator with pagination." bObjectBroker="true">

	<cfproperty ftSeq="1" ftFieldset="General" name="intro" type="longchar" hint="Intro text for paginated content. Can be any combination of content and HTML markup." required="false" default="" ftLabel="Intro Text" ftHint="This content will appear above the paginated content." />
	<cfproperty ftSeq="2" ftFieldset="General" name="displayMethod" type="string" hint="Display teaser method to render individual content items." required="true" default="displayTeaserStandard" ftType="webskin" fttypename="rulePaginatorAnimateByTwitterFeed" ftprefix="displayTeaser" ftLabel="Display Method" ftHint="This determines how each of your content will render." />

	<cfproperty ftSeq="3" ftFieldset="Twitter Details" name="twitterAccount" type="string" hint="Twitter Account Name" required="false" default="" ftvalidation="required" ftLabel="Twitter Account Name" />
	<cfproperty ftSeq="4" ftFieldset="Twitter Details" name="twitterRSS" type="string" hint="URL to Twitter RSS Feed" required="false" default="" ftvalidation="required" ftLabel="Twitter RSS URL" />
	<cfproperty ftSeq="5" ftFieldset="Twitter Details" name="numTwitterFeeds" type="numeric" hint="URL to Twitter RSS Feed" required="false" default=6 ftType="numeric" ftIncludeDecimal="false" ftvalidation="validate-digits" ftDefault=6 ftLabel="## of twitter feeds to retrieve" />

	<cfproperty ftSeq="6" ftFieldSet="Rotator Details" name="sliderDirection" ftlabel="Sliding Direction" hint="The direction of the slider. For horizonal sliding, only one item can be displayed at a time." type="string" fttype="list" ftlist="horizontal:Horizonal,vertical:Vertical" ftSelectMultiple="false" trendertype="dropdown" required="false" default="" ftvalidation="required" />
	<cfproperty ftSeq="7" ftFieldSet="Rotator Details" name="sliderSpeed" ftlabel="Slider Speed" hint="Slider speed." type="string" fttype="list" ftlist="2:Slow,1.5:Normal,1:Fast" ftSelectMultiple="false" trendertype="dropdown" required="false" default="" />
	<cfproperty ftSeq="8" ftFieldset="Rotator Details" name="bAutoScroll" type="boolean" hint="Start Auto Scrolling" required="false" default="0" ftType="boolean" ftLabel="Auto Scroll?" ftHint="Automatically start scrolling to the each article." />
	<cfproperty ftSeq="9" ftFieldset="Rotator Details" name="scrollInterval" type="numeric" hint="Rotator scrolling interval" required="false" default=3 fttype="list" ftlist="3:3,4:4,5:5,6:6,7:7,8:8,9:9,10:10" ftSelectMultiple="false" trendertype="dropdown" ftLabel="Scrolling Interval" ftHint="Auto scroll to the next article, default interval is every 3 seconds." />

	<cfproperty ftSeq="10" ftFieldset="Results" name="numItems" type="numeric" hint="The number of items to display per page." required="false" default="5" ftType="numeric" ftIncludeDecimal="false" ftvalidation="validate-digits" ftLabel="## items per page" />
	<cfproperty ftSeq="11" ftFieldset="Results" name="bArchive" type="boolean" hint="Displays with a paginated display." required="false" default="1" ftType="boolean" ftLabel="Paginate?" ftHint="Selecting NOT to paginate will only show the first page of results." />

</cfcomponent>