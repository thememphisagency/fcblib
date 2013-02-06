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

<!--- @@displayname: Testimonial Content Type --->
<!--- @@Description: Records Testimonials . --->
<!--- @@Developer: Jon Low --->
<cfcomponent extends="farcry.plugins.fcblib.packages.types.fcbVersions" displayname="Testimonial" hint="A little snippet of testimonial information including a label, testimonial text, name and postion" bSchedule="false" bObjectBroker="true" bPaginatorAnimateByTypeRule="1">
<!------------------------------------------------------------------------
type properties
------------------------------------------------------------------------->
<cfproperty ftseq="1" ftfieldset="Testimonial Details" bCleanHTML="1" name="label" type="string" bLabel="true" hint="Meaningful reference title" required="yes" default="" ftLabel="Label" ftvalidation="required" />
<cfproperty ftseq="2" ftfieldset="Testimonial Details" bCleanHTML="1" name="body" type="longchar" hint="Content of the Testimonial." required="No" default="" ftLabel="Body" ftType="longchar" />
<cfproperty ftseq="3" ftfieldset="Testimonial Details" bCleanHTML="1" name="FullName" type="string" hint="Full name of the person writng the testimonial" required="yes" default="" ftLabel="Name" ftvalidation="required" />
<cfproperty ftseq="4" ftfieldset="Testimonial Details" bCleanHTML="1" name="Position" type="string" hint="The persons title" required="no" default="" ftLabel="Position" />
<cfproperty ftseq="5" ftfieldset="Testimonial Details" bCleanHTML="1" name="Location" type="string" hint="The persons location" required="no" default="" ftLabel="Location"  />
<cfproperty ftseq="6" ftfieldset="Testimonial Details" name="teaserImage" type="uuid" hint="Image to display" required="no" default="" fttype="uuid" ftjoin="dmImage" ftlabel="Image" />
<cfproperty ftseq="7" ftfieldset="Categorisation" name="catFacts" type="longchar" hint="Fact categorisation." required="no" default="" fttype="category" ftalias="fcbTestimonial" ftlabel="Category" />

</cfcomponent>