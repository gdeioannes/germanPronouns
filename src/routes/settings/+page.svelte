<script lang="ts">
	import Seo from '$lib/components/Seo.svelte';
	// Settings, plus a jump list into the ladder.
	//
	// Nothing is locked any more, so "set your starting point" no longer has to
	// unlock anything — a learner who already speaks some German just goes
	// straight to the level that suits them.
	import Icon from '$lib/icons/Icon.svelte';
	import { returnTo, returnLabel } from '$lib/state/returnTo.svelte';
	import PracticeReminder from '$lib/components/PracticeReminder.svelte';
	import { rise } from '$lib/motion';
	import { playSound } from '$lib/services/sounds';
	import { forgetFirstSeen, track } from '$lib/services/analytics';
	import { catalog } from '$lib/content';

	/** The old whole-level printed book is withdrawn; flip back on with the new A1 book. */
	const SHOW_PRINTED_BOOK = false;
	import { loadCourse } from '$lib/content';
	import { buildLadder } from '$lib/domain/ladder';
	import { progress, type AnswerRevealMode } from '$lib/state/progress.svelte';
	import AccountCard from '$lib/components/AccountCard.svelte';
	import { account } from '$lib/state/account.svelte';
	import { collectMyData, downloadJson } from '$lib/services/myData';
	import { announce, radioKeys } from '$lib/a11y.svelte';
	import type { PopulatedCourse } from '$lib/content/types';
	import { lang, setLang, type UiLang } from '$lib/i18n/lang.svelte';
	import { t } from '$lib/i18n/t';
	import { levelInTurkish } from '$lib/i18n/available';

	let course = $state<PopulatedCourse | null>(null);
	let confirmingReset = $state(false);
	let message = $state('');
	$effect(() => {
		(async () => {
			const loaded = await loadCourse(catalog.defaultCourseId);
			course = loaded;
			if (!progress.loaded) await progress.load();
		})();
	});

	const ladder = $derived(course ? buildLadder(course, () => false) : []);

	let exporting = $state(false);
	let exportError = $state('');
	async function downloadMyData() {
		exporting = true;
		exportError = '';
		try {
			const data = await collectMyData(account.userId);
			downloadJson(data, `my-data-${new Date().toISOString().slice(0, 10)}.json`);
			announce(t('Your data is downloading.'));
		} catch (cause) {
			console.error('[my data]', cause);
			exportError = account.signedIn
				? "Couldn't reach your account just now. Check your connection and try again."
				: 'Something went wrong. Please try again.';
		} finally {
			exporting = false;
		}
	}

	let confirmingClose = $state(false);
	let closeTyped = $state('');
	let wipeLocal = $state(false);
	let closeError = $state('');
	async function closeAccount() {
		closeError = '';
		const ok = await account.closeAccount(wipeLocal);
		if (!ok) closeError = account.error ?? 'Something went wrong. Please try again.';
		confirmingClose = false;
		closeTyped = '';
		if (ok && account.close === 'closed') {
			message = wipeLocal
				? 'Your account is closed and everything is deleted, here and in the cloud.'
				: 'Your account is closed and everything in the cloud is deleted. Your progress in this browser is still here.';
			announce(message);
		}
	}

	async function resetEverything() {
		await progress.reset();
		forgetFirstSeen();
		confirmingReset = false;
		message = t('Progress cleared. Every score, streak and medal is gone.');
		announce(message);
	}
</script>

<Seo title="Settings — Language Quiz" description="Your Language Quiz settings: how answers are checked and revealed, the voice, calmer effects, surprises in the deck, your starting point and privacy." path="/settings" noindex />

