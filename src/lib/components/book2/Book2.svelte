<script lang="ts">
	import { t } from '$lib/i18n/t';
	import { hidesEnglish } from '$lib/domain/germanFirst';
	// Book v2: one chapter = nine A4 sheets (docs/book_v2_plan.md §3). The
	// companion's LearnBlock and ExerciseBlock draw the grammar and the
	// exercises; this file draws the pages around them: the word page, the
	// full-bleed opener, the reading, the document, the chapter end, the key.
	import ExerciseBlock from '$lib/components/companion/ExerciseBlock.svelte';
	import LearnBlock from '$lib/components/companion/LearnBlock.svelte';
	import RibbonBadge from '$lib/components/RibbonBadge.svelte';
	import { SITE_URL } from '$lib/seo';
	import { creditLine } from '$lib/domain/credits';
	import { OPERATOR } from '$lib/operator';
	import { APP_VERSION, BOOK_EDITION } from '$lib/version';
	import { rich } from '$lib/domain/companion';
	import { untrack } from 'svelte';
	import { chapterKey, picturedWords, practiseOf, speakerLine, type Book2, type BookExtra, type Chapter, type PhotoCredit } from '$lib/domain/book2';

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
		extras = [],
		cover = false,
		spineMm = 7.4,
		hd = false,
		siteQr = '',
		spread = false,
		scale = 1
	}: {
		book: Book2;
		credits: Record<string, PhotoCredit>;
		/** Only the wraparound print cover: back, spine, front on one sheet with 3.175 mm (0.125 in) bleed. */
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
		/** "Mehr lesen und hören": the level's longer texts, two pages each, after the last chapter. */
		extras?: BookExtra[];
		/** On screen: facing pages side by side, the cover alone on the right as in the printed book. */
		spread?: boolean;
		/** On screen: the whole book's zoom (1 = A4 at its real size). Print is always 1. */
		scale?: number;
	} = $props();

	/** Nine content pages and a notes page, so every chapter opens on a left-hand page. */
	const PAGES = 10;
	const photoBase = $derived(hd ? '/img/photo' : '/img/photo/web');
	/** Cover, how it works, contents: the first chapter opens on page 4, a left-hand page. */
	const FRONT = 3;
	const firstPage = (i: number) => FRONT + 1 + i * PAGES;
	const side = (p: number) => (p % 2 === 0 ? 'left' : 'right');
	/** The extra texts start where the chapters end, on a left-hand page: text left, questions right. */
	const extrasPage = $derived(firstPage(book.chapters.length));
	const keyPage = $derived(extrasPage + extras.length * 2);
	const LETTERS = 'abcd';
	/** From B1 the rules are in German: the words they use, with their English, once. */
	const GRAMMAR_WORDS = [
		['das Nomen', 'noun'], [t('das Verb'), 'verb'], ['das Adjektiv', 'adjective'], ['der Artikel', 'article'],
		['das Pronomen', 'pronoun'], ['die Präposition', 'preposition'], ['die Endung', 'ending'],
		['der Singular', 'singular'], ['der Plural', 'plural'], ['maskulin, feminin, neutral', t('masculine, feminine, neuter')],
		['der Nominativ (wer?)', 'nominative'], ['der Akkusativ (wen?)', 'accusative'], ['der Dativ (wem?)', 'dative'], ['der Genitiv (wessen?)', 'genitive'],
		['der Infinitiv', 'infinitive'], ['das Präsens', 'present'], ['das Perfekt', 'perfect'], ['das Präteritum', 'simple past'], ['das Partizip', 'participle'],
		['der Satz', 'sentence'], ['der Hauptsatz', 'main clause'], ['der Nebensatz', t('subordinate clause')], ['der Relativsatz', t('relative clause')],
		['das Subjekt', 'subject'], ['das Objekt', 'object'], ['der Komparativ', 'comparative'], ['der Superlativ', 'superlative'],
		['trennbar', 'separable'], ['reflexiv', 'reflexive']
	];
	/** Two chapters of answers per key page. */
	const keyPages = $derived([...Array.from({ length: Math.ceil(book.chapters.length / 2) }, (_, i) => book.chapters.slice(i * 2, i * 2 + 2)), []]);

	const article = (de: string) => /^(der|die|das) /.exec(de)?.[1] ?? '';
	const bare = (de: string) => de.replace(/^(der|die|das) /, '');
	/** "die Äpfel" prints whole; "-n" prints as the ending; "–" as nothing. */
	const plural = (pl?: string) => (!pl || pl === '' ? '' : pl === '–' ? (hidesEnglish(book.level) ? 'kein Plural' : t('no plural')) : pl.startsWith('-') || pl.startsWith('¨') ? `pl. ${pl}` : pl);
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

	// The book's size at 100%, for the frame that holds it at the viewer's
	// scale. Read in an effect, not a ResizeObserver: the viewer's keepPlace
	// awaits tick() after a view change and must find the frame resized.
	let natural = $state({ w: 0, h: 0 });
	const framed = $derived(!cover && scale !== 1 && natural.w > 0);
	$effect(() => {
		void spread; void scale; void book; void cover; void extras;
		const el = root;
		if (!el || cover) return;
		const w = el.offsetWidth;
		const h = el.offsetHeight;
		if (w !== natural.w || h !== natural.h) natural = { w, h };
	});

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

	// Testing the book anywhere but the live site (the dev server, a preview):
	// a click on a code stays on this server, so its new pages can be tried.
	// Only the links change, never the printed QR images; and not for the PDF
	// printer, which runs as an automated browser (navigator.webdriver).
	// On screen every code opens in a new tab, so the book stays open at the
	// page the reader was on (a long page whose fit pass resizes it after
	// load, so "back" would not find the place again).
	$effect(() => {
		const el = root;
		if (!el) return;
		const rewrite = location.origin !== SITE_URL && !navigator.webdriver;
		el.querySelectorAll<HTMLAnchorElement>(`a[href^="${SITE_URL}/"]`).forEach((a) => {
			if (rewrite) a.href = location.origin + a.href.slice(SITE_URL.length);
			a.target = '_blank';
			a.rel = 'noopener';
		});
	});

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
			// Measured at full size: under the viewer's zoom (0.45 on a phone)
			// the fit pass measured other sizes and shrank other pages
			// than the PDF. One synchronous pass, so nothing paints
			// at 100% in between.
			el.style.transform = 'none';
			const report: string[] = [];
			el.querySelectorAll<HTMLElement>('section.page').forEach((page, i) => {
				const r = fitPage(page);
				if (r) report.push(`page ${i + 1}: ${r.plate ? `word panel ${r.plate} mm, ` : ''}${Math.round(r.zoom * 100)}%${r.over ? `, still ${r.over} mm over` : ''}`);
			});
			el.querySelectorAll<HTMLElement>('section.page.words').forEach((page, i) => {
				if (placeWordsCode(page) === null) report.push(t('words page {i}: the code touches a label in every corner', { i: i + 1 }));
			});
			el.style.transform = untrack(() => (framed ? `scale(${scale})` : ''));
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
		<a class="page-code" href={code.url} aria-label={t('{label} – open this page in the app', { label })}>
			{@html code.svg}
			<span>{label}</span>
		</a>
	{/if}
{/snippet}

