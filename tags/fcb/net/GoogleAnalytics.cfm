<cfsetting enablecfoutputonly="yes" />

<cfif structKeyExists(application.config,"googleAnalytics") AND len(application.config.googleAnalytics.keyid) AND application.config.googleAnalytics.bActive EQ '1'>
			
	<cfoutput>	
	<!-- Google Analytics Tracking Code - Asyn style, that's how we roll! -->
	<script>
		var _gaq = _gaq || [];
		_gaq.push(['_setAccount', '#application.config.googleAnalytics.keyid#']);
		_gaq.push(['_trackPageview']);
	</cfoutput>	
	
	<cfif structKeyExists(form,"criteria") AND len(form.criteria)>
		<cfoutput>_gaq.push(['_trackPageview("/search?q={exp:search:#form.criteria#}")']);</cfoutput>
	<cfelse>
		<cfoutput>_gaq.push(['_trackPageview']);</cfoutput>
	</cfif>	
			
	<cfoutput>	
		(function() {
		  var ga = document.createElement('script'); ga.type = 'text/javascript'; ga.async = true;
		  ga.src = ('https:' == document.location.protocol ? 'https://ssl' : 'http://www') + '.google-analytics.com/u/ga_beta.js';
		  var s = document.getElementsByTagName('script')[0]; s.parentNode.insertBefore(ga, s);
		})();
	</script>
	</cfoutput>
	
</cfif>

<cfsetting enablecfoutputonly="no" />