<script lang="ts">
	// The written analysis that goes with the live report (../): what the
	// numbers say, read once and written down, and what was changed in the
	// tracking and on the site because of it.
	//
	// It is STATIC: a snapshot of one export (1–26 November 2026), written by
	// hand from tool/analytics-report.mjs and a few one-off sums. When a new
	// export is analysed, this page is rewritten (or a dated section is added
	// on top); nothing here updates by itself. The live report answers "what
	// are the numbers now"; this page answers "what do they mean".
	//
	// Kept to aggregates on purpose. The owner gate hides the page, but its
	// text ships in the site's public code like any other page's, so nothing
	// here describes a single visitor.
	import Seo from '$lib/components/Seo.svelte';
	import SiteNav from '$lib/components/SiteNav.svelte';
	import AnalyticsTabs from '$lib/components/backoffice/AnalyticsTabs.svelte';
	import OwnerGate from '$lib/components/backoffice/OwnerGate.svelte';
	import { page } from '$app/state';

	/** One bar of a comparison: `value` of `of`, with what it is. */
	type Bar = { label: string; value: number; of: number };
	type Finding = {
		id: string;
		title: string;
		/** The claim, in a sentence or two. */
		claim: string;
		/** What the bars compare (their heading), and the bars. */
		barsTitle?: string;
		bars?: Bar[];
		/** The numbers behind it, as sentences. */
		evidence: string[];
		/** What it means for the site. */
		meaning: string;
		/** What to do, or what was done. */
		action: string;
		/** How far to trust it. */
		caveat?: string;
	};

	const TOTAL = 629;

	const FINDINGS: Finding[] = [
		{
			id: 'one-source',
			title: 'Almost all the traffic is one source',
			claim:
				'ChatGPT recommends the site, and that is nearly the whole audience. Search engines send almost nobody.',
			barsTitle: 'Where the 629 people came from',
			bars: [
				{ label: 'ChatGPT', value: 429, of: TOTAL },
				{ label: 'Direct (typed, bookmark, unknown)', value: 108, of: TOTAL },
				{ label: 'A code in a book', value: 53, of: TOTAL },
				{ label: 'Google', value: 10, of: TOTAL },
				{ label: 'Everything else together', value: 29, of: TOTAL }
			],
			evidence: [
				'Until 16 November the site had one or two visitors a day. On 17 November it had 29, and on 25 November 100. The whole rise is ChatGPT.',
				'Google sent 10 people in 26 days, Bing 3. All social networks together: 10.',
				'Links shared from the site were tapped 40 times (30 of them WhatsApp) and brought 4 visits.'
			],
			meaning:
				'The site depends on one recommendation it does not control. If ChatGPT stops naming it, traffic goes back to almost nothing. The search engines, which would be the stable source, have not noticed the site.',
			action:
				'Done on 26 November: a page per book, the PDFs in the sitemap, proper titles inside the PDFs, book data for search engines, and an llms.txt. Still to do: set up Google Search Console and Bing Webmaster Tools to see whether any of it is picked up.'
		},
		{
			id: 'pdf-and-leave',
			title: 'ChatGPT sends people for a PDF, and they take it and go',
			claim:
				'Most ChatGPT visitors land on the books page, download within seconds, and never touch the course. Where they land decides what they do.',
			barsTitle: 'ChatGPT visitors who opened an exercise, by landing page',
			bars: [
				{ label: 'Landed on the home page', value: 50, of: 153 },
				{ label: 'Landed on the books page', value: 29, of: 259 }
			],
			evidence: [
				'259 ChatGPT visitors landed on /books: 69% downloaded, 11% opened an exercise, 5% finished one.',
				'153 landed on the home page: 55% downloaded, 33% opened an exercise, 12% finished one.',
				'Half of all downloaders had the PDF 18 seconds after arriving; three quarters within a minute.',
				'76% of ChatGPT visitors are on a phone.'
			],
			meaning:
				'These visitors asked an assistant for "a free German book" and got one. The visit is a success for them and nearly invisible to the course. The books page is doing its job as a download page and almost none as a doorway.',
			action:
				'Done on 22 November: after a download, a panel shows the downloaded book’s first chapter in the app (see the next finding). Worth trying next: on the books page itself, show what the app adds to the book (audio, checking answers) before the download button, not after.'
		},
		{
			id: 'after-download',
			title: 'The download used to be the end of the visit; the bridge changed that',
			claim:
				'Before 22 November almost no downloader went on to use the book online. Since the panel after the download, three in ten do.',
			barsTitle: 'Downloaders who then opened a chapter page or an exercise',
			bars: [
				{ label: 'Before 22 November', value: 10, of: 139 },
				{ label: 'From 22 November', value: 50, of: 168 }
			],
			evidence: [
				'Across the month, after their first download: 46% downloaded another book, 27% opened the online reader, 15% opened a chapter page, 9% opened an exercise, and 29% did nothing more at all.',
				'The panel was shown to 161 people and tapped by 40.',
				'272 of the 307 downloaders took A1.1; 187 took exactly one book; 19 took all twelve.'
			],
			meaning:
				'This is the clearest effect of any change so far: one panel moved "book, then goodbye" from 7% continuing to 30%. It also shows the limit: seven in ten still leave with the file.',
			action:
				'Keep the panel. The open idea is a reason to come back after the download ("My book" as the returning visitor’s home), which is agreed in direction and not built.',
			caveat:
				'The two periods differ in more than the panel (more visitors, more languages), so read 7% → 30% as "clearly better", not as an exact effect.'
		},
		{
			id: 'book-codes',
			title: 'The codes printed in the books are the best door into the course',
			claim:
				'People who arrive by a book’s page code behave like learners: most open an exercise, a third finish one, and they are the ones who return.',
			barsTitle: 'Opened an exercise, by how they arrived',
			bars: [
				{ label: 'A code in a book', value: 34, of: 53 },
				{ label: 'Direct', value: 37, of: 108 },
				{ label: 'ChatGPT', value: 83, of: 429 }
			],
			evidence: [
				'Book-code visitors: 64% opened an exercise and 34% finished one. ChatGPT visitors: 19% and 7%.',
				'60 different page codes were used, so people are working through the books, not just trying the first code.',
				'On a book’s page they checked answers 33 times, used the word cards 27 times and listened 25 times.',
				'Of the 72 returning visitors, 27 came by a book code.'
			],
			meaning:
				'The book is not a rival to the app; it is the strongest way into it. Someone holding the book with a code in front of them has a reason to open the site that a search visitor does not.',
			action:
				'Make the codes more visible in the books and on the download panel. Every change that gets a downloader to their first code is worth more than one that gets them to a random exercise.',
			caveat: '53 people. The direction is strong; the exact percentages will move.'
		},
		{
			id: 'returning',
			title: 'Few people come back, and those who do are a different kind of visitor',
			claim:
				'About one visitor in nine had been on the site on an earlier day. They download little and study a lot.',
			barsTitle: 'Finished an exercise that day',
			bars: [
				{ label: 'Returning visitors', value: 15, of: 72 },
				{ label: 'First-day visitors', value: 51, of: 557 }
			],
			evidence: [
				'Returning visitors (72): 13% downloaded, 46% opened an exercise, 21% finished one.',
				'First-day visitors (557): 54% downloaded, 24% opened an exercise, 9% finished one.',
				'Only 8% of visitors came back later the same day (after 30 minutes or more away).',
				'Half of all visits last under a minute and a half from first to last tap.'
			],
			meaning:
				'There are two audiences: many people passing through for a file, and a small group using the course. Averages over both describe neither. Growth in visitors has so far been growth in the first group.',
			action:
				'Judge changes by the second group: exercises finished and people returning, not visitors and downloads. The tracking now marks every event with how many exercises that browser has finished, so the two groups can be separated exactly.',
			caveat:
				'"Returning" relies on a date kept in the browser. Safari forgets it after a week without a visit, and a second device counts as new, so the real share of returning people is higher than 11%.'
		},
		{
			id: 'first-exercise',
			title: 'The first exercise decides everything, and people are lost before the first answer',
			claim:
				'Whoever finishes the first exercise almost always starts a second. Whoever does not, leaves. And those who leave mostly never answer a single question.',
			barsTitle: 'Opened a second exercise, after the first one (Zahlen 0–10)',
			bars: [
				{ label: 'Finished the first', value: 31, of: 34 },
				{ label: 'Did not finish it', value: 3, of: 38 }
			],
			evidence: [
				'The number exercise is the first one for 70 of the 168 people who opened any exercise. 72 opened it and 34 finished it.',
				'Since 22 November, of 97 people who opened an exercise, 45% answered at least one question and 40% finished: nearly everyone who answers once goes on to the end.',
				'The pronoun exercise since 22 November: 23 opened it, 12 answered a question, 12 reached five answers, 11 finished.',
				'A lesson was left by "I know this, practise now" 107 times out of 205.'
			],
			meaning:
				'The exercises themselves hold people: the drop is at the door, between opening an exercise and answering the first question. That gap is the lesson and the first screen, not the difficulty of the questions.',
			action:
				'Done on 22 November: after the first rule and its check, the lesson offers "Try it now". Next: look at what a new visitor sees in the first ten seconds of the first exercise, and get a question in front of them sooner. The new single "left the exercise" event records how far the lesson was read and how many questions were answered, which will show exactly where.',
			caveat:
				'"Answered at least one question" is only known from 22 November, and not for the number exercise, which is built differently.'
		},
		{
			id: 'core',
			title: 'A handful of people do most of the learning',
			claim:
				'Sixty-six people finished an exercise. Ten of them account for more than half of everything finished on the site.',
			barsTitle: 'The 168 people who opened an exercise',
			bars: [
				{ label: 'Finished none', value: 102, of: 168 },
				{ label: 'Finished one or two', value: 44, of: 168 },
				{ label: 'Finished three or more', value: 22, of: 168 }
			],
			evidence: [
				'247 exercises were finished in total; 144 of them by the ten busiest people (a person counts once per day).',
				'On some days one person sends a quarter of all the day’s events.',
				'131 of the 168 worked in A1.1. No other level reached 16 people.'
			],
			meaning:
				'Event charts mostly show these few people. A line that doubles can be one learner having a long evening. It also means the course beyond A1.1 is, for now, almost unvisited: its quality cannot be judged from these numbers.',
			action:
				'The live report counts people instead of events, and lists the busiest visitors so their weight is visible.'
		},
		{
			id: 'where',
			title: 'Who they are: phones, North Africa, and a learning minority in German-speaking countries',
			claim:
				'The typical visitor is on a phone outside Europe and wants the book. The visitors in Germany, Switzerland and Austria are fewer and far more likely to study.',
			barsTitle: 'Finished an exercise, by region',
			bars: [
				{ label: 'Germany, Switzerland, Austria', value: 21, of: 123 },
				{ label: 'Egypt, Morocco, Algeria, Tunisia', value: 17, of: 193 },
				{ label: 'Everywhere else', value: 28, of: 313 }
			],
			evidence: [
				'71% of all visitors are on a phone. On a Mac 43% open an exercise; on an iPhone 21%.',
				'North Africa: 193 people, 55% downloaded, 23% opened an exercise. German-speaking countries: 123 people, 29% downloaded, 38% opened an exercise, and 15% arrived by a book code.',
				'The Arabic version was used by 135 people (21%): 57% downloaded, the highest of any language with more than 50 people.',
				'Visits are spread across the day, busiest from late morning to evening in Central European time.'
			],
			meaning:
				'People already living in a German-speaking country have the need and use the course. People abroad are collecting material. The translated versions are reaching the people they were made for, at the download stage.',
			action:
				'The Arabic course stops at A2 while French, Ukrainian, Turkish and Spanish cover every level. Arabic is the largest translated audience, so its upper levels are the most justified translation work.'
		},
		{
			id: 'types',
			title: 'Speaking and dictation lose the most people, but the numbers are small',
			claim:
				'Fill-in exercises are finished by about half of those who open them. Speaking and dictation are finished far less often.',
			barsTitle: 'Finished, of the times an exercise of that kind was opened',
			bars: [
				{ label: 'Picture hunt', value: 10, of: 16 },
				{ label: 'Fill-in', value: 145, of: 267 },
				{ label: 'Reading', value: 29, of: 59 },
				{ label: 'Listening', value: 24, of: 50 },
				{ label: 'Dictation', value: 4, of: 10 },
				{ label: 'Speaking (with your own AI)', value: 4, of: 14 }
			],
			evidence: [
				'The first listening exercise of A1.1 was finished by 6 of the 16 who opened it, the lowest of the well-visited exercises.',
				'Speaking asks the learner to leave the site and paste a prompt into their own AI: 4 of 14 came back with a result.'
			],
			meaning:
				'The kinds that ask for more than tapping (typing what you hear, leaving for another app) are where people stop. That is expected, and not yet proof of a problem.',
			action:
				'No change yet. Finished runs now carry their time and score, so in a few weeks the report will show whether a low finish rate means "too hard", "too long" or "abandoned at once".',
			caveat: 'Ten and fourteen people. Wait for more before changing anything.'
		},
		{
			id: 'unused',
			title: 'Most of what is outside the course and the books is barely used',
			claim:
				'The games, the stories, the literature shelf, the forum and the worksheet each reached a dozen people or fewer in a month with 629 visitors.',
			barsTitle: 'People who used it, of 629',
			bars: [
				{ label: 'Level check', value: 45, of: TOTAL },
				{ label: 'Word library', value: 12, of: TOTAL },
				{ label: 'Wortblöcke', value: 11, of: TOTAL },
				{ label: 'Literature', value: 11, of: TOTAL },
				{ label: 'Stories', value: 10, of: TOTAL },
				{ label: 'Worksheet', value: 3, of: TOTAL },
				{ label: 'Ja oder Nein?', value: 2, of: TOTAL },
				{ label: 'Schreib mir!', value: 2, of: TOTAL },
				{ label: 'Forum', value: 1, of: TOTAL }
			],
			evidence: [
				'The cards that advertise these after a download were shown 74 times and tapped 8 times.',
				'The placement test was started by 27 people and finished by 14.',
				'4 people signed in.',
				'Asked who the book is for: 110 said "me", 7 "my class", 2 "my child"; 135 skipped the question.'
			],
			meaning:
				'Visitors come for the books and the course. The extras are not found, or not wanted, by this audience. That is not a verdict on them: almost nobody has seen them.',
			action:
				'Do not build more extras on these numbers, and do not remove any either. Spend the effort on the path every visitor is actually on: book, then first chapter, then first exercise.'
		}
	];

	type Change = { finding: string; change: string; answers: string };

	const TRACKING_22: Change[] = [
		{
			finding: 'Nobody could say where a lesson or an exercise loses people: only "opened" and "finished" were recorded.',
			change: 'New marks inside an exercise: each lesson step reached, how the lesson was left, and the first and fifth answered question.',
			answers: 'Showed that the loss is before the first answer, not during the questions.'
		},
		{
			finding: 'The question "who is the book for" was asked, but the panel after a download opened only in English.',
			change: 'The panel opens in every language and shows the downloaded book’s first chapter. Two new events: panel shown, panel tapped.',
			answers: 'Measured the bridge: 40 of 161 tapped it, and downloaders who continue rose from 7% to 30%.'
		},
		{
			finding: 'About a fifth of all events were repeats: reloads, and the same tap two to five times on a phone.',
			change: 'Page views, exercise starts and a few panel events count once per visit; a book download counts once per book per visit; one redundant event was dropped.',
			answers: 'Raw counts fell; counts of people did not change. Repeat downloads went from 59 of 451 to 11 of 165.'
		}
	];

	const TRACKING_26: Change[] = [
		{
			finding: '13% of the events of visitors with a known source were labelled "direct": a reload forgot where they came from.',
			change: 'The source is remembered for the whole browser tab.',
			answers: 'Per-source numbers in Aptabase’s own dashboard become trustworthy; the live report already corrects older data.'
		},
		{
			finding: 'A lesson sent about twelve events per reader. A quarter of all events said the same thing in pieces, and the monthly quota was in sight.',
			change: 'Those per-step events are gone. One event when someone leaves an unfinished exercise: lesson step reached, questions answered, seconds on screen.',
			answers: 'Where exactly people stop, in one row per person, at roughly a quarter fewer events.'
		},
		{
			finding: 'A finished exercise said nothing about how it went.',
			change: 'Finishing now records passed or not, time on screen, questions answered, the score where there is one, and how much of the lesson was read first.',
			answers: 'Whether a low finish rate is difficulty, length or early leaving; whether reading the lesson helps the score.'
		},
		{
			finding: 'Downloaders and learners could not be told apart except by guesswork, because the visitor id changes daily.',
			change: 'Every event carries how many exercises that browser has finished so far, as a range (0, 1–4, 5–19, 20–49, 50+). Read from the progress already kept in the browser; nothing new is stored.',
			answers: 'Every number can be split into passers-by and learners, and the size of the learning group can be followed week by week.'
		},
		{
			finding: 'ChatGPT’s visits were filed as a "campaign", as if the site had paid for them.',
			change: 'Assistants (ChatGPT, Perplexity, Claude, Gemini and others) are their own channel, "ai".',
			answers: 'AI recommendations as a whole can be followed as one source, next to search and social.'
		},
		{
			finding: '"37% come back the same day" was wrong: every reload counted as a new session.',
			change: 'The reports define a return as 30 minutes of nothing, then activity. The true figure is 8%.',
			answers: 'An honest same-day return rate. Aptabase’s own session count is still inflated.'
		},
		{
			finding: 'The dashboard’s event lines were being read as people.',
			change: 'The live report in this back office, and tool/analytics-page.mjs for a file on disk: everything counted in people, with its caveats written next to it.',
			answers: 'The questions on this page, for any dates, without redoing the sums by hand.'
		}
	];

	const NEXT = [
		{
			q: 'Does the single "left the exercise" event confirm that people leave before the first answer, and at which lesson step?',
			how: 'Live report, "Exercises: where people stop", from the day the update is live.'
		},
		{
			q: 'How big is the learning group, and is it growing with the traffic or staying the same size?',
			how: 'Live report, "Passing by, or learning?": people with 5 or more exercises finished, week against week.'
		},
		{
			q: 'Does the download bridge hold at around 30% as the audience grows?',
			how: 'Downloaders who then open a chapter page or an exercise; panel taps against panel views.'
		},
		{
			q: 'Do the new book pages and the sitemap bring any search traffic at all?',
			how: 'Google and Bing as sources in the live report; Search Console once it is set up. Ten people a month is the number to beat.'
		},
		{
			q: 'Which exercises take too long or score too low?',
			how: 'Median time and average score per exercise, once a few dozen runs have them.'
		}
	];

	const OPEN = [
		{
			what: 'Google Search Console and Bing Webmaster Tools',
			why: 'The only way to see clicks on the PDFs themselves and what people searched for. Needs your accounts; the verification files are a five-minute job after that.'
		},
		{
			what: 'Mark your own devices',
			why: 'Open the site once with ?internal=1 on each phone. Then the rule "Germany and a first visit 8 or more days ago is the owner" can go, and it stops removing real learners in Germany.'
		},
		{
			what: 'The event quota',
			why: 'The last full week ran at about 25,000 events a month before the diet. Check your plan’s limit in Aptabase: past it, days may simply go missing.'
		},
		{
			what: 'A visit counter and a session id kept in the browser',
			why: 'They would give real return rates and correct session counts. Both contradict the privacy notice as written ("no identifier is set; only the date of your first visit is kept"), so the notice would have to change first, in six languages. Not done.'
		}
	];

	const width = (b: Bar) => `${Math.round((100 * b.value) / b.of)}%`;
