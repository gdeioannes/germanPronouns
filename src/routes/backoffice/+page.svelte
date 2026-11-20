<script lang="ts">
	// The owner's back office: the answers from the feedback card, the menu's
	// Feedback link and the book questions. Only the account with a
	// site_owners/{uid} document (made by hand in the Firebase console) gets
	// anything here; the Firestore rules refuse everyone else, so this page is
	// only the view. Not in the sitemap, and noindex.
	//
	// Two tabs: Site (the site ratings) and Books (who downloads, the ratings
	// per book, mistakes reported, and the quotes to publish on /books).
	import Seo from '$lib/components/Seo.svelte';
	import SiteNav from '$lib/components/SiteNav.svelte';
	import Icon from '$lib/icons/Icon.svelte';
	import { page } from '$app/state';
	import { account } from '$lib/state/account.svelte';
	import { openSignIn } from '$lib/state/signin.svelte';
	import { BOOKS } from '$lib/content/books';
	import { feedback } from '$lib/state/feedback.svelte';
	import { isInternalDevice, setInternalDevice } from '$lib/services/analytics';
	import {
		deleteAudience,
		deleteFeedback,
		isSiteOwner,
		listAudience,
		listFeedback,
		publishedQuoteIds,
		setQuotePublished,
		type AudienceEntry,
		type FeedbackEntry
	} from '$lib/services/feedback';

	type Gate = 'checking' | 'signed-out' | 'not-owner' | 'owner' | 'unavailable';
	type Tab = 'site' | 'books';

	const WHO_LABEL = { me: 'Me', class: 'My class', child: 'My child', other: 'Someone else' } as const;
	const WHO_KEYS = ['me', 'class', 'child', 'other'] as const;

	let gate = $state<Gate>('checking');
	let tab = $state<Tab>('site');
	let entries = $state<FeedbackEntry[]>([]);
	let audience = $state<AudienceEntry[]>([]);
	let published = $state<Set<string>>(new Set());
	let loading = $state(false);
	let error = $state('');
	let starFilter = $state(0);
	let textOnly = $state(false);

	$effect(() => {
		const uid = account.userId;
		if (!account.available) {
			gate = 'unavailable';
			return;
		}
		if (!uid) {
			// A session is being restored for a moment after load.
			gate = 'checking';
			const t = setTimeout(() => {
				if (!account.userId) gate = 'signed-out';
			}, 2500);
			return () => clearTimeout(t);
		}
		gate = 'checking';
		void isSiteOwner(uid).then((owner) => {
			if (account.userId !== uid) return;
			gate = owner ? 'owner' : 'not-owner';
			if (owner) void load();
		});
	});

	async function load() {
		loading = true;
		error = '';
		try {
			[entries, audience, published] = await Promise.all([listFeedback(), listAudience(), publishedQuoteIds()]);
		} catch (cause) {
			console.error('[backoffice]', cause);
			error = 'Could not load the feedback. Are the new Firestore rules published?';
		} finally {
			loading = false;
		}
	}

	async function remove(entry: FeedbackEntry) {
		if (!confirm('Delete this answer for good?')) return;
		try {
			await deleteFeedback(entry.id);
			entries = entries.filter((e) => e.id !== entry.id);
		} catch {
			error = 'Delete failed.';
		}
	}

	async function removeAudience(entry: AudienceEntry) {
		if (!confirm('Delete this answer for good?')) return;
		try {
			await deleteAudience(entry.id);
			audience = audience.filter((e) => e.id !== entry.id);
		} catch {
			error = 'Delete failed.';
		}
	}

	async function togglePublished(entry: FeedbackEntry) {
		const on = !published.has(entry.id);
		try {
			await setQuotePublished(entry, on);
			const next = new Set(published);
			if (on) next.add(entry.id);
			else next.delete(entry.id);
			published = next;
		} catch {
			error = 'Could not change the quote.';
		}
	}

	// This device in the analytics: the owner's own visits are not counted.
	// Opening the back office as the owner marks the device by itself; the
	// switch undoes it. (Phones that never sign in: open any page once with
	// ?internal=1.)
	let internalDevice = $state(false);
	$effect(() => {
		if (gate !== 'owner') return;
		if (!isInternalDevice()) setInternalDevice(true);
		internalDevice = isInternalDevice();
	});
	function toggleInternal() {
		setInternalDevice(!internalDevice);
		internalDevice = isInternalDevice();
	}

	let testNote = $state('');
	function resetQuestions() {
		feedback.resetThisBrowser();
		feedback.skipWaitThisBrowser();
		testNote = 'Done. In this browser every question can show again, and the 5 minutes count as passed.';
	}

	const avg = (list: FeedbackEntry[]) => (list.length ? list.reduce((s, e) => s + e.rating, 0) / list.length : 0);

	// -- Site tab
	const siteEntries = $derived(entries.filter((e) => e.source !== 'book'));
	const siteCounts = $derived([5, 4, 3, 2, 1].map((n) => ({ n, count: siteEntries.filter((e) => e.rating === n).length })));
	const hasText = (e: FeedbackEntry) => Boolean(e.comment || e.wish || e.mistake || e.quote);
	const siteShown = $derived(
		siteEntries.filter((e) => (!starFilter || e.rating === starFilter) && (!textOnly || hasText(e)))
	);

	// -- Books tab
	const bookEntries = $derived(entries.filter((e) => e.source === 'book'));
	const whoTotals = $derived(WHO_KEYS.map((w) => ({ w, count: audience.filter((a) => a.who === w).length })));
	const perBook = $derived(
		BOOKS.map((b) => {
			const rated = bookEntries.filter((e) => e.book === b.level);
			const who = WHO_KEYS.map((w) => audience.filter((a) => a.book === b.level && a.who === w).length);
			return { level: b.level, who, asked: who.reduce((s, n) => s + n, 0), ratings: rated.length, avg: avg(rated) };
		}).filter((r) => r.asked || r.ratings)
	);
	const schools = $derived(audience.filter((a) => a.school));
	const bookShown = $derived(bookEntries.filter((e) => !textOnly || hasText(e)));

	const pct = (n: number, total: number) => (total ? Math.round((n / total) * 100) : 0);
	const fmt = (ms: number) => new Date(ms).toLocaleString(undefined, { dateStyle: 'medium', timeStyle: 'short' });
	/** Visitor-written: a link only when it is a plain path on this site. */
	const safePath = (p: string) => /^\/(?!\/)[\w\-./~%]*$/.test(p);
