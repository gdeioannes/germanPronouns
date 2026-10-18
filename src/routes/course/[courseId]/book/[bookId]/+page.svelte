<script lang="ts">
	// The printed book. On screen it reads as a stack of pages; printed, it is
	// the interior file for print on demand: US Letter, mirrored margins with a
	// binding gutter, running heads per part, page numbers in the foot.
	import WorkbookUnit from '$lib/components/workbook/WorkbookUnit.svelte';
	import { GENDER_COLORS } from '$lib/domain/gender';

	let { data } = $props();
	const book = $derived(data.book);
	const year = new Date().getFullYear();

	const partHead = (i: number) => `Part ${i + 1} · ${book.parts[i]?.level ?? ''} ${book.parts[i]?.title ?? ''}`;
	const pageStyle = $derived(
		`<style>
@page { size: 8.5in 11in; margin: 18mm 13mm 18mm 13mm; @bottom-center { content: counter(page); font: 800 8.5pt Inter, sans-serif; color: #1f3a5f; } @top-left { content: url(${data.mark}) "  languagequiz.org"; font: 700 7pt Inter, sans-serif; color: #1f3a5f; vertical-align: middle; white-space: pre; } }
@page :left { margin-left: 13mm; margin-right: 17mm; }
@page :right { margin-left: 17mm; margin-right: 13mm; }
@page front { @bottom-center { content: none; } @top-left { content: none; } }
@page advert { margin: 0; @bottom-center { content: none; } @top-left { content: none; } }
@page part1 { @top-right { font: 600 7pt Inter, sans-serif; color: #6e6458; content: "${partHead(0)}"; } }
@page part2 { @top-right { font: 600 7pt Inter, sans-serif; color: #6e6458; content: "${partHead(1)}"; } }
@page back { @top-right { font: 600 7pt Inter, sans-serif; color: #6e6458; content: "Key, tables and index"; } }
</style>`
	);

	const letters = $derived([...new Set(book.index.map((e) => e.de[0].toUpperCase()))]);
</script>

<svelte:head>
	<title>{book.title} · {book.subtitle}</title>
	<meta name="robots" content="noindex" />
	{@html pageStyle}
</svelte:head>

