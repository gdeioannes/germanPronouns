<script lang="ts">
	// The literature poll: thirty public-domain books, five per level, each
	// with a free source text. One tap votes (several books are fine), with
	// the language the visitor wants the notes in. That language starts as the
	// site's own and can be changed; the synopses follow it. Counts come from
	// Firestore after load, so the prerendered page (titles, synopses in
	// English) needs no script and stays crawlable.
	import { onMount } from 'svelte';
	import Icon from '$lib/icons/Icon.svelte';
	import ShareButton from '$lib/components/ShareButton.svelte';
	import { fly } from 'svelte/transition';
	import { POLL_BOOKS, POLL_LEVELS, NOTE_LANGS, type PollLevel } from '$lib/content/bookPoll';
	import { publicDomainCutoff } from '$lib/content/literature';
	import { castVote, fetchTallies, myVotes, type BookTally } from '$lib/services/bookVotes';
	import { lang, RTL_LANGS, type UiLang } from '$lib/i18n/lang.svelte';
	import { announce } from '$lib/a11y.svelte';
	import { track } from '$lib/services/analytics';

	/** Short picture credits by book id (from the page load); null = made with AI. */
	let { pictureCredits = {} }: { pictureCredits?: Record<string, string | null> } = $props();

	// The site language is known before hydration, so this starts right.
	let noteLang = $state<UiLang>(lang.current);
	let level = $state<PollLevel | 'all'>('all');
	let mine = $state<Record<string, UiLang>>({});
	let tallies = $state<Record<string, BookTally> | null>(null);
	/** The thank-you card after a vote: which book, which notes language. */
	let thanks = $state<{ id: string; title: string; lang: UiLang } | null>(null);

	const shown = $derived(level === 'all' ? POLL_LEVELS : [level]);
	const rtl = $derived(RTL_LANGS.includes(noteLang));
	const langName = (id: UiLang) => NOTE_LANGS.find((l) => l.id === id)?.name ?? id;

	onMount(() => {
		mine = myVotes();
		fetchTallies().then((t) => (tallies = t));
	});

	/** "Most want: Español", once a book has a few votes and a clear lead. */
	function topLang(t: BookTally | undefined): UiLang | null {
		if (!t || t.count < 3) return null;
		const [best] = Object.entries(t.langs).sort((a, b) => (b[1] ?? 0) - (a[1] ?? 0));
		return best && (best[1] ?? 0) * 2 > t.count ? (best[0] as UiLang) : null;
	}

	async function toggle(id: string, title: string) {
		const had = mine[id];
		const step = had ? -1 : 1;
		const voteLang = had ?? noteLang;
		// Show the tap at once; the write follows.
		if (had) delete mine[id];
		else mine[id] = voteLang;
		if (tallies) {
			const t = (tallies[id] ??= { count: 0, langs: {} });
			t.count = Math.max(0, t.count + step);
			t.langs[voteLang] = Math.max(0, (t.langs[voteLang] ?? 0) + step);
		}
		thanks = had ? (thanks?.id === id ? null : thanks) : { id, title, lang: voteLang };
		announce(had ? `Vote for ${title} taken back.` : `Voted for ${title}, notes in ${langName(voteLang)}. Thank you!`);
		track('book_poll_vote', { book: id, lang: voteLang, vote: step === 1 });
		await castVote(id, voteLang, step);
	}
</script>

