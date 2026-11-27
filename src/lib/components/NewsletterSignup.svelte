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

	/**
	 * `where`: where the form sits, so two on one page get distinct ids.
	 * `band`: one wide strip (the footer): the text on the left, the fields on
	 * the right; it stacks again on a narrow screen.
	 */
	let { where = 'page', band = false }: { where?: string; band?: boolean } = $props();

	const ACTION =
		'https://243c807a.sibforms.com/serve/MUIFABPdg3NuMJz1wrkmhvyiYNdTTt9YJmm3uefN_t6Q6KjrErTuO2hmMuzFb2WfyTf0sHGpGSDiwMFPGMIoj8FgasLAsNWUpWhstxUkL6ZHNewT06ihDNupk2eUYHzROUQ-7_aYpDHilWNbKA3br7guzcXu3G8FU6HIabVZUUAB-X72gtUzDE-xHzfyfqev1CFaOm-sEv1mTkxN';

	const id = $derived(`nl-${where}`);

	// Which placement brings sign-ups. Sent as the browser leaves for Brevo
	// (keepalive); the address itself never goes to the statistics.
	const count = () => track('newsletter_subscribe', { where });
</script>

<form class="signup" class:band method="POST" action={ACTION} aria-labelledby="{id}-title" onsubmit={count}>
	<div class="text">
		<p class="title" id="{id}-title">{t("What's new, once a week")}</p>
		<p class="what">
			{t('One short email a week: new lessons, new reading and listening, and what was fixed. Free, no spam, unsubscribe with one click.')}
			{#if lang.limited}<strong class="in-en">{t('The newsletter is always in English.')}</strong>{/if}
		</p>
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
</style>
