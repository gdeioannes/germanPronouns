<script lang="ts">
	// Contact: reveals the author's email only after a tiny arithmetic check.
	// The address is never in the served markup — it is stored as character
	// codes and assembled in the browser once the check passes, so harvesting
	// bots that read the page source (or run cheap scrapers) come up empty.
	import Seo from '$lib/components/Seo.svelte';
	import { ORGANIZATION, absoluteUrl, breadcrumbLd } from '$lib/seo';
	import SiteFooter from '$lib/components/SiteFooter.svelte';
	import Icon from '$lib/icons/Icon.svelte';
	import { onMount } from 'svelte';

	// "gdeioannes" + "@" + "gmail.com", as char codes. Decoded on demand only.
	const CODES = [103, 100, 101, 105, 111, 97, 110, 110, 101, 115, 64, 103, 109, 97, 105, 108, 46, 99, 111, 109];

	let a = $state(0);
	let b = $state(0);
	let answer = $state('');
	let email = $state<string | null>(null);
	let wrong = $state(false);
	let copied = $state(false);

	function deal() {
		a = 2 + Math.floor(Math.random() * 8);
		b = 2 + Math.floor(Math.random() * 8);
		answer = '';
		wrong = false;
	}

	// Dealt in the browser only, so the prerendered page carries no fixed
	// question a bot could hardcode the answer to.
	onMount(deal);

	function check(event: SubmitEvent) {
		event.preventDefault();
		if (Number(answer.trim()) === a + b) {
			email = String.fromCharCode(...CODES);
		} else {
			deal();
			wrong = true;
		}
	}

	async function copy() {
		if (!email) return;
		try {
			await navigator.clipboard.writeText(email);
			copied = true;
			setTimeout(() => (copied = false), 2000);
		} catch {
			// Clipboard unavailable — the address is on screen to select.
		}
	}
</script>

<Seo
	title="Contact — Language Quiz"
	jsonLd={[
		{
			'@context': 'https://schema.org',
			'@type': 'ContactPage',
			name: 'Contact Language Quiz',
			url: absoluteUrl('/contact'),
			publisher: ORGANIZATION,
			// No email here: the page only reveals it after a human check.
			mainEntity: { '@type': 'Person', name: 'GDI', jobTitle: 'Independent developer and course author' }
		},
		breadcrumbLd([
			{ name: 'Home', path: '/' },
			{ name: 'Contact', path: '/contact' }
		])
	]}
	description="Get in touch with the person behind Language Quiz: feedback, corrections, questions. One quick human check, then the email address."
	path="/contact"
/>

<main class="page">
	<a class="back-link" href="/"><Icon name="arrowLeft" size="1em" /> Home</a>
	<h1>Contact</h1>
	<p class="lede">
		Found a mistake, something confusing, or something missing? I genuinely
		want to hear it — the app has grown out of exactly that kind of
		feedback. There is no form and no tracking: you get my email address and
		write from your own inbox.
	</p>

	{#if email}
		<section class="reveal">
			<p class="thanks">Thank you — definitely human. Here you go:</p>
			<p class="address">
				<a href="mailto:{email}">{email}</a>
			</p>
			<button type="button" class="copy" onclick={copy}>
				{copied ? 'Copied!' : 'Copy address'}
			</button>
		</section>
	{:else}
		<section class="gate">
			<p>
				One quick check first, so address-harvesting bots leave empty-handed:
			</p>
			<form onsubmit={check}>
				<label for="human-check" class="question">
					What is <strong class="tnum">{a} + {b}</strong>?
				</label>
				<div class="row">
					<input
						id="human-check"
						type="text"
						inputmode="numeric"
						autocomplete="off"
						bind:value={answer}
						required
					/>
					<button type="submit">Show the address</button>
				</div>
				{#if wrong}
					<p class="miss" role="alert">
						Not quite — let's try a fresh one.
					</p>
				{/if}
			</form>
		</section>
	{/if}
</main>

<SiteFooter />

<style>
	h1 {
		margin: 0 0 0.5rem;
	}

	.lede {
		margin: 0 0 2rem;
		max-width: 56ch;
		color: var(--ink-muted);
	}

	section {
		max-width: 62ch;
	}

	.gate p,
	.reveal p {
		margin: 0 0 1rem;
		line-height: 1.65;
	}

	.question {
		display: block;
		margin-bottom: 0.6rem;
	}

	.row {
		display: flex;
		flex-wrap: wrap;
		gap: 0.6rem;
	}

	input {
		width: 6.5rem;
		padding: 0.55rem 0.75rem;
		font: inherit;
		color: var(--ink);
		background: var(--card, transparent);
		border: 1px solid var(--line);
		border-radius: 0.5rem;
	}

	input:focus-visible {
		outline: 2px solid var(--heading);
		outline-offset: 1px;
	}

	button {
		padding: 0.55rem 1rem;
		font: inherit;
		font-weight: 600;
		color: var(--heading);
		background: transparent;
		border: 1px solid var(--line);
		border-radius: 0.5rem;
		cursor: pointer;
	}

	button:hover {
		border-color: var(--heading);
	}

	.miss {
		margin-top: 0.75rem;
		color: var(--ink-muted);
	}

	.thanks {
		color: var(--ink-muted);
	}

	.address {
		font-size: var(--step-1, 1.25rem);
		font-weight: 700;
	}

	.address a {
		color: var(--heading);
	}

	.copy {
		font-size: var(--step--1);
	}
</style>