<main class="book">
	<!-- ── Front matter ──────────────────────────────────────────────── -->
	<section class="sheet front half-title">
		<p class="kicker">{book.courseName}</p>
		<h1 class="big">{book.title}</h1>
		<p class="sub">{book.subtitle}</p>
	</section>

	<section class="sheet front title-page">
		<p class="brand-line"><img src="/icons/Icon-192.png" alt="" width="192" height="192" /> languagequiz.org</p>
		<p class="kicker">{book.courseName}</p>
		<h1 class="big">{book.title}</h1>
		<p class="sub">{book.subtitle}</p>
		{#if book.cover}<img class="cover-pic" src="/img/{book.cover}.webp" alt="" width="1024" height="768" />{/if}
		<p class="tag">The complete workbook for {book.parts.map((p) => p.level).join(' and ')}: every lesson, every exercise, and the audio and speaking practice in the app, one scan away.</p>
	</section>

	<section class="sheet front copyright">
		<div>
			<p><strong>{book.title}: {book.subtitle}</strong><br />{book.courseName}, print edition {year}. Content version {book.version}.</p>
			<p><strong>ISBN {data.isbn}</strong></p>
			<p>Published by Language Quiz, <strong>https://{data.siteHost}</strong>, a non-profit project. The whole course, including every recording and exercise in this book, is free there.</p>
			<p>© {year} Language Quiz. All rights reserved. No part of this book may be reproduced, stored or transmitted without permission, except that the owner of this copy may photocopy its exercise pages for their own study. Quotation for review or teaching is welcome with attribution.</p>
			<p><strong>Use of AI.</strong> The text, exercises and explanations were written and reviewed by the author. The illustrations and the recorded voices were generated with AI tools (Google's image and text-to-speech models) and reviewed before use. No real person's likeness or voice is used; any resemblance is unintended. The pictures are not photographs and the voices are not those of real speakers.</p>
			<p><strong>No affiliation.</strong> This book is an independent learning resource. It is not affiliated with, endorsed by or connected to any examination board, certificate provider, publisher or institution. Level names (A1 to C2) follow the Common European Framework of Reference for Languages, published by the Council of Europe; this book is not an official CEFR publication. Names of people, companies and places in the exercises are invented; any resemblance to real ones is coincidental.</p>
			<p><strong>Accuracy.</strong> Every care has been taken to make the German correct and the explanations sound, and the content was checked by a native-level reviewer, but no textbook is free of errors. Corrections are published at the book's page online and applied in future printings. The publisher accepts no liability for loss arising from reliance on the content. Nothing in this book is professional advice.</p>
			<p><strong>Trademarks.</strong> Product and company names mentioned in passing belong to their owners and are used only to identify them.</p>
			<p class="small">Set in Source Serif 4 and Inter (SIL Open Font License). Printed on demand.</p>
		</div>
	</section>

	<section class="sheet front about">
		<p class="eyebrow">About this project</p>
		<h2>A free course, for anyone, for good</h2>
		<div class="about-grid">
			<div>
				<p>Language Quiz is a German course from A1 to C2 built by a learner living in Germany, for people who struggle with linear courses: it lets you start where you are, learn in any order, and go back whenever you like. This book is the course on paper; the app at <strong>{data.siteHost}</strong> is the same course on a screen.</p>
				<p>It is a <strong>non-profit project</strong>. The app is free and will stay free: no subscription, no paywall, no advertising, and no account needed. Signing in is only ever an option, for people who want their progress on more than one device.</p>
				<p><strong>Your data stays yours.</strong> The app works without knowing who you are. Nothing about you is sold, traded or passed to advertisers, and the usage statistics it keeps are anonymous and cookieless. If you choose to sign in, your progress is stored to sync it, and for nothing else.</p>
			</div>
			<div>
				<p><strong>Why a book, then?</strong> Because a page is calm. The lessons, the diagrams and the exercises work on paper without a phone in your hand; the phone comes in only where paper cannot: to play a recording, to talk to the tutor, to deal a deck of cards. Every code in the book is permanent, so this copy will still open the right page in years.</p>
				<p><strong>What the price pays for.</strong> The price of this book covers printing and distribution; what remains goes back into the project: new recordings, new pictures, new levels and languages.</p>
				<p><strong>Accessibility.</strong> The app aims at WCAG 2.2 AA: it works with a keyboard and screen readers, has no time limits, offers text for every listening exercise and reduced motion on request. If something in this book or the app gets in your way, write to the address on the book's page online; it will be fixed.</p>
				<p><strong>Book and app together.</strong> Scan the book's code on the "How this book works" page: it opens a checklist of this book in the app. Tick what you did on paper and the app counts it as done. Nobody checks; a tick is a tick.</p>
				<p><strong>Found a mistake?</strong> Corrections are listed on the book's page online and go into the next printing.</p>
			</div>
		</div>
	</section>

	<section class="sheet front how">
		<p class="eyebrow">Before you start</p>
		<h2>How this book works</h2>
		<div class="how-grid">
			<div>
				<h3>Every unit, the same four steps</h3>
				<ol class="steps">
					<li><b>Learn.</b> The idea in one line, then the rules with their examples and a diagram where one helps. Read the German out loud.</li>
					<li><b>Words.</b> The words the unit needs, each noun with its article and plural. Colour tells the gender: <span style="color:{GENDER_COLORS.m}">der</span>, <span style="color:{GENDER_COLORS.f}">die</span>, <span style="color:{GENDER_COLORS.n}">das</span>.</li>
					<li><b>Check yourself.</b> One quick question per rule. Tick a box, then turn the book round to see the answers at the foot of the unit.</li>
					<li><b>Practise.</b> Fill the gaps, read, listen, write or speak. The listening and dictation units need the audio: scan the code.</li>
				</ol>
			</div>
			<div>
				<h3>The codes</h3>
				<ul class="legend-list">
					<li><b>Do it in the app</b> opens the same exercise on your phone, with instant correction and the medal ladder.</li>
					<li><b>Listen</b> opens a player with every recording of the unit, numbered like the page.</li>
					<li>Speaking units open a prompt you can hand to the app's tutor, or to any German speaker.</li>
				</ul>
				<h3>Medals</h3>
				<p>The app awards bronze, silver and gold for a unit. The tracker on the next page has a box for each, so the book and the app keep the same score.</p>
				<h3>The key</h3>
				<p>Short answers sit upside down under each unit. Transcripts, dictation sentences and picture-hunt words are in the key at the back, so a listening page stays a listening page.</p>
				<div class="book-qr">
					<span class="qr">{@html data.bookQr.svg}</span>
					<span class="qr-text"><b>This book online</b><br />{data.siteHost}/b/{data.bookQr.code}<br />tick off what you did on paper, so the app counts it</span>
				</div>
			</div>
		</div>
	</section>

	<section class="sheet front advert">
		<div class="ad-top">
			<p class="ad-kicker">The book and the app are one course</p>
			<h2 class="ad-title">Did it on paper?<br />Tick it in the app.</h2>
			<p class="ad-lede">Scan the code once. You get a checklist of this book, unit by unit, exactly as it is printed on the next page. Tick what you did here, and the app counts it as done: it stops dealing you those units and your progress rings move. Finish something in the app, and it shows as ticked here too. One record, two places.</p>
		</div>
		<div class="ad-body">
			<div class="ad-mock" aria-hidden="true">
				<div class="mock-bar"><span class="mock-dot"></span><span class="mock-dot"></span><span class="mock-dot"></span></div>
				<p class="mock-head">My book · {book.title}</p>
				<p class="mock-sub">{book.parts[0]?.chapters[0] ? `Chapter 1 · ${book.parts[0].chapters[0].title}` : book.parts[0]?.title}</p>
				{#each (book.parts[0]?.chapters[0]?.units ?? book.parts[0]?.workbook.units ?? []).slice(0, 5) as u, i (u.quizId)}
					<div class="mock-row" class:on={i < 2}>
						<span class="mock-box">{#if i < 2}✓{/if}</span>
						<span class="mock-n">1.{u.n}</span>
						<span class="mock-t">{u.title}</span>
					</div>
				{/each}
				<p class="mock-count">2 / {book.parts[0]?.workbook.units.length ?? 0} units done</p>
			</div>
			<div class="ad-qr">
				<span class="qr big">{@html data.bookQr.svg}</span>
				<p class="ad-code">{data.siteHost}/b/{data.bookQr.code}</p>
				<p class="ad-note">Free. No account needed. Nobody checks your ticks; a tick is a tick.</p>
			</div>
		</div>
		<ul class="ad-three">
			<li><b>Listen</b><span>Every recording in this book, by the code on its page.</span></li>
			<li><b>Talk</b><span>The speaking units hand their prompt to a tutor that answers back.</span></li>
			<li><b>Play</b><span>Flashcard decks, picture hunts and the medal ladder for every unit.</span></li>
		</ul>
	</section>

	<section class="sheet front contents">
		<p class="eyebrow">Contents and progress</p>
		<h2>What is in this book</h2>
		{#each book.parts as part (part.n)}
			<h3 class="part-head"><span class="tnum">Part {part.n}</span> {part.level} · {part.title}{#if part.subtitle} <small>{part.subtitle}</small>{/if}</h3>
			<table class="toc">
				<thead><tr><th>Unit</th><th>Title</th><th>Type</th><th class="c">Learn</th><th class="c">Practise</th><th class="c">Medal</th></tr></thead>
				<tbody>
					{#each part.workbook.units as unit (unit.n)}
						{@const ch = part.chapters.find((c) => c.units[0]?.quizId === unit.quizId)}
						{#if ch}
							<tr class="toc-chapter"><td colspan="6">{#if ch.photo}<img src="/img/photo/{ch.photo.id}.jpg" alt="" />{/if}<span><b>Chapter {ch.n} · {ch.title}</b>{#if ch.subtitle} <small>{ch.subtitle}</small>{/if}</span></td></tr>
						{/if}
						<tr>
							<td class="tnum">{part.n}.{unit.n}</td>
							<td>{unit.title}</td>
							<td class="type">{unit.kindLabel}</td>
							<td class="c"><span class="box"></span></td>
							<td class="c"><span class="box"></span></td>
							<td class="c"><span class="box"></span><span class="box"></span><span class="box"></span></td>
						</tr>
					{/each}
					<tr><td class="tnum">★</td><td>Challenge</td><td class="type">Medal ladder</td><td class="c"></td><td class="c"><span class="box"></span></td><td class="c"></td></tr>
				</tbody>
			</table>
		{/each}
		<p class="toc-back"><b>At the back:</b> the key · grammar tables · word index A–Z · the audio index.</p>
	</section>

	<!-- ── Parts ─────────────────────────────────────────────────────── -->
	{#each book.parts as part (part.n)}
		<div class="part part{part.n}">
			<section class="sheet part-opener">
				<p class="kicker">Part {part.n}</p>
				<p class="code">{part.level}</p>
				<h1>{part.title}</h1>
				{#if part.subtitle}<p class="sub">{part.subtitle}</p>{/if}
				{#if part.photo}
					<figure class="photo">
						<img src="/img/photo/{part.photo.id}.jpg" alt="" />
						{#if part.caption}<figcaption lang="de">{part.caption}</figcaption>{/if}
					</figure>
					{#if part.de}<p class="intro-de" lang="de">{part.de}</p><p class="intro-en">{part.en}</p>{/if}
				{:else if part.workbook.cover}<img class="cover-pic" src="/img/{part.workbook.cover}.webp" alt="" width="1024" height="768" />{/if}
				{#if part.canDo.length}
					<div class="cando">
						<p class="eyebrow">By the end of this part you can</p>
						<ul>{#each part.canDo as item, i (i)}<li>{item}</li>{/each}</ul>
					</div>
				{/if}
				{#if part.themes.length}
					<p class="themes"><b>Themes:</b> {part.themes.join(' · ')}</p>
				{/if}
			</section>

			{#each part.workbook.units as unit, i (unit.n)}
				{@const chapter = part.chapters.find((c) => c.units[0]?.quizId === unit.quizId)}
				{#if chapter}
					<section class="sheet chapter">
						<p class="kicker">Part {part.n} · Chapter {chapter.n}</p>
						<h1 class="ch-title">{chapter.title}</h1>
						{#if chapter.subtitle}<p class="sub">{chapter.subtitle}</p>{/if}
						{#if chapter.photo}
							<figure class="photo">
								<img src="/img/photo/{chapter.photo.id}.jpg" alt="" />
								{#if chapter.caption}<figcaption lang="de">{chapter.caption}</figcaption>{/if}
							</figure>
						{/if}
						{#if chapter.de}<p class="intro-de" lang="de">{chapter.de}</p><p class="intro-en">{chapter.en}</p>{/if}
						<div class="ch-units">
							<p class="eyebrow">In this chapter</p>
							<ol>{#each chapter.units as u (u.n)}<li><span class="tnum">{part.n}.{u.n}</span> {u.title} <small>{u.kindLabel}</small></li>{/each}</ol>
						</div>
					</section>
				{/if}
				<div class="sheet unit-sheet">
					<WorkbookUnit {unit} partNo={part.n} qr={data.unitQr[unit.quizId] ?? []} compact />
				</div>
				{#if part.round && i === Math.floor(part.workbook.units.length / 2)}
					<section class="sheet round">
						<p class="eyebrow">A breather · Ja oder Nein?</p>
						<h2>{part.round.title} <small>{part.round.en}</small></h2>
						<p class="lede">{part.round.hook} Read each question out loud and tick <b>Ja</b> or <b>Nein</b>. There is no right answer; there is only you.</p>
						<ol class="janein">
							{#each part.round.questions as q, k (k)}
								<li><span class="n tnum">{k + 1}</span><div><p class="de" lang="de">{q.de}</p><p class="en">{q.en}</p></div><span class="jn"><span class="box"></span> Ja <span class="box"></span> Nein</span></li>
							{/each}
						</ol>
					</section>
				{/if}
			{/each}

			{#if part.challenge.length}
				<section class="sheet challenge">
					<p class="eyebrow">Part {part.n} · Medal ladder</p>
					<h2>Challenge</h2>
					<p class="lede">The hardest sentences of this part, with no help. Write the missing word. 16 right earns bronze, 18 silver, 20 gold; tick your medal on the contents page.</p>
					<ol class="cloze">
						{#each part.challenge as item (item.n)}
							<li>
								<span class="n tnum">{item.n}</span>
								<div>
									<p class="sentence" lang="de">{#each item.sentence.split('____') as piece, p (p)}{#if p > 0}<span class="gap"></span>{/if}{piece}{/each}</p>
									{#if item.english}<p class="en">{item.english} <small>· unit {part.n}.{item.unit}</small></p>{/if}
								</div>
							</li>
						{/each}
					</ol>
					<footer class="answers"><p><strong>Answers · Challenge {part.n}</strong>{#each part.challenge as item (item.n)}<span class="a"><span class="tnum">{item.n}</span>&nbsp;{item.answer}</span>{/each}</p></footer>
				</section>
			{/if}
		</div>
	{/each}

	<!-- ── Back matter ───────────────────────────────────────────────── -->
	<div class="back">
		{#if book.key.length}
			<section class="sheet key">
				<p class="eyebrow">Key</p>
				<h2>Transcripts, dictations and picture hunts</h2>
				<div class="key-cols">
					{#each book.key as entry, i (i)}
						<div class="key-entry">
							<h3><span class="tnum">{entry.part}.{entry.unit}</span> {entry.title} <small>· {entry.label}</small></h3>
							{#each entry.lines as line, l (l)}<p lang="de">{line}</p>{/each}
						</div>
					{/each}
				</div>
			</section>
		{/if}

		{#if book.appendix.length}
			<section class="sheet appendix">
				<p class="eyebrow">Grammar tables</p>
				<h2>The tables of this book</h2>
				<div class="tables">
					{#each book.appendix as entry, i (i)}
						<div class="app-table">
							<p class="t-head"><span class="tnum">{entry.part}.{entry.unit}</span> {entry.title}</p>
							<table>
								{#if entry.table.caption}<caption>{entry.table.caption}</caption>{/if}
								<thead><tr>{#each entry.table.columns as col, c (c)}<th>{col}</th>{/each}</tr></thead>
								<tbody>{#each entry.table.rows as row, r (r)}<tr>{#each row.cells as cell, c (c)}{#if c === 0}<th>{cell}</th>{:else}<td>{cell}</td>{/if}{/each}</tr>{/each}</tbody>
							</table>
						</div>
					{/each}
				</div>
			</section>
		{/if}

		<section class="sheet index">
			<p class="eyebrow">Word index</p>
			<h2>Every word in this book, A to Z</h2>
			<p class="lede">The number says where the word is taught: part and unit.</p>
			<div class="index-cols">
				{#each letters as letter (letter)}
					<h3 class="letter">{letter}</h3>
					{#each book.index.filter((e) => e.de[0].toUpperCase() === letter) as e (e.article + e.de)}
						<p class="ix" style={e.article ? `--g:${GENDER_COLORS[e.article === 'der' ? 'm' : e.article === 'die' ? 'f' : 'n']}` : ''}>
							<span class="ix-de" lang="de">{#if e.article}<span class="article">{e.article}</span> {/if}{e.de}{#if e.plural}<span class="pl"> {e.plural}</span>{/if}</span>
							<span class="ix-en">{e.en}</span>
							<span class="ix-where tnum">{e.where}</span>
						</p>
					{/each}
				{/each}
			</div>
		</section>

		{#if book.credits.length}
			<section class="sheet credits">
				<p class="eyebrow">Picture credits</p>
				<h2>The photographs</h2>
				<p class="lede">The photographs are used under free licences; the drawings and diagrams were made for this course. Thank you to the photographers who share their work.</p>
				<ol class="credit-list">
					{#each book.credits as ph (ph.id)}
						<li><img src="/img/photo/{ph.id}.jpg" alt="" /><span><b>{ph.title.replace(/.[a-z]+$/i, '').replace(/_/g, ' ')}</b><br />{ph.author} · {ph.license}<br /><span class="mono">{ph.source}</span></span></li>
					{/each}
				</ol>
			</section>
		{/if}

		<section class="sheet audio-index">
			<p class="eyebrow">Audio</p>
			<h2>Everything you can listen to</h2>
			<p class="lede">Each unit's Listen code opens a player with these recordings. Without a camera, type the address printed under the code.</p>
			<table class="audio">
				<thead><tr><th>Unit</th><th>Title</th><th class="c">Clips</th><th>Code</th></tr></thead>
				<tbody>
					{#each book.audio as a (a.quizId)}
						{@const code = (data.unitQr[a.quizId] ?? []).find((q) => q.label === 'Listen')?.code}
						{#if code}
							<tr><td class="tnum">{a.part}.{a.unit}</td><td>{a.title}</td><td class="c tnum">{a.clips}</td><td class="mono">{data.siteHost}/b/{code}</td></tr>
						{/if}
					{/each}
				</tbody>
			</table>
			<div class="colophon">
				<p>Set in Source Serif 4 and Inter. Printed on demand.</p>
			</div>
		</section>
	</div>
</main>

<style>
	:global(body) {
		background: var(--paper-mid);
	}

	.book {
		--serif: 'Source Serif 4 Variable', 'Source Serif 4', ui-serif, Georgia, serif;
		--cream: #fbf5e4;
		max-width: 210mm;
		margin: 0 auto;
		padding: 1rem 0 4rem;
		display: grid;
		gap: 1rem;
		color: var(--ink);
		font-size: 10pt;
	}

	.sheet {
		background: #fff;
		padding: 16mm 15mm 18mm;
		box-shadow: 0 1px 4px rgb(0 0 0 / 0.08);
	}

	.eyebrow {
		margin: 0;
		font-size: 7.2pt;
		font-weight: 800;
		letter-spacing: 0.09em;
		text-transform: uppercase;
		color: var(--accent);
	}
	.brand-line {
		display: flex;
		align-items: center;
		gap: 2mm;
		margin: 0 0 3mm;
		font-size: 8.5pt;
		font-weight: 700;
		color: var(--navy);
	}
	.brand-line img {
		width: 6mm;
		height: 6mm;
		border-radius: 1.3mm;
	}
	.kicker {
		margin: 0;
		font-size: 8pt;
		font-weight: 800;
		letter-spacing: 0.1em;
		text-transform: uppercase;
		color: var(--ink-muted);
	}
	h1,
	h2,
	h3 {
		font-family: var(--serif);
		color: var(--navy);
		margin: 0;
	}
	h2 {
		font-size: 22pt;
		margin: 1mm 0 4mm;
	}
	.lede {
		font-size: 10.5pt;
		color: var(--ink-muted);
		margin: 0 0 5mm;
		line-height: 1.5;
	}
	.box {
		display: inline-block;
		width: 3.4mm;
		height: 3.4mm;
		border: 0.3mm solid var(--ink);
		border-radius: 0.6mm;
		vertical-align: middle;
		margin: 0 0.5mm;
	}
	.tnum {
		font-variant-numeric: tabular-nums;
	}

	/* -- front matter ------------------------------------------------------- */

	.advert {
		display: grid;
		align-content: space-between;
		min-height: 226mm;
		background: var(--navy);
		color: #fff;
		border-radius: 3mm;
	}
	.ad-kicker {
		margin: 0;
		font-size: 8pt;
		font-weight: 800;
		letter-spacing: 0.12em;
		text-transform: uppercase;
		color: #e8b48c;
	}
	.ad-title {
		margin: 3mm 0 4mm;
		font-family: var(--serif);
		font-size: 36pt;
		line-height: 1.05;
		color: #fff;
	}
	.ad-lede {
		margin: 0;
		max-width: 150mm;
		font-size: 11pt;
		line-height: 1.55;
		color: #e9eef5;
	}
	.ad-body {
		display: grid;
		grid-template-columns: 1fr 62mm;
		gap: 10mm;
		align-items: center;
		margin: 8mm 0;
	}
	.ad-mock {
		background: #fbf8f3;
		color: var(--ink);
		border-radius: 4mm;
		padding: 4mm 5mm 5mm;
		box-shadow: 0 6mm 10mm rgb(0 0 0 / 0.25);
	}
	.mock-bar {
		display: flex;
		gap: 1.5mm;
		margin-bottom: 3mm;
	}
	.mock-dot {
		width: 2.4mm;
		height: 2.4mm;
		border-radius: 50%;
		background: var(--line-strong);
	}
	.mock-head {
		margin: 0;
		font-family: var(--serif);
		font-size: 14pt;
		font-weight: 700;
		color: var(--navy);
	}
	.mock-sub {
		margin: 0.5mm 0 3mm;
		font-size: 8.5pt;
		color: var(--ink-muted);
	}
	.mock-row {
		display: flex;
		align-items: center;
		gap: 2.5mm;
		padding: 2mm 2.5mm;
		margin-bottom: 1.5mm;
		border: 0.25mm solid var(--line-strong);
		border-radius: 2mm;
		background: #fff;
		font-size: 9.5pt;
	}
	.mock-row.on {
		background: #eef3ef;
		border-color: var(--forest);
	}
	.mock-box {
		display: inline-grid;
		place-items: center;
		width: 4.2mm;
		height: 4.2mm;
		border: 0.3mm solid var(--ink);
		border-radius: 0.8mm;
		font-size: 8pt;
		font-weight: 800;
		color: #fff;
	}
	.mock-row.on .mock-box {
		background: var(--forest);
		border-color: var(--forest);
	}
	.mock-n {
		font-weight: 800;
		color: var(--navy);
	}
	.mock-count {
		margin: 3mm 0 0;
		font-size: 9pt;
		font-weight: 700;
		color: var(--navy);
	}
	.ad-qr {
		display: grid;
		justify-items: center;
		text-align: center;
		gap: 2mm;
	}
	.qr.big {
		width: 52mm;
		height: 52mm;
		padding: 3mm;
		background: #fff;
		border-radius: 3mm;
		box-sizing: border-box;
	}
	.ad-code {
		margin: 0;
		font-family: ui-monospace, Menlo, Consolas, monospace;
		font-size: 10pt;
		color: #fff;
	}
	.ad-note {
		margin: 0;
		font-size: 8.5pt;
		line-height: 1.45;
		color: #c9d3e0;
	}
	.ad-three {
		display: grid;
		grid-template-columns: repeat(3, 1fr);
		gap: 6mm;
		margin: 0;
		padding: 5mm 0 0;
		list-style: none;
		border-top: 0.3mm solid rgb(255 255 255 / 0.25);
	}
	.ad-three li {
		display: grid;
		gap: 1mm;
		font-size: 9pt;
		line-height: 1.45;
		color: #e9eef5;
	}
	.ad-three b {
		font-family: var(--serif);
		font-size: 13pt;
		color: #fff;
	}

	.half-title,
	.title-page {
		display: grid;
		align-content: center;
		justify-items: start;
		min-height: 240mm;
	}
	.half-title {
		min-height: 120mm;
	}
	.big {
		font-size: 64pt;
		line-height: 1;
		color: var(--accent);
		margin: 2mm 0 3mm;
	}
	.sub {
		margin: 0;
		font-family: var(--serif);
		font-size: 20pt;
		color: var(--navy);
	}
	.cover-pic {
		width: 100%;
		max-height: 110mm;
		object-fit: contain;
		margin: 8mm 0;
		border-radius: 3mm;
		background: var(--cream);
	}
	.tag {
		font-size: 11pt;
		line-height: 1.5;
		color: var(--ink-muted);
		max-width: 150mm;
	}
	.copyright {
		display: grid;
		align-content: end;
		min-height: 240mm;
		font-size: 8.5pt;
		line-height: 1.55;
		color: var(--ink-muted);
	}
	.copyright p {
		margin: 0 0 2.5mm;
	}
	.copyright .small {
		font-size: 7.5pt;
	}
	.about-grid {
		display: grid;
		grid-template-columns: 1fr 1fr;
		gap: 8mm;
	}
	.about p {
		font-size: 9.5pt;
		line-height: 1.55;
		margin: 0 0 3mm;
	}
	.how-grid {
		display: grid;
		grid-template-columns: 1fr 1fr;
		gap: 8mm;
	}
	.how h3 {
		font-size: 12pt;
		margin: 3mm 0 1.5mm;
	}
	.how p,
	.how li {
		font-size: 9.5pt;
		line-height: 1.5;
	}
	.steps {
		padding-left: 4.5mm;
		margin: 0;
	}
	.steps li {
		margin-bottom: 2mm;
	}
	.legend-list {
		padding-left: 4mm;
		margin: 0;
	}
	.book-qr {
		display: flex;
		align-items: center;
		gap: 3mm;
		margin-top: 5mm;
		padding: 3mm;
		border: 0.25mm solid var(--line-strong);
		border-radius: 2mm;
	}
	.qr {
		display: block;
		width: 22mm;
		height: 22mm;
		flex: none;
	}
	.qr :global(svg) {
		width: 100%;
		height: 100%;
		display: block;
	}
	.qr-text {
		font-size: 8pt;
		line-height: 1.45;
		color: var(--ink-muted);
	}
	.qr-text b {
		color: var(--navy);
	}
	.part-head {
		font-size: 13pt;
		margin: 5mm 0 2mm;
		break-after: avoid;
	}
	.part-head small {
		font-family: Inter, sans-serif;
		font-size: 9pt;
		font-weight: 500;
		color: var(--ink-muted);
	}
	.toc {
		width: 100%;
		border-collapse: collapse;
		font-size: 8.5pt;
	}
	.toc th,
	.toc td {
		padding: 0.7mm 1.5mm;
		border-bottom: 0.2mm solid var(--line);
		text-align: left;
		vertical-align: middle;
	}
	.toc thead th {
		font-size: 6.8pt;
		font-weight: 800;
		letter-spacing: 0.06em;
		text-transform: uppercase;
		color: var(--ink-muted);
		border-bottom: 0.35mm solid var(--navy);
	}
	.toc .type {
		font-size: 7.5pt;
		color: var(--ink-muted);
	}
	.toc .c {
		text-align: center;
		white-space: nowrap;
	}
	.toc-back {
		margin: 4mm 0 0;
		font-size: 9pt;
		color: var(--ink-muted);
	}

	/* -- parts ------------------------------------------------------------ */

	.part-opener {
		display: grid;
		justify-items: start;
		align-content: start;
		min-height: 240mm;
	}
	.part-opener .code {
		margin: 2mm 0 0;
		font-family: var(--serif);
		font-size: 58pt;
		line-height: 1;
		font-weight: 800;
		color: var(--accent);
	}
	.part-opener h1 {
		font-size: 30pt;
		margin: 1mm 0 2mm;
	}
	.photo {
		margin: 4mm 0 0;
		width: 100%;
	}
	.photo img {
		display: block;
		width: 100%;
		height: 96mm;
		object-fit: cover;
		border-radius: 2.5mm;
	}
	.photo figcaption {
		margin-top: 1.2mm;
		font-size: 7.5pt;
		color: var(--ink-muted);
		text-align: right;
	}
	.intro-de {
		margin: 5mm 0 1.5mm;
		font-family: var(--serif);
		font-size: 13.5pt;
		line-height: 1.5;
		color: var(--ink);
	}
	.intro-en {
		margin: 0;
		font-size: 9pt;
		line-height: 1.5;
		color: var(--ink-muted);
	}
	.chapter {
		display: grid;
		align-content: start;
		justify-items: start;
		min-height: 240mm;
	}
	.ch-title {
		font-size: 34pt;
		margin: 1mm 0 1mm;
		color: var(--accent);
	}
	.ch-units {
		margin-top: 6mm;
		width: 100%;
	}
	.ch-units ol {
		margin: 1.5mm 0 0;
		padding: 0;
		list-style: none;
		columns: 2;
		column-gap: 8mm;
		font-size: 9.5pt;
		line-height: 1.6;
	}
	.ch-units .tnum {
		font-weight: 700;
		color: var(--navy);
		margin-right: 1.5mm;
	}
	.ch-units small {
		color: var(--ink-muted);
		font-size: 7.5pt;
	}
	.toc-chapter td {
		padding-top: 3mm;
		border-bottom: 0.3mm solid var(--navy);
	}
	.toc-chapter td img {
		width: 14mm;
		height: 9mm;
		object-fit: cover;
		border-radius: 1mm;
		vertical-align: middle;
		margin-right: 2.5mm;
	}
	.toc-chapter b {
		color: var(--navy);
	}
	.credit-list {
		margin: 0;
		padding: 0;
		list-style: none;
		display: grid;
		gap: 3mm;
	}
	.credit-list li {
		display: grid;
		grid-template-columns: 30mm 1fr;
		gap: 3mm;
		align-items: center;
		font-size: 8.5pt;
		line-height: 1.45;
		break-inside: avoid;
	}
	.credit-list img {
		width: 30mm;
		height: 20mm;
		object-fit: cover;
		border-radius: 1.5mm;
	}
	.cando {
		margin-top: 4mm;
		padding: 4mm 5mm;
		border-left: 1mm solid var(--navy);
		background: var(--cream);
		width: 100%;
		box-sizing: border-box;
	}
	.cando ul {
		margin: 1.5mm 0 0;
		padding-left: 4.5mm;
		font-size: 10pt;
		line-height: 1.5;
	}
	.themes {
		margin: 4mm 0 0;
		font-size: 9.5pt;
		color: var(--ink-muted);
	}

	/* -- round, challenge -------------------------------------------------- */

	.round h2 small,
	.challenge h2 small {
		font-family: Inter, sans-serif;
		font-size: 10pt;
		font-weight: 500;
		color: var(--ink-muted);
	}
	.janein {
		margin: 0;
		padding: 0;
		list-style: none;
		display: grid;
		gap: 3mm;
	}
	.janein li {
		display: grid;
		grid-template-columns: 6mm 1fr auto;
		gap: 3mm;
		align-items: center;
		padding: 2.5mm 3mm;
		border-radius: 2mm;
		background: var(--cream);
	}
	.janein .de {
		margin: 0;
		font-family: var(--serif);
		font-size: 13pt;
	}
	.janein .en,
	.challenge .en {
		margin: 0;
		font-size: 8.5pt;
		color: var(--ink-muted);
	}
	.jn {
		font-size: 9pt;
		font-weight: 700;
		white-space: nowrap;
	}
	.n {
		display: inline-flex;
		align-items: center;
		justify-content: center;
		width: 5.4mm;
		height: 5.4mm;
		border: 0.35mm solid var(--navy);
		border-radius: 50%;
		color: var(--navy);
		font-size: 7.5pt;
		font-weight: 800;
	}
	.cloze {
		margin: 0;
		padding: 0;
		list-style: none;
		display: grid;
		grid-template-columns: repeat(2, minmax(0, 1fr));
		gap: 3.5mm 6mm;
	}
	.cloze li {
		display: grid;
		grid-template-columns: 6mm minmax(0, 1fr);
		gap: 2mm;
		align-items: start;
		break-inside: avoid;
	}
	.sentence {
		margin: 0;
		font-family: var(--serif);
		font-size: 11pt;
		line-height: 1.55;
	}
	.gap {
		display: inline-block;
		width: 7em;
		height: 0.95em;
		margin: 0 0.15em;
		border-bottom: 0.35mm solid var(--ink);
		vertical-align: baseline;
	}
	.answers {
		margin-top: 4mm;
		padding-top: 2mm;
		border-top: 0.25mm dashed var(--line-strong);
	}
	.answers p {
		margin: 0;
		transform: rotate(180deg);
		font-size: 7.6pt;
		line-height: 1.6;
		color: var(--ink-muted);
	}
	.answers strong {
		margin-right: 2mm;
		color: var(--navy);
	}
	.a {
		display: inline-block;
		margin-right: 3mm;
	}

	/* -- back matter ------------------------------------------------------ */

	.key-entry {
		margin-bottom: 4mm;
		break-inside: avoid;
	}
	.key-entry h3 {
		font-size: 11pt;
		margin-bottom: 1mm;
	}
	.key-entry h3 small {
		font-family: Inter, sans-serif;
		font-size: 8pt;
		font-weight: 600;
		color: var(--ink-muted);
	}
	.key-entry p {
		margin: 0;
		font-family: var(--serif);
		font-size: 9.5pt;
		line-height: 1.5;
	}
	.tables {
		columns: 2;
		column-gap: 8mm;
	}
	.app-table {
		break-inside: avoid;
		margin-bottom: 4mm;
	}
	.t-head {
		margin: 0 0 1mm;
		font-size: 8pt;
		font-weight: 700;
		color: var(--navy);
	}
	.appendix table,
	.audio {
		width: 100%;
		border-collapse: collapse;
		font-size: 8pt;
	}
	.appendix th,
	.appendix td,
	.audio th,
	.audio td {
		padding: 0.8mm 1.5mm;
		border-bottom: 0.2mm solid var(--line);
		text-align: left;
	}
	.appendix thead th,
	.audio thead th {
		font-size: 6.5pt;
		font-weight: 800;
		letter-spacing: 0.06em;
		text-transform: uppercase;
		color: var(--ink-muted);
		border-bottom: 0.3mm solid var(--navy);
	}
	.appendix tbody th {
		font-family: var(--serif);
		font-size: 9pt;
	}
	caption {
		text-align: left;
		font-size: 7pt;
		color: var(--ink-muted);
		padding-bottom: 0.8mm;
	}
	.index-cols {
		columns: 3;
		column-gap: 6mm;
	}
	.letter {
		font-size: 13pt;
		color: var(--accent);
		margin: 2mm 0 1mm;
		break-after: avoid;
	}
	.ix {
		overflow-wrap: anywhere;
		margin: 0 0 0.6mm;
		font-size: 8pt;
		line-height: 1.3;
		break-inside: avoid;
		display: grid;
		grid-template-columns: minmax(0, 1fr) auto;
		column-gap: 1.5mm;
	}
	.ix-de {
		font-family: var(--serif);
		font-size: 9pt;
		font-weight: 650;
		color: var(--g, var(--ink));
	}
	.ix .article {
		font-weight: 400;
	}
	.ix .pl {
		font-weight: 400;
		color: var(--ink-muted);
	}
	.ix-en {
		grid-column: 1;
		color: var(--ink-muted);
	}
	.ix-where {
		grid-column: 2;
		grid-row: 1 / span 2;
		align-self: start;
		color: var(--ink-muted);
	}
	.audio .c {
		text-align: center;
	}
	.mono {
		font-family: ui-monospace, Menlo, Consolas, monospace;
		font-size: 7.5pt;
	}
	.colophon {
		margin-top: 10mm;
		font-size: 8pt;
		color: var(--ink-muted);
	}

	/* -- print ---------------------------------------------------------- */

	@media print {
		:global(body) {
			background: #fff;
		}
		:global(.skip-link),
		:global(header.site),
		:global(.site-nav),
		:global(footer.site) {
			display: none !important;
		}
		.book {
			display: block;
			max-width: none;
			padding: 0;
		}
		.sheet {
			padding: 0;
			box-shadow: none;
			break-before: page;
		}
		.front {
			page: front;
		}
		/* The navy page: a card that fills the printable area exactly, inside the white margins. */
		.sheet.advert {
			height: 243mm;
			min-height: 0;
			padding: 12mm 12mm 10mm;
			box-sizing: border-box;
			overflow: hidden;
			border-radius: 3mm;
			-webkit-print-color-adjust: exact;
			print-color-adjust: exact;
		}
		.part1 .sheet {
			page: part1;
		}
		.part2 .sheet {
			page: part2;
		}
		.back .sheet {
			page: back;
		}
		.half-title,
		.title-page,
		.copyright,
		.part-opener {
			min-height: 226mm;
		}
		/* Part openers and the title page start on a right-hand page. */
		/* Chrome prints break-before: right as a plain page break; openers may land left. */
		.title-page,
		.part-opener,
		.chapter {
			break-before: page;
		}
		/* Pages that share: about + how, key + tables, credits + audio. */
		.how,
		.appendix,
		.audio-index {
			break-before: auto;
			margin-top: 8mm;
		}
		.about p,
		.how p,
		.how li {
			font-size: 9pt;
			line-height: 1.42;
		}
		.about p {
			margin-bottom: 2mm;
		}
		.about-grid,
		.how-grid {
			gap: 6mm;
		}
		h2 {
			font-size: 19pt;
			margin-bottom: 3mm;
		}
		/* Contents: no thumbnails, tighter rows. */
		.toc-chapter td img {
			display: none;
		}
		.toc th,
		.toc td {
			padding: 0.45mm 1.5mm;
		}
		.toc-chapter td {
			padding-top: 2mm;
		}
		.part-head {
			margin: 3mm 0 1.5mm;
		}
		/* A chapter opener is a half page: the chapter's first unit follows on it. */
		.chapter {
			min-height: 0;
		}
		.chapter .photo img {
			height: 78mm;
		}
		.ch-title {
			font-size: 28pt;
		}
		.intro-de {
			margin-top: 3.5mm;
			font-size: 12pt;
			line-height: 1.45;
		}
		.ch-units {
			margin-top: 3.5mm;
		}
		.ch-units ol {
			font-size: 8.8pt;
			line-height: 1.45;
		}
		.chapter + .unit-sheet {
			margin-top: 7mm;
		}
		/* Back matter, denser. */
		.key-cols {
			columns: 2;
			column-gap: 7mm;
		}
		.key-entry {
			margin-bottom: 3mm;
		}
		.key-entry h3 {
			font-size: 9.5pt;
		}
		.key-entry p {
			font-size: 8.6pt;
			line-height: 1.4;
		}
		.index-cols {
			columns: 3;
			column-gap: 6mm;
		}
		.ix {
			font-size: 7.6pt;
			margin-bottom: 0.5mm;
		}
		.ix-de {
			font-size: 8.6pt;
		}
		.letter {
			font-size: 11pt;
			margin: 1.5mm 0 0.6mm;
		}
		.credit-list {
			columns: 2;
			column-gap: 7mm;
			display: block;
		}
		.credit-list li {
			margin-bottom: 2.5mm;
		}
		.colophon {
			margin-top: 5mm;
		}
		/* Units, the breather and the challenge flow on from whatever came
		   before; a unit's own head keeps it from being orphaned. */
		.unit-sheet,
		.round,
		.challenge {
			break-before: auto;
		}
		.unit-sheet + .unit-sheet,
		.unit-sheet + .round,
		.round + .unit-sheet,
		.unit-sheet + .challenge {
			margin-top: 7mm;
		}
	}
	@media screen and (max-width: 40rem) {
		.how-grid,
		.cloze {
			grid-template-columns: 1fr;
		}
		.index-cols,
		.tables {
			columns: 1;
		}
	}
</style>
