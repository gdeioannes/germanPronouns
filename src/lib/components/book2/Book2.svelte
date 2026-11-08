<script lang="ts">
	import { hidesEnglish } from '$lib/domain/germanFirst';
	// Book v2: one chapter = nine A4 sheets (docs/book_v2_plan.md §3). The
	// companion's LearnBlock and ExerciseBlock draw the grammar and the
	// exercises; this file draws the pages around them: the word page, the
	// full-bleed opener, the reading, the document, the chapter end, the key.
	import ExerciseBlock from '$lib/components/companion/ExerciseBlock.svelte';
	import LearnBlock from '$lib/components/companion/LearnBlock.svelte';
	import { rich } from '$lib/domain/companion';
	import { chapterKey, picturedWords, practiseOf, type Book2, type Chapter, type PhotoCredit } from '$lib/domain/book2';

	interface Qr {
		svg: string;
		code: string;
		url: string;
	}
	/** A code's address as it is printed: short enough to type from paper. */
	const shortUrl = (url: string) => url.replace(/^https?:\/\//, '');

	let {
		book,
		credits,
		qr,
		pages = {},
		cover = false,
		spineMm = 7.4,
		hd = false,
		siteQr = ''
	}: {
		book: Book2;
		credits: Record<string, PhotoCredit>;
		/** Only the wraparound print cover: back, spine, front on one sheet with 3 mm bleed. */
		cover?: boolean;
		spineMm?: number;
		/** Print originals (local only, gitignored); otherwise the 1400 px web copies. */
		hd?: boolean;
		/** The back cover's code to the site, as inline SVG. */
		siteQr?: string;
		/** Per chapter id: the app, Listen and Speak codes, when registered. */
		qr: Record<string, { app: Qr | null; listen: Qr | null; speak: Qr | null }>;
		/** Per chapter id and page part: the small code that opens that part in the app (domain/bookStudy). */
		pages?: Record<string, Partial<Record<string, Qr | null>>>;
	} = $props();

	/** Nine content pages and a notes page, so every chapter opens on a left-hand page. */
	const PAGES = 10;
	const photoBase = $derived(hd ? '/img/photo' : '/img/photo/web');
	/** Cover, how it works, contents: the first chapter opens on page 4, a left-hand page. */
	const FRONT = 3;
	const firstPage = (i: number) => FRONT + 1 + i * PAGES;
	const side = (p: number) => (p % 2 === 0 ? 'left' : 'right');
	const keyPage = $derived(firstPage(book.chapters.length));
	/** From B1 the rules are in German: the words they use, with their English, once. */
	const GRAMMAR_WORDS = [
		['das Nomen', 'noun'], ['das Verb', 'verb'], ['das Adjektiv', 'adjective'], ['der Artikel', 'article'],
		['das Pronomen', 'pronoun'], ['die Präposition', 'preposition'], ['die Endung', 'ending'],
		['der Singular', 'singular'], ['der Plural', 'plural'], ['maskulin, feminin, neutral', 'masculine, feminine, neuter'],
		['der Nominativ (wer?)', 'nominative'], ['der Akkusativ (wen?)', 'accusative'], ['der Dativ (wem?)', 'dative'], ['der Genitiv (wessen?)', 'genitive'],
		['der Infinitiv', 'infinitive'], ['das Präsens', 'present'], ['das Perfekt', 'perfect'], ['das Präteritum', 'simple past'], ['das Partizip', 'participle'],
		['der Satz', 'sentence'], ['der Hauptsatz', 'main clause'], ['der Nebensatz', 'subordinate clause'], ['der Relativsatz', 'relative clause'],
		['das Subjekt', 'subject'], ['das Objekt', 'object'], ['der Komparativ', 'comparative'], ['der Superlativ', 'superlative'],
		['trennbar', 'separable'], ['reflexiv', 'reflexive']
	];
	/** Two chapters of answers per key page. */
	const keyPages = $derived([...Array.from({ length: Math.ceil(book.chapters.length / 2) }, (_, i) => book.chapters.slice(i * 2, i * 2 + 2)), []]);

	const article = (de: string) => /^(der|die|das) /.exec(de)?.[1] ?? '';
	const bare = (de: string) => de.replace(/^(der|die|das) /, '');
	/** "die Äpfel" prints whole; "-n" prints as the ending; "–" as nothing. */
	const plural = (pl?: string) => (!pl || pl === '' ? '' : pl === '–' ? (hidesEnglish(book.level) ? 'kein Plural' : 'no plural') : pl.startsWith('-') || pl.startsWith('¨') ? `pl. ${pl}` : pl);
	const split = <T,>(xs: T[], n: number): [T[], T[]] => [xs.slice(0, n), xs.slice(n)];

	// The covers. The front is the market panorama's right half, the crop the
	// chapter's words page shows, so its pinned words land where the book pins
	// them; only the upper ones, clear of the title panel.
	const coverChapter = $derived(book.chapters.find((c) => c.id === (book.cover?.chapter ?? 'markt')) ?? book.chapters[2] ?? book.chapters[0]);
	const coverPins = $derived((coverChapter.opener.labels ?? []).filter((l) => l.y <= 52).slice(0, 6));
	/** The cities the chapters visit, in a fixed order, for the front's route line. */
	const CITIES = ['Berlin', 'München', 'Hamburg', 'Köln', 'Frankfurt', 'Leipzig', 'Dresden', 'Freiburg', 'Münster', 'Nürnberg', 'Heidelberg', 'Ulm', 'Rügen', 'Stuttgart', 'Göttingen', 'Sylt', 'Rothenburg', 'Passau', 'Karlsruhe', 'Wiesbaden', 'Papenburg', 'Wittenberg', 'Essen', 'Wien', 'Zürich'];
	const coverCities = $derived(CITIES.filter((city) => book.chapters.some((c) => c.world.includes(city))));

	// Fit pass. A page is a fixed A4 sheet with overflow hidden, so a chapter
	// whose words, fact box or exercises run long was simply cut off at the
	// footer. Once fonts and pictures are in, every page that runs past its
	// limit has its content zoomed down a step at a time (never below MIN) until
	// it fits; the text reflows to the full width at the smaller size. The
	// result lands on <html data-book-fit> for tool/gen-book2.mjs to wait for
	// and report: which pages shrank, and any that still overflow at MIN.
	const STEPS = [0.96, 0.92, 0.88, 0.84, 0.8, 0.77, 0.75];
	/** The opener's word panel (126 mm by design) may grow to this over the photo. */
	const PLATE_MAX = 165;
	let root = $state<HTMLElement>();

	function fitPage(page: HTMLElement): { zoom: number; over: number; plate?: number } | null {
		// Millimetres as drawn: the preview zooms the whole book on a narrow screen.
		const MM = page.getBoundingClientRect().width / 210;
		const plate = page.querySelector<HTMLElement>(':scope > .plate');
		const foot = page.querySelector<HTMLElement>(':scope > .foot');
		let units: HTMLElement[];
		let limit: () => number;
		if (plate) {
			// Chapter opener: a fixed panel at the foot of the photo holds the words.
			units = [...plate.children].filter((el): el is HTMLElement => el instanceof HTMLElement && getComputedStyle(el).position !== 'absolute');
			limit = () => plate.getBoundingClientRect().bottom - 5 * MM;
		} else if (foot && !page.classList.contains('words')) {
			units = [...page.children].filter((el): el is HTMLElement => el instanceof HTMLElement && el !== foot && getComputedStyle(el).position !== 'absolute');
			limit = () => foot.getBoundingClientRect().top - 1.5 * MM;
		} else return null;
		if (!units.length) return null;
		const bottom = () => {
			let b = -Infinity;
			for (const u of units) {
				b = Math.max(b, u.getBoundingClientRect().bottom);
				for (const el of u.querySelectorAll<HTMLElement>('*')) {
					if (el.closest('.fill')) continue; // writing space shrinks by design
					const r = el.getBoundingClientRect();
					if (r.height) b = Math.max(b, r.bottom);
				}
			}
			return b;
		};
		let over = bottom() - limit();
		if (over <= 0.5) return null;
		let zoom = 1;
		if (plate) {
			// An opener first gives the words more paper and the photo less, up to
			// PLATE_MAX, so its words keep their size; only then does it shrink.
			const grown = Math.min(PLATE_MAX, plate.getBoundingClientRect().height / MM + over / MM + 1);
			page.style.setProperty('--plate', `${grown.toFixed(1)}mm`);
			over = bottom() - limit();
			if (over <= 0.5) return { zoom, over: 0, plate: Math.round(grown) };
		}
		for (const z of STEPS) {
			for (const u of units) u.style.zoom = String(z);
			zoom = z;
			over = bottom() - limit();
			if (over <= 0.5) break;
		}
		const tall = page.style.getPropertyValue('--plate');
		return { zoom, over: Math.max(0, Math.round(over / MM)), plate: tall ? Math.round(parseFloat(tall)) : undefined };
	}

	/**
	 * The words page's code goes in the first corner where it touches no pinned
	 * word: the labels sit on their things, so the code is what moves. Returns
	 * the corner, or null when every corner is taken (it then stays top right).
	 */
	const CORNERS = ['tr', 'tl', 'br', 'bl'] as const;
	function placeWordsCode(page: HTMLElement): string | null {
		const code = page.querySelector<HTMLElement>('.page-code');
		if (!code) return 'tr';
		const labels = [...page.querySelectorAll<HTMLElement>('.pin .tag, .pin .dot, .eyebrow')].map((l) => l.getBoundingClientRect());
		// Inline, not a [data-corner] rule: Svelte drops CSS for attributes the template never sets.
		const at = (corner: (typeof CORNERS)[number]) => {
			const top = corner[0] === 't';
			const right = corner[1] === 'r';
			code.style.top = top ? (right ? '10mm' : '18mm') : 'auto';
			code.style.bottom = top ? '' : '18mm';
			code.style.right = right ? '' : 'auto';
			code.style.left = right ? '' : '10mm';
		};
		for (const corner of CORNERS) {
			at(corner);
			const r = code.getBoundingClientRect();
			if (!labels.some((o) => o.left < r.right && o.right > r.left && o.top < r.bottom && o.bottom > r.top)) return corner;
		}
		at('tr');
		return null;
	}

	$effect(() => {
		const el = root;
		if (!el) return;
		let gone = false;
		(async () => {
			await document.fonts.ready;
			await Promise.all(
				[...el.querySelectorAll('img')].map((img) =>
					img.complete ? null : new Promise((r) => { img.addEventListener('load', r, { once: true }); img.addEventListener('error', r, { once: true }); })
				)
			);
			if (gone) return;
			const report: string[] = [];
			el.querySelectorAll<HTMLElement>('section.page').forEach((page, i) => {
				const r = fitPage(page);
				if (r) report.push(`page ${i + 1}: ${r.plate ? `word panel ${r.plate} mm, ` : ''}${Math.round(r.zoom * 100)}%${r.over ? `, still ${r.over} mm over` : ''}`);
			});
			el.querySelectorAll<HTMLElement>('section.page.words').forEach((page, i) => {
				if (placeWordsCode(page) === null) report.push(`words page ${i + 1}: the code touches a label in every corner`);
			});
			(window as unknown as { __bookFit?: string[] }).__bookFit = report;
			document.documentElement.dataset.bookFit = 'done';
		})();
		return () => { gone = true; };
	});
</script>

<!-- The page's own code, top right: this page in the app. Checked against
     the key, the words as cards, the text read aloud. -->
{#snippet pageCode(c: Chapter, part: string, label: string)}
	{@const code = pages[c.id]?.[part]}
	{#if code}
		<a class="page-code" href={code.url} aria-label="Open this page in the app">
			{@html code.svg}
			<span>{label}</span>
		</a>
	{/if}
{/snippet}

{#snippet foot(page: number, c: Chapter)}
	<footer class="foot">
		<span class="tnum">{page}</span>
		<span><b>{c.n}</b> · {c.title} · <i>{c.world}</i></span>
	</footer>
{/snippet}

{#snippet fact(text?: string)}
	{#if text}
		<aside class="fact">
			<span class="eyebrow">Wusstest du?</span>
			<p>{@html rich(text)}</p>
		</aside>
	{/if}
{/snippet}

{#snippet filler(prompt: string, german = false)}
	<div class="fill">
		<p class="eyebrow">{german ? 'Schreib mit!' : 'Schreib mit! · your turn'}</p>
		<p class="fill-prompt">{prompt}</p>
		<div class="fill-lines"></div>
	</div>
{/snippet}

{#snippet photo(id: string, caption: string, cls = '')}
	<figure class="photo {cls}">
		<img src="{photoBase}/{id}.jpg" alt="" />
		<figcaption lang="de">{caption}</figcaption>
	</figure>
{/snippet}

{#snippet frontCover()}
	{@const c = coverChapter}
	<div class="fc" data-accent={c.accent}>
		<img class="fc-photo" src="{photoBase}/{c.opener.photo}.jpg" alt="" />
		<div class="fc-shade"></div>
		<header class="fc-brand">
			<img src="/icons/Icon-192.png" alt="" />
			<span><b>Language Quiz</b> · German for English speakers</span>
		</header>
		{#each coverPins as l (l.de)}
			{@const a = article(l.de)}
			<div class="pin {l.side ?? 'right'}" style:left="{l.x}%" style:top="{l.y}%">
				<span class="dot"></span>
				<span class="tag">
					<span class="de" lang="de">{#if a}<b class="art {a}">{a}</b>&nbsp;{/if}{bare(l.de)}</span>
					<span class="meta">{l.en}</span>
				</span>
			</div>
		{/each}
		<div class="fc-plate">
			<div class="fc-badge"><b>{book.level}</b><span>{book.cover?.badge ?? 'for complete beginners'}</span></div>
			<h1 lang="de">{book.title.replace(/\s*[A-C]\d\.\d$/, '')}</h1>
			<p class="fc-sub" lang="de">{book.subtitle}</p>
			<p class="fc-blurb">German in {book.chapters.length} real places: the words pinned on the things, a story in each place, and the grammar the story needs.</p>
			<p class="fc-route" lang="de">{#each coverCities as city, i (city)}{#if i}<i>·</i>{/if}<span class="nb">{city}</span> {/each}</p>
			<p class="fc-site">languagequiz.org</p>
		</div>
	</div>
{/snippet}

{#snippet backCover()}
	<div class="bc">
		<p class="bc-kicker">{book.title} · {book.subtitle}</p>
		<h2>German, one place at a time.</h2>
		<p class="bc-lede">{book.cover?.lede ?? 'A Späti at midnight. A market in Munich. A flat in Prenzlauer Berg, Sunday cake at Oma’s, the fish market at five in the morning. Twelve chapters, twelve real places, and the German you need in each of them.'}</p>
		<ol class="bc-places">
			{#each book.chapters as ch (ch.id)}
				<li>
					<img src="{photoBase}/{ch.opener.photo}.jpg" alt="" />
					<span class="n">{ch.n}</span>
					<span class="w" lang="de">{ch.world}</span>
				</li>
			{/each}
		</ol>
		<div class="bc-can">
			<p class="bc-can-title">After this book you can</p>
			<ul>
				{#each book.chapters as ch (ch.id)}{#if ch.canDo[0]}<li>{ch.canDo[0]}</li>{/if}{/each}
			</ul>
		</div>
		<div class="bc-points">
			<p><b>Words first.</b> Every chapter opens on a photograph with the words pinned to the things, so the first German you learn is what you can see.</p>
			<p><b>Real German.</b> {book.cover?.real ?? 'A price board, a doorbell, a menu, a form at the Bürgeramt'}: the texts Germany actually prints, photographed and read.</p>
			<p><b>Paper and phone.</b> Write in the book. Scan a code and the chapter is read aloud, a tutor talks with you, or the exercise opens in the app.</p>
			<p><b>Free.</b> The whole course, A1 to C2, is free at languagequiz.org. This book is its paper half.</p>
		</div>
		<footer class="bc-foot">
			{#if siteQr}<a class="bc-qr" href="https://languagequiz.org" aria-label="languagequiz.org">{@html siteQr}</a>{/if}
			<span class="bc-site"><img src="/icons/Icon-192.png" alt="" /><span><b>languagequiz.org</b><br />Start free, at your level.</span></span>
		</footer>
	</div>
{/snippet}

<div class="book2" class:wrap={cover} bind:this={root}>
{#if cover}
	{@const front = coverChapter}
	<section class="sheet" style:--spine="{spineMm}mm" data-accent={front.accent}>
		<div class="half backhalf">
			<div class="trim">{@render backCover()}</div>
		</div>
		<div class="spine"><span>{book.title} · {book.subtitle}</span><b>languagequiz.org</b></div>
		<div class="half fronthalf">
			<div class="trim">{@render frontCover()}</div>
		</div>
	</section>
{:else}
	<!-- 1 · cover -->
	<section class="page right cover">{@render frontCover()}</section>

	<!-- 2 · how this book works -->
	<section class="page left how">
		{#if hidesEnglish(book.level)}
		<header class="head small">
			<p class="eyebrow">Bevor du anfängst</p>
			<h2>So funktioniert dieses Buch</h2>
		</header>
		<div class="how-cols">
			<div>
				<p>Jedes Kapitel ist ein Ort. Der Ort bringt die Wörter, die Wörter bringen die Geschichte, und die Geschichte bringt die Grammatik.</p>
				<ol class="pages">
					<li><b>Das Foto.</b> Ein echter Ort, die Wörter stehen direkt auf den Dingen.</li>
					<li><b>Wörter zuerst.</b> Deck das Englische zu und teste dich.</li>
					<li><b>Lesen.</b> Eine Geschichte, ganz auf Deutsch, ohne Übersetzung.</li>
					<li><b>Grammatik.</b> Zwei Seiten, zwei Regeln, jeweils mit Mini-Check.</li>
					<li><b>Lesen im Alltag.</b> Ein echtes Schild, ein Formular oder ein Plakat.</li>
					<li><b>Übungen.</b> Schreib ins Buch. Die Lösungen stehen hinten.</li>
					<li><b>Hören, sprechen, ich kann.</b> Die QR-Codes und was du jetzt kannst.</li>
					<li><b>Bildwörterbuch.</b> Alle Wörter mit Bild auf einer Seite.</li>
				</ol>
				<p><b>Die Codes.</b> Oben auf jeder Seite mit Übungen steht ein kleiner Code. Bist du mit der Seite fertig, scann ihn mit dem Handy: Die App prüft deine Antworten. Auf der Wörterseite macht er aus den Wörtern Wortkarten, auf der Leseseite liest er dir den Text vor. Die großen Codes am Ende des Kapitels haben eine Adresse darunter. Die kannst du auch in den Browser eintippen.</p>
				<p><b>Regeln auf Englisch.</b> Alle Erklärungen sind hier auf Deutsch. In der App steht bei jeder Regel ein Knopf „English“. Dort findest du sie auch auf Englisch.</p>
				<p><b>Drei Farben.</b> <b class="art der">der</b> ist blau, <b class="art die">die</b> ist rot, <b class="art das">das</b> ist grün.</p>
				<p class="name">Dieses Buch gehört <span></span></p>
			</div>
			<div>
				<p><b>Die Grammatikwörter</b></p>
				<dl class="terms">
					{#each GRAMMAR_WORDS as [de, en] (de)}
						<div><dt lang="de">{de}</dt><dd>{en}</dd></div>
					{/each}
				</dl>
			</div>
		</div>
		{:else}
		<header class="head small">
			<p class="eyebrow">Before you start</p>
			<h2>How this book works</h2>
		</header>
		<div class="how-cols">
			<div>
				<p>Every chapter is one place: {book.cover?.places ?? 'a market in Munich, a Späti at midnight, a flat in Berlin, the Bürgeramt'}. The place gives you the words, the words carry the story, and the story carries the grammar. You never learn a rule before you have met it in a sentence.</p>
				<p>The chapters all have the same ten pages, so you always know where you are:</p>
				<ol class="pages">
					<li><b>The photo.</b> A real place, with the words pinned on the things.</li>
					<li><b>Words first.</b> The rest of the chapter's words, with pictures. Cover the English, test yourself.</li>
					<li><b>Reading.</b> Maya, Lena and Max in the situation.{#if hidesEnglish(book.level)} Try it in German: there is no translation here.{:else} The English is underneath, small.{/if}</li>
					<li><b>Grammar, twice.</b> Two pages, two rules, a Mini-Check at the foot of each.</li>
					<li><b>Reading the real thing.</b> A photographed sign, menu, form or board, as Germany prints it.</li>
					<li><b>Practice, two pages.</b> Write in the book. The answers are at the back, not on the page.</li>
					<li><b>Listen, speak, I can.</b> The QR codes, and the four things you can now do.</li>
					<li><b>The picture dictionary.</b> Every pictured word of the chapter on one page.</li>
				</ol>
			</div>
			<div>
				<p><b>Work with a pencil.</b> Say every German word out loud as you write it. The ruled lines at the foot of a page are yours: the sentences you want to keep, the mistakes you made twice.</p>
				<p><b>The codes.</b> Every page you write on has a small code at the top. Finish the page, scan the code with your phone, and the app checks your answers against the key. On the words page it turns the words into flashcards; on the reading page it reads the text aloud. The bigger codes at the end of a chapter play its audio, start the tutor, or open more practice, and each has an address under it to type into a browser if the camera will not read it. In the PDF, every code is a link.</p>
				<p><b>Wusstest du?</b> The box at the foot of a page is a fact about Germany, not grammar. Skip it or read it; it is there because the place deserved it.</p>
				<p><b>Three colours.</b> Blue words are <b class="art der">der</b>, red words <b class="art die">die</b>, green words <b class="art das">das</b>, in every list and table. Buy three pencils.</p>
				<p class="name">This book belongs to <span></span></p>
			</div>
		</div>
		{/if}
		<footer class="foot"><span class="tnum">2</span><span>{book.title} · {book.subtitle}</span></footer>
	</section>

	<!-- 3 · contents -->
	<section class="page right contents">
		<header class="head small">
			<p class="eyebrow">{book.level}</p>
			<h2>{hidesEnglish(book.level) ? 'Inhalt' : 'Contents'}</h2>
		</header>
		<ol class="toc">
			{#each book.chapters as c, i (c.id)}
				<li data-accent={c.accent}>
					<span class="no">{c.n}</span>
					<span class="t"><b lang="de">{c.title}</b> <small>{c.subtitle}</small><i>{c.world}</i></span>
					<span class="pg tnum">{firstPage(i)}</span>
				</li>
			{/each}
			<li class="key-line"><span class="no">✓</span><span class="t">{#if hidesEnglish(book.level)}<b>Lösungen</b> <small>und Bildnachweise</small>{:else}<b>Answers</b> <small>and the picture credits</small>{/if}</span><span class="pg tnum">{keyPage}</span></li>
		</ol>
		<footer class="foot"><span class="tnum">3</span><span>{book.title} · {book.subtitle}</span></footer>
	</section>

	{#each book.chapters as c, i (c.id)}
		{@const p = firstPage(i)}
		{@const prac = practiseOf(c)}
		{@const [prac1, prac2] = split(prac, Math.ceil(prac.length / 2))}

		<!-- 1 · Opener: the left page of the opening spread; the plate holds the words not pinned on the photo -->
		{@const pinned = new Set((c.opener.labels ?? []).map((l) => bare(l.de)))}
		{@const strip = c.words.groups.flatMap((g) => g.items).filter((w) => !pinned.has(bare(w.de)))}
		<section class="page {side(p)} opener" data-accent={c.accent}>
			<img class="bleed pano left" src="{photoBase}/{c.opener.photo}.jpg" alt="" />
			<div class="plate">
				<span class="num">{c.n}</span>
				<div class="plate-cols">
					<div>
						<h2 lang="de">{c.title}</h2>
						<p class="world">{c.world}</p>
						<p class="cap" lang="de">{c.opener.caption}</p>
					</div>
					<ol class="qs" lang="de">
						{#each c.opener.questions as q (q)}<li>{q}</li>{/each}
					</ol>
				</div>
				<p class="strip-title">{c.words.more ?? (c.german ? 'Auch hier' : 'Auch hier · also here')}</p>
				<!-- Pictured words as tiles; the rest (verbs, adjectives, abstract
				     nouns) as a tidy list under them, so the tiles have no holes. -->
				<ul class="grid">
					{#each strip.filter((w) => w.image) as w (w.de)}
						{@const a = article(w.de)}
						<li>
							<img src="/img/{w.image}.webp" alt="" />
							<span class="de" lang="de">{#if a}<b class="art {a}">{a}</b>&nbsp;{/if}{bare(w.de)}</span>
							{#if plural(w.pl)}<span class="pl">{plural(w.pl)}</span>{/if}
							<span class="en">{w.en}</span>
						</li>
					{/each}
				</ul>
				{#if strip.some((w) => !w.image)}
					<ul class="wordlist">
						{#each strip.filter((w) => !w.image) as w (w.de)}
							{@const a = article(w.de)}
							<li>
								<span class="de" lang="de">{#if a}<b class="art {a}">{a}</b>&nbsp;{/if}{bare(w.de)}</span>{#if plural(w.pl)}<span class="pl"> · {plural(w.pl)}</span>{/if}
								<span class="en">{w.en}</span>
							</li>
						{/each}
					</ul>
				{/if}
			</div>
		</section>

		<!-- 2 · Words first: the right half of the panorama, the words pinned onto it -->
		<section class="page {side(p + 1)} words" data-accent={c.accent}>
			<img class="bleed pano right" src="{photoBase}/{c.opener.photo}.jpg" alt="" />
			<p class="eyebrow onphoto">{c.german ? 'Wörter zuerst' : 'Wörter zuerst · words first'}</p>
			{@render pageCode(c, 'woerter', 'Wortkarten')}
			{#each c.opener.labels ?? [] as l (l.de)}
				{@const a = article(l.de)}
				<div class="pin {l.side ?? 'right'}" style:left="{l.x}%" style:top="{l.y}%">
					<span class="dot"></span>
					<span class="tag">
						<span class="de" lang="de">{#if a}<b class="art {a}">{a}</b>&nbsp;{/if}{bare(l.de)}</span>
						<span class="meta">{#if plural(l.pl)}{plural(l.pl)} · {/if}{l.en}</span>
					</span>
				</div>
			{/each}
			{@render foot(p + 1, c)}
		</section>

		<!-- 3 · Reading -->
		<section class="page {side(p + 2)} reading" class:coded={pages[c.id]?.lesen} data-accent={c.accent}>
			{@render pageCode(c, 'lesen', 'Hören, prüfen')}
			<header class="head small">
				<p class="eyebrow">{c.german ? 'Lesen' : 'Lesen · reading'}</p>
				<h2 lang="de">{c.reading.title}</h2>
			</header>
			<p class="intro">{c.reading.intro}</p>
			<div class="read-cols">
				<div class="dialogue" lang="de">
					{#each c.reading.lines as l, j (j)}
						<p class:a={l.who === c.reading.lines[0].who} class:prose={!l.who}>
							{#if l.who}<b>{l.who}</b>{/if}
							<span>{@html rich(l.de)}</span>
						</p>
					{/each}
				</div>
				<div class="side-photos">
					{#each c.reading.photos as ph (ph.photo)}{@render photo(ph.photo, ph.caption, 'small')}{/each}
				</div>
			</div>
			{#if !hidesEnglish(book.level)}<p class="en"><b>English</b> · {c.reading.en}</p>{/if}
			<div class="flow">
				{#each c.reading.tasks as ex, e (e)}<ExerciseBlock {ex} n={e + 1} german={c.german} />{/each}
			</div>
			{@render filler(c.german ? 'Schreib die zwei Sätze aus dem Text ab, die du dir merken möchtest. Schreib dann einen eigenen Satz in der gleichen Form.' : 'Copy the two sentences of the text you want to remember, then write one of your own in the same shape.', c.german)}
			{@render fact(c.reading.fact)}
			{@render foot(p + 2, c)}
		</section>

		<!-- 4–5 · Grammar -->
		{#each c.grammar as g, gi (g.heading)}
			<section class="page {side(p + 3 + gi)} grammar" class:coded={pages[c.id]?.[`grammatik-${gi + 1}`]} data-accent={c.accent}>
				{#if g.check}{@render pageCode(c, `grammatik-${gi + 1}`, 'Prüfen')}{/if}
				<header class="head small">
					<p class="eyebrow">Grammatik · {gi + 1} {c.german ? 'von' : 'of'} {c.grammar.length}</p>
					<h2 lang="de">{g.heading}</h2>
					{#if g.subheading}<p class="sub">{g.subheading}</p>{/if}
				</header>
				<div class="flow" class:with-photo={g.photo}>
					{#if g.photo}{@render photo(g.photo.photo, g.photo.caption, 'float')}{/if}
					{#each g.blocks as block, b (b)}<LearnBlock {block} german={c.german} />{/each}
					{#if g.check}<div class="check"><ExerciseBlock ex={g.check} n={gi + 1} german={c.german} /></div>{/if}
				</div>
				{@render filler(c.german ? 'Schreib drei eigene Sätze mit der Regel von dieser Seite. Benutze Wörter von der Wörterseite.' : 'Write three sentences of your own with the rule of this page. Use words from the word page.', c.german)}
				{@render fact(g.fact)}
				{@render foot(p + 3 + gi, c)}
			</section>
		{/each}

		<!-- 6 · Real-world reading -->
		<section class="page {side(p + 5)} document" class:coded={pages[c.id]?.alltag} data-accent={c.accent}>
			{@render pageCode(c, 'alltag', 'Prüfen')}
			<header class="head small">
				<p class="eyebrow">{c.german ? 'Lesen im Alltag' : 'Lesen im Alltag · reading the real thing'}</p>
				<h2 lang="de">{c.document.caption}</h2>
			</header>
			{@render photo(c.document.photo, '', c.document.tall ? 'wide tall' : 'wide')}
			<p class="intro">{@html rich(c.document.intro)}</p>
			<div class="flow">
				{#each c.document.tasks as ex, e (e)}<ExerciseBlock {ex} n={e + 1} german={c.german} />{/each}
			</div>
			{@render filler(c.german ? 'Schreib jedes deutsche Wort auf, das du auf dem Foto lesen kannst, bei Nomen mit Artikel.' : 'Write down every German word you can read on the photo, with its article if it is a noun.', c.german)}
			{@render fact(c.document.fact)}
			{@render foot(p + 5, c)}
		</section>

		<!-- 7–8 · Practise -->
		{#each [prac1, prac2] as exs, pi (pi)}
			<section class="page {side(p + 6 + pi)} practise" class:coded={pages[c.id]?.[`uebungen-${pi + 1}`]} data-accent={c.accent}>
				{@render pageCode(c, `uebungen-${pi + 1}`, 'Prüfen')}
				<header class="head small">
					<p class="eyebrow">{c.german ? `Übungen · ${pi + 1} von 2` : `Übungen · practise ${pi + 1} of 2`}</p>
					<h2 lang="de">{c.title}</h2>
				</header>
				<div class="flow">
					{#each exs as ex, e (e)}<ExerciseBlock {ex} n={pi * prac1.length + e + 1} listen={qr[c.id]?.listen ?? null} german={c.german} />{/each}
				</div>
				{@render filler(c.german ? (pi === 0 ? 'Such dir fünf Wörter aus diesem Kapitel aus und schreib mit jedem einen Satz.' : 'Schreib auf, was auf diesen Seiten falsch war, und schreib es dann richtig.') : (pi === 0 ? 'Pick five words from this chapter and write one sentence with each.' : 'Write what you got wrong on these two pages, correctly, once each.'), c.german)}
				{@render foot(p + 6 + pi, c)}
			</section>
		{/each}

		<!-- 9 · Listen, speak, I can -->
		<section class="page {side(p + 8)} end" data-accent={c.accent}>
			<header class="head small">
				<p class="eyebrow">Hören, sprechen, können</p>
				<h2 lang="de">{c.title}</h2>
			</header>
			<div class="codes">
				{#if qr[c.id]?.listen}
					<div class="code">
						<a class="code-qr" href={qr[c.id].listen!.url} aria-label="Open this code">{@html qr[c.id].listen!.svg}</a>
						<div><b>Hören</b><p>{c.listen?.intro ?? 'Every recording of this chapter. Scan, listen, and do the Listen exercise again with your eyes closed.'}</p><a class="code-url" href={qr[c.id].listen!.url}>{shortUrl(qr[c.id].listen!.url)}</a></div>
					</div>
				{/if}
				{#if qr[c.id]?.speak}
					<div class="code">
						<a class="code-qr" href={qr[c.id].speak!.url} aria-label="Open this code">{@html qr[c.id].speak!.svg}</a>
						<div><b>Sprechen</b><p>{c.speak?.intro ?? 'Open the code and speak with the tutor.'}</p><a class="code-url" href={qr[c.id].speak!.url}>{shortUrl(qr[c.id].speak!.url)}</a></div>
					</div>
				{/if}
				{#if qr[c.id]?.app}
					<div class="code">
						<a class="code-qr" href={qr[c.id].app!.url} aria-label="Open this code">{@html qr[c.id].app!.svg}</a>
						<div><b>In der App</b><p>{c.german ? 'Die Übung zu diesem Kapitel, sofort korrigiert, mit Medaillen.' : "The chapter's exercise with instant correction and the medal ladder."}</p><a class="code-url" href={qr[c.id].app!.url}>{shortUrl(qr[c.id].app!.url)}</a></div>
					</div>
				{/if}
			</div>
			<div class="cando">
				<p class="eyebrow">{c.german ? 'Ich kann …' : 'Ich kann … · I can'}</p>
				<ul>
					{#each c.canDo as line (line)}<li><span class="box"></span>{line}</li>{/each}
				</ul>
			</div>
			<div class="next">
				<p>{c.german ? `Fertig? Hak ab, was du kannst. Prüf jede Seite mit ihrem Code oder mit den Lösungen auf Seite ${keyPage}. Kreise ein, was falsch war, und übe es in einer Woche noch einmal.` : `Done? Tick what you can. Check each page with its code, or with the answers on page ${keyPage}. Circle what you got wrong and come back to it in a week.`}</p>
				{#if pages[c.id]?.woerter}<p class="chapter-url">{c.german ? 'Das ganze Kapitel in der App' : 'The whole chapter in the app'}: <a href={pages[c.id]!.woerter!.url}>{shortUrl(pages[c.id]!.woerter!.url)}</a></p>{/if}
			</div>
			<p class="eyebrow notes-title">{c.german ? 'Meine Notizen' : 'Meine Notizen · my notes'}</p>
			<div class="fill"><div class="fill-lines"></div></div>
			{@render foot(p + 8, c)}
		</section>

		<!-- 10 · The chapter's picture dictionary -->
		<section class="page {side(p + 9)} dict" data-accent={c.accent}>
			<header class="head small">
				<p class="eyebrow">{c.german ? 'Bildwörterbuch' : 'Bildwörterbuch · picture dictionary'}</p>
				<h2 lang="de">{c.title}</h2>
			</header>
			<p class="intro">{c.german ? 'Alle Wörter mit Bild aus diesem Kapitel auf einer Seite. Deck die Wörter zu und sag sie zu den Bildern. Deck die Bilder zu und zeichne sie zu den Wörtern.' : 'Every pictured word of this chapter on one page. Cover the words, say them from the pictures; cover the pictures, draw them from the words.'}</p>
			<ul class="grid big">
				{#each picturedWords(c).slice(0, 35) as w (w.de)}
					{@const a = article(w.de)}
					<li>
						<img src="/img/{w.image}.webp" alt="" />
						<span class="de" lang="de">{#if a}<b class="art {a}">{a}</b>&nbsp;{/if}{bare(w.de)}</span>
						{#if plural(w.pl)}<span class="pl">{plural(w.pl)}</span>{/if}
						<span class="en">{w.en}</span>
					</li>
				{/each}
			</ul>
			{@render foot(p + 9, c)}
		</section>
	{/each}

	<!-- Key and credits -->
	{#each keyPages as chunk, k (k)}
		<section class="page {side(keyPage + k)} key">
			<header class="head small">
				<p class="eyebrow">{hidesEnglish(book.level) ? 'Lösungen' : 'Lösungen · the key'}</p>
				<h2>{hidesEnglish(book.level) ? (chunk.length ? `Lösungen · ${k + 1} von ${keyPages.length - 1}` : 'Bildnachweise') : chunk.length ? `Answers · ${k + 1} of ${keyPages.length - 1}` : 'Picture credits'}</h2>
			</header>
			<div class="keycols">
				{#each chunk as c (c.id)}
					<section>
						<h3><b>{c.n}</b> {c.title}</h3>
						{#each chapterKey(c) as part (part.part)}
							<h4>{part.part}</h4>
							{#each part.entries as x (x.exercise)}
								<p>
									<span class="n">{x.exercise}</span> <em>{x.title}</em> ·
									{#each x.answers as a, j (j)}{#if j}<span class="sep">&ensp;·&ensp;</span>{/if}<span lang="de">{#if a.q}<span class="q">{a.q}</span>&nbsp;{/if}<strong>{a.a}</strong></span>{/each}
									{#if x.note}<i> {x.note}</i>{/if}
								</p>
							{/each}
						{/each}
					</section>
				{/each}
			</div>
			{#if k === keyPages.length - 1}
				<div class="credits full">
					<p class="eyebrow">Die Fotos · picture credits</p>
					{#each [...new Set(book.chapters.flatMap((c) => [c.opener.photo, ...c.reading.photos.map((x) => x.photo), ...c.grammar.flatMap((g) => (g.photo ? [g.photo.photo] : [])), c.document.photo]))] as id (id)}
						{#if credits[id]}<p>{credits[id].title} — {credits[id].author}, {credits[id].license}, Wikimedia Commons.</p>{/if}
					{/each}
					<p>Word pictures and diagrams: Language Quiz.</p>
				</div>
			{/if}
			<footer class="foot"><span class="tnum">{keyPage + k}</span><span>{book.title} · {book.subtitle}</span></footer>
		</section>
	{/each}
	<!-- back cover -->
	<section class="page left back">{@render backCover()}</section>
{/if}
</div>

<style>
	.book2 {
		--serif: 'Source Serif 4 Variable', 'Source Serif 4', ui-serif, Georgia, serif;
		--sans: 'Inter Variable', Inter, ui-sans-serif, system-ui, sans-serif;
		--navy: #1f3a5f;
		--ink: #24262b;
		--muted: #5f5a52;
		--rule: #cfc8bb;
		--paper: #fbf8f3;
		--accent: #c9683b;
		--accent-tint: #fbefe8;
		--der: #1f5aa6;
		--die: #b8322e;
		--das: #2f7d4f;
		display: grid;
		justify-content: center;
		gap: 8mm;
		padding: 8mm 0 16mm;
		color: var(--ink);
		font-family: var(--sans);
		font-size: 10.5pt;
		line-height: 1.4;
		-webkit-print-color-adjust: exact;
		print-color-adjust: exact;
	}

	[data-accent='terracotta'] { --accent: #c9683b; --accent-tint: #fbefe8; }
	[data-accent='mustard'] { --accent: #b9842a; --accent-tint: #fbf3df; }
	[data-accent='sage'] { --accent: #5f8064; --accent-tint: #eef3ee; }
	[data-accent='blue'] { --accent: #3b6ea5; --accent-tint: #e9f0f8; }

	.page {
		position: relative;
		box-sizing: border-box;
		display: flex;
		flex-direction: column;
		width: 210mm;
		height: 297mm;
		overflow: hidden;
		padding: 14mm 18mm 18mm 22mm;
		background: #fff;
		box-shadow: 0 1px 2px rgb(0 0 0 / 0.06), 0 8px 28px rgb(0 0 0 / 0.07);
	}
	.page.left { padding: 14mm 22mm 18mm 18mm; }

	/* The fore-edge tab: the chapter's colour on the outer edge of every page. */
	.page::before {
		content: '';
		position: absolute;
		top: 40mm;
		bottom: 40mm;
		right: 0;
		width: 3mm;
		background: var(--accent);
	}
	.page.left::before { right: auto; left: 0; }

	.foot {
		position: absolute;
		bottom: 9mm;
		left: 22mm;
		right: 18mm;
		display: flex;
		justify-content: space-between;
		align-items: baseline;
		padding-top: 2mm;
		border-top: 0.25mm solid var(--rule);
		font-size: 7.5pt;
		color: var(--muted);
	}
	.foot .tnum { order: 2; font-size: 9pt; font-weight: 800; color: var(--navy); }
	.left .foot { left: 18mm; right: 22mm; }
	.left .foot .tnum { order: 0; }

	.eyebrow {
		margin: 0;
		font-size: 7.5pt;
		font-weight: 800;
		letter-spacing: 0.1em;
		text-transform: uppercase;
		color: var(--accent);
	}
	h2 {
		margin: 0.5mm 0 0;
		font-family: var(--serif);
		font-size: 24pt;
		line-height: 1.05;
		color: var(--navy);
	}
	.head { display: flex; gap: 5mm; align-items: flex-start; margin-bottom: 4mm; }
	/* The page's code, top right of the head, the title kept clear of it. */
	.page-code {
		position: absolute;
		top: 11mm;
		right: 18mm;
		z-index: 2;
		display: flex;
		flex-direction: column;
		align-items: center;
		width: 17mm;
		color: var(--muted);
		text-decoration: none;
	}
	.left .page-code { right: 22mm; }
	.page-code :global(svg) { display: block; width: 15mm; height: 15mm; }
	.page-code span { margin-top: 0.3mm; font-size: 5.5pt; font-weight: 700; line-height: 1.15; text-align: center; letter-spacing: 0.02em; white-space: nowrap; }
	.coded .head.small, .coded > .intro { padding-right: 20mm; }
	/* The page's content starts below the code, so a floated photo never covers its label. */
	.grammar.coded .head.small, .document.coded .head.small { min-height: 19mm; box-sizing: border-box; }
	.chapter-url { margin: 1.5mm 0 0; font-size: 8pt; color: var(--muted); }
	.chapter-url a { color: var(--navy); font-weight: 700; text-decoration: none; }
	/* On the words page the code sits on a white tile over the photo. */
	.words .page-code { top: 10mm; padding: 1.5mm 1mm 1mm; border-radius: 1.5mm; background: #fff; box-shadow: 0 0.5mm 2mm rgb(0 0 0 / 0.25); }
	.head.small { display: block; margin-bottom: 3mm; }
	.head.small h2 { font-size: 19pt; }
	.head .num {
		font-family: var(--serif);
		font-size: 44pt;
		line-height: 0.9;
		font-weight: 700;
		color: var(--accent);
	}
	.sub { margin: 1mm 0 0; font-size: 10pt; color: var(--muted); }
	.intro { margin: 0 0 3mm; font-size: 10pt; color: var(--muted); max-width: 150mm; }
	.flow { display: flex; flex-direction: column; gap: 3mm; }

	/* -- the print wrap: back + spine + front, 3 mm bleed all round ------------- */
	.sheet { --bleed: 3mm; position: relative; display: grid; grid-template-columns: calc(210mm + var(--bleed)) var(--spine) calc(210mm + var(--bleed)); width: calc(420mm + var(--spine) + 2 * var(--bleed)); height: calc(297mm + 2 * var(--bleed)); background: var(--accent); overflow: hidden; }
	.spine { display: flex; flex-direction: column; justify-content: space-between; align-items: center; padding: calc(10mm + var(--bleed)) 0; background: var(--accent); color: #fff; writing-mode: vertical-rl; }
	.spine span { font-family: var(--serif); font-size: 11pt; font-weight: 700; }
	.spine b { font-size: 7pt; letter-spacing: 0.08em; }
	.wrap { padding: 0; display: block; }

	.back h2 { margin: 2mm 0 3mm; font-size: 30pt; }

	/* -- the covers -----------------------------------------------------------
	   One front and one back, drawn on a 210 x 297 mm trim box: the PDF's first
	   and last pages, and the two halves of the print wrap. */
	.cover, .back { padding: 0; }
	.cover::before, .back::before { display: none; }
	.half { position: relative; overflow: hidden; }
	.backhalf { background: var(--navy); }
	.trim { position: absolute; top: var(--bleed); width: 210mm; height: 297mm; }
	.backhalf .trim { left: var(--bleed); }
	.fronthalf .trim { left: 0; }

	.fc { position: absolute; inset: 0; overflow: hidden; }
	.half .fc { overflow: visible; }
	/* The words page's crop of the panorama, so the pins sit on their things. */
	.fc-photo { position: absolute; top: 0; left: -210mm; width: 420mm; height: 297mm; object-fit: cover; }
	.half .fc-photo { top: calc(-1 * var(--bleed)); height: calc(297mm + 2 * var(--bleed)); width: calc(420mm + 2 * var(--bleed)); }
	.fc-shade { position: absolute; inset: 0 0 auto; height: 40mm; background: linear-gradient(rgb(0 0 0 / 0.5), transparent); }
	.fc-brand { position: absolute; top: 10mm; left: 14mm; right: 14mm; display: flex; align-items: center; gap: 2.5mm; color: #fff; font-size: 9pt; letter-spacing: 0.02em; text-shadow: 0 1px 3px rgb(0 0 0 / 0.5); }
	.fc-brand img { width: 9mm; height: 9mm; border-radius: 2mm; box-shadow: 0 1mm 3mm rgb(0 0 0 / 0.3); }
	.fc .pin .tag { box-shadow: 0 1mm 3mm rgb(0 0 0 / 0.35); }
	.fc .pin .de { font-size: 11pt; }
	.fc .pin .meta { font-size: 7.5pt; }
	.fc-plate { position: absolute; left: 0; right: 0; bottom: 0; height: 96mm; box-sizing: border-box; padding: 13mm 18mm 0 18mm; background: var(--paper); border-top: 3mm solid var(--accent); }
	.half .fc-plate { bottom: calc(-1 * var(--bleed)); height: calc(96mm + var(--bleed)); padding-right: calc(18mm + var(--bleed)); }
	.fc h1 { margin: 0; font-family: var(--serif); font-size: 66pt; line-height: 0.95; letter-spacing: -0.01em; color: var(--navy); }
	.fc-sub { margin: 1.5mm 0 0; font-family: var(--serif); font-size: 26pt; font-style: italic; line-height: 1.1; color: var(--accent); }
	.fc-blurb { margin: 6mm 0 0; max-width: 125mm; font-size: 10.5pt; line-height: 1.45; color: var(--ink); }
	.fc-route { margin: 6mm 0 0; padding-top: 3mm; border-top: 0.3mm solid var(--rule); font-size: 8.5pt; font-weight: 700; letter-spacing: 0.06em; text-transform: uppercase; color: var(--navy); }
	.fc-route i { margin: 0 2.2mm; font-style: normal; color: var(--accent); }
	.fc-site { position: absolute; right: 18mm; bottom: 10mm; margin: 0; font-size: 9pt; font-weight: 800; color: var(--navy); }
	.half .fc-site { right: calc(18mm + var(--bleed)); bottom: calc(10mm + var(--bleed)); }
	/* The level as a sticker on the panel's edge. */
	.fc-badge { position: absolute; right: 16mm; top: -24mm; width: 40mm; height: 40mm; border-radius: 50%; display: flex; flex-direction: column; align-items: center; justify-content: center; gap: 1mm; background: var(--accent); color: #fff; transform: rotate(-8deg); box-shadow: 0 2mm 6mm rgb(0 0 0 / 0.3); border: 1.2mm solid var(--paper); text-align: center; }
	.half .fc-badge { right: calc(16mm + var(--bleed)); }
	.fc-route .nb { white-space: nowrap; }
	.fc-badge b { font-family: var(--serif); font-size: 30pt; line-height: 1; }
	.fc-badge span { max-width: 28mm; font-size: 7pt; font-weight: 700; letter-spacing: 0.06em; text-transform: uppercase; line-height: 1.2; }

	.bc { position: absolute; inset: 0; box-sizing: border-box; display: flex; flex-direction: column; padding: 16mm 18mm 14mm; background: var(--navy); color: #f3eee6; }
	.half .bc { inset: calc(-1 * var(--bleed)); padding: calc(16mm + var(--bleed)) calc(18mm + var(--bleed)) calc(14mm + var(--bleed)); }
	.bc-kicker { margin: 0; font-size: 8pt; font-weight: 800; letter-spacing: 0.12em; text-transform: uppercase; color: #e9a27c; }
	.bc h2 { margin: 2mm 0 0; font-family: var(--serif); font-size: 32pt; line-height: 1.05; color: #fff; }
	.bc-lede { margin: 3.5mm 0 0; font-family: var(--serif); font-size: 11.5pt; line-height: 1.45; color: #e6e0d6; }
	.bc-places { list-style: none; margin: 6mm 0 0; padding: 0; display: grid; grid-template-columns: repeat(4, 1fr); gap: 3.5mm 3mm; }
	.bc-places li { position: relative; }
	.bc-places img { display: block; width: 100%; aspect-ratio: 3 / 2; object-fit: cover; border-radius: 1.2mm; }
	.bc-places .n { position: absolute; top: 1.2mm; left: 1.2mm; min-width: 5mm; padding: 0.3mm 1mm; border-radius: 1mm; background: var(--navy); color: #fff; font-family: var(--serif); font-size: 8pt; font-weight: 700; text-align: center; }
	.bc-places .w { display: block; margin-top: 1mm; font-size: 7pt; line-height: 1.25; color: #d9d2c6; }
	.bc-can { margin-top: 5mm; padding: 4mm 0 3mm; border-top: 0.3mm solid rgb(255 255 255 / 0.25); border-bottom: 0.3mm solid rgb(255 255 255 / 0.25); }
	.bc-can-title { margin: 0 0 2mm; font-size: 8pt; font-weight: 800; letter-spacing: 0.12em; text-transform: uppercase; color: #e9a27c; }
	.bc-can ul { list-style: none; margin: 0; padding: 0; columns: 2; column-gap: 8mm; font-size: 8.8pt; line-height: 1.35; color: #f3eee6; }
	.bc-can li { position: relative; padding-left: 4.5mm; margin-bottom: 1.2mm; break-inside: avoid; }
	.bc-can li::before { content: '✓'; position: absolute; left: 0; color: #e9a27c; font-weight: 800; }
	.bc-points { margin-top: 5mm; columns: 2; column-gap: 8mm; font-size: 9pt; line-height: 1.45; color: #e6e0d6; }
	.bc-points p { margin: 0 0 2.8mm; break-inside: avoid; }
	.bc-points b { color: #fff; }
	/* Bottom right stays clear: KDP prints its barcode there (2 x 1.2 in). */
	.bc-foot { margin-top: auto; padding-top: 3mm; display: flex; align-items: center; gap: 4mm; max-width: 110mm; }
	.bc-qr { flex: none; width: 22mm; height: 22mm; padding: 1mm; background: #fff; border-radius: 1.2mm; }
	.bc-qr :global(svg) { display: block; width: 100%; height: 100%; }
	.bc-site { display: flex; align-items: center; gap: 2.5mm; font-size: 9pt; line-height: 1.35; color: #e6e0d6; }
	.bc-site b { color: #fff; font-size: 10.5pt; }
	.bc-site img { width: 9mm; height: 9mm; border-radius: 2mm; }

	/* -- cover, how, contents ------------------------------------------------ */
	.cover h1 { margin: 2mm 0 0; font-family: var(--serif); font-size: 52pt; line-height: 1; color: var(--navy); }
	.how-cols { display: grid; grid-template-columns: 1fr 1fr; gap: 8mm; font-size: 9.5pt; line-height: 1.45; }
	.how-cols p { margin: 0 0 2.5mm; }
	.pages { margin: 0 0 3mm; padding-left: 5mm; }
	.pages li { margin-bottom: 1.2mm; }
	.name { margin-top: 8mm !important; font-family: var(--serif); font-size: 12pt; color: var(--navy); }
	.name span { display: inline-block; width: 60mm; border-bottom: 0.3mm solid var(--navy); }
	.toc { list-style: none; margin: 2mm 0 0; padding: 0; }
	.toc li { display: grid; grid-template-columns: 12mm 1fr 12mm; align-items: baseline; gap: 3mm; padding: 1.7mm 0; border-bottom: 0.25mm solid var(--rule); }
	.toc .no { font-family: var(--serif); font-size: 18pt; font-weight: 700; color: var(--accent); }
	.toc .t b { font-family: var(--serif); font-size: 13pt; color: var(--navy); }
	.toc .t small { display: block; font-size: 8.5pt; color: var(--muted); }
	.toc .t i { display: block; font-size: 7.5pt; font-style: normal; letter-spacing: 0.06em; text-transform: uppercase; color: var(--accent); margin-top: 0.5mm; }
	.toc .pg { text-align: right; font-weight: 800; color: var(--navy); }
	.toc .key-line .no { color: var(--navy); }

	/* -- words first --------------------------------------------------------- */
	.words { padding: 0; }
	.words::before { display: none; }
	.words .eyebrow.onphoto { position: absolute; top: 8mm; left: 10mm; padding: 1mm 2.5mm; background: var(--navy); color: #fff; border-radius: 1mm; }
	.pin { position: absolute; display: flex; align-items: center; gap: 1.2mm; transform: translate(-1.6mm, -50%); }
	.pin.left { flex-direction: row-reverse; transform: translate(calc(-100% + 1.6mm), -50%); }
	.pin .dot { width: 3.2mm; height: 3.2mm; border-radius: 50%; background: var(--accent); border: 0.5mm solid #fff; box-shadow: 0 0 0 0.3mm var(--navy); flex: none; }
	.pin .tag { display: flex; flex-direction: column; padding: 1mm 2.2mm 1.2mm; background: rgb(255 255 255 / 0.93); border-radius: 1.2mm; box-shadow: 0 0.6mm 2mm rgb(0 0 0 / 0.28); line-height: 1.15; white-space: nowrap; }
	.pin .de { font-size: 9.5pt; font-weight: 800; color: var(--navy); }
	.pin .meta { font-size: 6.6pt; color: var(--muted); }
	.strip { position: absolute; left: 10mm; right: 14mm; bottom: 16mm; padding: 3.5mm 4mm 3mm; background: rgb(251 248 243 / 0.95); border-radius: 2mm; box-shadow: 0 2mm 8mm rgb(0 0 0 / 0.2); }
	.strip-title { margin: 0 0 1.2mm; padding-top: 1.5mm; border-top: 0.3mm solid var(--accent); font-size: 7.5pt; font-weight: 800; letter-spacing: 0.08em; text-transform: uppercase; color: var(--accent); }
	.words .foot { left: 10mm; right: 14mm; border-top: 0; color: transparent; }
	.words .foot .tnum { color: #fff; }
	.plate-cols { display: grid; grid-template-columns: 1.3fr 1fr; gap: 6mm; align-items: end; margin-bottom: 2.5mm; }
	.phrases { list-style: none; margin: 0; padding: 0; font-size: 8.5pt; line-height: 1.3; columns: 1; }
	.phrases .en { color: var(--muted); font-size: 7.5pt; }
	.phrases li { border-left: 0.4mm solid var(--accent); padding-left: 2mm; margin-bottom: 0.6mm; }
	.grid {
		list-style: none;
		margin: 0;
		padding: 0;
		display: grid;
		grid-template-columns: repeat(6, 1fr);
		gap: 1.4mm 2mm;
	}
	/* One long word must break inside its column, not run off the page. */
	.grid li { min-width: 0; }
	.grid .de { overflow-wrap: anywhere; hyphens: auto; }
	.grid li { display: flex; flex-direction: column; align-items: center; text-align: center; font-size: 8.5pt; line-height: 1.2; }
	.grid img { width: 12mm; height: 12mm; object-fit: contain; margin-bottom: 0.8mm; background: #fff; border-radius: 2mm; }
	.grid .de { font-weight: 700; color: var(--ink); }
	.grid .pl { font-size: 7pt; color: var(--muted); }
	.grid .en { font-size: 7.5pt; color: var(--muted); }
	.wordlist {
		list-style: none;
		margin: 2.5mm 0 0;
		padding: 2mm 0 0;
		border-top: 0.2mm dashed var(--line, #ccc);
		columns: 3;
		column-gap: 5mm;
		font-size: 8.5pt;
		line-height: 1.25;
	}
	.wordlist li { break-inside: avoid; margin-bottom: 1mm; }
	.wordlist .de { font-weight: 700; color: var(--ink); }
	.wordlist .pl { font-size: 7pt; color: var(--muted); }
	.wordlist .en { display: block; font-size: 7.5pt; color: var(--muted); }
	.art.der { color: var(--der); }
	.art.die { color: var(--die); }
	.art.das { color: var(--das); }
	.verbs { list-style: none; margin: 0; padding: 0; display: grid; grid-template-columns: repeat(4, 1fr); gap: 1.5mm 4mm; font-size: 8.5pt; }
	.verbs li { display: flex; flex-direction: column; border-left: 0.4mm solid var(--accent); padding-left: 2mm; }
	.verbs .en { color: var(--muted); font-size: 7.5pt; }

	/* -- opener ------------------------------------------------------------- */
	.opener { padding: 0; }
	.opener::before { display: none; }
	/* The panorama: one photo across the spread, each page showing its half. */
	.bleed.pano { position: absolute; top: 0; height: 297mm; width: 420mm; object-fit: cover; }
	.bleed.pano.left { left: 0; }
	.bleed.pano.right { left: -210mm; }
	.opener .bleed { height: 297mm; clip-path: inset(0 0 var(--plate, 126mm) 0); }
	.opener .plate {
		position: absolute;
		left: 0; right: 0; bottom: 0;
		height: var(--plate, 126mm);
		padding: 5mm 22mm 5mm 18mm;
		background: var(--paper);
		border-top: 3mm solid var(--accent);
	}
	.opener .num { position: absolute; left: 18mm; top: -22mm; font-family: var(--serif); font-size: 60pt; font-weight: 700; color: #fff; text-shadow: 0 1px 6px rgb(0 0 0 / 0.5); }
	.opener h2 { font-size: 26pt; }
	.opener .world { margin: 0.5mm 0 2mm; font-size: 9pt; font-weight: 700; letter-spacing: 0.05em; text-transform: uppercase; color: var(--accent); }
	.opener .cap { margin: 0; font-family: var(--serif); font-size: 10.5pt; color: var(--ink); }
	.qs { margin: 0; padding-left: 5mm; font-size: 10pt; }
	.qs li { margin-bottom: 0.8mm; }
	.fact.onplate { position: absolute; right: 22mm; bottom: 8mm; width: 56mm; margin: 0; }

	/* -- reading ------------------------------------------------------------ */
	.read-cols { display: grid; grid-template-columns: 1fr 46mm; gap: 5mm; margin-bottom: 2mm; }
	.dialogue { font-family: var(--serif); font-size: 10pt; line-height: 1.3; }
	.dialogue p { margin: 0 0 0.9mm; display: grid; grid-template-columns: 22mm 1fr; gap: 2mm; }
	.dialogue p.prose { display: block; margin-bottom: 2.2mm; }
	.dialogue b { font-family: var(--sans); font-size: 8pt; font-weight: 800; letter-spacing: 0.04em; text-transform: uppercase; color: var(--accent); padding-top: 0.8mm; }
	.dialogue p.a b { color: var(--navy); }
	.side-photos { display: flex; flex-direction: column; gap: 3mm; }
	.reading .en { margin: 0 0 2mm; font-size: 6.8pt; color: var(--muted); line-height: 1.25; }
	.reading .en b { color: var(--navy); }

	/* -- photos --------------------------------------------------------------- */
	.photo { margin: 0; }
	.photo img { display: block; width: 100%; border: 0.3mm solid var(--navy); border-radius: 1mm; }
	.photo figcaption { margin-top: 1mm; font-size: 7.5pt; color: var(--muted); font-style: italic; }
	.photo.small img { aspect-ratio: 4 / 3; object-fit: cover; }
	.photo.wide img { aspect-ratio: 3 / 2; object-fit: cover; max-height: 94mm; }
	.photo.wide { margin-bottom: 3mm; }
	/* A portrait document (a menu, a timetable): the whole sheet, not a crop. */
	.photo.wide.tall img { aspect-ratio: auto; object-fit: contain; width: auto; height: auto; max-width: 100%; max-height: 128mm; margin: 0 auto; }
	.photo.float { float: right; width: 66mm; margin: 0 0 3mm 4mm; }
	.flow.with-photo { display: block; }
	.flow.with-photo > :global(*) { margin-bottom: 3mm; }

	/* -- filler: ruled lines that take whatever room the page has left ---------- */
	.fill { flex: 1 1 0; display: flex; flex-direction: column; min-height: min-content; margin-top: 3mm; overflow: hidden; }
	.fill-prompt { margin: 0.5mm 0 0; font-size: 8pt; color: var(--muted); }
	.fill-lines { flex: 1; min-height: 16mm; margin-top: 1mm; background: repeating-linear-gradient(to bottom, transparent 0, transparent 7.7mm, var(--rule) 7.7mm, var(--rule) 7.95mm); background-position: 0 100%; }
	.flow { flex: 0 0 auto; }

	/* -- facts --------------------------------------------------------------- */
	.fact {
		margin-top: 3mm;
		padding: 2.5mm 3.5mm;
		background: var(--accent-tint);
		border-left: 1mm solid var(--accent);
		border-radius: 0 1.5mm 1.5mm 0;
		font-size: 8.5pt;
		line-height: 1.35;
		margin-bottom: 11mm;
	}
	.fact p { margin: 0.5mm 0 0; }

	/* -- document ------------------------------------------------------------ */
	.document .head.small h2 { font-size: 13pt; font-family: var(--sans); font-weight: 600; color: var(--ink); }

	/* -- chapter end --------------------------------------------------------- */
	.codes { display: grid; gap: 4mm; margin: 4mm 0 8mm; }
	.code { display: grid; grid-template-columns: 26mm 1fr; gap: 4mm; align-items: center; padding: 3mm; border: 0.3mm solid var(--rule); border-radius: 2mm; }
	.code :global(svg) { width: 26mm; height: 26mm; }
	.code b { font-family: var(--serif); font-size: 14pt; color: var(--navy); }
	.code p { margin: 1mm 0; font-size: 9.5pt; }
	.code-qr { display: block; width: 26mm; height: 26mm; }
	.code-url { color: var(--muted); font-size: 8pt; text-decoration: none; }
	.cando { padding: 5mm 6mm; background: var(--accent-tint); border-radius: 2mm; }
	.cando ul { list-style: none; margin: 2mm 0 0; padding: 0; display: grid; gap: 2mm; font-size: 11pt; }
	.cando li { display: flex; gap: 3mm; align-items: center; }
	.box { width: 5mm; height: 5mm; border: 0.4mm solid var(--navy); border-radius: 1mm; flex: none; }
	.next { margin-top: 6mm; font-size: 9.5pt; color: var(--muted); max-width: 140mm; }

	/* -- notes ------------------------------------------------------------------ */
	.lines { display: grid; gap: 8.2mm; margin-top: 4mm; }
	.lines.short { gap: 7.5mm; margin-top: 2mm; }
	.notes-title { margin-top: 6mm; }
	.check { margin-top: 2mm; padding-top: 2mm; border-top: 0.3mm solid var(--accent); }
	.grid.big { grid-template-columns: repeat(5, 1fr); gap: 3mm 3mm; margin-top: 3mm; }
	.grid.big img { width: 24mm; height: 24mm; }
	.grid.big li { font-size: 9.5pt; }
	.grid.big .en { font-size: 8pt; }
	.lines span { display: block; border-bottom: 0.25mm solid var(--rule); }

	/* -- key ------------------------------------------------------------------- */
	.keycols { columns: 3; column-gap: 5mm; font-size: 7pt; line-height: 1.3; overflow: hidden; max-height: 240mm; }
	.key h3 { margin: 0 0 1.5mm; font-family: var(--serif); font-size: 12pt; color: var(--navy); }
	.key h4 { margin: 2.5mm 0 1mm; font-size: 7.5pt; letter-spacing: 0.08em; text-transform: uppercase; color: var(--accent); }
	.key p { margin: 0 0 1mm; break-inside: avoid; }
	.key .n { display: inline-block; min-width: 3.5mm; font-weight: 800; color: var(--navy); }
	.key em { color: var(--muted); }
	.key .q { color: var(--muted); }
	.key i { color: var(--muted); }
	.credits { margin-top: auto; margin-bottom: 11mm; font-size: 7pt; color: var(--muted); line-height: 1.3; }
	.credits.full { margin-top: 0; columns: 2; column-gap: 6mm; }
	.credits p { margin: 0.5mm 0; }

	@media print {
		.book2 { display: block; padding: 0; }
		.page { box-shadow: none; break-after: page; }
		.page:last-child { break-after: auto; }
		:global(.skip-link) { display: none; }
	}
	@media screen and (max-width: 222mm) { .book2 { zoom: 0.45; } }
	.terms {
		margin: 0;
		font-size: 8.6pt;
		line-height: 1.32;
	}
	.terms div {
		display: flex;
		justify-content: space-between;
		gap: 3mm;
		padding: 0.55mm 0;
		border-bottom: 0.2mm solid rgba(0, 0, 0, 0.12);
	}
	.terms dt {
		font-weight: 600;
	}
	.terms dd {
		margin: 0;
		text-align: right;
		opacity: 0.75;
	}
</style>
