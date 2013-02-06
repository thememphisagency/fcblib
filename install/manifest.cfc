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
<cfcomponent extends="farcry.core.webtop.install.manifest" name="manifest">

	<!--- IMPORT TAG LIBRARIES --->
	<cfimport taglib="/farcry/core/packages/fourq/tags/" prefix="q4">
	
	
	<cfset this.name = "Fcb Lib" />
	<cfset this.description = "Fcb Lib (Farcry in a Box Library) is a library of common tags and components required in every Farcry in a Box installation e.g Google Analytics, Web 2.0 Footer and FCB Nav" />
	<cfset this.lRequiredPlugins = "" />
	<cfset addSupportedCore(majorVersion="5", minorVersion="1", patchVersion="6") />

	<cffunction name="install">
		
		<cfset var result = "done" />
		
		
		
		<cfreturn result />
	</cffunction>	

</cfcomponent>

