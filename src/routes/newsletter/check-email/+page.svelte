<script lang="ts">
	// Where Brevo sends the browser after the sign-up form is posted (set in the
	// Brevo form's settings). Nobody is subscribed yet: the double opt-in email
	// is on its way, and its link leads to /newsletter/confirmed.
	import Seo from '$lib/components/Seo.svelte';
	import SiteNav from '$lib/components/SiteNav.svelte';
	import SiteFooter from '$lib/components/SiteFooter.svelte';
	import { page } from '$app/state';
	import { t } from '$lib/i18n/t';
</script>

<Seo
	title="Check your inbox — Language Quiz newsletter"
	description="One more step: open the email we just sent and click the link to confirm your subscription."
	path="/newsletter/check-email"
	noindex
/>

<SiteNav courseHref={page.data.site?.courseHref ?? '/'} />

<main class="page">
	<h1>{t('Almost done: check your inbox')}</h1>
	<p class="lede">
		{t('We have just sent you an email. Click the link in it to confirm, and the weekly update starts coming. Until you click, you are not on the list.')}
	</p>
	<ul>
		<li>{t('Nothing there after a few minutes? Look in your spam or promotions folder.')}</li>
		<li>{t('Still nothing? The address may have had a typo. Simply sign up again.')}</li>
		<li>{t('Changed your mind? Ignore the email and nothing more happens.')}</li>
	</ul>
	<p><a href={page.data.site?.courseHref ?? '/'}>{t('Back to the course')}</a></p>
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

	ul {
		margin: 0 0 2rem;
		padding-inline-start: 1.2rem;
		max-width: 56ch;
		line-height: 1.6;
		color: var(--ink-muted);
	}
</style>
