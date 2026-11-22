// Chart 29 (und, deshalb, weil: three word orders): writes tool/charts/src/29-linking-words.html on
// the 15-gender.html skeleton. Three rows = three kinds of linking word. Each row says the SAME
// thing (I stay home, I am ill) on a slot track, so only the place of the verb changes; then the
// linking words of that group with English, and two more examples. A fourth row: side clause first.
// Verb with the ending = solid terracotta, as in Chart 3. Course level A2.1 → B1.1.
// Run from the repo root: node tool/charts/build/build-29.mjs
import { readFileSync, writeFileSync } from 'node:fs';

const SKELETON = 'tool/charts/src/15-gender.html';
const FILE = 'tool/charts/src/29-linking-words.html';

// slots: [class, text]; c = linking word, s = subject, v = verb, x = rest, p = first clause
const ROWS = [
	['nothing changes', 'the verb stays second', [['p', 'Ich bleibe zu Hause,'], ['c', 'denn'], ['s', 'ich'], ['v', 'bin'], ['x', 'krank.']],
		[['und', 'and'], ['aber', 'but'], ['oder', 'or'], ['denn', 'because'], ['sondern', 'but rather']],
		['Es ist spät, [aber] ich {bin} nicht müde.', 'Ich trinke Tee, [und] du {trinkst} Kaffee.']],
	['the verb comes next', 'linking word, then the verb', [['p', 'Ich bin krank,'], ['c', 'deshalb'], ['v', 'bleibe'], ['s', 'ich'], ['x', 'zu Hause.']],
		[['deshalb', 'so'], ['trotzdem', 'still'], ['dann', 'then'], ['danach', 'after that'], ['sonst', 'otherwise'], ['außerdem', 'also'], ['also', 'so'], ['darum', 'that is why']],
		['Es regnet, [trotzdem] {gehe} ich spazieren.', 'Beeil dich, [sonst] {verpassen} wir den Bus.']],
	['the verb goes last', 'a side clause', [['p', 'Ich bleibe zu Hause,'], ['c', 'weil'], ['s', 'ich'], ['x', 'krank'], ['v', 'bin.']],
		[['weil', 'because'], ['dass', 'that'], ['wenn', 'if, when'], ['ob', 'whether'], ['obwohl', 'although'], ['als', 'when (past)'], ['bevor', 'before'], ['nachdem', 'after'], ['damit', 'so that'], ['während', 'while'], ['bis', 'until'], ['seit', 'since']],
		['Ich weiß, [dass] du recht {hast}.', 'Ich komme mit, [wenn] ich Zeit {habe}.']],
	['side clause first', 'verb, comma, verb', [['c', 'Weil'], ['s', 'ich'], ['x', 'krank'], ['v', 'bin,'], ['v', 'bleibe'], ['s', 'ich'], ['x', 'zu Hause.']],
		[],
		['[Wenn] es regnet, {nehme} ich den Bus.', '[Obwohl] er müde {ist}, {arbeitet} er weiter.']]
];

let count = 0;
const fx = (t) => t.replace(/\[([^\]]+)\]/g, '<b class="lc">$1</b>').replace(/\{([^}]+)\}/g, '<b class="lv">$1</b>');
const rows = ROWS.map(([name, sub, track, words, ex], i) => {
	count += 1 + words.length + ex.length;
	return `<div class="wr r${i}"><div class="wn"><b>${i + 1}</b><span><strong>${name}</strong>${sub}</span></div>
		<div class="wt"><div class="track">${track.map(([c, t]) => `<span class="sl ${c}">${t}</span>`).join('')}</div><div class="wx">${ex.map((e) => `<span>${fx(e)}</span>`).join('')}</div></div>
		<div class="ww">${words.length ? words.map(([w, en]) => `<span><b>${w}</b>${en}</span>`).join('') : '<p>Every linking word of group 3 can start the sentence. Then the main verb comes right after the comma.</p>'}</div></div>`;
}).join('');

const body = `<div class="focus">
			<div class="look">
				<div class="lk a"><div class="trio">
					<div class="dm"><div class="w">…, <b class="lc">denn</b> ich <b class="lv">bin</b> krank.</div><small><b>1</b> nothing changes</small></div>
					<div class="dm"><div class="w">…, <b class="lc">deshalb</b> <b class="lv">bleibe</b> ich …</div><small><b>2</b> the verb comes next</small></div>
					<div class="dm"><div class="w">…, <b class="lc">weil</b> ich krank <b class="lv">bin</b>.</div><small><b>3</b> the verb goes last</small></div>
				</div>
				<div class="cap1"><span class="c1"><b>1</b>German has three kinds of linking word. All three rows below say the same thing (I stay at home, because I am ill), but the verb lands in a different place.</span><span class="c2"><b>2</b>Find your linking word in the right-hand column. Its row shows where the verb goes: the orange box.</span></div><h3 class="lt">Look here first: <strong>the linking word decides where the verb goes</strong></h3></div>
			</div>
			<div class="idea"><h3>The one idea: <strong>three groups, three places</strong></h3>
				<div class="proof"><span class="chip"><span class="w"><b class="lc">weil</b> ich krank <b class="lv">bin</b></span></span><p>After weil, dass, wenn and the rest of their group, the verb goes to the very end.</p></div></div>
		</div>

		<div class="wo">${rows}</div>

		<div class="rules">
			<div class="rl">which one?</div>
			<div><b class="lead">als, wenn or wann?</b><b class="lc">als</b> = once, in the past: Als ich Kind war · <b class="lc">wenn</b> = if, whenever: Wenn ich Zeit habe · <b class="lc">wann</b> = the question: Wann kommst du?</div>
			<div><b class="lead">denn or weil?</b>the same meaning, a different order: …, denn ich <b class="lv">bin</b> krank · …, weil ich krank <b class="lv">bin</b></div>
			<div class="rl warn">watch out</div>
			<div><b class="lead">a comma before the linking word</b>…, aber · …, denn · …, deshalb · …, weil · …, dass (before und and oder you may leave it out)</div>
			<div><b class="lead">two verbs at the end</b>…, weil ich arbeiten <b class="lv">muss</b> · …, dass er gekommen <b class="lv">ist</b>: the verb with the ending comes last <span class="aside">see Chart 4</span></div>
		</div>
		<div class="key"><b>Key:</b> <span class="sp"><b class="lc">weil</b> = the linking word</span> <span class="sp"><b class="lv">bin</b> = the verb with the ending</span> <span class="sp"><span class="ks">ich</span> = the subject</span> <span class="sp">verb positions, step by step: Chart 3</span></div>
`;

