<script lang="ts">
	// Where the confirmation link in Brevo's double opt-in email lands (set in
	// the Brevo form's settings). From here on the address is on the list.
	import Seo from '$lib/components/Seo.svelte';
	import SiteNav from '$lib/components/SiteNav.svelte';
	import SiteFooter from '$lib/components/SiteFooter.svelte';
	import { page } from '$app/state';
</script>

<Seo
	title="You're subscribed — Language Quiz newsletter"
	description="Your subscription to the weekly Language Quiz update is confirmed."
	path="/newsletter/confirmed"
	noindex
/>

<SiteNav courseHref={page.data.site?.courseHref ?? '/'} />

<main class="page">
	<h1>You're subscribed</h1>
	<p class="lede">
		Thank you. Once a week you get a short email with what is new in the course: new lessons, new
		reading and listening, and what was fixed. Every email has a link to unsubscribe with one click.
	</p>
	<p>
		<a class="go" href={page.data.site?.courseHref ?? '/'}>Back to the course</a>
		· <a href="/changelog">See what changed recently</a>
	</p>
</main>

<SiteFooter />

<style>
	h1 {
		margin: 0 0 0.75rem;
	}

	.lede {
		margin: 0 0 1.5rem;
		max-width: 56ch;
	}

	.go {
		font-weight: 700;
	}
</style>
