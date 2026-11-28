<script lang="ts">
	// The weekly newsletter sign-up. A plain HTML form that posts straight to
	// Brevo's form endpoint: no Brevo script, style or font is loaded on the
	// site, and it works without JavaScript. Brevo then sends the double opt-in
	// email and redirects the browser to /newsletter/check-email; the link in
	// that email lands on /newsletter/confirmed. Both redirects are set in the
	// Brevo form ("Weekly newsletter languagequiz.org"), not here.
	//
	// The field names are Brevo's (from the form's "Simple HTML" export):
	// EMAIL, OPT_IN=1, an empty email_address_check (a trap for bots that fill
	// every field), locale and html_type. Change them only together with the form.
	//
	// The form speaks every interface language. The emails themselves are in
	// English, and in a second language the form says so in that language.

	import { track } from '$lib/services/analytics';
	import { t } from '$lib/i18n/t';
	import { lang } from '$lib/i18n/lang.svelte';
	import { onMount, type Snippet } from 'svelte';
	import { INSTAGRAM, NEWS_IDS, NEWS_TERMS, NEWS_TEXT, type NewsId } from '$lib/domain/bookNews';

	/**
	 * `where`: where the form sits, so two on one page get distinct ids.
	 * `band`: one wide strip (the footer): the text on the left, the fields on
	 * the right; it stacks again on a narrow screen.
	 * `inline`: inside another panel (the download panel): no card of its own,
	 * and `title` and `pitch` say why here (the book gets new editions) instead of the usual lines.
	 */
	let {
		where = 'page',
		band = false,
		inline = false,
		title = '',
		pitch
	}: { where?: string; band?: boolean; inline?: boolean; title?: string; pitch?: Snippet } = $props();

	const ACTION =
		'https://243c807a.sibforms.com/serve/MUIFABPdg3NuMJz1wrkmhvyiYNdTTt9YJmm3uefN_t6Q6KjrErTuO2hmMuzFb2WfyTf0sHGpGSDiwMFPGMIoj8FgasLAsNWUpWhstxUkL6ZHNewT06ihDNupk2eUYHzROUQ-7_aYpDHilWNbKA3br7guzcXu3G8FU6HIabVZUUAB-X72gtUzDE-xHzfyfqev1CFaOm-sEv1mTkxN';

	const id = $derived(`nl-${where}`);

	// The band's look (the books' chapter ends carry the same one): a wording
	// with its figure rising out of a disc. Which of the four a visitor sees
	// is drawn once per tab and kept, so the statistics can compare them.
	// Inside another panel (inline) the form stays plain and keeps that panel's words.
	const MSG_KEY = 'lq_news_msg';
	// Each wording in its own colour: the books' four chapter colours, in the
	// darker shade that keeps the small white print readable on a screen.
	const BAND: Record<NewsId, string> = { weekly: '#a24c26', books: '#836215', edition: '#44614a', engaged: '#30597f' };
	let msg = $state<NewsId>('weekly');
	onMount(() => {
		if (inline) return;
		try {
			const kept = sessionStorage.getItem(MSG_KEY) as NewsId | null;
			msg = kept && NEWS_IDS.includes(kept) ? kept : NEWS_IDS[Math.floor(Math.random() * NEWS_IDS.length)];
			sessionStorage.setItem(MSG_KEY, msg);
		} catch {
			/* private mode: the first wording */
		}
	});

	// Which placement brings sign-ups. Sent as the browser leaves for Brevo
	// (keepalive); the address itself never goes to the statistics.
	const count = () => track('newsletter_subscribe', inline ? { where } : { where, msg });
</script>