const css = `
/* linking words version */
.lk.a .trio { justify-content: space-between }
.dm .w { font-size: 1.6cqw }
.dm small b { color: var(--terracotta-ink) }
b.lc { background: var(--navy); color: #fff; border-radius: .3cqw; padding: 0 .3cqw; font-weight: 800 }
b.lv { background: var(--terracotta-ink); color: #fff; border-radius: .3cqw; padding: 0 .3cqw; font-weight: 800 }
.idea .chip .w { font-size: 1.7cqw }
.wo { flex: 1; min-height: 0; display: grid; grid-template-rows: 1fr 1fr 1.15fr .9fr; gap: .5cqw }
.wr { min-height: 0; display: grid; grid-template-columns: 10.5cqw 1.35fr 1fr; border: .25cqw solid var(--navy); border-radius: .8cqw; overflow: hidden; background: #fff }
.wr.r3 { border-style: dashed; background: #fafbfd }
.wn { background: var(--navy); color: #fff; display: flex; align-items: center; gap: .6cqw; padding: 0 .7cqw }
.wr.r3 .wn { background: #47617f }
.wn > b { font-family: var(--serif); font-size: 2.6cqw; font-weight: 700; line-height: 1 }
.wn span { display: flex; flex-direction: column; font-size: .72cqw; font-weight: 600; line-height: 1.25 }
.wn strong { font-family: var(--serif); font-size: 1.15cqw; font-weight: 700; line-height: 1.1; margin-bottom: .1cqw }
.wt { display: flex; flex-direction: column; justify-content: center; gap: .45cqw; padding: .3cqw 1cqw; min-width: 0 }
.track { display: flex; gap: .35cqw; flex-wrap: nowrap }
.sl { font-family: var(--serif); font-size: 1.6cqw; font-weight: 700; border-radius: .3cqw; padding: .05cqw .4cqw; white-space: nowrap }
.sl.p { color: var(--muted); padding-left: 0 } .sl.c { background: var(--navy); color: #fff }
.sl.s { box-shadow: inset 0 0 0 .14cqw var(--ink) } .sl.v { background: var(--terracotta-ink); color: #fff }
.sl.x { background: #f1f3f6 }
.wx { display: flex; flex-direction: column; gap: .12cqw; font-family: var(--serif); font-size: 1.2cqw; font-weight: 600 }
.wx span { white-space: nowrap }
.wx b.lc, .wx b.lv { padding: 0 .2cqw }
.ww { display: flex; flex-wrap: wrap; align-content: center; gap: .25cqw .9cqw; padding: .3cqw 1cqw; border-left: .12cqw solid #dde3ec; background: #f6f8fb }
.ww span { display: inline-flex; align-items: baseline; gap: .3cqw; font-size: .76cqw; font-weight: 600; color: var(--muted); white-space: nowrap }
.ww span b { font-family: var(--serif); font-size: 1.4cqw; font-weight: 700; color: var(--navy) }
.ww p { margin: 0; font-size: .92cqw; line-height: 1.35; font-weight: 600 }
.key .ks { box-shadow: inset 0 0 0 .12cqw var(--ink); border-radius: .25cqw; padding: 0 .3cqw; font-weight: 700 }
`;

let html = readFileSync(SKELETON, 'utf8');
const a = html.indexOf('<div class="focus">'), b = html.indexOf('</div></div>\n\t</div>\n\n\t<p class="note">');
if (a < 0 || b < 0) throw new Error('markers not found');
html = html.slice(0, a) + body + '\t' + html.slice(b);
html = html.replace('</style>', css + '</style>');
const rep = (x, y) => { if (!html.includes(x)) throw new Error('missing: ' + x); html = html.replace(x, y); };
rep('<title>Noun Gender Chart</title>', '<title>Linking Words Chart</title>');
html = html.replace(/<h1>Chart 15[^<]*<\/h1>\s*<p>[^<]*/, '<h1>Chart 29, three word orders</h1>\n\t\t<p>Linking words in three groups, and where each one puts the verb.');
rep('<small>Chart 15</small>der, die or das?', '<small>Chart 29</small>denn, deshalb, weil');
rep('data-qr="15"', 'data-qr="29"');
html = html.replace(/<div class="path">[\s\S]*?<\/div>/, `<div class="path">
				<span><b>1</b>Find your linking word</span>
				<span><b>2</b>Its row is the order</span>
				<span><b>3</b>Put the verb there</span>
			</div>`);
writeFileSync(FILE, html);
console.log('chart 29 built', Math.round(html.length / 1024) + ' KB,', count, 'linking words and sentences');
