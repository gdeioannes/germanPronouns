<script lang="ts">
	// The base-language picker on the home page: a globe button naming the
	// current language, opening a short list of the languages German is
	// explained in. Each name is in its own language, so whoever is lost in
	// the other one finds theirs. A choice reloads the page, so every text,
	// overlay and hidden part comes up in the new language at once (the same
	// as arriving with it).
	// `bar`: the same picker in the site's top bar, a globe and the short code
	// (EN, ES …), styled for the light bar instead of a photo.
	// `level`: inside the course, the sub-level on screen. Switching to a
	// language that does not explain it asks first, in that language.
	import { lang, setLang, type UiLang } from '$lib/i18n/lang.svelte';
	import Icon from '$lib/icons/Icon.svelte';
	import { LANG_OPTIONS } from '$lib/i18n/languages';
	import { t } from '$lib/i18n/t';
	import { track } from '$lib/services/analytics';
	import { addressIn, hasTwin, stripLang } from '$lib/i18n/paths';
	import { levelExplainedIn } from '$lib/i18n/content.svelte';
	import { modal } from '$lib/a11y.svelte';

	const OPTIONS = LANG_OPTIONS;

	let {
		bar = false,
		where = 'home',
		level = null
	}: { bar?: boolean; where?: string; level?: string | null } = $props();

	/** The language waiting for a yes, when it does not explain `level`. */
	let asking = $state<(typeof OPTIONS)[number] | null>(null);
	// The question goes to <body>: the slim course bar blurs and slides, which
	// would hold a fixed overlay inside the bar. Then the usual modal contract.
	function floating(node: HTMLElement, onclose: () => void) {
		document.body.appendChild(node);
		const m = modal(node.firstElementChild as HTMLElement, onclose);
		return {
			update: m.update,
			destroy() {
				m.destroy();
				node.remove();
			}
		};
	}

	function cancel() {
		asking = null;
		button?.focus();
	}

	const levelName = $derived(level ? level.toUpperCase().replace('_', '.') : '');

	let open = $state(false);
	let root: HTMLElement;
	let button: HTMLButtonElement;
	const current = $derived(OPTIONS.find((o) => o.code === lang.current) ?? OPTIONS[0]);

	function pick(code: UiLang) {
		open = false;
		if (code === lang.current) return button?.focus();
		if (level && !levelExplainedIn(code, level)) {
			asking = OPTIONS.find((o) => o.code === code) ?? null;
			return;
		}
		go(code);
	}

	function go(code: UiLang) {
		asking = null;
		// Sent with keepalive, so it survives the reload just below.
		track('language_picked', { from: lang.current, to: code, where, ...(level ? { level } : {}) });
		setLang(code);
		// A ?lang= in the address would win over the saved choice on reload, and
		// the page has its own address in each language (/tr/…, /ar/…).
		const url = new URL(location.href);
		url.searchParams.delete('lang');
		// Only pages built under the language prefix (A1–A2) move there; a
		// B1–C2 page has no such address and would 404 on the static host, so it
		// stays at its bare address and the saved choice switches the language.
		const bare = stripLang(url.pathname);
		url.pathname = hasTwin(bare) ? addressIn(code, bare) : bare;
		location.replace(url);
	}

	function toggle() {
		open = !open;
		if (open) queueMicrotask(() => root?.querySelector<HTMLElement>('[aria-checked="true"]')?.focus());
	}

	function onKey(e: KeyboardEvent) {
		if (!open) return;
		if (e.key === 'Escape') {
			open = false;
			button.focus();
			return;
		}
		if (e.key !== 'ArrowDown' && e.key !== 'ArrowUp') return;
		e.preventDefault();
		const items = [...root.querySelectorAll<HTMLElement>('[role="menuitemradio"]')];
		const at = items.indexOf(document.activeElement as HTMLElement);
		items[(at + (e.key === 'ArrowDown' ? 1 : items.length - 1)) % items.length]?.focus();
	}

	// Tabbing out of the menu closes it. Only when focus lands somewhere else:
	// Safari (iPhone, iPad, Mac) gives a tapped button no focus, so a tap on
	// an option blurs the menu with nowhere to go, and closing then would
	// remove the option before its click arrives. Taps outside close it below.
	function onFocusOut(e: FocusEvent) {
		const to = e.relatedTarget as Node | null;
		if (to && !root.contains(to)) open = false;
	}

	function onOutside(e: PointerEvent) {
		if (open && root && !root.contains(e.target as Node)) open = false;
	}