<main class="page">
	<a class="back-link" href={returnTo.path}><Icon name="arrowLeft" size="1em" /> {returnLabel(returnTo.path)}</a>
	<h1>{t('Settings')}</h1>

	{#if message}
		<p class="message" in:rise>
			<Icon name="info" size="1.05em" />
			<span>{message}</span>
		</p>
	{/if}

	<PracticeReminder />

	<!-- Both names are shown in their own language, so whoever is lost in the
	     other one can still find theirs. -->
	<section class="card">
		<h2 lang="en">Language <span class="alt" lang="tr">· Dil</span></h2>
		<p class="lede">
			{t('The language the site explains German in. In Turkish, levels A1 and A2 are available.')}
		</p>
		<div class="segmented" role="radiogroup" aria-label="Language / Dil" use:radioKeys>
			{#each [['en', 'English'], ['tr', 'Türkçe']] as [code, label] (code)}
				<button
					type="button"
					role="radio"
					lang={code}
					aria-checked={lang.current === code}
					tabindex={lang.current === code ? 0 : -1}
					onclick={() => {
						if (code === lang.current) return;
						track('language_picked', { from: lang.current, to: code, where: 'settings' });
						setLang(code as UiLang);
					}}
				>
					{label}
				</button>
			{/each}
		</div>
	</section>

	<section class="card">
		<h2>{t('Answer checking')}</h2>
		<label class="row">
			<input
				type="checkbox"
				checked={progress.relaxedCorrection}
				onchange={(e) => progress.setRelaxedCorrection(e.currentTarget.checked)}
			/>
			<span>
				<strong>{t('Relaxed correction')}</strong>
				<small>
					{t("On by default: an answer still counts when it's only missing an umlaut, an accent, or punctuation like a full stop or apostrophe — your keyboard shouldn't decide whether you know the German. The correct spelling is still written into the gap afterwards. Turn this off to be marked on the exact spelling.")}
				</small>
			</span>
		</label>

		<!-- B1 and up only, so not in Turkish mode. -->
		{#if !lang.tr}
		<label class="row">
			<input
				type="checkbox"
				checked={progress.alwaysEnglish}
				onchange={(e) => progress.setAlwaysEnglish(e.currentTarget.checked)}
			/>
			<span>
				<strong>Always show translations</strong>
				<small>
					From B1, translations of sentences wait behind an English button, so
					you try the German first. Turn this on to see them straight away.
				</small>
			</span>
		</label>
		{/if}

		<label class="row">
			<input
				type="checkbox"
				checked={progress.wordHelp}
				onchange={(e) => progress.setWordHelp(e.currentTarget.checked)}
			/>
			<span>
				<strong>{t('Word help')}</strong>
				<small>
					{t("Lets you tap any German word for its English meaning — verbs in whatever form the sentence uses them, prepositions, the little words that make a sentence hard to read. Nouns are also coloured by gender — blue der, red die, green das — and show their article and plural. The same switch sits on the exercise itself, so you can turn it off mid-quiz when you'd rather be tested than helped.")}
				</small>
			</span>
		</label>

		<label class="row">
			<input
				type="checkbox"
				checked={progress.showFirstLetterHint}
				onchange={(e) => progress.setShowFirstLetterHint(e.currentTarget.checked)}
			/>
			<span>
				<strong>{t('Show the first letter')}</strong>
				<small>{t('Starts every fill-in answer off for you.')}</small>
			</span>
		</label>
	</section>

	<section class="card">
		<h2>{t('Voice')}</h2>
		<label class="row">
			<input
				type="checkbox"
				checked={progress.voiceOfflineOnly}
				onchange={(e) => progress.setVoiceOfflineOnly(e.currentTarget.checked)}
			/>
			<span>
				<strong>{t("Use this device's voice only")}</strong>
				<small>
					{t('Sentences are normally read by a neural voice through our audio service, which sounds far closer to a native speaker. Tick this to keep every sentence on your device instead — the built-in voice is more robotic, but nothing is sent anywhere.')}
				</small>
			</span>
		</label>
	</section>

	<section class="card">
		<h2>{t('Effects')}</h2>
		<label class="row">
			<input
				type="checkbox"
				checked={progress.muted}
				onchange={(e) => progress.setMuted(e.currentTarget.checked)}
			/>
			<span>
				<strong>{t('Mute the app')}</strong>
				<small>
					{t('Silences everything: the sound effects and the voice that reads German aloud. Listening and dictation exercises need that voice, so unmute before you do one of those.')}
				</small>
			</span>
		</label>

		<label class="row" class:off={progress.muted}>
			<input
				type="checkbox"
				checked={progress.soundEffects}
				disabled={progress.muted}
				onchange={(e) => {
					progress.setSoundEffects(e.currentTarget.checked);
					if (e.currentTarget.checked) playSound('right');
				}}
			/>
			<span>
				<strong>{t('Sound effects')}</strong>
				<small>
					{t('A chime for a right answer — climbing higher as your streak grows — a soft low note for a miss, and a little fanfare when you finish. Separate from the calm setting below, so you can have one without the other.')}
				</small>
			</span>
		</label>

		<label class="row">
			<input
				type="checkbox"
				checked={progress.calmEffects}
				onchange={(e) => progress.setCalmEffects(e.currentTarget.checked)}
			/>
			<span>
				<strong>{t('Calm effects')}</strong>
				<small>
					{t('Turns off the flashy extras: confetti, the words of praise that pop up after a right answer, the coloured glow at the screen edges, the shake after a miss and the flickering streak flame. Right and wrong are still shown in the answer itself. Your device’s “reduce motion” setting does the same.')}
				</small>
			</span>
		</label>

		<label class="row">
			<input
				type="checkbox"
				checked={progress.showTranscripts}
				onchange={(e) => progress.setShowTranscripts(e.currentTarget.checked)}
			/>
			<span>
				<strong>{t('Show the text in listening exercises')}</strong>
				<small>
					{t('For when you can’t hear the audio: dictations and listening exercises get a “Show the text” button, so you can read what is said instead of hearing it. The picture hunt’s Listen step shows its word written.')}
				</small>
			</span>
		</label>

		<label class="row">
			<input
				type="checkbox"
				checked={progress.autoSpeak}
				onchange={(e) => progress.setAutoSpeak(e.currentTarget.checked)}
			/>
			<span>
				<strong>{t('Say questions and answers aloud')}</strong>
				<small>
					{t('The voice reads the German question as it appears and the answer after you check. Turn it off if you use a screen reader, so two voices don’t talk at once. The play buttons still work, and a question you can only hear is still said.')}
				</small>
			</span>
		</label>
	</section>

	<!-- The deck deals no surprises in Turkish mode. -->
	{#if !lang.tr}
	<section class="card">
		<h2>Surprises</h2>
		<label class="row">
			<input
				type="checkbox"
				checked={progress.surprises}
				onchange={(e) => progress.setSurprises(e.currentTarget.checked)}
			/>
			<span>
				<strong>Games in the deck</strong>
				<small>
					Now and then your deck slips in a surprise: a round of Ja oder Nein?,
					Wortblöcke or a quick word check. Never more than one in a hand. Turn this off and the deck
					deals only exercises. The games and stories are still in the
					Library menu whenever you want them.
				</small>
			</span>
		</label>
	</section>
	{/if}

	<section class="card">
		<h2>{t('Answer reveal')}</h2>
		<p class="lede">
			{t('After you answer, the correct spelling is written into the gap — green when you had it, red when you didn’t. This is how long it stays before the next question. “Wait for me” never moves on by itself: press Next or Enter when you’re ready.')}
		</p>
		<div class="segmented" role="radiogroup" aria-label={t('Answer reveal speed')} use:radioKeys>
			{#each [['quick', t('Quick')], ['normal', t('Normal')], ['slow', t('Slow')], ['manual', t('Wait for me')]] as [mode, label] (mode)}
				<button
					type="button"
					role="radio"
					aria-checked={progress.answerRevealMode === mode}
					tabindex={progress.answerRevealMode === mode ? 0 : -1}
					onclick={() => progress.setAnswerRevealMode(mode as AnswerRevealMode)}
				>
					{label}
				</button>
			{/each}
		</div>
	</section>

	<section class="card">
		<h2>{t('Start where you like')}</h2>
		<p class="lede">
			{t('Every level is open from the start — nothing has to be unlocked. Already speak some German? Jump straight in at your level.')}
		</p>
		<ul class="levels">
			{#each ladder as level (level.id)}
				{#if level.quizzes.length > 0 && (!lang.tr || levelInTurkish(level.level))}
					<li>
						<span>{level.title}</span>
						<a href="/course/{course?.id}/quiz/{level.quizzes[0].id}">{t('Start here')}</a>
					</li>
				{/if}
			{/each}
		</ul>
	</section>

	<!-- Hidden 2026-11-05: the whole-level printed book (/book/<level>) is withdrawn
	     until a new A1 book (Book v2 A1.1 + A1.2) replaces it. The progress pages stay
	     reachable by URL so QR codes in any printed copy still open them. -->
	{#if SHOW_PRINTED_BOOK}
	<section class="card">
		<h2>My book</h2>
		<p class="lede">
			Working through the printed book? Tell the app what you did on paper, unit by unit, and it counts as done here too. No check, no score: a tick is a tick.
		</p>
		<ul class="levels">
			{#each ['A1', 'A2', 'B1', 'B2', 'C1', 'C2'] as b (b)}
				<li>
					<span>Deutsch {b}</span>
					<a href="/course/{course?.id ?? catalog.defaultCourseId}/book/{b}/progress">Open the checklist</a>
				</li>
			{/each}
		</ul>
	</section>
	{/if}

	{#if account.available && !lang.tr}
		<section class="card">
			<h2>Save your progress</h2>
			<AccountCard heading={false} />
		</section>
	{/if}

	<section class="card" id="your-data">
		<h2>{t('Your data')}</h2>
		<p class="lede">
			{#if lang.tr}
				{t('Download everything this site stores about you as one file: your progress and settings in this browser.')}
			{:else}
			Download everything this site stores about you as one file:
			{#if account.signedIn}
				your progress in this browser and in the cloud, your account details, and your forum
				topics, replies and likes.
			{:else}
				your progress and settings in this browser (without an account, that is all there is).
			{/if}
			{/if}
		</p>
		<button class="btn-quiet" onclick={downloadMyData} disabled={exporting}>
			<Icon name="download" size="1em" />
			{exporting ? t('Collecting…') : t('Download my data')}
		</button>
		{#if exportError}<p class="error" role="alert">{exportError}</p>{/if}

		<!-- Account management is English-only, like signing in. -->
		{#if lang.tr}
			<!-- nothing: Turkish mode has no account screens -->
		{:else if account.close === 'relink'}
			<div class="closing" role="status">
				<p>
					<strong>Almost done.</strong> Everything stored in the cloud is deleted. To remove your
					sign-in address too, open the link we just emailed you — that finishes closing the
					account.
				</p>
				<button class="btn-quiet" onclick={() => account.cancelClose()}>Leave it for now</button>
			</div>
		{:else if account.signedIn}
			<h3>Close your account</h3>
			<p class="lede">
				Deletes your synced progress, your forum name, every topic you started (with its
				replies), every reply and like you left, and your sign-in address. This cannot be
				undone.
			</p>
			{#if confirmingClose}
				<label class="row">
					<input type="checkbox" bind:checked={wipeLocal} />
					<span>
						Also delete my progress in this browser
						<small>Otherwise it stays here, as after signing out.</small>
					</span>
				</label>
				<label class="confirm">
					Type <strong>delete</strong> to confirm
					<input type="text" bind:value={closeTyped} autocomplete="off" spellcheck="false" />
				</label>
				<button
					class="danger-btn"
					onclick={closeAccount}
					disabled={closeTyped.trim().toLowerCase() !== 'delete' || account.close === 'closing'}
				>
					<Icon name="trash" size="1em" />
					{account.close === 'closing' ? 'Deleting…' : 'Close my account'}
				</button>
				<button class="btn-quiet" onclick={() => ((confirmingClose = false), (closeTyped = ''))}>Cancel</button>
			{:else}
				<button class="danger-btn" onclick={() => (confirmingClose = true)}>
					<Icon name="trash" size="1em" /> Close my account…
				</button>
			{/if}
			{#if closeError}<p class="error" role="alert">{closeError}</p>{/if}
		{/if}
	</section>

	<section class="card">
		<h2>{t('Privacy')}</h2>
		{#if lang.tr}
			<p class="lede">
				{t('This site uses no cookies and collects no personal data. Anonymous usage statistics (which pages are visited, and whether a visit comes from a search engine or a shared link) are gathered without any identifier, via Aptabase in the EU. The only thing kept on your device for statistics is the date of your first visit, so we can tell new visitors from returning ones in aggregate. Your learning progress stays in this browser and never leaves it. The full privacy notice (in English) names every service involved:')}
				<a href="/legal">{t('privacy notice')}</a>
			</p>
		{:else}
		<p class="lede">
			This site uses no cookies and collects no personal data. Anonymous usage
			statistics (which pages are visited, and whether a visit comes from a
			search engine or a shared link) are gathered without any identifier,
			via Aptabase in the EU. The only thing kept on your device for
			statistics is the date of your first visit — no name, no ID, nothing
			unique — so we can tell new visitors from returning ones in aggregate.
			Your learning progress stays in this browser and never leaves it, unless
			you choose to sign in above — and then the only thing stored is your
			email address and your own scores. The full <a href="/legal">privacy notice</a>
			names every service involved.
		</p>
		{/if}
	</section>

	<section class="card danger">
		<h2>{t('Start over')}</h2>
		<p class="lede">
			{t('Clears every score, streak and medal in this browser. This cannot be undone.')}
		</p>
		{#if confirmingReset}
			<button class="danger-btn" onclick={resetEverything}>
				<Icon name="trash" size="1em" /> {t('Yes, delete my progress')}
			</button>
			<button class="btn-quiet" onclick={() => (confirmingReset = false)}>{t('Cancel')}</button>
		{:else}
			<button class="danger-btn" onclick={() => (confirmingReset = true)}>
				<Icon name="trash" size="1em" /> {t('Delete all progress')}
			</button>
		{/if}
	</section>
</main>

<style>
	h1 {
		margin: 0 0 1.25rem;
	}

	h2 {
		margin: 0 0 0.6rem;
		font-size: 1.05rem;
	}

	.card {
		padding: 1.35rem 1.6rem;
		margin-bottom: 1rem;
		border: 1px solid var(--line);
		border-radius: var(--radius);
		background: var(--surface);
	}

	.card.danger {
		border-color: var(--wrong);
	}

	.lede {
		margin: 0 0 1rem;
		font-size: var(--step--1);
		color: var(--ink-muted);
	}

	.message {
		display: flex;
		align-items: flex-start;
		gap: 0.5rem;
		max-width: none;
		padding: 0.85rem 1.05rem;
		margin-bottom: 1rem;
		border: 1px solid var(--right);
		border-radius: var(--radius-sm);
		background: var(--right-bg);
		color: var(--right);
	}

	.row {
		display: flex;
		gap: 0.7rem;
		align-items: flex-start;
		padding: 0.6rem 0;
		cursor: pointer;
	}

	.row input {
		margin-top: 0.25rem;
	}

	/* A switch that the mute currently overrides. */
	.row.off {
		opacity: 0.55;
		cursor: default;
	}

	.row small {
		display: block;
		margin-top: 0.1rem;
		color: var(--ink-muted);
		font-size: var(--step--1);
	}

	.segmented {
		display: inline-flex;
		padding: 0.2rem;
		border: 1px solid var(--line-strong);
		border-radius: 6px;
		background: var(--surface-alt);
	}

	.segmented button {
		padding: 0.35rem 1.1rem;
		border: 0;
		border-radius: 4px;
		background: none;
		color: var(--ink-muted);
		font: inherit;
		font-size: var(--step--1);
		font-weight: 600;
		cursor: pointer;
		transition:
			background var(--fast) var(--ease-out),
			color var(--fast) var(--ease-out);
	}

	@media (max-width: 30rem) {
		.segmented button {
			padding: 0.35rem 0.7rem;
			white-space: nowrap;
		}
	}

	/* Four options don't fit one row on the smallest phones: two by two. */
	@media (max-width: 24rem) {
		.segmented:has(> :nth-child(4)) {
			display: grid;
			grid-template-columns: 1fr 1fr;
			border-radius: var(--radius-sm);
		}
	}

	.segmented button[aria-checked='true'] {
		background: var(--surface);
		color: var(--ink);
		box-shadow: 0 1px 3px rgba(42, 42, 40, 0.12);
	}

	.levels {
		margin: 0;
		padding: 0;
		list-style: none;
	}

	.levels li {
		display: flex;
		align-items: center;
		justify-content: space-between;
		gap: 1rem;
		padding: 0.45rem 0;
		border-top: 1px solid var(--line);
		font-size: var(--step--1);
	}

	.levels a {
		flex: none;
		padding: 0.32rem 0.9rem;
		border: 1px solid var(--line-strong);
		border-radius: 6px;
		background: var(--surface);
		color: var(--ink);
		font-size: var(--step--1);
		font-weight: 600;
		text-decoration: none;
		transition:
			border-color var(--fast) var(--ease-out),
			color var(--fast) var(--ease-out);
	}

	.levels a:hover {
		border-color: var(--accent);
		color: var(--accent-ink);
	}


	.danger-btn {
		display: inline-flex;
		align-items: center;
		gap: 0.4rem;
		padding: 0.58rem 1.2rem;
		border: 0;
		border-radius: 6px;
		background: var(--wrong);
		color: #fff;
		font: inherit;
		font-weight: 600;
		cursor: pointer;
		transition: transform var(--fast) var(--ease-out);
	}

	.danger-btn:disabled {
		opacity: 0.5;
		cursor: not-allowed;
		transform: none;
	}

	h3 {
		margin: 1.4rem 0 0.4rem;
		padding-top: 1.1rem;
		border-top: 1px solid var(--line);
		font-size: var(--step-0);
	}

	.error {
		margin: 0.6rem 0 0;
		color: var(--wrong);
		font-size: var(--step--1);
	}

	.closing {
		margin-top: 1.2rem;
		padding: 0.9rem 1.05rem;
		border: 1px solid var(--line-strong);
		border-radius: var(--radius-sm);
		background: var(--surface-alt);
		font-size: var(--step--1);
	}

	.closing p {
		margin: 0 0 0.7rem;
	}

	.confirm {
		display: flex;
		flex-wrap: wrap;
		align-items: center;
		gap: 0.6rem;
		margin: 0.4rem 0 1rem;
		font-size: var(--step--1);
	}

	.confirm input {
		width: 8rem;
		padding: 0.4rem 0.6rem;
		border: 1px solid var(--line-strong);
		border-radius: 6px;
		background: var(--surface);
		color: var(--ink);
		font: inherit;
	}

	.danger-btn:hover {
		transform: translateY(-1px);
	}
	.alt {
		font-weight: 400;
		color: var(--ink-muted);
	}
</style>