<form class="signup" class:loud={!inline} class:band class:inline style:--band={inline ? null : BAND[msg]} method="POST" action={ACTION} aria-labelledby="{id}-title" onsubmit={count}>
	<div class="text">
		{#if !inline}<p class="kick">✉ Newsletter</p>{/if}
		<p class="title" id="{id}-title">{inline ? title || t("What's new, once a week") : t(NEWS_TEXT[msg].site ?? NEWS_TEXT[msg].en)}</p>
		{#if !inline}
			<p class="what">
				{t(NEWS_TERMS.en)}
				{#if lang.limited}<strong class="in-en">{t('The newsletter is always in English.')}</strong>{/if}
			</p>
		{:else if pitch}
			{@render pitch()}
			{#if lang.limited}<p class="what"><strong class="in-en">{t('The newsletter is always in English.')}</strong></p>{/if}
		{:else}
			<p class="what">
				{t('One short email a week: new lessons, new reading and listening, and what was fixed. Free, no spam, unsubscribe with one click.')}
				{#if lang.limited}<strong class="in-en">{t('The newsletter is always in English.')}</strong>{/if}
			</p>
		{/if}
	</div>

	<div class="fields">
	<div class="row">
		<label class="sr-only" for="{id}-email">{t('Your email address')}</label>
		<input
			id="{id}-email"
			type="email"
			name="EMAIL"
			autocomplete="email"
			placeholder="you@example.com"
			dir="ltr"
			required
		/>
		<button type="submit">{t('Subscribe')}</button>
	</div>

	<label class="consent">
		<input type="checkbox" name="OPT_IN" value="1" required />
		<span>{t('Yes, send me the weekly update.')}</span>
	</label>
	<p class="fine">
		{t('You get an email to confirm first. Sent with Brevo (EU); only your email address is stored.')}
		<a href="/legal#newsletter">{t('Privacy notice')}</a>
	</p>
	</div>

	{#if !inline}
		<!-- The figure twice: inside the disc, cut by its rim, and above the disc's
		     middle uncut, so it rises out of the circle. -->
		<div class="art {msg}" aria-hidden="true">
			<span class="disc"><img src="/img/news/news_{msg}.webp" alt="" /></span>
			<img class="out" src="/img/news/news_{msg}.webp" alt="" />
			<span class="free">{t('Free')}</span>
		</div>
		<a class="insta" href={INSTAGRAM} target="_blank" rel="noopener" onclick={() => track('instagram_open', { where })}>
			<svg viewBox="0 0 24 24" aria-hidden="true"><rect x="3" y="3" width="18" height="18" rx="5" /><circle cx="12" cy="12" r="4.2" /><circle cx="17.3" cy="6.7" r="1" class="dot" /></svg>
			Instagram · @language.quiz
		</a>
	{/if}

	<!-- Brevo's bot trap: real people never see or fill it. -->
	<input class="trap" type="text" name="email_address_check" value="" tabindex="-1" autocomplete="off" aria-hidden="true" />
	<input type="hidden" name="locale" value="en" />
	<input type="hidden" name="html_type" value="simple" />
</form>

<style>
	.signup,
	.text,
	.fields {
		display: flex;
		flex-direction: column;
		gap: 0.6rem;
	}

	.signup {
		gap: 0.9rem;
		max-width: 34rem;
		padding: 1.1rem 1.2rem 1.2rem;
		background: var(--surface);
		border: 1px solid var(--line);
		border-radius: var(--radius);
		color: var(--ink);
	}

	.title {
		margin: 0;
		font-weight: 800;
		font-size: var(--step-0);
		color: var(--heading);
	}

	.what,
	.fine {
		margin: 0;
		line-height: 1.5;
	}

	.what {
		color: var(--ink-muted);
	}

	.fine {
		font-size: 0.8rem;
		color: var(--ink-muted);
	}

	.row {
		display: flex;
		flex-wrap: wrap;
		gap: 0.5rem;
	}

	input[type='email'] {
		flex: 1 1 14rem;
		min-width: 0;
		padding: 0.55rem 0.75rem;
		font: inherit;
		color: var(--ink);
		background: var(--surface);
		border: 1px solid var(--line-strong);
		border-radius: var(--radius-sm);
	}

	button {
		padding: 0.55rem 1.1rem;
		font: inherit;
		font-weight: 700;
		color: #fff;
		background: var(--heading);
		border: 1px solid var(--heading);
		border-radius: var(--radius-sm);
		cursor: pointer;
	}

	button:hover {
		filter: brightness(1.15);
	}

	input:focus-visible,
	button:focus-visible {
		outline: 2px solid var(--heading);
		outline-offset: 2px;
	}

	.consent {
		display: flex;
		align-items: flex-start;
		gap: 0.55rem;
		line-height: 1.45;
		cursor: pointer;
	}

	.consent input {
		flex: none;
		width: 1.1rem;
		height: 1.1rem;
		margin: 0.15rem 0 0;
		accent-color: var(--heading);
	}

	.fine a {
		color: var(--heading);
	}

	.in-en {
		color: var(--ink);
		font-weight: 600;
	}

	/* Off-screen rather than display:none, as Brevo's own form does. */
	.trap {
		position: absolute;
		left: -9999px;
		width: 1px;
		height: 1px;
		opacity: 0;
	}

	.sr-only {
		position: absolute;
		width: 1px;
		height: 1px;
		overflow: hidden;
		clip-path: inset(50%);
		white-space: nowrap;
	}

	/* Inside another panel: that panel is the card. */
	.inline {
		gap: 0.7rem;
		max-width: none;
		padding: 0.9rem 1rem 1rem;
		background: var(--surface-2, var(--surface));
		font-size: 0.92rem;
		text-align: start;
	}

	/* The footer strip: text left, fields right, full width. */
	.band {
		display: grid;
		grid-template-columns: minmax(0, 1fr) minmax(0, 1.15fr);
		align-items: start;
		gap: 1rem 2.5rem;
		max-width: none;
		padding: 1.25rem 1.5rem;
		font-size: var(--step--1);
	}

	@media (max-width: 48rem) {
		.band {
			grid-template-columns: 1fr;
		}
	}

	/* The loud look, shared with the books' chapter ends: a terracotta band,
	   white type, the wording's figure rising out of a paper disc. The colour
	   is the darker terracotta, so the small print keeps its contrast. */
	.loud {
		--disc: 7rem;
		--fig: 9.6rem;
		--sink: 0.5rem;
		position: relative;
		margin-top: 3.2rem;
		background: var(--band, #a24c26);
		transition: background-color 0.3s;
		border: 0;
		color: #fff;
	}
	.loud .text { padding-inline-end: calc(var(--disc) + 1.5rem); min-height: 4.2rem; }
	.loud .kick { margin: 0; font-size: 0.72rem; font-weight: 800; letter-spacing: 0.12em; text-transform: uppercase; }
	.loud .title { font-family: var(--serif, Georgia, serif); font-size: var(--step-1, 1.35rem); line-height: 1.15; color: #fff; }
	.loud .what, .loud .fine, .loud .in-en { color: #fff; }
	.loud .fine a { color: #fff; }
	.loud input[type='email'] { background: #fff; border-color: #fff; color: #24262b; }
	.loud button { background: #1f3a5f; border-color: #fff; }
	.loud .consent input { accent-color: #1f3a5f; }
	.loud input:focus-visible, .loud button:focus-visible, .loud a:focus-visible { outline-color: #fff; }
	.art { position: absolute; top: -1.6rem; inset-inline-end: 1.6rem; width: var(--disc); height: var(--disc); pointer-events: none; }
	.art .disc { position: absolute; inset: 0; border-radius: 50%; overflow: hidden; background: #fbf5e4; box-shadow: 0 0 0 0.25rem #fff, 0 0.4rem 1rem rgb(0 0 0 / 0.3); }
	.art img {
		position: absolute;
		bottom: calc(-1 * var(--sink));
		left: 50%;
		width: calc(var(--disc) * 1.43);
		height: var(--fig);
		max-width: none;
		object-fit: contain;
		object-position: 50% 100%;
		transform: translateX(-50%);
	}
	.art.weekly { --sink: calc(var(--disc) * -0.13); }
	.art img.out { clip-path: inset(0 0 calc(var(--disc) / 2 + var(--sink)) 0); }
	.free { position: absolute; bottom: -0.3rem; inset-inline-start: -1.1rem; padding: 0.2rem 0.7rem; border-radius: 99rem; background: #1f3a5f; box-shadow: 0 0 0 2px #fff; color: #fff; font-size: 0.72rem; font-weight: 800; letter-spacing: 0.1em; text-transform: uppercase; transform: rotate(-6deg); }
	.insta { display: inline-flex; align-items: center; gap: 0.45rem; align-self: flex-start; padding: 0.4rem 0.9rem; border: 1.5px solid #fff; border-radius: 99rem; color: #fff; font-weight: 700; font-size: 0.9rem; text-decoration: none; }
	.insta:hover { background: rgb(255 255 255 / 0.14); }
	.insta svg { width: 1.05rem; height: 1.05rem; fill: none; stroke: currentColor; stroke-width: 2; }
	.insta svg .dot { fill: currentColor; stroke: none; }
	/* The footer strip: the text keeps clear of the figure, the fields sit beside it. */
	.loud.band { padding: 1.4rem 1.6rem; padding-inline-end: calc(var(--disc) + 3.4rem); }
	.loud.band .text { padding-inline-end: 0; min-height: 0; }
	.loud.band .insta { grid-column: 1; justify-self: start; }
	@media (max-width: 48rem) {
		.loud.band { padding-inline-end: 1.6rem; }
		.loud.band .text { padding-inline-end: calc(var(--disc) + 1.5rem); min-height: 4.2rem; }
	}
</style>
