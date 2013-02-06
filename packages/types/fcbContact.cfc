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

<!--- @@displayname: Contact Details Type --->
<!--- @@Description: Records Contact Info . --->
<!--- @@Developer: Sandy Trinh --->

<cfcomponent extends="farcry.plugins.fcblib.packages.types.fcbVersions" displayname="Contact" hint="A little snippet of contact information including an location address, postal address, phone, fax, email, opening hours etc." bSchedule="false" bObjectBroker="true" bPaginatorAnimateByTypeRule="1">
	<!------------------------------------------------------------------------
	type properties
	------------------------------------------------------------------------->
	<cfproperty ftWizardStep="Details" ftseq="1" ftfieldset="Contact Label" bCleanHTML="1" name="label" type="string" bLabel="true" hint="Meaningful reference title" required="yes" default="" ftLabel="Label" ftvalidation="required" />
	<cfproperty ftWizardStep="Details" ftseq="2" ftfieldset="Contact Label" bCleanHTML="1" name="subLabel" type="string" hint="Contact Details sub label" required="no" default="" ftLabel="Sub Label" />

	<cfproperty ftWizardStep="Details" ftseq="3" ftfieldset="Head Office" name="bHeadOffice" type="boolean" hint="Check if head office" required="no" default="0" ftType="boolean" ftRenderType="checkbox" ftLabel="Yes" />
	
	<cfproperty ftWizardStep="Details" ftseq="4" ftfieldset="Location Address" bCleanHTML="1" name="locationStreet1" type="string" required="no" default="" ftLabel="Street 1" ftHint="Unit, apartment number" />
	<cfproperty ftWizardStep="Details" ftseq="5" ftfieldset="Location Address" bCleanHTML="1" name="locationStreet2" type="string" required="no" default="" ftLabel="Street 2" ftHint="Street number and street address"/>
	<cfproperty ftWizardStep="Details" ftseq="6" ftfieldset="Location Address" name="locationSuburb" type="string" required="no" default="" ftLabel="Suburb" />
	<cfproperty ftWizardStep="Details" ftseq="7" ftfieldset="Location Address"  name="locationState" type="string" ftList=":select,ACT:ACT,NSW:NSW,NT:NT,QLD:QLD,SA:SA,TAS:TAS,VIC:VIC,WA:WA" ftType="list" required="false" default="" ftLabel="State" />
	<cfproperty ftWizardStep="Details" ftseq="8" ftfieldset="Location Address" name="locationPostcode" type="string" required="no" default="" ftLabel="Postcode" />
	<cfproperty ftWizardStep="Details" ftseq="9" ftfieldset="Location Address" name="locationCountry" type="string" required="no" default="" ftLabel="Country" />
	
	<cfproperty ftWizardStep="Details" ftseq="10" ftfieldset="Postal Address" bCleanHTML="1" name="postalStreet1" type="string" required="no" default="" ftLabel="Street 1" />
	<cfproperty ftWizardStep="Details" ftseq="11" ftfieldset="Postal Address" bCleanHTML="1" name="postalStreet2" type="string" required="no" default="" ftLabel="Street 2" />
	<cfproperty ftWizardStep="Details" ftseq="12" ftfieldset="Postal Address" name="postalSuburb" type="string" required="no" default="" ftLabel="Suburb" />
	<cfproperty ftWizardStep="Details" ftseq="13" ftfieldset="Postal Address" name="postalState" type="string" required="no" default="" ftLabel="State" />
	<cfproperty ftWizardStep="Details" ftseq="14" ftfieldset="Postal Address" name="postalPostcode" type="string" required="no" default="" ftLabel="Postcode" />
	<cfproperty ftWizardStep="Details" ftseq="15" ftfieldset="Postal Address" name="postalCountry" type="string" required="no" default="" ftLabel="Country" />
	
	<cfproperty ftWizardStep="Details" ftseq="16" ftfieldset="Contact Details" name="email" type="string" required="no" default="" ftLabel="Email" ftvalidation="required,validate-email" />
	<cfproperty ftWizardStep="Details" ftseq="17" ftfieldset="Contact Details" name="phone" type="string" required="no" default="" ftLabel="Phone" ftvalidation="required" />
	<cfproperty ftWizardStep="Details" ftseq="18" ftfieldset="Contact Details" name="fax" type="string" required="no" default="" ftLabel="Fax" />
	
	<cfproperty ftWizardStep="Details" ftseq="19" ftfieldset="Opening Times" name="officeHours" type="string" required="no" default="" ftLabel="Office Hours" />
	<cfproperty ftWizardStep="Details" ftseq="20" ftfieldset="Opening Times" name="freightHours" type="string" required="no" default="" ftLabel="Freight Hours" />
	<cfproperty ftWizardStep="Details" ftseq="21" ftfieldset="Opening Times" bCleanHTML="1" name="note" type="longchar" required="no" default="" ftLabel="Note" />

	<cfproperty ftWizardStep="Details" ftseq="22" ftfieldset="Show google map?" name="bShowMap" type="boolean" required="no" default="0" ftType="boolean" ftRenderType="checkbox" ftLabel="Yes" />

	<!--- Need all properties below in order to work OK! --->
	<cfproperty ftWizardStep="Mapping Location" ftseq="50" ftfieldset="Eatery Map" ftlabel="Mapping Location" name="geoLat" type="string" required="no" default="" ftEditMethod="showMap" />
	<cfproperty name="geoLong" type="string" required="no" default="" />
	<cfproperty name="bGeo" type="boolean" required="no" default="0" />
	
	<cffunction name="showMap" returntype="string">
		<cfargument name="typename" required="true" type="string" hint="The name of the type that this field is part of.">
		<cfargument name="stObject" required="true" type="struct" hint="The object of the record that this field is part of.">
		<cfargument name="stMetadata" required="true" type="struct" hint="This is the metadata that is either setup as part of the type.cfc or overridden when calling ft:object by using the stMetadata argument.">
		<cfargument name="fieldname" required="true" type="string" hint="This is the name that will be used for the form field. It includes the prefix that will be used by ft:processform.">
		<cfargument name="stPackage" required="true" type="struct" hint="Data type details" />
		
		<cfset var sHTML = '' />
		<cfset var sAddress = '#arguments.stObject.locationStreet2# #arguments.stObject.locationSuburb# #arguments.stObject.locationState# #arguments.stObject.locationPostcode# #arguments.stObject.locationCountry#' />
		<cfset var sPrefix = 'fc' & replaceNoCase(arguments.stObject.objectid, '-', '', 'all') />
		<cfset var oLocator = request.fcbObjectBucket.create(fullPath='farcry.plugins.fcblib.packages.custom.gpsLoc') />		
		<cfset sHTML = oLocator.showLocator(ftPrefix=sPrefix,latitude=arguments.stObject.geoLat,longitude=arguments.stObject.geoLong,address=sAddress,bGeo=arguments.stObject.bGeo) />

		<cfreturn sHTML />			
	</cffunction>
	
</cfcomponent>