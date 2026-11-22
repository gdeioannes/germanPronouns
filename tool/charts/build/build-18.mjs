// Chart 18 (der, ein or nothing?), reworked: writes tool/charts/src/18-articles.html on the
// 15-gender.html skeleton. Three columns = the three choices; in each, the situations that call
// for it, with two example sentences each. [x] = the article to notice, _ = no article where
// English would have one. Course level A1.1 → A2.1.
// Run from the repo root: node tool/charts/build/build-18.mjs
import { readFileSync, writeFileSync } from 'node:fs';

const SKELETON = 'tool/charts/src/15-gender.html';
const FILE = 'tool/charts/src/18-articles.html';

const COLS = [
	['c0', 'der · die · das', 'known: the one we both mean', [
		['said before', 'Ich habe ein Auto. [Das] Auto ist rot.', 'Da ist ein Café. [Das] Café ist neu.'],
		['clear from where we are', 'Mach bitte [das] Fenster zu.', 'Wo ist [der] Bahnhof?'],
		['there is only one', '[Die] Sonne scheint.', '[Der] Mond ist heute voll.'],
		['what follows says which', '[der] Mann mit dem Hut', '[das] Buch, das ich gerade lese'],
		['a whole kind, an idea', '[Die] Katze ist ein Haustier.', '[Das] Leben ist schön.'],
		['rivers, mountains, some countries', '[der] Rhein · [die] Alpen', 'in [der] Schweiz · in [die] Türkei'],
		['days, months, seasons', '[am] Montag · [im] Mai · [im] Sommer', '[Der] Winter ist kalt.'],
		['buses and trains, your body', 'mit [dem] Bus · mit [dem] Zug', 'Ich wasche mir [die] Hände.']
	]],
	['c1', 'ein · eine', 'new: one of many', [
		['said for the first time', 'Da steht [ein] Mann.', 'Ich habe [eine] Idee.'],
		['any one, not a special one', 'Ich suche [eine] Wohnung.', 'Hast du [einen] Stift?'],
		['saying what something is', 'Das ist [ein] Tisch.', 'Berlin ist [eine] Stadt.'],
		['after haben, brauchen, es gibt', 'Ich brauche [ein] Taxi.', 'Hier gibt es [einen] Park.'],
		['ordering one', '[Ein] Kaffee, bitte.', 'Ich nehme [eine] Suppe.'],
		['a job with an adjective', 'Sie ist [eine] gute Ärztin.', 'Er ist [ein] netter Kollege.'],
		['what kind of …?', 'Was für [ein] Auto ist das?', 'So [ein] Zufall!'],
		['saying no: kein', 'Ich habe [keinen] Hund.', 'Das ist [kein] Problem.']
	]],
	['c2', 'nothing', 'English says a or the, German nothing', [
		['the plural of ein', 'Ich habe _Kinder.', 'Da sind _Leute.'],
		['jobs and nationality', 'Ich bin _Lehrerin.', 'Er ist _Deutscher.'],
		['things you cannot count', 'Ich trinke _Wasser.', 'Wir brauchen _Milch.'],
		['names, cities, most countries', '_Anna wohnt in _Berlin.', 'Ich komme aus _Italien.'],
		['languages, subjects, sports', 'Ich lerne _Deutsch.', 'Wir spielen _Fußball.'],
		['hunger, time, fear', 'Ich habe _Hunger.', 'Hast du heute _Zeit?'],
		['fixed phrases', 'zu _Hause · nach _Hause', 'zu _Fuß · in _Rente'],
		['after als (as)', 'Ich arbeite als _Kellner.', 'Als _Kind war ich oft krank.']
	]]
];

let count = 0;
const sent = (t) => { count++; return t.replace(/\[([^\]]+)\]/g, '<b>$1</b>').replace(/_/g, '<i class="slot"></i>'); };
let grid = '';
for (const [cls, head, sub, cards] of COLS) {
	grid += `<div class="ac ${cls}"><div class="ah"><b>${head}</b><span>${sub}</span></div>${cards.map(([lab, s1, s2]) =>
		`<div class="card"><span class="lab">${lab}</span><div class="ss"><span>${sent(s1)}</span><span>${sent(s2)}</span></div></div>`).join('')}</div>`;
}