</script>

<Seo
	title="Analytics: the analysis"
	description="The site owner's written analysis of the analytics."
	path="/backoffice/analytics/analysis"
	noindex
/>

<SiteNav courseHref={page.data.site?.courseHref ?? '/'} />

<main class="page page-wide">
	<AnalyticsTabs current="analysis" />
	<h1>What the analytics say</h1>

	<OwnerGate>
		<p class="basis">
			<strong>Written on 26 November 2026</strong> from the export of 1–26 November: 629 people, 7,325 events.
			A “person” is one visitor on one day. Your own visits are left out. This page is a snapshot and does not
			update; for current numbers and any dates, use the <a href="/backoffice/analytics">live report</a>, whose
			notes list what these numbers cannot tell you.
		</p>

		<section class="short" aria-labelledby="short-head">
			<h2 id="short-head">The short version</h2>
			<ol>
				<li>
					<strong>The site is a book download page fed by ChatGPT.</strong> 68% of visitors come from it, half of
					everyone downloads a book, and one in ten finishes an exercise.
				</li>
				<li>
					<strong>The panel after a download works.</strong> Downloaders who go on to use the book online rose from
					7% to 30%.
				</li>
				<li>
					<strong>Book codes make learners.</strong> Two thirds of people arriving by a code open an exercise; one
					fifth of ChatGPT visitors do.
				</li>
				<li>
					<strong>People are lost before the first answer, not during the exercise.</strong> Whoever answers one
					question nearly always finishes, and whoever finishes the first exercise starts a second (31 of 34).
				</li>
				<li>
					<strong>The learning is done by few.</strong> Ten people account for more than half of all finished
					exercises, so event charts describe them, not the audience.
				</li>
			</ol>
		</section>

		<nav class="toc" aria-label="On this page">
			<a href="#findings">Ten findings</a>
			<a href="#tracking">What changed in the tracking</a>
			<a href="#next">What to check next</a>
			<a href="#open">Open decisions</a>
		</nav>

		<h2 id="findings" class="part">Ten findings</h2>
		{#each FINDINGS as f, i (f.id)}
			<article class="finding" aria-labelledby="f-{f.id}">
				<h3 id="f-{f.id}"><span class="n tnum">{i + 1}</span>{f.title}</h3>
				<p class="claim">{f.claim}</p>

				{#if f.bars}
					<figure>
						<figcaption>{f.barsTitle}</figcaption>
						<ul class="bars">
							{#each f.bars as b (b.label)}
								<li>
									<span class="b-label">{b.label}</span>
									<span class="b-track"><span style:width={width(b)}></span></span>
									<span class="b-value tnum"><strong>{width(b)}</strong> {b.value} of {b.of}</span>
								</li>
							{/each}
						</ul>
					</figure>
				{/if}

				<ul class="evidence">
					{#each f.evidence as e (e)}<li>{e}</li>{/each}
				</ul>

				<dl>
					<div>
						<dt>What it means</dt>
						<dd>{f.meaning}</dd>
					</div>
					<div>
						<dt>What to do</dt>
						<dd>{f.action}</dd>
					</div>
					{#if f.caveat}
						<div class="caveat">
							<dt>How far to trust it</dt>
							<dd>{f.caveat}</dd>
						</div>
					{/if}
				</dl>
			</article>
		{/each}

		<h2 id="tracking" class="part">What changed in the tracking because of this</h2>
		<p class="muted">
			Each change answers something the numbers could not say, or corrects something they said wrongly. The
			26 November changes are in the code and go live with the next deploy: numbers before and after them do not
			compare on source, sessions or the lesson events.
		</p>

		{#each [{ when: '22 November 2026', list: TRACKING_22 }, { when: '26 November 2026', list: TRACKING_26 }] as group (group.when)}
			<section class="changes" aria-label="Changes of {group.when}">
				<h3>{group.when}</h3>
				<div class="table-wrap">
					<table>
						<thead>
							<tr>
								<th scope="col">What the numbers showed</th>
								<th scope="col">What was changed</th>
								<th scope="col">What it answers now</th>
							</tr>
						</thead>
						<tbody>
							{#each group.list as c (c.change)}
								<tr>
									<td>{c.finding}</td>
									<td>{c.change}</td>
									<td>{c.answers}</td>
								</tr>
							{/each}
						</tbody>
					</table>
				</div>
			</section>
		{/each}

		<section class="changes" aria-labelledby="site-head">
			<h3 id="site-head">Changed on the site itself, from the same numbers</h3>
			<ul class="plain">
				<li><strong>22 November:</strong> the lesson offers “Try it now” after the first rule and its check.</li>
				<li><strong>22 November:</strong> the panel after a download, in every language, leading to the book’s first chapter.</li>
				<li>
					<strong>26 November:</strong> a page for each of the twelve books, the PDFs in the sitemap, titles and
					author inside the PDF files, book data for search engines on the books page, and an llms.txt for
					assistants.
				</li>
			</ul>
		</section>

		<h2 id="next" class="part">What to check next</h2>
		<p class="muted">Around 29 November and again mid-December, once the update has a week or two of visits behind it.</p>
		<ol class="next">
			{#each NEXT as n (n.q)}
				<li>
					<strong>{n.q}</strong>
					<span>{n.how}</span>
				</li>
			{/each}
		</ol>

		<h2 id="open" class="part">Open decisions</h2>
		<dl class="open">
			{#each OPEN as o (o.what)}
				<div>
					<dt>{o.what}</dt>
					<dd>{o.why}</dd>
				</div>
			{/each}
		</dl>
	</OwnerGate>
</main>

<style>
	h1 {
		margin: 0.75rem 0 0.75rem;
	}

	.basis {
		max-width: 78ch;
		margin: 0 0 1.25rem;
		color: var(--ink-muted);
		line-height: 1.6;
	}

	.basis strong {
		color: var(--ink);
	}

	.muted {
		max-width: 78ch;
		margin: 0 0 1rem;
		color: var(--ink-muted);
	}

	.short,
	.finding,
	.changes {
		margin: 0 0 1.25rem;
		padding: 1.1rem 1.35rem;
		background: var(--surface);
		border: 1px solid var(--line);
		border-radius: 12px;
	}

	.short {
		border-inline-start: 4px solid var(--heading);
	}

	.short h2 {
		margin: 0 0 0.6rem;
		font-size: var(--step-1);
	}

	.short ol {
		margin: 0;
		padding-inline-start: 1.3rem;
		display: grid;
		gap: 0.5rem;
		max-width: 80ch;
		line-height: 1.55;
	}

	.toc {
		display: flex;
		flex-wrap: wrap;
		gap: 0.4rem 1.25rem;
		margin: 0 0 0.5rem;
		font-weight: 600;
	}

	.part {
		margin: 2rem 0 0.75rem;
		font-size: var(--step-2);
		scroll-margin-top: 5rem;
	}

	.finding h3 {
		display: flex;
		align-items: baseline;
		gap: 0.6rem;
		margin: 0 0 0.4rem;
		font-size: var(--step-1);
		text-wrap: balance;
	}

	.n {
		flex: none;
		color: var(--accent-ink);
	}

	.claim {
		max-width: 75ch;
		margin: 0 0 1rem;
		font-size: 1.05rem;
		line-height: 1.55;
	}

	figure {
		margin: 0 0 1rem;
		padding: 0.85rem 1rem;
		background: var(--surface-alt);
		border-radius: 10px;
	}

	figcaption {
		margin-bottom: 0.5rem;
		font-size: 0.85rem;
		font-weight: 700;
		color: var(--ink-muted);
	}

	.bars {
		list-style: none;
		margin: 0;
		padding: 0;
		display: grid;
		gap: 0.4rem;
	}

	.bars li {
		display: grid;
		grid-template-columns: minmax(9rem, 17rem) 1fr 9.5rem;
		align-items: center;
		gap: 0.75rem;
		font-size: 0.9rem;
	}

	.b-track {
		height: 0.85rem;
		background: var(--surface);
		border-radius: 0 4px 4px 0;
		overflow: hidden;
	}

	.b-track span {
		display: block;
		height: 100%;
		min-width: 2px;
		background: #2a78d6;
		border-radius: 0 4px 4px 0;
	}

	.b-value {
		text-align: end;
		color: var(--ink-muted);
		white-space: nowrap;
	}

	.b-value strong {
		margin-inline-end: 0.35rem;
		color: var(--ink);
	}

	.evidence {
		margin: 0 0 1rem;
		padding-inline-start: 1.2rem;
		display: grid;
		gap: 0.3rem;
		max-width: 80ch;
		line-height: 1.55;
	}

	.finding dl {
		margin: 0;
		display: grid;
		gap: 0.75rem;
	}

	.finding dl > div {
		padding-top: 0.75rem;
		border-top: 1px solid var(--line);
	}

	dt {
		font-size: 0.75rem;
		font-weight: 700;
		letter-spacing: 0.04em;
		text-transform: uppercase;
		color: var(--ink-muted);
	}

	dd {
		margin: 0.2rem 0 0;
		max-width: 80ch;
		line-height: 1.55;
	}

	.caveat dd {
		color: var(--ink-muted);
	}

	.changes h3 {
		margin: 0 0 0.6rem;
		font-size: var(--step-1);
	}

	.table-wrap {
		overflow-x: auto;
	}

	table {
		border-collapse: collapse;
		width: 100%;
		min-width: 44rem;
		font-size: 0.92rem;
	}

	th,
	td {
		width: 33.3%;
		padding: 0.6rem 0.75rem;
		border-bottom: 1px solid var(--line);
		text-align: start;
		vertical-align: top;
		line-height: 1.5;
	}

	thead th {
		font-size: 0.8rem;
		color: var(--ink-muted);
	}

	tbody tr:last-child td {
		border-bottom: 0;
	}

	tbody td:nth-child(2) {
		font-weight: 600;
	}

	.plain {
		margin: 0;
		padding-inline-start: 1.2rem;
		display: grid;
		gap: 0.4rem;
		max-width: 80ch;
		line-height: 1.55;
	}

	.next {
		margin: 0;
		padding-inline-start: 1.3rem;
		display: grid;
		gap: 0.75rem;
		max-width: 80ch;
	}

	.next span {
		display: block;
		color: var(--ink-muted);
		line-height: 1.5;
	}

	.open {
		margin: 0;
		display: grid;
		gap: 0.75rem;
	}

	.open > div {
		padding: 0.85rem 1.1rem;
		background: var(--surface);
		border: 1px solid var(--line);
		border-radius: 12px;
	}

	.open dt {
		font-size: 1rem;
		letter-spacing: 0;
		text-transform: none;
		color: var(--heading);
	}

	@media (max-width: 40rem) {
		.bars li {
			grid-template-columns: 1fr auto;
		}

		.b-track {
			grid-column: 1 / -1;
			order: 3;
		}
	}
</style>
