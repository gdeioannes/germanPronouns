// Chart 27 (prepositions with a fixed case): writes tool/charts/src/27-fixed-prepositions.html on
// the 15-gender.html skeleton. Left: the Akkusativ group (yellow), right: the Dativ group (violet,
// two columns); each preposition with its English and two phrases whose ending shows the case.
// The nine two-case prepositions point to Chart 2. Course level A2.1 → A2.2.
// Run from the repo root: node tool/charts/build/build-27.mjs
import { readFileSync, writeFileSync } from 'node:fs';

const SKELETON = 'tool/charts/src/15-gender.html';
const FILE = 'tool/charts/src/27-fixed-prepositions.html';

// [prep, English, phrase 1, phrase 2]; [x] = the ending that shows the case
const AKK = [
	['durch', 'through', 'durch d[en] Park', 'durch d[ie] Stadt'],
	['ohne', 'without', 'ohne d[en] Schlüssel', 'ohne m[ich]'],
	['gegen', 'against', 'gegen d[ie] Wand', 'gegen acht Uhr'],
	['für', 'for', 'für d[en] Chef', 'für m[ich]'],
	['um', 'around, at', 'um d[en] See', 'um acht Uhr'],
	['bis', 'until', 'bis Montag', 'bis morgen'],
	['entlang', 'along, after the noun', 'd[en] Fluss entlang', 'd[ie] Straße entlang']
];
const DAT = [
	['aus', 'out of, from', 'aus d[em] Haus', 'aus d[er] Türkei'],
	['bei', 'at, near, with', 'bei d[er] Arbeit', 'bei mein[en] Eltern'],
	['mit', 'with, by', 'mit d[em] Bus', 'mit mein[er] Freundin'],
	['nach', 'to (cities), after', 'nach Berlin', 'nach d[em] Essen'],
	['seit', 'since, for', 'seit ein[em] Jahr', 'seit zwei Woche[n]'],
	['von', 'from, of', 'von d[er] Arbeit', 'ein Freund von m[ir]'],
	['zu', 'to (people, places)', 'zu[m] Arzt', 'zu[r] Schule'],
	['gegenüber', 'opposite', 'gegenüber d[em] Bahnhof', 'd[em] Kino gegenüber'],
	['außer', 'except', 'außer m[ir]', 'außer d[em] Chef'],
	['ab', 'from (a time)', 'ab nächst[er] Woche', 'ab d[em] 1. Mai']
];
const SHORT = [['zum', 'zu dem'], ['zur', 'zu der'], ['beim', 'bei dem'], ['vom', 'von dem'], ['im', 'in dem'], ['ins', 'in das'], ['am', 'an dem'], ['ans', 'an das']];

let count = 0;
const row = (c) => ([p, en, a, b]) => { count += 3; const f = (t) => t.replace(/\[([^\]]+)\]/g, `<b class="${c}">$1</b>`); return `<div class="pr"><span class="pp ${c}">${p}</span><span class="pen">${en}</span><span class="ph">${f(a)}</span><span class="ph">${f(b)}</span></div>`; };

const body = `<div class="focus">
			<div class="look">
				<div class="lk a"><div class="trio">
					<div class="dm"><div class="w"><span class="pp akk">durch</span> d<b class="akk">en</b> Park</div><small><b>Akkusativ</b> always, after durch</small></div>
					<div class="dm"><div class="w"><span class="pp dat">mit</span> d<b class="dat">em</b> Bus</div><small><b>Dativ</b> always, after mit</small></div>
					<div class="dm"><div class="w"><span class="pp dat">aus</span> d<b class="dat">er</b> Stadt</div><small><b>Dativ</b> always, after aus</small></div>
				</div>
				<div class="cap1"><span class="c1"><b>1</b>After these prepositions the case never changes: always Akkusativ (yellow) or always Dativ (violet). You see it in the article: den after durch, dem after mit.</span><span class="c2"><b>2</b>Learn them as two groups, with a phrase each. Nine other prepositions can take either case, depending on Wo? or Wohin?: they are on Chart 2.</span></div><h3 class="lt">Look here first: <strong>the preposition picks the case</strong></h3></div>
			</div>
			<div class="idea"><h3>The one idea: <strong>one preposition, one case</strong></h3>
				<div class="proof"><span class="chip"><span class="w"><span class="pp akk">für</span> d<b class="akk">en</b> Chef · <span class="pp dat">mit</span> d<b class="dat">em</b> Chef</span></span><p>Same man, two prepositions, two cases: für always wants Akkusativ, mit always Dativ.</p></div></div>
		</div>

		<div class="fixp">
			<div class="bx akk"><div class="bh"><b>always Akkusativ</b><span>remember: DOGFUB</span></div>${AKK.map(row('akk')).join('')}</div>
			<div class="bx dat"><div class="bh"><b>always Dativ</b><span>remember: aus bei mit nach seit von zu</span></div><div class="two">${DAT.map(row('dat')).join('')}</div></div>
		</div>

		<div class="rules">
			<div class="rl">short forms</div>
			<div class="sf">${SHORT.map(([s, l]) => { count++; return `<span><b>${s}</b> = ${l}</span>`; }).join('')}</div>
			<div><b class="lead">nine take both cases</b>an · auf · hinter · in · neben · über · unter · vor · zwischen: Wo? <b class="dat">Dativ</b> · Wohin? <b class="akk">Akkusativ</b> <span class="aside">see Chart 2</span></div>
			<div class="rl warn">watch out</div>
			<div><b class="lead">nach or zu?</b>nach + cities, countries, Hause: nach Wien · zu + people and places in town: zum Arzt, zur Bank</div>
			<div><b class="lead">pronouns change too</b>für m<b class="akk">ich</b> · ohne d<b class="akk">ich</b> · mit m<b class="dat">ir</b> · bei d<b class="dat">ir</b> · von i<b class="dat">hm</b> <span class="aside">see Chart 21</span></div>
		</div>
		<div class="key"><b>Key:</b> <span class="sp"><span class="pp akk">für</span> <b class="akk">-en</b> = Akkusativ</span> <span class="sp"><span class="pp dat">mit</span> <b class="dat">-em</b> = Dativ</span> <span class="sp">the case colours of Chart 1</span> <span class="sp">DOGFUB = durch, ohne, gegen, für, um, bis</span></div>
`;

