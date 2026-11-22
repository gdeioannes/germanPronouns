<script lang="ts">
	// The one share panel, mounted once in the root layout and opened from any
	// share button (state/sharePanel). It shows the message the way it will
	// arrive in a chat, lets the learner change the words, and offers the ways
	// to send it: WhatsApp, Telegram, email, the link copied, a QR code for
	// someone at the same table, and the device's own share sheet.
	import { fade, fly } from 'svelte/transition';
	import { cubicOut } from 'svelte/easing';
	import Icon from '$lib/icons/Icon.svelte';
	import Logo from '$lib/components/Logo.svelte';
	import { announce, modal } from '$lib/a11y.svelte';
	import { t } from '$lib/i18n/t';
	import { sharePanel } from '$lib/state/sharePanel.svelte';
	import { mailLink, telegramLink, trackShare, whatsappLink, type ShareHow } from '$lib/services/share';

	let copied = $state(false);
	/** A way out was taken: the panel says thank you. */
	let sent = $state(false);
	let qr = $state<{ d: string; size: number } | null>(null);
	let showQr = $state(false);
	let canNative = $state(false);

	// Fresh each time it opens.
	$effect(() => {
		if (!sharePanel.open) return;
		copied = false;
		sent = false;
		qr = null;
		showQr = false;
		canNative = typeof navigator.share === 'function';
	});

	/** The address as a reader would say it: no protocol, no tracking tag. */
	const shown = $derived.by(() => {
		try {
			const u = new URL(sharePanel.url);
			return decodeURI(u.host + (u.pathname === '/' ? '' : u.pathname));
		} catch {
			return sharePanel.url;
		}
	});
	/** The card's headline: the page title without the site's name after it. */
	const headline = $derived(sharePanel.title.replace(/\s*[|–—-]\s*Language Quiz\s*$/, '') || 'Language Quiz');

	function close() {
		sharePanel.open = false;
	}

	function done(how: ShareHow) {
		trackShare(sharePanel.where, how, sharePanel.props);
		sent = true;
	}

	async function copy() {
		try {
			await navigator.clipboard.writeText(`${sharePanel.text}\n${sharePanel.url}`);
		} catch {
			return;
		}
		copied = true;
		announce(t('Link copied'));
		done('copy');
		setTimeout(() => (copied = false), 2400);
	}

	async function native() {
		try {
			await navigator.share({ title: sharePanel.title, text: sharePanel.text, url: sharePanel.url });
			done('sheet');
		} catch {
			// The sheet was closed: nothing was shared.
		}
	}

	async function toggleQr() {
		showQr = !showQr;
		if (!showQr || qr) return;
		const QRCode = (await import('qrcode')).default;
		const code = QRCode.create(sharePanel.url, { errorCorrectionLevel: 'M' });
		const size = code.modules.size;
		let d = '';
		for (let y = 0; y < size; y++) {
			for (let x = 0; x < size; x++) {
				if (code.modules.data[y * size + x]) d += `M${x + 2} ${y + 2}h1.04v1.04h-1.04z`;
			}
		}
		qr = { d, size: size + 4 };
		trackShare(sharePanel.where, 'qr', sharePanel.props);
	}
</script>

