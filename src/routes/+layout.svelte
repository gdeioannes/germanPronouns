<script lang="ts">
	import { onNavigate } from '$app/navigation';
	import { page } from '$app/state';
	import { cubicOut } from 'svelte/easing';
	import { fade } from 'svelte/transition';
	import { navDirection, prefersReducedMotion } from '$lib/motion';
	import { trackScreenView } from '$lib/services/analytics';
	import { tts } from '$lib/services/speech';
	import FxLayer from '$lib/components/FxLayer.svelte';
	import VoiceNotice from '$lib/components/VoiceNotice.svelte';
	import Announcer from '$lib/components/Announcer.svelte';
	// Self-hosted fonts: no third-party request blocks the first paint, and the
	// files ship from the same origin as the page.
	import '@fontsource-variable/inter';
	import '@fontsource-variable/source-serif-4';
	// The two font files the first paint needs, preloaded so text does not
	// swap fonts after the CSS has been parsed and discovered them.
	import interUrl from '@fontsource-variable/inter/files/inter-latin-wght-normal.woff2?url';
	import serifUrl from '@fontsource-variable/source-serif-4/files/source-serif-4-latin-wght-normal.woff2?url';
	import '../app.css';

	let { children } = $props();

	// Each page renders its own <main>; the skip link finds whichever one is
	// showing and hands it focus, so the next Tab starts inside the content.
	function skipToMain(event: MouseEvent) {
		const main = document.querySelector<HTMLElement>('main');
		if (!main) return;
		event.preventDefault();
		if (!main.hasAttribute('tabindex')) main.setAttribute('tabindex', '-1');
		main.focus();
	}

	// One screen_view per navigation, the same signal the Flutter router
	// reported. Cookieless and no-op when no ingestion key is configured, which
	// is why there is no consent banner to show.
	$effect(() => {
		trackScreenView(page.url.pathname);
	});

	// Where the browser supports the View Transitions API, a navigation
	// cross-fades the old page into the new one with a short slide in the
	// direction of travel (deeper = forward), so the learner can tell where
	// they went. The sticky nav bar is named in SiteNav so it holds still.
	// Browsers without it fall back to the keyed fade below.
	const viewTransitions = typeof document !== 'undefined' && 'startViewTransition' in document;

	onNavigate((navigation) => {
		// Leaving a page silences whatever it was saying: a clip or passage
		// must not follow the learner out of the quiz.
		if (navigation.from?.url.pathname !== navigation.to?.url.pathname) void tts.stop();

		if (!viewTransitions || prefersReducedMotion()) return;
		// Same page, new query/hash (e.g. a level pick): let the page animate
		// its own change rather than sliding the whole screen.
		if (navigation.from?.url.pathname === navigation.to?.url.pathname) return;

		const direction = navDirection(
			navigation.from?.url.pathname,
			navigation.to?.url.pathname,
			navigation.type,
			navigation.delta
		);
		document.documentElement.dataset.nav = direction;

		return new Promise((resolve) => {
			const transition = document.startViewTransition(async () => {
				resolve();
				await navigation.complete;
			});
			transition.finished.finally(() => {
				delete document.documentElement.dataset.nav;
			});
		});
	});
</script>

<svelte:head>
	<link rel="preload" as="font" type="font/woff2" crossorigin="anonymous" href={interUrl} />
	<link rel="preload" as="font" type="font/woff2" crossorigin="anonymous" href={serifUrl} />
	<link rel="icon" type="image/png" href="/favicon.png" />
	<link rel="apple-touch-icon" href="/icons/Icon-192.png" />
	<link rel="manifest" href="/manifest.json" />
	<meta name="theme-color" content="#1F3A5F" />
</svelte:head>

<a class="skip-link" href="#main" onclick={skipToMain}>Skip to content</a>

<!-- Fallback for browsers without view transitions: fades the new page in so
     a client-side navigation reads as a change of content rather than a
     flash. Off where view transitions already animate the swap. -->
{#key page.url.pathname}
	<div in:fade={{ duration: viewTransitions ? 0 : 220, easing: cubicOut }}>
		{@render children()}
	</div>
{/key}

<FxLayer />
<VoiceNotice />
<Announcer />