const css = `
/* fixed prepositions version */
.lk.a .trio { justify-content: space-between }
.dm .w { font-size: 2cqw }
.dm small b { color: var(--navy) }
.pp { display: inline-block; font-family: var(--serif); font-weight: 700; border-radius: .35cqw; padding: 0 .4cqw .05cqw; line-height: 1.25; white-space: nowrap }
.pp.akk { background: var(--hi); color: var(--ink) } .pp.dat { background: var(--dat); color: #fff }
b.akk { background: #fff4b3; border-radius: .2cqw; padding: 0 .08cqw; font-weight: 800 }
b.dat { background: #e6defa; color: #3d2380; border-radius: .2cqw; padding: 0 .08cqw; font-weight: 800 }
.idea .chip .w { font-size: 1.5cqw }
.fixp { flex: 1; min-height: 0; display: grid; grid-template-columns: 1fr 1.9fr; gap: .9cqw }
.bx { min-height: 0; display: flex; flex-direction: column; border: .3cqw solid var(--dat); border-radius: .8cqw; overflow: hidden; background: #fff }
.bx.akk { border-color: #d9b600 }
.bh { display: flex; align-items: baseline; gap: .9cqw; padding: .1cqw 1cqw .3cqw; background: var(--dat); color: #fff }
.bx.akk .bh { background: var(--hi); color: var(--ink) }
.bh b { font-family: var(--serif); font-size: 1.8cqw; font-weight: 700; line-height: 1.15 }
.bh span { font-size: .78cqw; font-weight: 800; letter-spacing: .05em; text-transform: uppercase }
.two { flex: 1; min-height: 0; display: grid; grid-template-columns: 1fr 1fr; grid-auto-flow: column; grid-template-rows: repeat(5, 1fr); column-gap: 0 }
.two .pr:nth-child(n+6) { border-left: .15cqw solid #ddd3f5 }
.two .pr { grid-template-columns: 8.4cqw 1fr }
.two .pr .pp { font-size: 1.4cqw }
.pr { flex: 1; min-height: 0; display: grid; grid-template-columns: 6.6cqw 1fr; grid-template-rows: auto auto auto; align-items: center; column-gap: .7cqw; padding: .1cqw .9cqw; border-top: .1cqw solid #e6e1f2 }
.bx.akk .pr { border-top-color: #f1e7b5 }
.bh + .pr, .two .pr:nth-child(1), .two .pr:nth-child(6) { border-top: 0 }
.pr .pp { grid-row: 1 / 4; font-size: 1.5cqw; justify-self: start }
.pen { font-size: .72cqw; font-weight: 800; letter-spacing: .04em; text-transform: uppercase; color: var(--muted); line-height: 1.3 }
.ph { font-family: var(--serif); font-size: 1.22cqw; font-weight: 600; line-height: 1.3; white-space: nowrap }
.rules .sf { display: flex; flex-wrap: wrap; gap: .1cqw 1.1cqw; align-items: center }
.rules .sf b { font-weight: 800; color: var(--navy) }
.key .pp { font-size: .95cqw; padding: 0 .3cqw }
`;

let html = readFileSync(SKELETON, 'utf8');
const a = html.indexOf('<div class="focus">'), b = html.indexOf('</div></div>\n\t</div>\n\n\t<p class="note">');
if (a < 0 || b < 0) throw new Error('markers not found');
html = html.slice(0, a) + body + '\t' + html.slice(b);
html = html.replace('</style>', css + '</style>');
const rep = (x, y) => { if (!html.includes(x)) throw new Error('missing: ' + x); html = html.replace(x, y); };
rep('<title>Noun Gender Chart</title>', '<title>Fixed-Case Prepositions</title>');
html = html.replace(/<h1>Chart 15[^<]*<\/h1>\s*<p>[^<]*/, '<h1>Chart 27, prepositions with a fixed case</h1>\n\t\t<p>The prepositions that always take Akkusativ or always Dativ.');
rep('<small>Chart 15</small>der, die or das?', '<small>Chart 27</small>für den, mit dem');
rep('data-qr="15"', 'data-qr="27"');
html = html.replace(/<div class="path">[\s\S]*?<\/div>/, `<div class="path">
				<span><b>1</b>Find the preposition</span>
				<span><b>2</b>Its colour is the case</span>
				<span><b>3</b>Give the article that ending</span>
			</div>`);
writeFileSync(FILE, html);
console.log('chart 27 built', Math.round(html.length / 1024) + ' KB,', count, 'prepositions, phrases, short forms');
