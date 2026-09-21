<script lang="ts">
	// The Word Library: the shared German noun and verb collections, with
	// gender colouring and the conjugation tables. Reads the same
	// assets/content/shared/** files the Flutter app shipped.
	import SpeakButton from '$lib/components/SpeakButton.svelte';
	import Icon from '$lib/icons/Icon.svelte';
	import { slide } from 'svelte/transition';
	import nounData from '$content/shared/nouns/de.json';
	import verbData from '$content/shared/verbs/de.json';

	interface Noun {
		noun: string;
		gender: string;
		english: string;
		categories: string[];
		plural?: string;
		sentence?: string;
	}
	interface VerbForm {
		person: string;
		form: string;
	}
	interface VerbSet {
		label: string;
		forms: VerbForm[];
	}
	interface Verb {
		verb: string;
		english: string;
		sets: VerbSet[];
	}

	const nouns = (nounData as { nouns: Noun[] }).nouns;
	const verbs = (verbData as { verbs: Verb[] }).verbs;
	const categoryNames = (nounData as { categoryDisplayNames: Record<string, string> })
		.categoryDisplayNames;

	const LOCALE = 'de-DE';
	/** The gender colours the quizzes use, so the two views agree. */
	const GENDER_COLORS: Record<string, string> = {
		m: '#2E6FB7',
		f: '#C0446A',
		n: '#3F7D4E'
	};
	const ARTICLES: Record<string, string> = { m: 'der', f: 'die', n: 'das' };

	let tab = $state<'nouns' | 'verbs'>('nouns');
	let search = $state('');
	let openWord = $state<string | null>(null);

	const filteredNouns = $derived(
		nouns.filter(
			(n) =>
				!search ||
				n.noun.toLowerCase().includes(search.toLowerCase()) ||
				n.english.toLowerCase().includes(search.toLowerCase())
		)
	);
	const filteredVerbs = $derived(
		verbs.filter(
			(v) =>
				!search ||
				v.verb.toLowerCase().includes(search.toLowerCase()) ||
				v.english.toLowerCase().includes(search.toLowerCase())
		)
	);
</script>

<svelte:head>
	<title>Word Library — Language Quiz</title>
	<meta
		name="description"
		content="Every German noun and verb in the course: genders, plurals and full conjugation tables, each with audio."
	/>
</svelte:head>