</script>

<Seo title="Back office" description="The site owner's feedback inbox." path="/backoffice" noindex />

<SiteNav courseHref={page.data.site?.courseHref ?? '/'} />

<main class="page page-wide">
	<h1>Back office</h1>

	{#if gate === 'checking'}
		<p class="muted" role="status">Checking your account…</p>
	{:else if gate === 'unavailable'}
		<p class="muted">This build has no Firebase project configured.</p>
	{:else if gate === 'signed-out'}
		<p class="muted">Sign in with the owner's account to see this page.</p>
		<button type="button" class="btn" onclick={openSignIn}>Sign in</button>
	{:else if gate === 'not-owner'}
		<p class="muted">Not available.</p>
	{:else}
		<div class="row">
			<div class="tabs" role="group" aria-label="Show">
				<button type="button" aria-pressed={tab === 'site'} onclick={() => (tab = 'site')}>
					Site <span class="tnum count">{siteEntries.length}</span>
				</button>
				<button type="button" aria-pressed={tab === 'books'} onclick={() => (tab = 'books')}>
					Books <span class="tnum count">{bookEntries.length + audience.length}</span>
				</button>
			</div>
			<button type="button" class="btn ghost" onclick={load} disabled={loading}>
				{loading ? 'Loading…' : 'Refresh'}
			</button>
		</div>

		{#if error}<p class="err" role="alert">{error}</p>{/if}

		<p class="device" role="status">
			{#if internalDevice}
				<strong>This device is not counted in the analytics.</strong> Your own visits stay out of the numbers.
			{:else}
				<strong>This device is counted in the analytics</strong> like any visitor.
			{/if}
			<button type="button" class="btn ghost" onclick={toggleInternal}>
				{internalDevice ? 'Count it again' : "Don't count this device"}
			</button>
		</p>

		<details class="testing">
			<summary>Testing the questions</summary>
			<p class="muted">
				Each question remembers in this browser that it was shown. To see them again: reset, then download a
				book, or open a book code (e.g. /b/a1-01) and check an exercise, or finish a quiz run with 8/10.
			</p>
			<button type="button" class="btn ghost" onclick={resetQuestions}>Reset the questions in this browser</button>
			{#if testNote}<p class="muted" role="status">{testNote}</p>{/if}
		</details>

		{#if tab === 'site'}
			<section aria-label="Site feedback">
				<div class="stats">
					<div class="stat">
						<span class="big tnum">{siteEntries.length ? avg(siteEntries).toFixed(1) : '–'}</span>
						<span class="muted">average of {siteEntries.length} ratings</span>
					</div>
					<div class="stat">
						<span class="big tnum">{siteEntries.filter(hasText).length}</span>
						<span class="muted">with written feedback</span>
					</div>
					<ul class="bars" aria-label="Ratings by stars">
						{#each siteCounts as c (c.n)}
							<li>
								<span class="tnum">{c.n}★</span>
								<span class="bar"><span style:width="{pct(c.count, siteEntries.length)}%"></span></span>
								<span class="tnum">{c.count}</span>
							</li>
						{/each}
					</ul>
				</div>

				<div class="filters">
					<label>
						Stars
						<select bind:value={starFilter}>
							<option value={0}>All</option>
							{#each [5, 4, 3, 2, 1] as n (n)}<option value={n}>{n}</option>{/each}
						</select>
					</label>
					<label class="check"><input type="checkbox" bind:checked={textOnly} /> Only with text</label>
					<span class="muted">{siteShown.length} shown</span>
				</div>

				{#if !loading && !siteShown.length}<p class="muted">Nothing here yet.</p>{/if}
				<ul class="list">
					{#each siteShown as e (e.id)}
						{@render entry(e)}
					{/each}
				</ul>
			</section>
		{:else}
			<section aria-labelledby="who-head">
				<h2 id="who-head">Who downloads the books</h2>
				<div class="stats">
					<div class="stat">
						<span class="big tnum">{audience.length}</span>
						<span class="muted">answers at download</span>
					</div>
					<ul class="bars" aria-label="Who the book is for">
						{#each whoTotals as w (w.w)}
							<li class="wide">
								<span>{WHO_LABEL[w.w]}</span>
								<span class="bar"><span style:width="{pct(w.count, audience.length)}%"></span></span>
								<span class="tnum">{w.count} · {pct(w.count, audience.length)}%</span>
							</li>
						{/each}
					</ul>
				</div>

				{#if perBook.length}
					<div class="table-wrap">
						<table>
							<caption class="muted">Per book</caption>
							<thead>
								<tr>
									<th scope="col">Book</th>
									{#each WHO_KEYS as w (w)}<th scope="col">{WHO_LABEL[w]}</th>{/each}
									<th scope="col">Ratings</th>
									<th scope="col">Average</th>
								</tr>
							</thead>
							<tbody>
								{#each perBook as r (r.level)}
									<tr>
										<th scope="row">{r.level}</th>
										{#each r.who as n, i (i)}<td class="tnum">{n}</td>{/each}
										<td class="tnum">{r.ratings}</td>
										<td class="tnum">{r.ratings ? `${r.avg.toFixed(1)}★` : '–'}</td>
									</tr>
								{/each}
							</tbody>
						</table>
					</div>
				{/if}

				{#if schools.length}
					<h3>Schools and courses</h3>
					<ul class="schools">
						{#each schools as a (a.id)}
							<li>
								<span class="school-name">{a.school}</span>
								<span class="muted">{a.book} · {fmt(a.at)}</span>
								<button type="button" class="del" aria-label="Delete this answer" onclick={() => removeAudience(a)}>
									<Icon name="trash" size="1em" />
								</button>
							</li>
						{/each}
					</ul>
				{/if}
			</section>

			<section aria-labelledby="book-fb-head">
				<div class="row">
					<h2 id="book-fb-head">Book ratings, mistakes and quotes</h2>
					<label class="check"><input type="checkbox" bind:checked={textOnly} /> Only with text</label>
				</div>
				{#if !loading && !bookShown.length}<p class="muted">Nothing here yet.</p>{/if}
				<ul class="list">
					{#each bookShown as e (e.id)}
						{@render entry(e)}
					{/each}
				</ul>
			</section>
		{/if}
	{/if}
</main>

{#snippet entry(e: FeedbackEntry)}
	<li class="item">
		<div class="meta">
			<span class="stars" aria-label="{e.rating} of 5 stars">{'★'.repeat(e.rating)}<span class="dim">{'★'.repeat(5 - e.rating)}</span></span>
			<span class="muted">{fmt(e.at)}</span>
			<span class="tag">{e.source === 'menu' ? 'Menu' : e.source === 'book' ? `Book ${e.book}` : 'Card'}</span>
			{#if e.code}<span class="tag">code {e.code}</span>{/if}
			{#if e.lang && e.lang !== 'en'}<span class="tag">{e.lang}</span>{/if}
			{#if safePath(e.page)}
				<a class="muted path" href={e.page}>{e.page}</a>
			{:else}
				<span class="muted path">{e.page}</span>
			{/if}
			<button type="button" class="del" aria-label="Delete this answer" onclick={() => remove(e)}>
				<Icon name="trash" size="1em" />
			</button>
		</div>
		{#if e.comment}
			<p class="q">{e.source === 'book' ? "What's missing / could be better" : "What didn't work / anything to say"}</p>
			<p class="text">{e.comment}</p>
		{/if}
		{#if e.wish}
			<p class="q">What would help to learn better</p>
			<p class="text">{e.wish}</p>
		{/if}
		{#if e.mistake}
			<p class="q">Mistake reported</p>
			<p class="text">{e.mistake}</p>
		{/if}
		{#if e.quote}
			<p class="q">Quote{e.name ? ` — ${e.name}` : ''}{e.quoteOk ? '' : ' (no permission to publish)'}</p>
			<blockquote class="text">{e.quote}</blockquote>
			{#if e.quoteOk}
				<label class="check publish">
					<input type="checkbox" checked={published.has(e.id)} onchange={() => togglePublished(e)} />
					Show on the books page
				</label>
			{/if}
		{/if}
	</li>
{/snippet}

<style>
	h1 {
		margin: 0 0 1rem;
	}

	h2 {
		margin: 1.5rem 0 0.75rem;
		font-size: var(--step-1);
	}

	h3 {
		margin: 1.5rem 0 0.5rem;
		font-size: var(--step-0);
	}

	.muted {
		color: var(--ink-muted);
	}

	.device {
		display: flex;
		flex-wrap: wrap;
		gap: 0.5rem 1rem;
		align-items: center;
		margin: 0 0 1rem;
		color: var(--ink-muted);
	}

	.testing {
		margin: 0 0 1.25rem;
		padding: 0.6rem 1rem;
		border: 1px dashed var(--line-strong);
		border-radius: 10px;
	}

	.testing summary {
		cursor: pointer;
		font-weight: 600;
	}

	.err {
		color: var(--wrong);
	}

	.row {
		display: flex;
		flex-wrap: wrap;
		align-items: center;
		justify-content: space-between;
		gap: 0.75rem 1rem;
		margin-bottom: 1rem;
	}

	.row h2 {
		margin: 1.5rem 0 0;
	}

	.tabs {
		display: inline-flex;
		gap: 0.25rem;
		padding: 0.25rem;
		border: 1px solid var(--line);
		border-radius: 999px;
		background: var(--surface);
	}

	.tabs button {
		min-height: 2.5rem;
		padding: 0 1rem;
		border: 0;
		border-radius: 999px;
		background: transparent;
		color: var(--ink-muted);
		font: inherit;
		font-weight: 600;
		cursor: pointer;
	}

	.tabs button[aria-pressed='true'] {
		background: var(--heading);
		color: #fff;
	}

	.count {
		margin-inline-start: 0.3rem;
		font-weight: 400;
		opacity: 0.8;
	}

	.btn {
		min-height: 2.75rem;
		padding: 0 1.1rem;
		border: 0;
		border-radius: 999px;
		background: var(--heading);
		color: #fff;
		font: inherit;
		font-weight: 600;
		cursor: pointer;
	}

	.btn.ghost {
		background: transparent;
		color: var(--heading);
		border: 1px solid var(--line-strong);
	}

	.stats {
		display: flex;
		flex-wrap: wrap;
		gap: 1rem 2.5rem;
		align-items: center;
		padding: 1rem 1.25rem;
		margin-bottom: 1rem;
		background: var(--surface);
		border: 1px solid var(--line);
		border-radius: 12px;
	}

	.stat {
		display: flex;
		flex-direction: column;
	}

	.big {
		font-family: 'Source Serif 4 Variable', 'Source Serif 4', ui-serif, Georgia, serif;
		font-size: var(--step-3);
		font-weight: 600;
		color: var(--heading);
		line-height: 1.1;
	}

	.bars {
		list-style: none;
		margin: 0;
		padding: 0;
		flex: 1 1 14rem;
		display: grid;
		gap: 0.2rem;
		font-size: 0.85rem;
	}

	.bars li {
		display: grid;
		grid-template-columns: 2.2rem 1fr 2.5rem;
		align-items: center;
		gap: 0.5rem;
	}

	.bars li.wide {
		grid-template-columns: 7rem 1fr 5rem;
	}

	.bar {
		height: 0.55rem;
		background: var(--surface-alt);
		border-radius: 99px;
		overflow: hidden;
	}

	.bar span {
		display: block;
		height: 100%;
		background: var(--accent);
	}

	.table-wrap {
		overflow-x: auto;
		margin-bottom: 1rem;
	}

	table {
		border-collapse: collapse;
		width: 100%;
		min-width: 34rem;
		font-size: 0.9rem;
	}

	caption {
		text-align: start;
		padding-bottom: 0.4rem;
	}

	th,
	td {
		padding: 0.45rem 0.6rem;
		border-bottom: 1px solid var(--line);
		text-align: start;
	}

	thead th {
		font-size: 0.8rem;
		color: var(--ink-muted);
	}

	.schools {
		list-style: none;
		margin: 0;
		padding: 0;
		display: grid;
		gap: 0.4rem;
	}

	.schools li {
		display: flex;
		flex-wrap: wrap;
		align-items: center;
		gap: 0.3rem 0.9rem;
		padding: 0.4rem 0.8rem;
		border: 1px solid var(--line);
		border-radius: 10px;
		background: var(--surface);
	}

	.school-name {
		font-weight: 600;
		overflow-wrap: anywhere;
	}

	.filters {
		display: flex;
		flex-wrap: wrap;
		align-items: center;
		gap: 0.75rem 1.5rem;
		margin-bottom: 1rem;
	}

	.filters select {
		margin-inline-start: 0.4rem;
		min-height: 2.4rem;
		font: inherit;
	}

	.check {
		display: inline-flex;
		align-items: center;
		gap: 0.4rem;
	}

	.publish {
		margin-top: 0.6rem;
		font-weight: 600;
		color: var(--heading);
	}

	.list {
		list-style: none;
		margin: 0;
		padding: 0;
		display: grid;
		gap: 0.75rem;
	}

	.item {
		padding: 0.9rem 1.1rem;
		background: var(--surface);
		border: 1px solid var(--line);
		border-radius: 12px;
	}

	.meta {
		display: flex;
		flex-wrap: wrap;
		align-items: center;
		gap: 0.4rem 0.9rem;
		font-size: 0.85rem;
	}

	.stars {
		color: var(--accent-ink);
		font-size: 1.05rem;
		letter-spacing: 0.05em;
	}

	.stars .dim {
		color: var(--line-strong);
	}

	.tag {
		padding: 0.05rem 0.5rem;
		border-radius: 99px;
		background: var(--surface-alt);
		font-size: 0.75rem;
		font-weight: 600;
	}

	.path {
		min-width: 0;
		overflow-wrap: anywhere;
	}

	.del {
		margin-inline-start: auto;
		display: inline-flex;
		align-items: center;
		justify-content: center;
		width: 2.5rem;
		height: 2.5rem;
		border: 1px solid var(--line);
		border-radius: 50%;
		background: transparent;
		color: var(--ink-muted);
		cursor: pointer;
	}

	.del:hover {
		color: var(--wrong);
		border-color: var(--wrong);
	}

	.q {
		margin: 0.7rem 0 0.15rem;
		font-size: 0.75rem;
		font-weight: 700;
		letter-spacing: 0.04em;
		text-transform: uppercase;
		color: var(--ink-muted);
	}

	.text {
		margin: 0;
		white-space: pre-wrap;
		overflow-wrap: anywhere;
		line-height: 1.55;
	}
</style>
