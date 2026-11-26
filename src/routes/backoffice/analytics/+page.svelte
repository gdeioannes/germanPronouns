<script lang="ts">
	// The back office's live analytics report. Like the back office itself it
	// is for the owner only, not in the sitemap, and noindex. The report reads
	// a CSV export the owner picks from their own disk: nothing is fetched and
	// nothing is uploaded. Its written companion is ./analysis.
	import Seo from '$lib/components/Seo.svelte';
	import SiteNav from '$lib/components/SiteNav.svelte';
	import AnalyticsReport from '$lib/components/backoffice/AnalyticsReport.svelte';
	import AnalyticsTabs from '$lib/components/backoffice/AnalyticsTabs.svelte';
	import OwnerGate from '$lib/components/backoffice/OwnerGate.svelte';
	import { page } from '$app/state';
</script>

<Seo title="Analytics report" description="The site owner's analytics report." path="/backoffice/analytics" noindex />

<SiteNav courseHref={page.data.site?.courseHref ?? '/'} />

<main class="page page-wide">
	<AnalyticsTabs current="report" />
	<h1>Analytics report</h1>
	<OwnerGate>
		<AnalyticsReport />
	</OwnerGate>
</main>

<style>
	h1 {
		margin: 0.75rem 0 1rem;
	}
</style>