<main class="page-wide">
	<a class="back-link" href="/"><Icon name="arrowLeft" size="1em" /> Home</a>
	<h1>Word Library</h1>

	<div class="tabs" role="tablist">
		<button role="tab" aria-selected={tab === 'nouns'} onclick={() => (tab = 'nouns')}>
			Nouns ({nouns.length})
		</button>
		<button role="tab" aria-selected={tab === 'verbs'} onclick={() => (tab = 'verbs')}>
			Verbs ({verbs.length})
		</button>
	</div>

	<div class="search">
		<Icon name="search" size="1.05em" />
		<input bind:value={search} placeholder="Search nouns and verbs…" type="search" />
	</div>

	{#if tab === 'nouns'}
		<ul class="grid">
			{#each filteredNouns as noun (noun.noun)}
				<li>
					<button class="word" onclick={() => (openWord = openWord === noun.noun ? null : noun.noun)}>
						<span class="article" style="color:{GENDER_COLORS[noun.gender]}">
							{ARTICLES[noun.gender] ?? ''}
						</span>
						<span class="term">{noun.noun}</span>
						<span class="gloss">{noun.english}</span>
					</button>
					{#if openWord === noun.noun}
						<div class="detail" transition:slide={{ duration: 180 }}>
							<p>
								<strong style="color:{GENDER_COLORS[noun.gender]}">
									{ARTICLES[noun.gender]} {noun.noun}
								</strong>
								<SpeakButton text="{ARTICLES[noun.gender]} {noun.noun}" locale={LOCALE} />
							</p>
							{#if noun.plural}<p class="meta">Plural: {noun.plural}</p>{/if}
							<p class="meta">
								{noun.categories.map((c) => categoryNames[c] ?? c).join(' · ')}
							</p>
						</div>
					{/if}
				</li>
			{/each}
		</ul>
	{:else}
		<ul class="grid">
			{#each filteredVerbs as verb (verb.verb)}
				<li>
					<button class="word" onclick={() => (openWord = openWord === verb.verb ? null : verb.verb)}>
						<span class="term">{verb.verb}</span>
						<span class="gloss">{verb.english}</span>
					</button>
					{#if openWord === verb.verb}
						<div class="detail" transition:slide={{ duration: 180 }}>
							<p>
								<strong>{verb.verb}</strong>
								<SpeakButton text={verb.verb} locale={LOCALE} />
							</p>
							{#each verb.sets as set (set.label)}
								<table>
									<caption>{set.label}</caption>
									<tbody>
										{#each set.forms as form (form.person)}
											<tr>
												<th scope="row">{form.person}</th>
												<td>{form.form}</td>
											</tr>
										{/each}
									</tbody>
								</table>
							{/each}
						</div>
					{/if}
				</li>
			{/each}
		</ul>
	{/if}
</main>

<style>
	h1 {
		margin: 0 0 1rem;
	}

	.tabs {
		display: flex;
		gap: 0.5rem;
		margin-bottom: 1rem;
	}

	.tabs button {
		padding: 0.45rem 1.1rem;
		border: 1px solid var(--line-strong);
		border-radius: 999px;
		background: var(--surface);
		color: var(--ink);
		font: inherit;
		font-weight: 600;
		font-size: var(--step--1);
		cursor: pointer;
		transition:
			background var(--fast) var(--ease-out),
			border-color var(--fast) var(--ease-out),
			color var(--fast) var(--ease-out);
	}

	.tabs button[aria-selected='true'] {
		background: var(--navy);
		border-color: var(--navy);
		color: #fff;
	}

	.search {
		display: flex;
		align-items: center;
		gap: 0.55rem;
		padding: 0.15rem 0.9rem;
		margin-bottom: 1.25rem;
		border: 1px solid var(--line-strong);
		border-radius: 999px;
		background: var(--surface);
		color: var(--ink-muted);
		transition:
			border-color var(--fast) var(--ease-out),
			box-shadow var(--fast) var(--ease-out);
	}

	.search:focus-within {
		border-color: var(--accent);
		box-shadow: 0 0 0 3px var(--accent-soft);
	}

	.search input {
		flex: 1;
		min-width: 0;
		padding: 0.55rem 0;
		border: 0;
		background: none;
		font: inherit;
		color: var(--ink);
	}

	.search input:focus {
		outline: none;
	}

	.grid {
		margin: 0;
		padding: 0;
		list-style: none;
		display: grid;
		gap: 0.4rem;
		grid-template-columns: repeat(auto-fill, minmax(15rem, 1fr));
		align-items: start;
	}

	.word {
		display: flex;
		align-items: baseline;
		gap: 0.45rem;
		width: 100%;
		padding: 0.55rem 0.8rem;
		border: 1px solid var(--line);
		border-radius: var(--radius-sm);
		background: var(--surface);
		font: inherit;
		text-align: left;
		cursor: pointer;
		transition:
			border-color var(--fast) var(--ease-out),
			transform var(--fast) var(--ease-out);
	}

	.word:hover {
		border-color: var(--accent);
		transform: translateY(-1px);
	}

	.article {
		font-weight: 700;
		font-size: 0.85rem;
	}

	/* The German word is the content; its gloss is interface. */
	.term {
		font-family: 'Source Serif 4', ui-serif, Georgia, serif;
		font-size: var(--step-0);
		font-weight: 700;
		color: var(--ink);
	}

	.gloss {
		margin-left: auto;
		font-size: var(--step--1);
		color: var(--ink-muted);
	}

	.detail {
		padding: 0.8rem 0.95rem;
		border: 1px solid var(--line);
		border-top: 0;
		border-radius: 0 0 var(--radius-sm) var(--radius-sm);
		background: var(--surface-alt);
	}

	.detail p {
		margin: 0 0 0.35rem;
	}

	.meta {
		font-size: 0.85rem;
		color: var(--ink-muted);
	}

	table {
		width: 100%;
		margin: 0.5rem 0;
		border-collapse: collapse;
		font-size: 0.85rem;
	}

	caption {
		text-align: left;
		font-size: 0.7rem;
		font-weight: 800;
		letter-spacing: 0.08em;
		text-transform: uppercase;
		color: var(--accent);
		padding-bottom: 0.25rem;
	}

	th {
		text-align: left;
		font-weight: 500;
		color: var(--ink-muted);
		padding: 0.15rem 0.5rem 0.15rem 0;
		white-space: nowrap;
	}

	td {
		padding: 0.15rem 0;
		font-weight: 600;
	}
</style>