<!-- The page challenge, at the foot of each practice page that has a quiz
     list in the app (Chapter.appQuizzes): win gold in the page's app
     quizzes, tick them off here. No code of its own: the page code at the
     top is the one door (Book or App). -->
{#snippet challenge(c: Chapter, part: string)}
	{@const ticks = c.appQuizzes?.[part]?.length ?? 0}
	{@const code = pages[c.id]?.[part]}
	{#if ticks && code}
		<div class="app-challenge">
			<span class="medal" aria-hidden="true"><RibbonBadge tier="gold" width={30} /></span>
			<div>
				<b lang="de">Seiten-Challenge: Gold auf dieser Seite</b>
				<p>{c.german ? 'Fertig auf Papier? Scann den Code oben auf dieser Seite und wähl App: dieselben Übungen als kurze Quizze. Hol in jedem Gold und hak es hier ab.' : t('Done on paper? Scan the code at the top of this page and choose App: the same exercises as short quizzes. Win gold in each one and tick it off here.')}</p>
				<p class="ticks">{#each Array(ticks) as _, k (k)}<i>{k + 1}</i>{/each}</p>
			</div>
			<a class="app-up" href={code.url}><span aria-hidden="true">↑</span>{c.german ? 'Code oben' : t('Code at the top')}<b><span class="phone" aria-hidden="true"></span>App</b></a>
		</div>
	{/if}
{/snippet}

<!-- The app, told once: it is this book as short quizzes, reached through
     any page code (App) or the site, where the deck deals from the book's
     level. A picture of the switch and a quiz card, no code of its own. -->
{#snippet appPitch(de: boolean)}
	<div class="app-pitch">
		<span class="app-tag"><span class="phone" aria-hidden="true"></span>{de ? 'Die App zum Buch' : t('The app · die App')}</span>
		<b class="big">{de ? 'Dein Buch als kurze Quizze.' : t('Your book, as short quizzes.')}</b>
		<p>
			{de
				? 'Jede Seite dieses Buches gibt es auch in der App: dieselben Wörter, dieselbe Grammatik, dieselben Leute, in kleinen Quizzen. Jede Antwort wird sofort korrigiert, und du gewinnst Medaillen. Scann einen Seiten-Code und wähl App. Oder öffne languagequiz.org: Der Stapel dort wählt jeden Tag Quizze aus deinem Niveau.'
				: t('Every page of this book is also in the app: the same words, the same grammar, the same people, cut into small quizzes. Every answer is corrected at once, and you win medals. Scan a page code and choose App. Or open languagequiz.org, where a deck of cards picks quizzes from your book’s level every day.')}
		</p>
		<div class="demo" aria-hidden="true">
			<span class="switch"><span>{de ? 'Buch' : t('Book')}</span><span class="on">App</span></span>
			<span class="card">Wie <i>heißt</i> du? <small>✓ {de ? 'Richtig!' : t('Right!')}</small></span>
		</div>
	</div>
{/snippet}

{#snippet imprint()}
	<!-- German press law wants the publisher's name and address in every printed book. -->
	<div class="imprint" lang="de">
		<p><b>Impressum</b> · © {new Date().getFullYear()} {OPERATOR.name}. Alle Rechte vorbehalten, mit Ausnahme der Fotos, die unter ihren eigenen Lizenzen stehen (Bildnachweise hinten im Buch).</p>
		<p>Herausgeber: {OPERATOR.name}, {OPERATOR.street}, {OPERATOR.city}, {OPERATOR.country === 'Germany' ? 'Deutschland' : OPERATOR.country} · {OPERATOR.email} · languagequiz.org</p>
		<p>{BOOK_EDITION.label} · Version {APP_VERSION}. Die aktuelle Ausgabe liegt immer unter languagequiz.org/books.</p>
		<p>Texte und Übungen: Language Quiz, geschrieben mit KI-Unterstützung (Anthropic Claude). Abgebildete Dokumente wie Stundenplan, Anzeige oder Zeugnis sind, wo nicht anders genannt, für dieses Buch gesetzt; Personen und Firmen darin sind erfunden. Language Quiz ist unabhängig und nicht mit einem Prüfungsanbieter verbunden.</p>
	</div>
{/snippet}

{#snippet foot(page: number, c: Chapter)}
	<footer class="foot">
		<span class="tnum">{page}</span>
		<span><b>{c.n}</b> · <span lang="de">{c.title}</span> · <i lang="de">{c.world}</i></span>
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
		<p class="eyebrow">{german ? 'Schreib mit!' : t('Schreib mit! · your turn')}</p>
		<p class="fill-prompt">{prompt}</p>
		<div class="fill-lines"></div>
	</div>
{/snippet}

{#snippet mcq(x: BookExtra)}
	<ol class="mcq" lang="de">
		{#each x.questions as q, j (j)}
			<li>
				<p class="q"><b>{j + 1}</b> {q.question}</p>
				<ul>
					{#each q.options as o, k (k)}<li><span class="box"></span><i>{LETTERS[k]}</i> {o}</li>{/each}
				</ul>
			</li>
		{/each}
	</ol>
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
			<span><b>{t('Language Quiz')}</b> {t('· German for English speakers')}</span>
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
			<div class="fc-badge"><b>{book.level}</b><span>{book.cover?.badge ?? t('for complete beginners')}</span></div>
			<h1 lang="de">{book.title.replace(/\s*[A-C]\d\.\d$/, '')}</h1>
			<p class="fc-sub" lang="de">{book.subtitle}</p>
			<p class="fc-blurb">{t('German in {n} real places: the words pinned on the things, a story in each place, and the grammar the story needs.', { n: book.chapters.length })}</p>
			<p class="fc-route" lang="de">{#each coverCities as city, i (city)}{#if i}<i>·</i>{/if}<span class="nb">{city}</span> {/each}</p>
			<p class="fc-site">languagequiz.org</p>
		</div>
	</div>
{/snippet}

{#snippet backCover()}
	<div class="bc">
		<p class="bc-kicker">{book.title} · {book.subtitle}</p>
		<h2>{t('German, one place at a time.')}</h2>
		<p class="bc-lede">{book.cover?.lede ?? t('A Späti at midnight. A market in Munich. A flat in Prenzlauer Berg, Sunday cake at Oma’s, the fish market at five in the morning. Twelve chapters, twelve real places, and the German you need in each of them.')}</p>
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
			<p class="bc-can-title">{t('After this book you can')}</p>
			<ul>
				{#each book.chapters as ch (ch.id)}{#if ch.canDo[0]}<li>{ch.canDo[0]}</li>{/if}{/each}
			</ul>
		</div>
		<div class="bc-points">
			<p><b>{t('Words first.')}</b> {t('Every chapter opens on a photograph with the words pinned to the things, so the first German you learn is what you can see.')}</p>
			<p><b>{t('Real German.')}</b> {book.cover?.real ?? t('A price board, a doorbell, a menu, a form at the Bürgeramt')}: {t('the texts Germany actually prints, photographed and read.')}</p>
			<p><b>{t('Paper and phone.')}</b> {t('Write in the book. Scan a code and the chapter is read aloud, a tutor talks with you, or the exercise opens in the app.')}</p>
			<p><b>Free.</b> {t('The whole course, A1 to C2, is free at languagequiz.org. This book is its paper half.')}</p>
		</div>
		<footer class="bc-foot">
			{#if siteQr}<a class="bc-qr" href="https://languagequiz.org" aria-label=languagequiz.org>{@html siteQr}</a>{/if}
			<span class="bc-site"><img src="/icons/Icon-192.png" alt="" /><span><b>languagequiz.org</b><br />{t('Start free, at your level.')}</span></span>
		</footer>
	</div>
{/snippet}

<!-- The frame takes the book's room at the viewer's scale; the book inside is
     laid out at full A4 and shrunk as a picture (transform), never zoomed: a
     zoomed-out phone page enlarged every small text to Chrome's 6 px minimum
     font size, and the imprint on page 2 ran into the footer. -->
<div
	class="book2-frame"
	class:framed
	style:width={framed ? `${natural.w * scale}px` : null}
	style:height={framed ? `${natural.h * scale}px` : null}
>
<div class="book2" class:wrap={cover} class:spread={spread && !cover} style:transform={framed ? `scale(${scale})` : null} bind:this={root}>
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
				<p><b>Die Codes.</b> Oben auf jeder Seite mit Übungen steht ein kleiner Code. Scann ihn und wähl Buch oder App. Buch zeigt die Seite im Web: Sie prüft deine Antworten, macht aus den Wörtern Wortkarten und liest dir den Text vor. App zeigt dieselbe Seite als kurze Quizze. Deine Wahl wird gespeichert, wechseln kannst du immer. Die großen Codes am Ende des Kapitels haben eine Adresse darunter. Die kannst du auch in den Browser eintippen.</p>
				<p><b>Regeln auf Englisch.</b> Alle Erklärungen sind hier auf Deutsch. In der App steht bei jeder Regel ein Knopf „English“. Dort findest du sie auch auf Englisch.</p>
				<p><b>Drei Farben.</b> <b class="art der">der</b> ist blau, <b class="art die">die</b> ist rot, <b class="art das">das</b> ist grün.</p>
				<p class="name">Dieses Buch gehört <span></span></p>
			</div>
			<div>
				{@render appPitch(true)}
				<p><b>Die Grammatikwörter</b></p>
				<dl class="terms">
					{#each GRAMMAR_WORDS as [de, en] (de)}
						<div><dt lang="de">{de}</dt><dd>{en}</dd></div>
					{/each}
				</dl>
			</div>
		</div>
		{@render imprint()}
		{:else}
		<header class="head small">
			<p class="eyebrow">{t('Before you start')}</p>
			<h2>{t('How this book works')}</h2>
		</header>
		<div class="how-cols">
			<div>
				<p>{t('Every chapter is one place:')} {book.cover?.places ?? t('a market in Munich, a Späti at midnight, a flat in Berlin, the Bürgeramt')}. {t('The place gives you the words, the words carry the story, and the story carries the grammar. You never learn a rule before you have met it in a sentence.')}</p>
				<p>{t('The chapters all have the same ten pages, so you always know where you are:')}</p>
				<ol class="pages">
					<li><b>{t('The photo.')}</b> {t('A real place, with the words pinned on the things.')}</li>
					<li><b>{t('Words first.')}</b> {t('The rest of the chapter\'s words, with pictures. Cover the English, test yourself.')}</li>
					<li><b>{t('Reading.')}</b> {t('Maya, Lena and Max in the situation.')}{#if hidesEnglish(book.level)} Try it in German: there is no translation here.{:else} {t('The English is underneath, small.')}{/if}</li>
					<li><b>{t('Grammar, twice.')}</b> {t('Two pages, two rules, a Mini-Check at the foot of each.')}</li>
					<li><b>{t('Reading the real thing.')}</b> {t('A photographed sign, menu, form or board, as Germany prints it.')}</li>
					<li><b>{t('Practice, two pages.')}</b> {t('Write in the book. The answers are at the back, not on the page.')}</li>
					<li><b>{t('Listen, speak, I can.')}</b> {t('The QR codes, and the four things you can now do.')}</li>
					<li><b>{t('The picture dictionary.')}</b> {t('Every pictured word of the chapter on one page.')}</li>
				</ol>
			</div>
			<div>
				{@render appPitch(false)}
				<p><b>{t('Work with a pencil.')}</b> {t('Say every German word out loud as you write it. The ruled lines at the foot of a page are yours: the sentences you want to keep, the mistakes you made twice.')}</p>
				<p><b>{t('The codes.')}</b> {t('Every page you write on has a small code at the top. Scan it and choose Book or App. Book shows the page on the web: it checks your answers against the key, turns the words into flashcards and reads the text aloud. App shows the same page as short quizzes. Your choice is remembered, and you can switch at any time. The bigger codes at the end of a chapter play its audio or start the tutor, each with an address to type into a browser. In the PDF, every code is a link.')}</p>
				<p><b>Wusstest du?</b> {t('The box at the foot of a page is a fact about Germany, not grammar. Skip it or read it; it is there because the place deserved it.')}</p>
				<p><b>Three colours.</b> {t('Blue words are')} <b class="art der">der</b>{t(', red words')} <b class="art die">die</b>{t(', green words')} <b class="art das">das</b>{t(', in every list and table. Buy three pencils.')}</p>
				<p class="name">{t('This book belongs to')} <span></span></p>
			</div>
		</div>
		{@render imprint()}
		{/if}
		<footer class="foot"><span class="tnum">2</span><span>{book.title} · {book.subtitle}</span></footer>
	</section>

	<!-- 3 · contents -->
	<section class="page right contents">
		<header class="head small">
			<p class="eyebrow">{book.level}</p>
			<h2>{hidesEnglish(book.level) ? 'Inhalt' : t('Contents')}</h2>
		</header>
		<ol class="toc">
			{#each book.chapters as c, i (c.id)}
				<li data-accent={c.accent}>
					<span class="no">{c.n}</span>
					<span class="t"><b lang="de">{c.title}</b> <small>{c.subtitle}</small><i lang="de">{c.world}</i></span>
					<span class="pg tnum">{firstPage(i)}</span>
				</li>
			{/each}
			{#if extras.length}
				<li class="key-line"><span class="no">+</span><span class="t"><b lang="de">Mehr lesen und hören</b> <small lang="de">{extras.length} längere Texte mit Fragen</small></span><span class="pg tnum">{extrasPage}</span></li>
			{/if}
			<li class="key-line"><span class="no">✓</span><span class="t">{#if hidesEnglish(book.level)}<b>Lösungen</b> <small>und Bildnachweise</small>{:else}<b>{t('Answers')}</b> <small>{t('and the picture credits')}</small>{/if}</span><span class="pg tnum">{keyPage}</span></li>
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
						<p class="world" lang="de">{c.world}</p>
						<p class="cap" lang="de">{c.opener.caption}</p>
					</div>
					<ol class="qs" lang="de">
						{#each c.opener.questions as q (q)}<li>{q}</li>{/each}
					</ol>
				</div>
				<p class="strip-title">{c.words.more ?? (c.german ? 'Auch hier' : t('Auch hier · also here'))}</p>
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
			<p class="eyebrow onphoto">{c.german ? 'Wörter zuerst' : t('Wörter zuerst · words first')}</p>
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
				<p class="eyebrow">{c.german ? 'Lesen' : t('Lesen · reading')}</p>
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
			{#if !hidesEnglish(book.level)}<p class="en"><b>{t('English')}</b> · {c.reading.en}</p>{/if}
			<div class="flow">
				{#each c.reading.tasks as ex, e (e)}<ExerciseBlock {ex} n={e + 1} german={c.german} />{/each}
			</div>
			{@render filler(c.german ? 'Schreib die zwei Sätze aus dem Text ab, die du dir merken möchtest. Schreib dann einen eigenen Satz in der gleichen Form.' : t('Copy the two sentences of the text you want to remember, then write one of your own in the same shape.'), c.german)}
			{@render fact(c.reading.fact)}
			{@render foot(p + 2, c)}
		</section>

		<!-- 4–5 · Grammar -->
		{#each c.grammar as g, gi (g.heading)}
			<section class="page {side(p + 3 + gi)} grammar" class:coded={pages[c.id]?.[`grammatik-${gi + 1}`]} data-accent={c.accent}>
				{#if g.check}{@render pageCode(c, `grammatik-${gi + 1}`, 'Prüfen')}{/if}
				<header class="head small">
					<p class="eyebrow"><span lang="de">Grammatik</span> · {gi + 1} {c.german ? 'von' : t('of')} {c.grammar.length}</p>
					<h2 lang="de">{g.heading}</h2>
					{#if g.subheading}<p class="sub">{g.subheading}</p>{/if}
				</header>
				<div class="flow" class:with-photo={g.photo}>
					{#if g.photo}{@render photo(g.photo.photo, g.photo.caption, 'float')}{/if}
					{#each g.blocks as block, b (b)}<LearnBlock {block} german={c.german} />{/each}
					{#if g.check}<div class="check"><ExerciseBlock ex={g.check} n={gi + 1} german={c.german} /></div>{/if}
				</div>
				{@render filler(c.german ? 'Schreib drei eigene Sätze mit der Regel von dieser Seite. Benutze Wörter von der Wörterseite.' : t('Write three sentences of your own with the rule of this page. Use words from the word page.'), c.german)}
				{@render fact(g.fact)}
				{@render foot(p + 3 + gi, c)}
			</section>
		{/each}

		<!-- 6 · Real-world reading -->
		<section class="page {side(p + 5)} document" class:coded={pages[c.id]?.alltag} data-accent={c.accent}>
			{@render pageCode(c, 'alltag', 'Prüfen')}
			<header class="head small">
				<p class="eyebrow">{c.german ? 'Lesen im Alltag' : t('Lesen im Alltag · reading the real thing')}</p>
				<h2 lang="de">{c.document.caption}</h2>
			</header>
			{@render photo(c.document.photo, '', c.document.tall ? 'wide tall' : 'wide')}
			<p class="intro">{@html rich(c.document.intro)}</p>
			<div class="flow">
				{#each c.document.tasks as ex, e (e)}<ExerciseBlock {ex} n={e + 1} german={c.german} />{/each}
			</div>
			{@render filler(c.german ? 'Schreib jedes deutsche Wort auf, das du auf dem Foto lesen kannst, bei Nomen mit Artikel.' : t('Write down every German word you can read on the photo, with its article if it is a noun.'), c.german)}
			{@render fact(c.document.fact)}
			{@render foot(p + 5, c)}
		</section>

		<!-- 7–8 · Practise -->
		{#each [prac1, prac2] as exs, pi (pi)}
			<section class="page {side(p + 6 + pi)} practise" class:coded={pages[c.id]?.[`uebungen-${pi + 1}`]} data-accent={c.accent}>
				{@render pageCode(c, `uebungen-${pi + 1}`, 'Prüfen')}
				<header class="head small">
					<p class="eyebrow">{c.german ? `Übungen · ${pi + 1} von 2` : t('Übungen · practise {pi} of 2', { pi: pi + 1 })}</p>
					<h2 lang="de">{c.title}</h2>
				</header>
				<div class="flow">
					{#each exs as ex, e (e)}<ExerciseBlock {ex} n={pi * prac1.length + e + 1} listen={qr[c.id]?.listen ?? null} german={c.german} />{/each}
				</div>
				{@render challenge(c, `uebungen-${pi + 1}`)}
				{@render filler(c.german ? (pi === 0 ? 'Such dir fünf Wörter aus diesem Kapitel aus und schreib mit jedem einen Satz.' : 'Schreib auf, was auf diesen Seiten falsch war, und schreib es dann richtig.') : (pi === 0 ? t('Pick five words from this chapter and write one sentence with each.') : t('Write what you got wrong on these two pages, correctly, once each.')), c.german)}
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
						<a class="code-qr" href={qr[c.id].listen!.url} aria-label={t('Open this code')}>{@html qr[c.id].listen!.svg}</a>
						<div><b>Hören</b><p>{c.listen?.intro ?? t('Every recording of this chapter. Scan, listen, and do the Listen exercise again with your eyes closed.')}</p><a class="code-url" href={qr[c.id].listen!.url}>{shortUrl(qr[c.id].listen!.url)}</a></div>
					</div>
				{/if}
				{#if qr[c.id]?.speak}
					<div class="code">
						<a class="code-qr" href={qr[c.id].speak!.url} aria-label={t('Open this code')}>{@html qr[c.id].speak!.svg}</a>
						<div><b>Sprechen</b><p>{c.speak?.intro ?? t('Open the code and speak with the tutor.')}</p><a class="code-url" href={qr[c.id].speak!.url}>{shortUrl(qr[c.id].speak!.url)}</a></div>
					</div>
				{/if}
				{#if qr[c.id]?.app}
					<div class="code">
						<a class="code-qr" href={qr[c.id].app!.url} aria-label={t('Open this code')}>{@html qr[c.id].app!.svg}</a>
						<div><b>In der App</b><p>{c.german ? 'Die Übung zu diesem Kapitel, sofort korrigiert, mit Medaillen.' : t("The chapter's exercise with instant correction and the medal ladder.")}</p><a class="code-url" href={qr[c.id].app!.url}>{shortUrl(qr[c.id].app!.url)}</a></div>
					</div>
				{/if}
			</div>
			<div class="cando">
				<p class="eyebrow">{c.german ? 'Ich kann …' : t('Ich kann … · I can')}</p>
				<ul>
					{#each c.canDo as line (line)}<li><span class="box"></span>{line}</li>{/each}
				</ul>
			</div>
			<div class="next">
				<p>{c.german ? t('Fertig? Hak ab, was du kannst. Prüf jede Seite mit ihrem Code oder mit den Lösungen auf Seite {keyPage}. Kreise ein, was falsch war, und übe es in einer Woche noch einmal.', { keyPage }) : t('Done? Tick what you can. Check each page with its code, or with the answers on page {keyPage}. Circle what you got wrong and come back to it in a week.', { keyPage })}</p>
				<p class="app-line"><span class="phone" aria-hidden="true"></span>{c.german ? 'Alle Übungen dieses Kapitels gibt es auch als kurze Quizze in der App: Scann einen Seiten-Code und wähl App.' : t('Every exercise of this chapter is also a short quiz in the app: scan any page code and choose App.')}</p>
				{#if pages[c.id]?.woerter}<p class="chapter-url">{c.german ? 'Das ganze Kapitel in der App' : t('The whole chapter in the app')}: <a href={pages[c.id]!.woerter!.url}>{shortUrl(pages[c.id]!.woerter!.url)}</a></p>{/if}
			</div>
			<p class="eyebrow notes-title">{c.german ? 'Meine Notizen' : t('Meine Notizen · my notes')}</p>
			<div class="fill"><div class="fill-lines"></div></div>
			{@render foot(p + 8, c)}
		</section>

		<!-- 10 · The chapter's picture dictionary -->
		<section class="page {side(p + 9)} dict" data-accent={c.accent}>
			<header class="head small">
				<p class="eyebrow">{c.german ? 'Bildwörterbuch' : t('Bildwörterbuch · picture dictionary')}</p>
				<h2 lang="de">{c.title}</h2>
			</header>
			<p class="intro">{c.german ? 'Alle Wörter mit Bild aus diesem Kapitel auf einer Seite. Deck die Wörter zu und sag sie zu den Bildern. Deck die Bilder zu und zeichne sie zu den Wörtern.' : t('Every pictured word of this chapter on one page. Cover the words, say them from the pictures; cover the pictures, draw them from the words.')}</p>
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

	<!-- Mehr lesen und hören: the level's longer texts. Left page the text (or,
	     for a listening, the questions beside the code that plays it), right
	     page the questions (or the text to read afterwards). -->
	{#each extras as x, i (x.id)}
		{@const p = extrasPage + i * 2}
		{@const listening = x.kind === 'listening'}
		<section class="page {side(p)} extra" class:coded={!!x.code}>
			{#if x.code}
				<a class="page-code" href={x.code.url}>
					{@html x.code.svg}
					<span>{listening ? 'Hören' : 'Hören, prüfen'}</span>
				</a>
			{/if}
			<header class="head small">
				<p class="eyebrow">{listening ? 'Mehr hören' : 'Mehr lesen'} · {i + 1}</p>
				<h2 lang="de">{x.title}</h2>
			</header>
			{#if x.photo}
				<figure class="photo band">
					<img src="{photoBase}/{x.photo}.jpg" alt="" />
				</figure>
			{:else if x.image}
				<figure class="photo band drawn"><img src="/img/{x.image}.webp" alt="" /></figure>
			{/if}
			{#if listening}
				<p class="intro" lang="de">Lies zuerst die Fragen. Scanne dann den Code und hör den Text zweimal. Kreuze beim zweiten Hören an. Den Text zum Nachlesen findest du auf der nächsten Seite.</p>
				{@render mcq(x)}
			{:else}
				<div class="extra-text" lang="de">
					{#each x.passage.split(/\n{2,}/) as para, j (j)}<p class:short={para.length < 60}>{para}</p>{/each}
				</div>
			{/if}
			<footer class="foot"><span class="tnum">{p}</span><span lang="de">Mehr lesen und hören · <i>{x.title}</i></span></footer>
		</section>
		<section class="page {side(p + 1)} extra">
			<header class="head small">
				<p class="eyebrow">{listening ? 'Zum Nachlesen' : 'Fragen zum Text'}</p>
				<h2 lang="de">{x.title}</h2>
			</header>
			{#if listening}
				<p class="intro" lang="de">Lies den Text erst, nachdem du ihn gehört hast. Unterstreiche, was du beim Hören nicht verstanden hast.</p>
				<div class="extra-text talk" lang="de">
					{#each x.passage.split(/\n+/) as line, j (j)}
						{@const l = speakerLine(line)}
						<p>{#if l.who}<b>{l.who}</b> {/if}{l.de}</p>
					{/each}
				</div>
			{:else}
				<p class="intro" lang="de">Kreuze an. Zu jeder Frage passt genau eine Antwort. Such die Stelle im Text und unterstreiche sie.</p>
				{@render mcq(x)}
				{@render filler('Fass den Text in drei Sätzen zusammen. Schreib dann einen Satz dazu, was du selbst darüber denkst.', true)}
			{/if}
			<footer class="foot"><span class="tnum">{p + 1}</span><span lang="de">Mehr lesen und hören · <i>{x.title}</i></span></footer>
		</section>
	{/each}

	<!-- Key and credits -->
	{#each keyPages as chunk, k (k)}
		<section class="page {side(keyPage + k)} key">
			<header class="head small">
				<p class="eyebrow">{hidesEnglish(book.level) ? 'Lösungen' : t('Lösungen · the key')}</p>
				<h2>{hidesEnglish(book.level) ? (chunk.length ? `Lösungen · ${k + 1} von ${keyPages.length - 1}` : 'Bildnachweise') : chunk.length ? t('Answers · {k} of {keyPages}', { k: k + 1, keyPages: keyPages.length - 1 }) : t('Picture credits')}</h2>
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
			<!-- The longer texts' answers close the last answers page, which has
			     room to spare; the credits page alone ran over in A2.1. -->
			{#if k === keyPages.length - 2 && extras.length}
				<div class="extra-key" lang="de">
					<p class="eyebrow">Mehr lesen und hören · Lösungen</p>
					{#each extras as x, i (x.id)}
						<p><b>{i + 1}</b> <em>{x.title}</em> · {#each x.questions as q, j (j)}{#if j}&ensp;·&ensp;{/if}{j + 1}&nbsp;<strong>{LETTERS[q.correct]}</strong>{/each}</p>
					{/each}
				</div>
			{/if}
			{#if k === keyPages.length - 1}
				<div class="credits full">
					<p class="eyebrow">Die Fotos · picture credits</p>
					{#each [...new Set([...book.chapters.flatMap((c) => [c.opener.photo, ...c.reading.photos.map((x) => x.photo), ...c.grammar.flatMap((g) => (g.photo ? [g.photo.photo] : [])), c.document.photo]), ...extras.flatMap((x) => (x.photo ? [x.photo] : []))])] as id (id)}
						{@const line = creditLine(id, hidesEnglish(book.level))}
						{#if line}<p><span lang="de">{credits[id]?.title.replace(/\.[a-z]+$/i, '').replace(/_/g, ' ')}</span>: {line}.</p>{/if}
					{/each}
					<p>{hidesEnglish(book.level) ? 'Wortbilder: mit KI erstellt (Google Gemini) für Language Quiz. Diagramme und Gestaltung: Language Quiz.' : t('Word pictures: made with AI (Google Gemini) for Language Quiz. Diagrams and design: Language Quiz.')}</p>
				</div>

			{/if}
			<footer class="foot"><span class="tnum">{keyPage + k}</span><span>{book.title} · {book.subtitle}</span></footer>
		</section>
	{/each}
	<!-- back cover -->
	<section class="page left back">{@render backCover()}</section>
{/if}
</div>
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
		/* Small accent-coloured text needs 4.5:1 on the paper; the bright
		   --accent stays for borders, large type and decoration. */
		--accent-ink: #a24c26;
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
		/* A phone must not blow the type up in a zoomed-out page (it overflowed the fitted pages). */
		-webkit-text-size-adjust: 100%;
		text-size-adjust: 100%;
	}
	/* Wider than the screen when zoomed in: start at the left edge, never cut it off. */
	.book2 { justify-content: safe center; }
	/* The frame is the book's room on screen, centred; at a scale other than
	   100% it is sized to the scaled book and the book, at full A4, is shrunk
	   into it from the top left corner. */
	.book2-frame { width: fit-content; margin-inline: auto; }
	.book2-frame > .book2:not(.wrap) { width: max-content; }
	.book2-frame.framed { position: relative; margin-inline: auto; }
	/* Physical left: the paper runs left to right in every language. */
	.book2-frame.framed > .book2 { position: absolute; top: 0; left: 0; transform-origin: 0 0; }
	/* Facing pages: a left page in the first column, a right page in the second.
	   The cover (a right page) stands alone, then two by two, as the book opens. */
	.book2.spread { grid-template-columns: 210mm 210mm; column-gap: 0; }
	.book2.spread > .page.left { grid-column: 1; }
	.book2.spread > .page.right { grid-column: 2; }

	[data-accent='terracotta'] { --accent: #c9683b; --accent-tint: #fbefe8; --accent-ink: #a24c26; }
	[data-accent='mustard'] { --accent: #b9842a; --accent-tint: #fbf3df; --accent-ink: #836215; }
	[data-accent='sage'] { --accent: #5f8064; --accent-tint: #eef3ee; --accent-ink: #44614a; }
	[data-accent='blue'] { --accent: #3b6ea5; --accent-tint: #e9f0f8; --accent-ink: #30597f; }

	.page {
		position: relative;
		box-sizing: border-box;
		display: flex;
		flex-direction: column;
		width: 210mm;
		/* app.css's .page (the app's 46rem column) must not narrow the sheet to 195 mm. */
		max-width: none;
		margin: 0;
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
		/* The folio sits on the outer edge whatever the language. */
		direction: ltr;
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
		color: var(--accent-ink);
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
		inset-inline-end: 18mm;
		z-index: 2;
		display: flex;
		flex-direction: column;
		align-items: center;
		width: 17mm;
		color: var(--muted);
		text-decoration: none;
	}
	.left .page-code { inset-inline-end: 22mm; }
	/* Right to left the code moves to the other top corner, so it takes that
	   side's margin: the gutter's 22 mm on a right page, the outer 18 mm on a left. */
	.page-code:dir(rtl) { inset-inline-end: 22mm; }
	.left .page-code:dir(rtl) { inset-inline-end: 18mm; }
	.page-code :global(svg) { display: block; width: 15mm; height: 15mm; }
	.page-code span { margin-top: 0.3mm; font-size: 5.5pt; font-weight: 700; line-height: 1.15; text-align: center; letter-spacing: 0.02em; white-space: nowrap; }
	.coded .head.small, .coded > .intro { padding-inline-end: 20mm; }
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

	/* -- the print wrap: back + spine + front, KDP's 3.175 mm bleed all round ------------- */
	.sheet { --bleed: 3.175mm; position: relative; display: grid; grid-template-columns: calc(210mm + var(--bleed)) var(--spine) calc(210mm + var(--bleed)); width: calc(420mm + var(--spine) + 2 * var(--bleed)); height: calc(297mm + 2 * var(--bleed)); background: var(--accent); overflow: hidden; }
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
	.fc-badge { position: absolute; right: 16mm; top: -24mm; width: 40mm; height: 40mm; border-radius: 50%; display: flex; flex-direction: column; align-items: center; justify-content: center; gap: 1mm; background: var(--accent-ink); color: #fff; transform: rotate(-8deg); box-shadow: 0 2mm 6mm rgb(0 0 0 / 0.3); border: 1.2mm solid var(--paper); text-align: center; }
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
	.bc-can li { position: relative; padding-inline-start: 4.5mm; margin-bottom: 1.2mm; break-inside: avoid; }
	.bc-can li::before { content: '✓'; position: absolute; inset-inline-start: 0; color: #e9a27c; font-weight: 800; }
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
	.pages { margin: 0 0 3mm; padding-inline-start: 5mm; }
	.pages li { margin-bottom: 1.2mm; }
	.name { margin-top: 8mm !important; font-family: var(--serif); font-size: 12pt; color: var(--navy); }
	.name span { display: inline-block; width: 60mm; border-bottom: 0.3mm solid var(--navy); }
	.toc { list-style: none; margin: 2mm 0 0; padding: 0; }
	.toc li { display: grid; grid-template-columns: 12mm 1fr 12mm; align-items: baseline; gap: 3mm; padding: 1.7mm 0; border-bottom: 0.25mm solid var(--rule); }
	.toc .no { font-family: var(--serif); font-size: 18pt; font-weight: 700; color: var(--accent); }
	.toc .t b { font-family: var(--serif); font-size: 13pt; color: var(--navy); }
	.toc .t small { display: block; font-size: 8.5pt; color: var(--muted); }
	.toc .t i { display: block; font-size: 7.5pt; font-style: normal; letter-spacing: 0.06em; text-transform: uppercase; color: var(--accent-ink); margin-top: 0.5mm; }
	.toc .pg { text-align: end; font-weight: 800; color: var(--navy); }
	.toc .key-line .no { color: var(--navy); }

	/* -- words first --------------------------------------------------------- */
	.words { padding: 0; }
	.words::before { display: none; }
	.words .eyebrow.onphoto { position: absolute; top: 8mm; inset-inline-start: 10mm; padding: 1mm 2.5mm; background: var(--navy); color: #fff; border-radius: 1mm; }
	.pin { position: absolute; display: flex; align-items: center; gap: 1.2mm; transform: translate(-1.6mm, -50%); }
	.pin.left { flex-direction: row-reverse; transform: translate(calc(-100% + 1.6mm), -50%); }
	.pin:dir(rtl) { flex-direction: row-reverse; }
	.pin.left:dir(rtl) { flex-direction: row; }
	.pin .dot { width: 3.2mm; height: 3.2mm; border-radius: 50%; background: var(--accent); border: 0.5mm solid #fff; box-shadow: 0 0 0 0.3mm var(--navy); flex: none; }
	.pin .tag { display: flex; flex-direction: column; padding: 1mm 2.2mm 1.2mm; background: rgb(255 255 255 / 0.93); border-radius: 1.2mm; box-shadow: 0 0.6mm 2mm rgb(0 0 0 / 0.28); line-height: 1.15; white-space: nowrap; }
	.pin .de { font-size: 9.5pt; font-weight: 800; color: var(--navy); }
	.pin .meta { font-size: 6.6pt; color: var(--muted); }
	.strip { position: absolute; left: 10mm; right: 14mm; bottom: 16mm; padding: 3.5mm 4mm 3mm; background: rgb(251 248 243 / 0.95); border-radius: 2mm; box-shadow: 0 2mm 8mm rgb(0 0 0 / 0.2); }
	.strip-title { margin: 0 0 1.2mm; padding-top: 1.5mm; border-top: 0.3mm solid var(--accent); font-size: 7.5pt; font-weight: 800; letter-spacing: 0.08em; text-transform: uppercase; color: var(--accent-ink); }
	.words .foot { left: 10mm; right: 14mm; border-top: 0; color: transparent; }
	.words .foot .tnum { color: #fff; }
	.plate-cols { display: grid; grid-template-columns: 1.3fr 1fr; gap: 6mm; align-items: end; margin-bottom: 2.5mm; }
	.phrases { list-style: none; margin: 0; padding: 0; font-size: 8.5pt; line-height: 1.3; columns: 1; }
	.phrases .en { color: var(--muted); font-size: 7.5pt; }
	.phrases li { border-inline-start: 0.4mm solid var(--accent); padding-inline-start: 2mm; margin-bottom: 0.6mm; }
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
	.verbs li { display: flex; flex-direction: column; border-inline-start: 0.4mm solid var(--accent); padding-inline-start: 2mm; }
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
	.opener .world { margin: 0.5mm 0 2mm; font-size: 9pt; font-weight: 700; letter-spacing: 0.05em; text-transform: uppercase; color: var(--accent-ink); }
	.opener .cap { margin: 0; font-family: var(--serif); font-size: 10.5pt; color: var(--ink); }
	.qs { margin: 0; padding-inline-start: 5mm; font-size: 10pt; }
	.qs li { margin-bottom: 0.8mm; }
	.fact.onplate { position: absolute; right: 22mm; bottom: 8mm; width: 56mm; margin: 0; }

	/* -- reading ------------------------------------------------------------ */
	.read-cols { display: grid; grid-template-columns: 1fr 46mm; gap: 5mm; margin-bottom: 2mm; }
	.dialogue { font-family: var(--serif); font-size: 10pt; line-height: 1.3; }
	.dialogue p { margin: 0 0 0.9mm; display: grid; grid-template-columns: 22mm 1fr; gap: 2mm; }
	.dialogue p.prose { display: block; margin-bottom: 2.2mm; }
	.dialogue b { font-family: var(--sans); font-size: 8pt; font-weight: 800; letter-spacing: 0.04em; text-transform: uppercase; color: var(--accent-ink); padding-top: 0.8mm; }
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

	/* Mehr lesen und hören: a long text set in two columns under a low photo. */
	.photo.band { margin-bottom: 4mm; }
	.photo.band img { aspect-ratio: 3 / 1; object-fit: cover; }
	.photo.band.drawn img { aspect-ratio: 3 / 1; object-fit: contain; background: #fbf5e6; }
	.extra-text { columns: 2; column-gap: 7mm; font-family: var(--serif); font-size: 9.6pt; line-height: 1.36; hyphens: auto; }
	.extra-text p { margin: 0 0 2.2mm; }
	.extra-text p.short { font-family: var(--sans); font-size: 8.6pt; font-weight: 700; color: var(--navy); break-after: avoid; }
	.extra-text.talk p { margin-bottom: 1.8mm; }
	.extra-text.talk b { font-family: var(--sans); font-size: 7.6pt; font-weight: 800; letter-spacing: 0.04em; text-transform: uppercase; color: var(--accent-ink); }
	.mcq { list-style: none; margin: 0 0 3mm; padding: 0; columns: 2; column-gap: 7mm; font-size: 8.8pt; line-height: 1.3; }
	.mcq > li { break-inside: avoid; margin: 0 0 3mm; }
	.mcq .q { margin: 0 0 1mm; font-weight: 700; color: var(--navy); }
	.mcq .q b { display: inline-block; min-width: 4mm; color: var(--accent-ink); }
	.mcq ul { list-style: none; margin: 0; padding: 0; }
	.mcq ul li { display: grid; grid-template-columns: 3.4mm 3mm 1fr; gap: 1.2mm; align-items: baseline; margin: 0 0 0.6mm; }
	.mcq .box { width: 2.8mm; height: 2.8mm; border: 0.3mm solid var(--navy); border-radius: 0.5mm; transform: translateY(0.5mm); }
	.mcq i { font-style: normal; font-weight: 700; color: var(--muted); }
	.extra-key { margin: 0 0 5mm; font-size: 8.5pt; line-height: 1.45; }
	.extra-key p { margin: 0.6mm 0; }
	.extra-key .eyebrow { margin-bottom: 1.5mm; }
	/* A portrait document (a menu, a timetable): the whole sheet, not a crop. */
	.photo.wide.tall img { aspect-ratio: auto; object-fit: contain; width: auto; height: auto; max-width: 100%; max-height: 128mm; margin: 0 auto; }
	.photo.float { float: inline-end; width: 66mm; margin-block: 0 3mm; margin-inline: 4mm 0; }
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
		border-inline-start: 1mm solid var(--accent);
		border-radius: 1.5mm;
		border-start-start-radius: 0;
		border-end-start-radius: 0;
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
	.key h4 { margin: 2.5mm 0 1mm; font-size: 7.5pt; letter-spacing: 0.08em; text-transform: uppercase; color: var(--accent-ink); }
	.key p { margin: 0 0 1mm; break-inside: avoid; }
	.key .n { display: inline-block; min-width: 3.5mm; font-weight: 800; color: var(--navy); }
	.key em { color: var(--muted); }
	.key .q { color: var(--muted); }
	.key i { color: var(--muted); }
	.credits { margin-top: auto; margin-bottom: 11mm; font-size: 7pt; color: var(--muted); line-height: 1.3; }
	.credits.full { margin-top: 0; columns: 2; column-gap: 6mm; }
	.credits p { margin: 0.5mm 0; }
	.imprint { margin-top: auto; padding-top: 2mm; border-top: 0.3mm solid var(--rule, #ddd); font-size: 6.5pt; color: var(--muted); line-height: 1.3; }
	.imprint p { margin: 0.4mm 0; }

	@media print {
		.book2 { display: block; padding: 0; transform: none !important; }
		.book2-frame { width: auto !important; height: auto !important; margin: 0; }
		.book2-frame.framed > .book2 { position: static; width: auto; }
		.page { box-shadow: none; break-after: page; }
		.page:last-child { break-after: auto; }
		:global(.skip-link) { display: none; }
	}
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
		text-align: end;
		opacity: 0.75;
	}

	/* ---- The app on the printed page: navy, the phone mark. The page code is
	   the one door into it; nothing here has a code of its own. ---- */
	.phone {
		display: inline-block;
		position: relative;
		flex: none;
		width: 2mm;
		height: 3.1mm;
		margin-inline-end: 1.2mm;
		border: 0.35mm solid currentColor;
		border-radius: 0.5mm;
		box-sizing: border-box;
		vertical-align: -0.4mm;
	}
	.phone::after {
		content: '';
		position: absolute;
		left: 50%;
		bottom: 0.25mm;
		width: 0.5mm;
		height: 0.3mm;
		margin-left: -0.25mm;
		background: currentColor;
	}
	.app-tag {
		font-size: 6.5pt;
		font-weight: 800;
		letter-spacing: 0.1em;
		text-transform: uppercase;
		color: #c9d6e8;
	}
	.app-challenge {
		display: grid;
		grid-template-columns: auto minmax(0, 1fr) auto;
		gap: 3.5mm;
		align-items: center;
		margin-top: 3mm;
		padding: 2.5mm 3.5mm;
		border: 0.5mm solid var(--navy);
		border-radius: 3mm;
		background: #fff;
		break-inside: avoid;
	}
	/* The app's own gold ribbon: the medal a learner wins there. */
	.app-challenge .medal {
		display: flex;
		align-self: start;
		width: 8mm;
	}
	.app-challenge .medal :global(svg) {
		width: 8mm;
		height: auto;
	}
	.app-challenge b {
		font-family: var(--serif);
		font-size: 11pt;
		color: var(--navy);
	}
	.app-challenge p {
		margin: 0.5mm 0 0;
		font-size: 8pt;
		color: var(--muted);
	}
	/* One box per app exercise on the page, numbered as the page's list numbers them. */
	.app-challenge .ticks {
		display: flex;
		gap: 2.5mm;
		margin-top: 2mm;
	}
	.app-challenge .ticks i {
		display: grid;
		place-items: end start;
		width: 6mm;
		height: 6mm;
		padding-block-end: 0.4mm;
		padding-inline-start: 0.8mm;
		box-sizing: border-box;
		border: 0.4mm solid var(--navy);
		border-radius: 1mm;
		font-style: normal;
		font-size: 6pt;
		font-weight: 800;
		color: var(--navy);
	}
	.app-up {
		display: flex;
		flex-direction: column;
		align-items: center;
		gap: 0.5mm;
		padding: 1.5mm 2.5mm;
		border-radius: 2mm;
		background: var(--navy);
		color: #fff;
		font-size: 7pt;
		font-weight: 700;
		text-decoration: none;
		text-align: center;
		white-space: nowrap;
	}
	.app-up > span {
		font-size: 13pt;
		line-height: 1;
	}
	.app-challenge .app-up b {
		font-family: var(--sans);
		font-size: 9pt;
		color: #fff;
	}

	/* The app's pitch on the how-it-works page: the book as quizzes. */
	.app-pitch {
		margin: 0 0 3mm;
		padding: 3mm 3.5mm;
		border-radius: 2.5mm;
		background: var(--navy);
		color: #fff;
	}
	.app-pitch .app-tag {
		display: block;
		margin-bottom: 1mm;
	}
	.app-pitch b.big {
		display: block;
		margin-bottom: 1mm;
		font-family: var(--serif);
		font-size: 12pt;
		line-height: 1.15;
	}
	.app-pitch p {
		margin: 0 0 1.5mm !important;
		font-size: 8.5pt;
		line-height: 1.4;
		color: #dbe4f0;
	}
	.app-pitch .demo {
		display: flex;
		align-items: center;
		gap: 2.5mm;
		margin-top: 2mm;
	}
	.app-pitch .switch {
		display: inline-flex;
		padding: 0.6mm;
		border-radius: 99mm;
		background: rgb(255 255 255 / 0.18);
		font-size: 7.5pt;
		font-weight: 700;
	}
	.app-pitch .switch span {
		padding: 0.8mm 2.5mm;
		border-radius: 99mm;
	}
	.app-pitch .switch span.on {
		background: #fff;
		color: var(--navy);
	}
	.app-pitch .card {
		flex: 1;
		padding: 1.5mm 2mm;
		border-radius: 1.5mm;
		background: #fff;
		color: var(--ink);
		font-size: 7.5pt;
	}
	.app-pitch .card i {
		font-style: normal;
		display: inline-block;
		padding: 0 1.5mm;
		margin: 0 0.5mm;
		border-bottom: 0.4mm solid var(--navy);
		color: var(--navy);
		font-weight: 800;
	}
	.app-pitch .card small {
		display: block;
		color: #2f7d4f;
		font-weight: 700;
	}

	/* One line about the app on a chapter's end page. */
	.app-line {
		display: flex;
		align-items: center;
		gap: 1.5mm;
		margin: 2mm 0 0 !important;
		padding: 1.5mm 2.5mm;
		border-radius: 1.5mm;
		background: #e8eef6;
		color: var(--navy);
		font-size: 8.5pt;
	}
</style>
