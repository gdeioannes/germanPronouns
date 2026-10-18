<script lang="ts">
	// Every lesson diagram kind on one page, plus every diagram the course
	// actually uses (?all), for checking the drawing at phone and laptop
	// width. Dev only.
	import LessonVisual from '$lib/components/lesson/LessonVisual.svelte';
	import type { LessonVisual as Visual } from '$lib/content/types';
	import { page } from '$app/state';

	const SAMPLES: Visual[] = [
		{
			kind: 'bracket',
			caption: 'The verb is always the second element; its partner waits at the end.',
			rows: [
				{ cells: ['Ich', 'stehe', 'um sieben', 'auf'], en: 'I get up at seven.' },
				{ cells: ['Morgen', 'muss', 'ich früh', 'aufstehen'], en: 'Tomorrow I have to get up early.' },
				{ cells: ['Gestern', 'bin', 'ich spät', 'aufgestanden'], en: 'Yesterday I got up late.' }
			]
		},
		{
			kind: 'caseGrid',
			caption: 'Only the masculine changes in the accusative.',
			rows: [
				{ label: 'Nom', cells: ['der', 'die', 'das', 'die'] },
				{ label: 'Akk', cells: ['den', 'die', 'das', 'die'] }
			],
			hot: [[1, 0]]
		},
		{
			kind: 'people',
			columns: [
				{ label: 'sein', forms: ['bin', 'bist', 'ist', 'sind', 'seid', 'sind'] },
				{ label: 'haben', forms: ['habe', 'hast', 'hat', 'haben', 'habt', 'haben'] }
			],
			hot: [1, 2]
		},
		{
			kind: 'timeline',
			caption: 'seit reaches up to now; vor is a point in the past; in is a point ahead.',
			marks: [
				{ at: -2, to: 0, label: 'since 2020, still true', de: 'seit 2020' },
				{ at: -1, label: 'three years ago', de: 'vor drei Jahren' },
				{ at: 1.5, label: 'in two weeks', de: 'in zwei Wochen' }
			]
		},
		{
			kind: 'scale',
			low: 'possible',
			high: 'certain',
			points: [
				{ at: 95, de: 'Er muss krank sein.', en: 'He must be ill.' },
				{ at: 75, de: 'Er dürfte krank sein.', en: 'He is probably ill.' },
				{ at: 45, de: 'Er könnte krank sein.', en: 'He could be ill.' }
			]
		},
		{
			kind: 'tree',
			root: {
				q: 'Does the verb move you from A to B, or change your state?',
				yes: { answer: 'sein', de: 'Ich bin nach Berlin gefahren.' },
				no: { answer: 'haben', de: 'Ich habe Pizza gegessen.' }
			}
		},
		{
			kind: 'pairs',
			left: 'clause',
			right: 'noun phrase',
			rows: [
				{ a: 'weil es regnet', b: 'wegen des Regens' },
				{ a: 'nachdem wir gegessen hatten', b: 'nach dem Essen' }
			]
		},
		{
			kind: 'blocks',
			rows: [
				{ parts: [{ text: 'Apfel' }, { text: 'Kuchen', role: 'suffix' }], result: 'der Apfelkuchen', gender: 'm', en: 'apple cake' },
				{ parts: [{ text: 'auf', role: 'prefix' }, { text: 'ge', role: 'joint' }, { text: 'räum' }, { text: 't', role: 'ending' }], result: 'aufgeräumt' }
			]
		},
		{
			kind: 'clock',
			caption: 'halb looks forward to the next hour.',
			faces: [
				{ time: '7:30', de: 'halb acht', digital: '7:30' },
				{ time: '7:15', de: 'Viertel nach sieben', digital: '7:15' },
				{ time: '7:45', de: 'Viertel vor acht', digital: '7:45' }
			]
		},
		{
			kind: 'places',
			items: [
				{ prep: 'auf', mode: 'wo', spot: 'on', de: 'Die Katze ist auf dem Tisch.', en: 'on the table' },
				{ prep: 'auf', mode: 'wohin', spot: 'on', de: 'Die Katze springt auf den Tisch.', en: 'onto the table' },
				{ prep: 'unter', mode: 'wo', spot: 'under', de: 'unter dem Tisch' },
				{ prep: 'zwischen', mode: 'wo', spot: 'between', de: 'zwischen den Kisten' },
				{ prep: 'an', mode: 'wo', spot: 'at', de: 'an der Wand' },
				{ prep: 'aus', mode: 'woher', spot: 'in', de: 'aus der Kiste' }
			]
		},
		{
			kind: 'moves',
			moves: [
				{ label: 'Greeting', de: ['Liebe Anna,', 'Hallo Tom,'] },
				{ label: 'Why you write', de: ['ich schreibe dir, weil …'] },
				{ label: 'Sign-off', de: ['Viele Grüße', 'Bis bald!'] }
			]
		},
		{
			kind: 'textMap',
			blocks: [
				{ label: 'Who', de: 'Ich heiße Lena und bin 24 Jahre alt.', focus: ['24 Jahre'] },
				{ label: 'Where from', de: 'Ich komme aus Graz in Österreich.', focus: ['aus Graz'] }
			]
		}
	];

	let fromCourse = $state<{ id: string; title: string; tip: string; visual: Visual }[]>([]);
	$effect(() => {
		if (!import.meta.env.DEV || !page.url.searchParams.has('all')) return;
		import('$content/courses/de_cert_a1.json').then((m) => {
			const only = page.url.searchParams.get('all');
			fromCourse = (m.default as unknown as { quizzes: { id: string; title: string; help?: { tips?: { title?: string; visual?: Visual }[] } }[] }).quizzes
				.filter((q) => !only || q.id.includes(only))
				.flatMap((q) =>
					(q.help?.tips ?? []).flatMap((t) => (t.visual ? [{ id: q.id, title: q.title, tip: t.title ?? '', visual: t.visual }] : []))
				);
		});
	});
</script>

<svelte:head>
	<title>Lesson diagrams</title>
	<meta name="robots" content="noindex" />
</svelte:head>

{#if import.meta.env.DEV}
	<main class="gallery">
		{#if fromCourse.length}
			{#each fromCourse as item, i (i)}
				<section data-shot={item.id}>
					<h2>{item.title} · {item.tip}</h2>
					<p class="id">{item.id}</p>
					<LessonVisual visual={item.visual} />
				</section>
			{/each}
		{:else}
			{#each SAMPLES as v, i (i)}
				<section data-shot={v.kind}>
					<h2>{v.kind}</h2>
					<LessonVisual visual={v} />
				</section>
			{/each}
		{/if}
	</main>
{:else}
	<main class="gallery"><p>This page only exists in development.</p></main>
{/if}

<style>
	.gallery {
		max-width: 38rem;
		margin: 0 auto;
		padding: 1rem;
		display: grid;
		gap: 1.5rem;
	}
	h2 {
		margin: 0 0 0.4rem;
		font-size: 1rem;
		color: var(--heading);
	}
	.id {
		margin: 0 0 0.4rem;
		font-size: 0.75rem;
		color: var(--ink-muted);
	}
</style>