{#if sharePanel.open}
	<div class="share-layer">
		<button type="button" class="scrim" tabindex="-1" aria-label={t('Close')} onclick={close} transition:fade={{ duration: 160 }}></button>
		<div
			class="panel"
			role="dialog"
			aria-modal="true"
			aria-labelledby="share-panel-title"
			tabindex="-1"
			use:modal={close}
			transition:fly={{ y: 28, duration: 260, easing: cubicOut }}
		>
			<header>
				<h2 id="share-panel-title">
					{#if sent}<span lang="de">Danke!</span> {t('Thank you for passing it on.')}{:else}{t('Send it to a friend')}{/if}
				</h2>
				<button type="button" class="x" aria-label={t('Close')} onclick={close}><Icon name="close" size="1.1em" /></button>
			</header>

			<!-- The message as it will arrive: the words (theirs to change) and the link's card. -->
			<div class="chat">
				<div class="bubble">
					<label class="sr-only" for="share-words">{t('Your message. Change it if you like.')}</label>
					<textarea id="share-words" rows="3" bind:value={sharePanel.text} dir="auto"></textarea>
					<div class="link-card">
						<Logo tile size="2.4rem" />
						<span class="link-text">
							<strong>{headline}</strong>
							<span dir="ltr">{shown}</span>
						</span>
					</div>
				</div>
				<p class="hint">{t('Your message. Change it if you like.')}</p>
			</div>

			<div class="ways">
				<a
					class="way wa"
					href={whatsappLink(sharePanel.text, sharePanel.url)}
					target="_blank"
					rel="noopener"
					onclick={() => done('whatsapp')}
				>
					<span class="dot"><Icon name="chat" size="1.35em" /></span>
					<span class="name">WhatsApp</span>
				</a>
				<a
					class="way tg"
					href={telegramLink(sharePanel.text, sharePanel.url)}
					target="_blank"
					rel="noopener"
					onclick={() => done('telegram')}
				>
					<span class="dot"><Icon name="send" size="1.35em" /></span>
					<span class="name">Telegram</span>
				</a>
				<a class="way mail" href={mailLink(headline, sharePanel.text, sharePanel.url)} onclick={() => done('email')}>
					<span class="dot"><Icon name="mail" size="1.35em" /></span>
					<span class="name">{t('Email')}</span>
				</a>
				<button type="button" class="way copy" class:on={copied} onclick={copy}>
					<span class="dot"><Icon name={copied ? 'check' : 'copy'} size="1.35em" /></span>
					<span class="name">{copied ? t('Link copied') : t('Copy link')}</span>
				</button>
				<button type="button" class="way qr" class:on={showQr} aria-expanded={showQr} onclick={toggleQr}>
					<span class="dot"><Icon name="qr" size="1.35em" /></span>
					<span class="name">{t('QR code')}</span>
				</button>
				{#if canNative}
					<button type="button" class="way more" onclick={native}>
						<span class="dot"><Icon name="share" size="1.35em" /></span>
						<span class="name">{t('More')}</span>
					</button>
				{/if}
			</div>

			{#if showQr}
				<div class="qr-box">
					{#if qr}
						<svg viewBox="0 0 {qr.size} {qr.size}" shape-rendering="crispEdges" role="img" aria-label={t('QR code')}>
							<path fill="#1f3a5f" d={qr.d} />
						</svg>
					{/if}
					<p>{t('Someone next to you? They point their phone camera at this.')}</p>
				</div>
			{/if}
		</div>
	</div>
{/if}

<style>
	.share-layer {
		position: fixed;
		inset: 0;
		z-index: 120;
		display: grid;
		place-items: center;
		padding: 1rem;
	}

	.scrim {
		position: absolute;
		inset: 0;
		border: 0;
		background: rgb(20 32 52 / 0.55);
		cursor: pointer;
	}

	.panel {
		position: relative;
		width: min(27rem, 100%);
		max-height: calc(100dvh - 2rem);
		overflow-y: auto;
		border-radius: 20px;
		background: var(--surface);
		box-shadow: 0 30px 70px -20px rgb(20 32 52 / 0.6);
		outline: none;
	}

	header {
		display: flex;
		align-items: center;
		justify-content: space-between;
		gap: 0.75rem;
		padding: 1rem 1rem 1rem 1.3rem;
		background: var(--share);
		color: var(--share-ink);
	}

	h2 {
		margin: 0;
		font-size: var(--step-1);
		line-height: 1.2;
		color: var(--share-ink);
	}

	.x {
		flex: none;
		display: inline-flex;
		align-items: center;
		justify-content: center;
		width: 2.5rem;
		height: 2.5rem;
		border: 0;
		border-radius: 50%;
		background: rgb(31 58 95 / 0.1);
		color: var(--share-ink);
		cursor: pointer;
	}

	.x:hover {
		background: rgb(31 58 95 / 0.2);
	}

	/* A chat's wallpaper, with the message on the sender's side. */
	.chat {
		padding: 1.2rem 1.1rem 0.8rem;
		background:
			radial-gradient(circle at 12% 20%, rgb(201 104 59 / 0.1) 0 2.2rem, transparent 2.3rem),
			radial-gradient(circle at 88% 78%, rgb(63 93 69 / 0.1) 0 3rem, transparent 3.1rem),
			#fbf5e4;
	}

	.bubble {
		position: relative;
		margin-inline-start: 2rem;
		padding: 0.5rem;
		border-radius: 16px;
		border-start-end-radius: 4px;
		background: #fff;
		box-shadow: 0 2px 6px rgb(31 58 95 / 0.14);
	}

	textarea {
		display: block;
		width: 100%;
		box-sizing: border-box;
		min-height: 4.2rem;
		padding: 0.35rem 0.45rem;
		border: 1px dashed transparent;
		border-radius: 10px;
		background: transparent;
		color: var(--ink);
		font: inherit;
		/* 16 px: a smaller field makes iPhone zoom the whole page on focus. */
		font-size: 16px;
		line-height: 1.4;
		resize: none;
		field-sizing: content;
	}

	textarea:hover,
	textarea:focus {
		border-color: var(--line-strong);
		outline: none;
	}

	.link-card {
		display: flex;
		align-items: center;
		gap: 0.7rem;
		margin-top: 0.4rem;
		padding: 0.6rem 0.7rem;
		border-inline-start: 4px solid var(--accent);
		border-radius: 8px;
		background: var(--surface-alt);
	}

	.link-text {
		display: flex;
		flex-direction: column;
		min-width: 0;
		font-size: var(--step--1);
		color: var(--ink-muted);
	}

	.link-text strong {
		color: var(--heading);
		overflow: hidden;
		text-overflow: ellipsis;
		white-space: nowrap;
	}

	.link-text span {
		overflow: hidden;
		text-overflow: ellipsis;
		white-space: nowrap;
	}

	.hint {
		margin: 0.5rem 0 0;
		text-align: end;
		font-size: 0.78rem;
		color: var(--ink-muted);
	}

	.ways {
		display: grid;
		grid-template-columns: repeat(auto-fit, minmax(4.4rem, 1fr));
		gap: 0.9rem 0.3rem;
		padding: 1.1rem 0.9rem 1.2rem;
	}

	.way {
		display: flex;
		flex-direction: column;
		align-items: center;
		gap: 0.4rem;
		padding: 0;
		border: 0;
		background: none;
		color: var(--ink);
		font: inherit;
		font-size: 0.8rem;
		font-weight: 600;
		text-align: center;
		text-decoration: none;
		cursor: pointer;
	}

	.dot {
		display: inline-flex;
		align-items: center;
		justify-content: center;
		width: 3.4rem;
		height: 3.4rem;
		border-radius: 50%;
		background: var(--surface-alt);
		color: var(--heading);
		transition: transform var(--medium) var(--ease-spring);
	}

	.way:hover .dot,
	.way:focus-visible .dot {
		transform: translateY(-3px) scale(1.08);
	}

	.way:focus-visible {
		outline: none;
	}

	.way:focus-visible .dot {
		outline: 3px solid var(--accent);
		outline-offset: 2px;
	}

	.wa .dot {
		background: #25d366;
		color: #06301f;
	}

	.tg .dot {
		background: #2aabee;
		color: #06263a;
	}

	.mail .dot {
		background: var(--ochre);
		color: #fff;
	}

	.copy .dot {
		background: var(--accent-ink);
		color: #fff;
	}

	.qr .dot {
		background: var(--navy);
		color: #fff;
	}

	.copy.on .dot {
		background: var(--right);
	}

	.qr.on .dot {
		outline: 3px solid var(--accent);
		outline-offset: 2px;
	}

	.qr-box {
		display: flex;
		align-items: center;
		gap: 1rem;
		margin: 0 1.1rem 1.2rem;
		padding: 0.9rem;
		border: 1px solid var(--line);
		border-radius: 14px;
	}

	.qr-box svg {
		flex: none;
		width: 8.5rem;
		height: 8.5rem;
	}

	.qr-box p {
		margin: 0;
		font-size: var(--step--1);
		color: var(--ink-muted);
	}

	/* A phone: the panel rises from the bottom edge, like the chat apps' own. */
	@media (max-width: 36rem) {
		.share-layer {
			place-items: end center;
			padding: 0;
		}
		.panel {
			width: 100%;
			max-height: 92dvh;
			border-radius: 20px 20px 0 0;
			padding-bottom: env(safe-area-inset-bottom);
		}
	}

	.sr-only {
		position: absolute;
		width: 1px;
		height: 1px;
		overflow: hidden;
		clip-path: inset(50%);
		white-space: nowrap;
	}

	@media print {
		.share-layer {
			display: none;
		}
	}
</style>
