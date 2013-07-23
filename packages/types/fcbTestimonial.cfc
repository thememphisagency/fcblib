<!--- @@displayname: Testimonial Content Type --->
<!--- @@Description: Record Testimonials --->
<!--- @@Developer: Sandy Trinh --->
<cfcomponent extends="farcry.plugins.fcblib.packages.types.fcbVersions" displayname="Testimonial" hint="A little snippet of testimonial information including a label, testimonial text, name and postion" bObjectBroker="true" bPaginatorAnimateByTypeRule="1" bFriendly="true" fuAlias="testimonials">

    <cfproperty ftseq="1" ftfieldset="Testimonial Details" bCleanHTML="1" name="title" type="string" ftType="string" bLabel="true" hint="Meaningful reference title" required="yes" default="" ftLabel="Label" ftvalidation="required" />
    <cfproperty ftseq="2" ftfieldset="Testimonial Details" bCleanHTML="1" name="fullName" type="string" ftType="string" hint="Full name of the person writng the testimonial" required="yes" default="" ftLabel="Name" ftvalidation="required" />
    <cfproperty ftseq="3" ftfieldset="Testimonial Details" bCleanHTML="1" name="position" type="string" ftType="string" hint="The persons title" required="no" default="" ftLabel="Position" />
    <cfproperty ftseq="4" ftfieldset="Testimonial Details" bCleanHTML="1" name="companyName" type="string" ftType="string" hint="Company name" required="no" default="" ftLabel="Company Name"  />
    <cfproperty ftseq="5" ftfieldset="Testimonial Details" bCleanHTML="1" name="location" type="string" ftType="string" hint="The persons location" required="no" default="" ftLabel="Location"  />
    <cfproperty ftSeq="6" ftFieldset="Teaser" bCleanHTML="1" name="Teaser" type="longchar" ftLabel="Teaser" ftType="longchar" hint="Teaser text." required="no" default="" ftAutoResize="true">
    <cfproperty ftseq="7" ftfieldset="Teaser" name="teaserImage" type="uuid" hint="Image to display" required="no" default="" fttype="uuid" ftjoin="dmImage" ftlabel="Image" />
    <cfproperty ftSeq="8" ftFieldset="Teaser" name="readMoreText" ftlabel="Read More Text" type="nstring" hint="Display text for read more link for object teasers" required="no" default="Read more">

    <cfproperty ftseq="8" ftfieldset="Body Content" bCleanHTML="1" name="body" type="longchar" ftType="richtext" hint="Main body of content." required="no" default=""
        ftLabel="Body" ftImageArrayField="aObjectIDs" ftImageTypename="dmImage" ftImageField="StandardImage"
        ftTemplateTypeList="dmImage,dmFile,dmNavigation" ftTemplateWebskinPrefixList="insertHTML"
        ftLinkListFilterRelatedTypenames="dmFile,dmImage,dmNavigation"
        ftTemplateSnippetWebskinPrefix="insertSnippet" />

    <cfproperty ftseq="9" ftfieldset="Relationships" name="aObjectIDs" type="array" hint="Related media items for this content item." required="no" default=""
        ftLabel="Associated Media" ftType="array" ftJoin="dmImage,dmFile"
        ftShowLibraryLink="false" ftAllowAttach="true" ftAllowAdd="true" ftAllowEdit="true" ftRemoveType="detach"
        bSyncStatus="true">

    <cfproperty ftseq="10" ftfieldset="Categorisation" name="catFacts" type="longchar" hint="Fact categorisation." required="no" default="" fttype="category" ftalias="fcbTestimonial" ftlabel="Category" />

</cfcomponent>
