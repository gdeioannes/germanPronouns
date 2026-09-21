<script lang="ts">
	// The Word Library: the shared German noun and verb collections, with
	// gender colouring and the conjugation tables. Reads the same
	// assets/content/shared/** files the Flutter app shipped.
	import SpeakButton from '$lib/components/SpeakButton.svelte';
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
	<a class="back-link" href="/">← Home</a>
	<h1>Word Library</h1>

	<div class="tabs" role="tablist">
		<button role="tab" aria-selected={tab === 'nouns'} onclick={() => (tab = 'nouns')}>
			Nouns ({nouns.length})
		</button>
		<button role="tab" aria-selected={tab === 'verbs'} onclick={() => (tab = 'verbs')}>
			Verbs ({verbs.length})
		</button>
	</div>

	<input class="search" bind:value={search} placeholder="Search…" type="search" />

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
						<div class="detail">
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
						<div class="detail">
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
		padding: 0.45rem 1rem;
		border: 1px solid var(--line);
		border-radius: 999px;
		background: var(--surface);
		font: inherit;
		font-weight: 600;
		cursor: pointer;
	}

	.tabs button[aria-selected='true'] {
		background: var(--ink);
		border-color: var(--ink);
		color: #fff;
	}

	.search {
		width: 100%;
		padding: 0.6rem 0.85rem;
		margin-bottom: 1.25rem;
		border: 1px solid var(--line);
		border-radius: 10px;
		background: var(--surface);
		font: inherit;
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
		gap: 0.4rem;
		width: 100%;
		padding: 0.5rem 0.7rem;
		border: 1px solid var(--line);
		border-radius: 10px;
		background: var(--surface);
		font: inherit;
		text-align: left;
		cursor: pointer;
	}

	.word:hover {
		border-color: var(--accent);
	}

	.article {
		font-weight: 700;
		font-size: 0.85rem;
	}

	.term {
		font-weight: 600;
	}

	.gloss {
		margin-left: auto;
		font-size: 0.82rem;
		color: var(--muted);
	}

	.detail {
		padding: 0.75rem 0.9rem;
		border: 1px solid var(--line);
		border-top: 0;
		border-radius: 0 0 10px 10px;
		background: var(--surface-alt);
	}

	.detail p {
		margin: 0 0 0.35rem;
	}

	.meta {
		font-size: 0.85rem;
		color: var(--muted);
	}

	table {
		width: 100%;
		margin: 0.5rem 0;
		border-collapse: collapse;
		font-size: 0.85rem;
	}

	caption {
		text-align: left;
		font-weight: 700;
		color: var(--accent);
		padding-bottom: 0.2rem;
	}

	th {
		text-align: left;
		font-weight: 500;
		color: var(--muted);
		padding: 0.15rem 0.5rem 0.15rem 0;
		white-space: nowrap;
	}

	td {
		padding: 0.15rem 0;
		font-weight: 600;
	}
</style>