const body = `<div class="focus">
			<div class="look">
				<div class="lk a"><div class="trio">
					<div class="dm"><div class="w">Da ist <b class="k1">ein</b> Hund.</div><small><b>new</b> the first time: ein</small></div>
					<div class="dm"><div class="w"><b class="k0">Der</b> Hund ist groß.</div><small><b>known</b> now we both know it: der</small></div>
					<div class="dm"><div class="w"><i class="slot"></i>Hunde sind toll.</div><small><b>plural</b> of ein: nothing</small></div>
				</div>
				<div class="cap1"><span class="c1"><b>1</b>Use der, die, das when the listener knows which one you mean. Use ein, eine when it is new or any one of many. Use no article for the plural of ein and in the situations on the right.</span><span class="c2"><b>2</b>Find your situation in a column. The dashed box marks a place where English says "a" or "the" and German says nothing.</span></div><h3 class="lt">Look here first: <strong>does the listener know which one?</strong></h3></div>
			</div>
			<div class="idea"><h3>The one idea: <strong>new → ein, known → der</strong></h3>
				<div class="proof"><span class="chip"><span class="w">Da ist <b class="k1">ein</b> Café. <b class="k0">Das</b> Café ist neu.</span></span><p>The first time it is new: ein. From then on, you both know which one: der, die, das.</p></div></div>
		</div>

		<div class="arts">${grid}</div>

		<div class="rules">
			<div class="rl">English vs German</div>
			<div><b class="lead">English a, German nothing</b>I am a teacher → Ich bin Lehrer · as a child → als Kind · I have a cold → Ich habe Schnupfen</div>
			<div><b class="lead">English nothing, German der</b>Life is short → <b>Das</b> Leben ist kurz · by bus → mit <b>dem</b> Bus · in May → <b>im</b> Mai · to work → zur Arbeit</div>
			<div class="rl warn">watch out</div>
			<div><b class="lead">am, im, zum, zur, ins, beim</b>are a preposition + dem, der or das: am = an dem · im = in dem · zum = zu dem · zur = zu der · ins = in das</div>
			<div><b class="lead">no with nouns = kein</b>ein Hund → kein Hund · Wasser → kein Wasser · Kinder → keine Kinder <span class="aside">see Chart 19</span></div>
		</div>
		<div class="key"><b>Key:</b> <span class="sp"><b class="k0">der</b> = known, the one we both mean</span> <span class="sp"><b class="k1">ein</b> = new, one of many</span> <span class="sp"><i class="slot"></i> = no article where English has one</span> <span class="sp">The cases (den, dem, einen …) are in Chart 1</span></div>
`;

const css = `
/* articles version */
.lk.a .trio { justify-content: space-between }
.dm .w { font-size: 1.85cqw }
.dm small b { color: var(--navy) }
b.k0, .ac.c0 .ss b { background: var(--navy); color: #fff; border-radius: .3cqw; padding: 0 .3cqw; font-weight: 800 }
b.k1, .ac.c1 .ss b { background: #d5dfec; color: var(--navy); border-radius: .3cqw; padding: 0 .3cqw; font-weight: 800 }
i.slot { display: inline-block; width: 1.15em; height: .9em; border: .14cqw dashed var(--terracotta-ink); border-radius: .25cqw; vertical-align: -.1em; margin-right: .3em; background: #fbf1ea }
.idea .chip .w { font-size: 1.45cqw }
.arts { flex: 1; min-height: 0; display: grid; grid-template-columns: repeat(3, minmax(0, 1fr)); gap: .9cqw }
.ac { min-height: 0; min-width: 0; display: flex; flex-direction: column; border: .3cqw solid var(--navy); border-radius: .9cqw; background: #fff; overflow: hidden }
.ac.c1 { border-color: #47617f } .ac.c2 { border-color: var(--terracotta-ink) }
.ah { background: var(--navy); color: #fff; display: flex; align-items: baseline; gap: .9cqw; padding: .1cqw 1.1cqw .3cqw }
.ac.c1 .ah { background: #47617f } .ac.c2 .ah { background: var(--terracotta-ink) }
.ah b { font-family: var(--serif); font-size: 2.4cqw; font-weight: 700; line-height: 1.15; white-space: nowrap }
.ah span { font-size: .8cqw; font-weight: 800; letter-spacing: .06em; text-transform: uppercase; line-height: 1.2 }
.card { flex: 1; min-height: 0; display: grid; grid-template-columns: 6.6cqw 1fr; align-items: center; gap: .7cqw; padding: .15cqw .8cqw; border-top: .12cqw solid #d5dce6 }
.ah + .card { border-top: 0 }
.card .lab { font-size: .8cqw; font-weight: 700; line-height: 1.2; color: var(--muted) }
.ss { display: flex; flex-direction: column; gap: .12cqw; font-family: var(--serif); font-size: 1.24cqw; font-weight: 600; line-height: 1.25; color: var(--ink); min-width: 0 }
.ss span { white-space: nowrap }
.rules b:not(.lead) { font-weight: 800 }
.key .sp b.k0, .key .sp b.k1 { padding: 0 .3cqw }
`;

let html = readFileSync(SKELETON, 'utf8');
const a = html.indexOf('<div class="focus">'), b = html.indexOf('</div></div>\n\t</div>\n\n\t<p class="note">');
if (a < 0 || b < 0) throw new Error('markers not found');
html = html.slice(0, a) + body + '\t' + html.slice(b);
html = html.replace('</style>', css + '</style>');
const rep = (x, y) => { if (!html.includes(x)) throw new Error('missing: ' + x); html = html.replace(x, y); };
rep('<title>Noun Gender Chart</title>', '<title>Articles Chart</title>');
html = html.replace(/<h1>Chart 15[^<]*<\/h1>\s*<p>[^<]*/, '<h1>Chart 18, der, ein or nothing</h1>\n\t\t<p>Which article to use: the known one, a new one, or none at all.');
rep('<small>Chart 15</small>der, die or das?', '<small>Chart 18</small>der, ein or nothing?');
rep('data-qr="15"', 'data-qr="18"');
html = html.replace(/<div class="path">[\s\S]*?<\/div>/, `<div class="path">
				<span><b>1</b>Is it new or known?</span>
				<span><b>2</b>Find your situation</span>
				<span><b>3</b>Use that article, or none</span>
			</div>`);
writeFileSync(FILE, html);
console.log('chart 18 built', Math.round(html.length / 1024) + ' KB,', count, 'examples');
