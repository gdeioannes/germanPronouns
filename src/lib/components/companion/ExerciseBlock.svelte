<script lang="ts">
	// One exercise on a companion's right page, shaped for a pencil: lines to
	// write on, dots to join, tags to fill. The answers are in the key at the
	// back (domain/companion answerKey), never on the page.
	import { rich, type Exercise } from '$lib/domain/companion';
	import ClockFace from './ClockFace.svelte';

	let { ex, n, listen = null }: { ex: Exercise; n: number; listen?: { svg: string; code: string } | null } = $props();

	/** When the prompt and the answer won't both fit on one row (in its column), the line goes underneath, full width. */
	const tooLong = (item: { prompt: string; answer: string }) => (item.prompt.length + item.answer.length) * (ex.kind === 'write' ? (ex.cols ?? 1) : 1) > 64;
	/** One layout per exercise, so rows side by side line up. */
	const stacked = (ex.kind === 'write' && ex.items.some(tooLong));
</script>

<section class="ex">
	<header>
		<span class="n">{n}</span>
		<div>
			<h3>{ex.title}</h3>
			<p class="how">{@html rich(ex.instruction)}</p>
		</div>
		{#if ex.listen && listen}
			<figure class="qr">
				{@html listen.svg}
				<figcaption>Listen<br /><span>{listen.code}</span></figcaption>
			</figure>
		{/if}
	</header>

	{#if ex.kind === 'colour'}
		{#if ex.image}<img class="colour-pic" src="/img/{ex.image}.webp" alt="" width="1024" height="768" />{/if}
		<ol class="colour">
			{#each ex.sentences as line, i (i)}<li lang="de"><span class="tick"></span>{line}</li>{/each}
		</ol>
	{:else}
	<div class="body" class:with-pic={ex.image}>
	<div>
	{#if ex.kind === 'circle'}
		<ol class="circle" style:--cols={ex.cols ?? 1}>
			{#each ex.items as item, i (i)}
				<li lang="de">
					{item.before}
					<span class="choice">{#each item.options as o, j (j)}{#if j}<span class="slash">/</span>{/if}<span>{o}</span>{/each}</span>
					{item.after ?? ''}
				</li>
			{/each}
		</ol>
	{:else if ex.kind === 'sort'}
		<p class="bank" lang="de">{#each ex.words as w, i (i)}<span>{w}</span>{/each}</p>
		<div class="sort" style:--cols={ex.columns.length}>
			{#each ex.columns as c, ci (ci)}
				<div><b lang="de">{c}</b>{#each Array(Math.ceil(ex.words.length / ex.columns.length) + 1) as _, i (i)}<span class="line"></span>{/each}</div>
			{/each}
		</div>
	{:else if ex.kind === 'write'}
		<ol class="write" style:--cols={ex.cols ?? 1}>
			{#each ex.items as item, i (i)}
				<!-- A whole sentence to write gets a full-width line under its prompt. -->
				<li class:stack={stacked}><span class="prompt" lang="de">{@html rich(item.prompt)}</span><span class="line"></span></li>
			{/each}
		</ol>
	{:else if ex.kind === 'match'}
		<div class="match">
			<ol>
				{#each ex.left as l, i (i)}<li class="tnum">{l}<span class="dot"></span></li>{/each}
			</ol>
			<ol>
				{#each ex.right as r, i (i)}<li lang="de"><span class="dot"></span>{r}</li>{/each}
			</ol>
		</div>
	{:else if ex.kind === 'tags'}
		<ol class="tags">
			{#each ex.items as item, i (i)}
				<li>
					<img src="/img/{item.image}.webp" alt="" width="1024" height="1024" />
					<span class="tag"><span class="hole"></span><span class="blank"></span>{ex.unit ?? ''}</span>
					<span class="label" lang="de">{item.label}</span>
				</li>
			{/each}
		</ol>
	{:else if ex.kind === 'clocks'}
		<ol class="clocks">
			{#each ex.items as item, i (i)}
				<li>
					<span class="face"><ClockFace time={ex.draw ? null : item.time} /></span>
					{#if ex.draw}<span class="clock-de" lang="de">{item.de}</span>{:else}<span class="line"></span>{/if}
				</li>
			{/each}
		</ol>
	{:else if ex.kind === 'gaps'}
		<ol class="gaps">
			{#each ex.items as item, i (i)}
				<li lang="de">{item.before} <span class="line" class:short={item.answer}></span> {item.after ?? ''}</li>
			{/each}
		</ol>
	{/if}
	</div>
	{#if ex.image}<img class="side-pic" src="/img/{ex.image}.webp" alt="" width="1024" height="768" />{/if}
	</div>
	{/if}
</section>

<style>
	.ex {
		break-inside: avoid;
	}

	header {
		display: flex;
		align-items: flex-start;
		gap: 2.6mm;
		margin-bottom: 2.4mm;
	}

	.n {
		flex: none;
		display: inline-flex;
		align-items: center;
		justify-content: center;
		width: 6.4mm;
		height: 6.4mm;
		margin-top: 0.3mm;
		border-radius: 50%;
		background: var(--navy);
		color: #fff;
		font-size: 9pt;
		font-weight: 800;
	}

	header > div {
		flex: 1;
	}

	h3 {
		margin: 0;
		font-family: var(--serif);
		font-size: 12.5pt;
		color: var(--navy);
	}

	.how {
		margin: 0.4mm 0 0;
		font-size: 9pt;
		color: var(--muted);
	}

	.qr {
		flex: none;
		display: flex;
		align-items: center;
		gap: 1.6mm;
		margin: 0;
	}

	.qr :global(svg) {
		width: 15mm;
		height: 15mm;
	}

	.qr figcaption {
		font-size: 7.5pt;
		font-weight: 800;
		color: var(--navy);
		line-height: 1.3;
	}

	.qr figcaption span {
		font-weight: 500;
		color: var(--muted);
	}

	/* A line to write on: tall enough for handwriting. */
	.line {
		flex: 1;
		display: inline-block;
		min-width: 20mm;
		height: 6.2mm;
		border-bottom: 0.3mm solid var(--ink);
	}

	.clocks {
		display: grid;
		grid-template-columns: repeat(4, minmax(0, 1fr));
		gap: 3mm 4mm;
		margin: 0;
		padding: 0;
		list-style: none;
	}

	.clocks li {
		display: grid;
		justify-items: center;
		gap: 1mm;
	}

	.clocks .face {
		width: 20mm;
	}

	.clocks .line {
		width: 100%;
	}

	.clock-de {
		font-size: 9pt;
		font-weight: 600;
		text-align: center;
	}

	.write {
		display: grid;
		grid-template-columns: repeat(var(--cols), minmax(0, 1fr));
		gap: 1mm 8mm;
		margin: 0;
		padding: 0 0 0 9mm;
		list-style: none;
	}

	.write li {
		display: flex;
		align-items: flex-end;
		gap: 2.5mm;
		font-size: 10.5pt;
	}

	.prompt {
		flex: none;
		min-width: 7mm;
		font-weight: 700;
		color: var(--navy);
	}

	.write li.stack {
		flex-direction: column;
		align-items: stretch;
		gap: 0;
	}

	.write li.stack .prompt {
		flex: none;
	}

	.write li.stack .line {
		flex: none;
		width: 100%;
	}

	/* -- match --------------------------------------------------------------- */

	.match {
		display: flex;
		justify-content: space-between;
		margin: 0 14mm 0 9mm;
	}

	.match ol {
		display: grid;
		gap: 0.9mm;
		margin: 0;
		padding: 0;
		list-style: none;
		font-size: 10pt;
	}

	.match ol:first-child li {
		font-weight: 800;
		color: var(--navy);
		text-align: right;
	}

	.dot {
		display: inline-block;
		width: 2.2mm;
		height: 2.2mm;
		margin: 0 2.4mm;
		border-radius: 50%;
		background: var(--navy);
	}

	/* -- tags ---------------------------------------------------------------- */

	.tags {
		display: grid;
		grid-template-columns: repeat(6, minmax(0, 1fr));
		gap: 3mm;
		margin: 0;
		padding: 0;
		list-style: none;
	}

	.tags li {
		display: grid;
		justify-items: center;
		gap: 1mm;
	}

	.tags img {
		width: 18mm;
		height: 18mm;
		object-fit: contain;
	}

	.tag {
		position: relative;
		display: flex;
		align-items: flex-end;
		gap: 0.8mm;
		width: 100%;
		box-sizing: border-box;
		padding: 1mm 2mm 1.2mm 5mm;
		border: 0.35mm solid var(--navy);
		border-radius: 1mm 4mm 4mm 1mm;
		font-size: 9pt;
		font-weight: 700;
	}

	.hole {
		position: absolute;
		left: 1.6mm;
		top: 50%;
		width: 1.6mm;
		height: 1.6mm;
		border: 0.3mm solid var(--navy);
		border-radius: 50%;
		transform: translateY(-50%);
	}

	.blank {
		flex: 1;
		height: 5mm;
		border-bottom: 0.25mm dotted var(--ink);
	}

	.tags .label {
		font-size: 8pt;
		text-align: center;
		color: var(--muted);
	}

	/* -- picture beside ----------------------------------------------------- */

	.body.with-pic {
		display: grid;
		grid-template-columns: 1fr 74mm;
		gap: 5mm;
		align-items: center;
	}

	.side-pic {
		width: 100%;
		height: auto;
	}

	/* -- circle the word ----------------------------------------------------- */

	.circle {
		display: grid;
		grid-template-columns: repeat(var(--cols), minmax(0, 1fr));
		gap: 2mm;
		margin: 0;
		padding: 0 0 0 9mm;
		list-style: none;
		font-size: 10.5pt;
	}

	.choice {
		display: inline-flex;
		gap: 1.6mm;
		margin: 0 1mm;
		padding: 0.3mm 2.2mm;
		border: 0.25mm dashed var(--rule);
		border-radius: 3mm;
		font-weight: 700;
		color: var(--navy);
	}

	.slash {
		font-weight: 400;
		color: var(--muted);
	}

	/* -- sort into columns ---------------------------------------------------- */

	.bank {
		display: flex;
		flex-wrap: wrap;
		gap: 1.5mm 2mm;
		margin: 0 0 2.5mm 9mm;
		font-size: 10pt;
		font-weight: 700;
	}

	.bank span {
		padding: 0.3mm 2mm;
		border: 0.25mm solid var(--rule);
		border-radius: 1mm;
	}

	.sort {
		display: grid;
		grid-template-columns: repeat(var(--cols), minmax(0, 1fr));
		gap: 0 6mm;
		margin-left: 9mm;
	}

	.sort div {
		display: grid;
	}

	.sort b {
		padding-bottom: 0.6mm;
		border-bottom: 0.5mm solid var(--navy);
		font-family: var(--serif);
		font-size: 11pt;
		text-align: center;
		color: var(--navy);
	}

	.sort .line {
		display: block;
		min-width: 0;
		height: 6.4mm;
		border-bottom: 0.25mm solid var(--rule);
	}

	/* -- colouring page ------------------------------------------------------ */

	.colour-pic {
		display: block;
		width: 100%;
		max-height: 70mm;
		object-fit: contain;
		margin-bottom: 3mm;
	}

	.colour {
		display: grid;
		grid-template-columns: 1fr 1fr;
		gap: 1.6mm 8mm;
		margin: 0;
		padding: 0 0 0 9mm;
		list-style: none;
		font-size: 10.5pt;
	}

	.colour li {
		display: flex;
		align-items: center;
		gap: 2mm;
	}

	.tick {
		flex: none;
		width: 3.4mm;
		height: 3.4mm;
		border: 0.35mm solid var(--navy);
		border-radius: 0.6mm;
	}

		/* -- gaps ---------------------------------------------------------------- */

	.gaps {
		display: grid;
		gap: 1.4mm;
		margin: 0;
		padding: 0 0 0 9mm;
		list-style: none;
		font-size: 10.5pt;
	}

	.gaps li {
		display: flex;
		align-items: flex-end;
		gap: 2mm;
	}

	/* A gap for one word or two is a short line inside the sentence; the
	   reader's own answers keep the long one. */
	.gaps .line.short {
		flex: 0 0 38mm;
	}
</style>