</script>

<svelte:window onpointerdown={onOutside} />

<!-- svelte-ignore a11y_no_static_element_interactions -->
<div class="lang-picker" class:bar bind:this={root} onkeydown={onKey} onfocusout={onFocusOut}>
	<button
		type="button"
		class="trigger"
		bind:this={button}
		aria-haspopup="menu"
		aria-expanded={open}
		aria-label="{t('Language')}: {current.name}"
		onclick={toggle}
	>
		<Icon name="globe" size="1.1em" />
		{#if bar}
			<span class="code" aria-hidden="true">{current.code.toUpperCase()}</span>
		{:else}
			<span lang={current.code} dir={current.dir}>{current.name}</span>
			<Icon name="chevronDown" size="0.9em" class={open ? 'up' : ''} />
		{/if}
	</button>

	{#if asking}
		{@const m = asking.missing}
		{@const [before, after] = m.text.split('{level}')}
		<div class="backdrop" use:floating={cancel}>
			<div
				class="ask"
				role="alertdialog"
				aria-modal="true"
				aria-labelledby="lang-ask-name"
				aria-describedby="lang-ask-text"
				lang={asking.code}
				dir={asking.dir}
				tabindex="-1"
			>
				<p class="ask-name" id="lang-ask-name"><Icon name="globe" size="1.1em" /> {asking.name}</p>
				<p id="lang-ask-text">{before}<bdi dir="ltr">{levelName}</bdi>{after} {m.kept}</p>
				<div class="ask-actions">
					<!-- svelte-ignore a11y_autofocus -->
					<button type="button" class="no" autofocus onclick={cancel}>{m.no}</button>
					<button type="button" class="yes" onclick={() => asking && go(asking.code)}>{m.yes}</button>
				</div>
			</div>
		</div>
	{/if}

	{#if open}
		<div class="menu" role="menu" aria-label={t('Language')}>
			{#each OPTIONS as o (o.code)}
				<button
					type="button"
					role="menuitemradio"
					aria-checked={o.code === lang.current}
					lang={o.code}
					dir={o.dir}
					onclick={() => pick(o.code)}
				>
					<span class="text">
						<strong>{o.name}</strong>
						<small>{o.note}</small>
					</span>
					{#if o.code === lang.current}<Icon name="check" size="1em" stroke={2.5} />{/if}
				</button>
			{/each}
		</div>
	{/if}
</div>

<style>
	.lang-picker {
		position: relative;
		font-family: 'Inter Variable', Inter, system-ui, sans-serif;
	}

	.trigger {
		display: inline-flex;
		align-items: center;
		gap: 0.4rem;
		padding: 0.45rem 0.75rem;
		border: 1px solid rgb(255 255 255 / 0.35);
		border-radius: 999px;
		/* Dark enough for 4.5:1 white text over the brightest part of a photo. */
		background: rgb(20 22 26 / 0.7);
		backdrop-filter: blur(6px);
		color: #fff;
		font: inherit;
		font-size: 0.88rem;
		font-weight: 600;
		cursor: pointer;
	}

	.trigger:hover {
		background: rgb(20 22 26 / 0.8);
	}

	.trigger :global(.up) {
		transform: rotate(180deg);
	}

	.menu {
		position: absolute;
		top: calc(100% + 0.4rem);
		inset-inline-end: 0;
		z-index: 10;
		display: grid;
		gap: 0.15rem;
		min-width: 17rem;
		padding: 0.35rem;
		border-radius: 0.75rem;
		background: #fff;
		box-shadow: 0 12px 32px rgb(0 0 0 / 0.22);
	}

	.menu button {
		display: flex;
		align-items: center;
		justify-content: space-between;
		gap: 0.75rem;
		padding: 0.6rem 0.75rem;
		border: 0;
		border-radius: 0.5rem;
		background: transparent;
		color: #1d2330;
		font: inherit;
		text-align: start;
		cursor: pointer;
	}

	.menu button:hover,
	.menu button:focus-visible {
		background: #f2efe9;
		outline: none;
	}

	.menu button[aria-checked='true'] {
		color: var(--accent-ink, #8a3f1d);
	}

	.text {
		display: grid;
		gap: 0.1rem;
	}

	strong {
		font-size: 0.95rem;
	}

	small {
		white-space: nowrap;
		color: #5b6170;
		font-size: 0.78rem;
	}

	.trigger:focus-visible {
		outline: 2px solid #fff;
		outline-offset: 2px;
	}

	/* In the top bar: quiet like Sign in beside it, globe in the accent. */
	.bar .trigger {
		gap: 0.3rem;
		padding: 0.35rem 0.45rem;
		border: 0;
		border-radius: 6px;
		background: none;
		backdrop-filter: none;
		color: var(--ink-muted);
		font-size: var(--step--1);
	}

	.bar .trigger:hover {
		background: none;
		color: var(--heading);
	}

	.bar .trigger :global(.icon) {
		color: var(--accent-ink);
	}

	.bar .trigger:focus-visible {
		outline-color: var(--accent-ink);
	}

	.bar .menu {
		z-index: 60;
		border: 1px solid var(--line, #e4dfd6);
	}

	/* On a phone the button sits mid-bar, so a list hung from it would run off
	   the screen: it hangs from the whole bar instead, inside the gutters. */
	@media (max-width: 40rem) {
		.lang-picker.bar {
			position: static;
		}
		.bar .menu {
			top: calc(100% - 0.25rem);
			inset-inline: 1rem;
			min-width: 0;
		}
		.bar .menu small {
			white-space: normal;
		}
	}

	.code {
		letter-spacing: 0.03em;
	}

	/* The question before switching to a language that skips this level. */
	.backdrop {
		position: fixed;
		inset: 0;
		z-index: 100;
		display: grid;
		place-items: center;
		padding: 1rem;
		background: rgb(20 22 26 / 0.45);
	}

	.ask {
		display: grid;
		gap: 0.75rem;
		width: min(26rem, 100%);
		padding: 1.25rem;
		border-radius: 0.9rem;
		background: #fff;
		color: #1d2330;
		box-shadow: 0 18px 48px rgb(0 0 0 / 0.28);
		text-align: start;
	}

	.ask:focus {
		outline: none;
	}

	.ask p {
		margin: 0;
		line-height: 1.5;
	}

	.ask-name {
		display: inline-flex;
		align-items: center;
		gap: 0.4rem;
		font-weight: 700;
		color: var(--accent-ink, #8a3f1d);
	}

	.ask-actions {
		display: flex;
		flex-wrap: wrap;
		justify-content: flex-end;
		gap: 0.5rem;
		margin-top: 0.25rem;
	}

	.ask-actions button {
		padding: 0.55rem 1rem;
		border-radius: 6px;
		font: inherit;
		font-weight: 600;
		cursor: pointer;
	}

	.ask-actions .no {
		border: 1px solid #d6d1c8;
		background: #fff;
		color: #1d2330;
	}

	.ask-actions .yes {
		border: 1px solid var(--accent-ink, #8a3f1d);
		background: var(--accent-ink, #8a3f1d);
		color: #fff;
	}

	.ask-actions button:focus-visible {
		outline: 2px solid var(--accent-ink, #8a3f1d);
		outline-offset: 2px;
	}
</style>
