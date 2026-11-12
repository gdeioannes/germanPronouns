<script lang="ts">
	// The base-language picker on the home page: a globe button naming the
	// current language, opening a short list of the languages German is
	// explained in. Each name is in its own language, so whoever is lost in
	// the other one finds theirs. A choice reloads the page, so every text,
	// overlay and hidden part comes up in the new language at once (the same
	// as arriving with it).
	import { lang, setLang, type UiLang } from '$lib/i18n/lang.svelte';
	import Icon from '$lib/icons/Icon.svelte';
	import { LANG_OPTIONS, LANGUAGE_LABEL } from '$lib/i18n/languages';
	import { track } from '$lib/services/analytics';
	import { addressIn } from '$lib/i18n/paths';

	const OPTIONS = LANG_OPTIONS;

	let open = $state(false);
	let root: HTMLElement;
	let button: HTMLButtonElement;
	const current = $derived(OPTIONS.find((o) => o.code === lang.current) ?? OPTIONS[0]);

	function pick(code: UiLang) {
		open = false;
		if (code === lang.current) return button?.focus();
		// Sent with keepalive, so it survives the reload just below.
		track('language_picked', { from: lang.current, to: code, where: 'home' });
		setLang(code);
		// A ?lang= in the address would win over the saved choice on reload, and
		// the page has its own address in each language (/tr/…, /ar/…).
		const url = new URL(location.href);
		url.searchParams.delete('lang');
		url.pathname = addressIn(code, url.pathname);
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
<div class="lang-picker" bind:this={root} onkeydown={onKey} onfocusout={onFocusOut}>
	<button
		type="button"
		class="trigger"
		bind:this={button}
		aria-haspopup="menu"
		aria-expanded={open}
		aria-label="{LANGUAGE_LABEL}: {current.name}"
		onclick={toggle}
	>
		<Icon name="globe" size="1.1em" />
		<span lang={current.code} dir={current.dir}>{current.name}</span>
		<Icon name="chevronDown" size="0.9em" class={open ? 'up' : ''} />
	</button>

	{#if open}
		<div class="menu" role="menu" aria-label={LANGUAGE_LABEL}>
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
		background: rgb(20 22 26 / 0.55);
		backdrop-filter: blur(6px);
		color: #fff;
		font: inherit;
		font-size: 0.88rem;
		font-weight: 600;
		cursor: pointer;
	}

	.trigger:hover {
		background: rgb(20 22 26 / 0.7);
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
</style>