<section class="poll" aria-labelledby="poll-title">
	<h2 id="poll-title">Vote for the next book</h2>
	<p class="lede">
		Thirty classics, five for each level, all free to use: every author died in
		{publicDomainCutoff()} or earlier, and each book has a free original text to work from.
		Tap the ones you would read. You can vote for as many as you like.
	</p>

	<fieldset class="langs">
		<legend>Notes in</legend>
		<div class="choices">
			{#each NOTE_LANGS as l (l.id)}
				<label class:on={noteLang === l.id}>
					<input type="radio" name="note-lang" value={l.id} bind:group={noteLang} />
					<span lang={l.id}>{l.name}</span>
				</label>
			{/each}
		</div>
		<p class="hint">The language you would like the explanations in. The summaries below switch to it too.</p>
	</fieldset>

	<div class="levels" role="group" aria-label="Level">
		<button type="button" aria-pressed={level === 'all'} onclick={() => (level = 'all')}>All levels</button>
		{#each POLL_LEVELS as l (l)}
			<button type="button" aria-pressed={level === l} onclick={() => (level = l)}>{l}</button>
		{/each}
	</div>

	{#each shown as l (l)}
		<h3 class="level-head">{l}</h3>
		<ul class="books">
			{#each POLL_BOOKS.filter((b) => b.level === l) as b (b.id)}
				{@const t = tallies?.[b.id]}
				{@const top = topLang(t)}
				{@const voted = !!mine[b.id]}
				<li class="book" class:voted>
					<div class="head">
						<img class="pic" src="/img/lit/lit_{b.id}.webp" alt="" width="480" height="600" loading="lazy" decoding="async" />
						<div>
							<h4 lang="de">{b.title}</h4>
							<p class="by">{b.author} · {b.year}</p>
							<p class="credit">Picture: {pictureCredits[b.id] ?? 'drawn with AI'}</p>
						</div>
					</div>
					<p class="syn" lang={noteLang} dir={rtl ? 'rtl' : 'ltr'}>{b.synopsis[noteLang]}</p>
					<div class="foot">
						<button
							type="button"
							class="vote"
							aria-pressed={voted}
							onclick={() => toggle(b.id, b.title)}
						>
							<Icon name={voted ? 'check' : 'heart'} size="1em" />
							{voted ? 'Voted' : 'Vote'}
							<span class="sr-only">for {b.title}</span>
						</button>
						{#if tallies}
							<span class="count">
								{t?.count ?? 0}
								{(t?.count ?? 0) === 1 ? 'vote' : 'votes'}{#if top}
									· most want <span lang={top}>{langName(top)}</span>{/if}
							</span>
						{/if}
						{#if voted && mine[b.id] !== noteLang}
							<span class="note">your vote: notes in <span lang={mine[b.id]}>{langName(mine[b.id])}</span></span>
						{/if}
						<a class="src" href={b.source.href} target="_blank" rel="noopener">
							Free text: {b.source.site} <Icon name="external" size="0.85em" />
						</a>
					</div>
				</li>
			{/each}
		</ul>
	{/each}
</section>

<svelte:window onkeydown={(e) => e.key === 'Escape' && (thanks = null)} />

<!-- After a vote: thanks, and the ask that grows the poll. Not a modal: it
     sits at the foot of the screen and the list stays usable behind it. -->
{#if thanks}
	<div class="thanks" role="status" transition:fly={{ y: 28, duration: 240 }}>
		<button type="button" class="x" aria-label="Close" onclick={() => (thanks = null)}><Icon name="close" size="1em" /></button>
		<img src="/img/lit/lit_{thanks.id}.webp" alt="" width="480" height="600" />
		<div class="t-body">
			<p class="t-head">Thank you for voting!</p>
			<p>
				Your vote for <i lang="de">{thanks.title}</i> is in, with notes in
				<span lang={thanks.lang}>{langName(thanks.lang)}</span>. The book with the most votes is
				the next one we annotate, so share the poll with your friends: with their votes, your
				book could be next.
			</p>
			<div class="t-actions">
				<ShareButton
					where="poll"
					look="btn"
					label="Share with friends"
					text={`I voted for ${thanks.title} as the next German classic to get English notes. Which one would you read?`}
					path="/literature"
					props={{ book: thanks.id }}
				/>
				<button type="button" class="later" onclick={() => (thanks = null)}>Maybe later</button>
			</div>
		</div>
	</div>
{/if}

<style>
	.poll {
		margin: 2.4rem 0 0;
	}

	.poll h2 {
		font-size: var(--step-2);
		color: var(--heading);
	}

	.lede {
		max-width: var(--measure);
		line-height: 1.6;
	}

	.langs {
		margin: 1.2rem 0 0;
		padding: 0;
		border: 0;
	}

	legend {
		font-weight: 700;
		color: var(--heading);
		margin-bottom: 0.5rem;
	}

	.choices {
		display: flex;
		flex-wrap: wrap;
		gap: 0.4rem;
	}

	.choices label {
		position: relative;
		display: inline-flex;
		align-items: center;
		padding: 0.45rem 0.9rem;
		border: 1px solid var(--line-strong);
		border-radius: 999px;
		background: var(--surface);
		cursor: pointer;
	}

	.choices label.on {
		border-color: var(--accent-ink);
		background: var(--accent-soft);
		color: var(--accent-ink);
		font-weight: 700;
	}

	.choices label:focus-within {
		outline: 2px solid var(--accent-ink);
		outline-offset: 2px;
	}

	.choices input {
		position: absolute;
		opacity: 0;
		inset: 0;
		margin: 0;
		cursor: pointer;
	}

	.hint {
		margin: 0.5rem 0 0;
		font-size: var(--step--1);
		color: var(--ink-muted);
	}

	.levels {
		display: flex;
		flex-wrap: wrap;
		gap: 0.4rem;
		margin: 1.4rem 0 0;
	}

	.levels button {
		padding: 0.4rem 0.8rem;
		border: 1px solid var(--line-strong);
		border-radius: var(--radius-sm);
		background: var(--surface);
		color: var(--ink);
		font: inherit;
		cursor: pointer;
	}

	.levels button[aria-pressed='true'] {
		background: var(--heading);
		border-color: var(--heading);
		color: #fff;
		font-weight: 700;
	}

	.level-head {
		margin: 1.6rem 0 0.6rem;
		font-size: var(--step-1);
		color: var(--accent-ink);
	}

	.books {
		list-style: none;
		margin: 0;
		padding: 0;
		display: grid;
		grid-template-columns: repeat(auto-fill, minmax(min(100%, 19rem), 1fr));
		gap: 0.8rem;
	}

	.book {
		display: flex;
		flex-direction: column;
		gap: 0.5rem;
		padding: 1rem 1.1rem;
		border: 1px solid var(--line);
		border-radius: var(--radius);
		background: var(--surface);
	}

	.book.voted {
		border-color: var(--accent);
	}

	.head {
		display: grid;
		grid-template-columns: 5.5rem minmax(0, 1fr);
		gap: 0.9rem;
		align-items: start;
	}

	.pic {
		width: 100%;
		height: auto;
		border-radius: 4px;
		background: #f4efe6;
		box-shadow: 0 0 0 1px var(--line);
	}

	.credit {
		margin: 0.35rem 0 0;
		font-size: 0.72rem;
		line-height: 1.35;
		color: var(--ink-muted);
	}

	h4 {
		margin: 0;
		font-size: var(--step-0);
		color: var(--heading);
	}

	.by {
		margin: 0.15rem 0 0;
		font-size: var(--step--1);
		color: var(--ink-muted);
	}

	.syn {
		margin: 0;
		line-height: 1.55;
		flex: 1;
		text-align: start;
	}

	.foot {
		display: flex;
		flex-wrap: wrap;
		align-items: center;
		gap: 0.4rem 0.8rem;
	}

	.vote {
		display: inline-flex;
		align-items: center;
		gap: 0.4rem;
		padding: 0.45rem 0.95rem;
		border: 1px solid var(--accent-ink);
		border-radius: 999px;
		background: var(--surface);
		color: var(--accent-ink);
		font: inherit;
		font-weight: 700;
		cursor: pointer;
	}

	.vote[aria-pressed='true'] {
		background: var(--accent-ink);
		color: #fff;
	}

	.count,
	.note {
		font-size: var(--step--1);
		color: var(--ink-muted);
	}

	.src {
		margin-inline-start: auto;
		display: inline-flex;
		align-items: center;
		gap: 0.25rem;
		font-size: var(--step--1);
		color: var(--accent-ink);
		text-decoration: none;
	}

	.thanks {
		position: fixed;
		inset-inline: 0;
		bottom: max(1rem, env(safe-area-inset-bottom));
		z-index: 60;
		display: grid;
		grid-template-columns: 4.5rem minmax(0, 1fr);
		gap: 1rem;
		width: min(32rem, calc(100% - 2rem));
		margin: 0 auto;
		padding: 1.1rem 1.2rem;
		border: 1px solid var(--accent);
		border-radius: var(--radius);
		background: var(--surface);
		box-shadow: 0 18px 40px -18px rgba(31, 58, 95, 0.45);
	}

	.thanks img {
		width: 100%;
		height: auto;
		border-radius: 4px;
		box-shadow: 0 0 0 1px var(--line);
	}

	.t-head {
		margin: 0 1.6rem 0.3rem 0;
		font-family: var(--font-display, serif);
		font-size: var(--step-1);
		color: var(--heading);
	}

	.t-body p {
		margin: 0;
		line-height: 1.5;
	}

	.t-actions {
		display: flex;
		flex-wrap: wrap;
		align-items: center;
		gap: 0.5rem 1rem;
		margin-top: 0.9rem;
	}

	.later {
		padding: 0;
		border: 0;
		background: none;
		color: var(--ink-muted);
		font: inherit;
		cursor: pointer;
		text-decoration: underline;
		text-underline-offset: 0.2em;
	}

	.x {
		position: absolute;
		top: 0.5rem;
		inset-inline-end: 0.5rem;
		display: inline-flex;
		padding: 0.4rem;
		border: 0;
		border-radius: 50%;
		background: none;
		color: var(--ink-muted);
		cursor: pointer;
	}

	.x:hover {
		background: var(--surface-alt);
		color: var(--heading);
	}

	.sr-only {
		position: absolute;
		width: 1px;
		height: 1px;
		overflow: hidden;
		clip: rect(0 0 0 0);
		white-space: nowrap;
	}
</style>
