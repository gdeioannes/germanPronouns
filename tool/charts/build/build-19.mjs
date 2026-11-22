// Chart 19 (kein or nicht?), reworked: writes tool/charts/src/19-kein-nicht.html on the
// 15-gender.html skeleton. Left: when kein, when nicht (situation cards). Right: where nicht
// stands in the sentence, and the other ways to say no. [k] = kein word, {n} = nicht.
// Course level A1.1 → A2.1. Run from the repo root: node tool/charts/build/build-19.mjs
import { readFileSync, writeFileSync } from 'node:fs';

const SKELETON = 'tool/charts/src/15-gender.html';
const FILE = 'tool/charts/src/19-kein-nicht.html';

const KEIN = [
	['a noun with ein', 'Ich habe [kein] Auto.', 'Ich habe [keinen] Bruder.'],
	['a noun with no article', 'Ich habe [keine] Zeit.', 'Ich trinke [keinen] Kaffee.'],
	['a plural with no article', 'Wir haben [keine] Kinder.', 'Hier gibt es [keine] Läden.'],
	['jobs, after sein', 'Ich bin [kein] Lehrer.', 'Sie ist [keine] Ärztin.'],
	['hunger, time, fun', 'Ich habe [keinen] Hunger.', 'Ich habe [keine] Lust.']
];
const NICHT = [
	['the verb, the whole sentence', 'Ich komme {nicht}.', 'Er arbeitet heute {nicht}.'],
	['a noun with der, die, das', 'Ich kenne den Mann {nicht}.', 'Ich nehme die Suppe {nicht}.'],
	['names, mein, dein …', 'Das ist {nicht} Anna.', 'Das ist {nicht} mein Handy.'],
	['adjectives', 'Das ist {nicht} teuer.', 'Der Film war {nicht} gut.'],
	['places', 'Ich wohne {nicht} in Berlin.', 'Er ist {nicht} zu Hause.']
];
const TRACK = [
	['Ich komme heute {nicht}.', 'at the end'],
	['Ich kenne den Mann {nicht}.', 'after the object'],
	['Das Essen ist {nicht} teuer.', 'before an adjective'],
	['Ich wohne {nicht} in Berlin.', 'before a place'],
	['Ich kann heute {nicht} kommen.', 'before the second verb'],
	['Ich habe das {nicht} gesagt.', 'before the participle'],
	['Ich rufe dich {nicht} an.', 'before the split-off part'],
	['{Nicht} ich, sondern Anna!', 'before the word you contrast']
];
const OTHER = [
	['nicht mehr', 'no longer', 'Ich rauche {nicht mehr}.'],
	['noch nicht', 'not yet', 'Er ist {noch nicht} da.'],
	['nie', 'never', 'Ich war {nie} in Rom.'],
	['nichts', 'nothing', 'Ich sehe {nichts}.'],
	['niemand', 'nobody', '{Niemand} ist da.'],
	['nirgends', 'nowhere', 'Ich finde es {nirgends}.'],
	['kein … mehr', 'no more', 'Ich habe [kein] Geld [mehr].'],
	['gar nicht', 'not at all', 'Das ist {gar nicht} schlimm.']
];

let count = 0;
const fx = (t) => { count++; return t.replace(/\[([^\]]+)\]/g, '<b class="kk">$1</b>').replace(/\{([^}]+)\}/g, '<b class="nn">$1</b>'); };
const cards = (rows) => rows.map(([lab, s1, s2]) => `<div class="card"><span class="lab">${lab}</span><div class="ss"><span>${fx(s1)}</span><span>${fx(s2)}</span></div></div>`).join('');

const body = `<div class="focus">
			<div class="look">
				<div class="lk a"><div class="trio">
					<div class="dm"><div class="w">Ich habe <b class="kk">kein</b> Auto.</div><small><b>kein</b> was: ein Auto</small></div>
					<div class="dm"><div class="w">Ich fahre <b class="nn">nicht</b>.</div><small><b>nicht</b> no to the verb</small></div>
					<div class="dm"><div class="w">Das Auto ist <b class="nn">nicht</b> neu.</div><small><b>nicht</b> no to the adjective</small></div>
				</div>
				<div class="cap1"><span class="c1"><b>1</b>If the noun would have ein, or no article at all, say no with kein: it takes the endings of ein. For everything else use nicht: verbs, adjectives, places, nouns with der or mein.</span><span class="c2"><b>2</b>Then put nicht in its place with the track on the right: at the end, or just before the part you say no to.</span></div><h3 class="lt">Look here first: <strong>kein goes with nouns, nicht with the rest</strong></h3></div>
			</div>
			<div class="idea"><h3>The one idea: <strong>ein → kein, the rest → nicht</strong></h3>
				<div class="proof"><span class="chip"><span class="w">ein Auto → <b class="kk">kein</b> Auto</span></span><p>Where you would say ein, or nothing, say kein. Everywhere else, say nicht.</p></div></div>
		</div>

		<div class="kn">
			<div class="col">
				<div class="bx k"><div class="bh"><b>kein</b><span>no + a noun</span></div>${cards(KEIN)}</div>
				<div class="bx n"><div class="bh"><b>nicht</b><span>no to everything else</span></div>${cards(NICHT)}</div>
			</div>
			<div class="col">
				<div class="bx t"><div class="bh"><b>Where does nicht stand?</b><span>late, or right before the part you say no to</span></div>${TRACK.map(([s, l]) => `<div class="tr"><span class="ts">${fx(s)}</span><span class="tl">${l}</span></div>`).join('')}</div>
				<div class="bx o"><div class="bh"><b>More ways to say no</b></div><div class="og">${OTHER.map(([w, en, s]) => `<div class="oi"><span class="ow">${w}</span><span class="oe">${en}</span><span class="os">${fx(s)}</span></div>`).join('')}</div></div>
			</div>
		</div>

		<div class="rules">
			<div class="rl">answering</div>
			<div><b class="lead">yes to a no-question: doch</b>Kommst du <b class="nn">nicht</b>? <b>Doch!</b> (yes, I do) · <b>Nein.</b> (no, I don't)</div>
			<div><b class="lead">no …, but …: sondern</b><b class="nn">Nicht</b> heute, <b>sondern</b> morgen. · <b class="kk">Kein</b> Tee, <b>sondern</b> Kaffee.</div>
			<div class="rl warn">watch out</div>
			<div><b class="lead">never nicht ein</b><s>Ich habe nicht ein Auto.</s> → Ich habe <b class="kk">kein</b> Auto.</div>
			<div><b class="lead">mein, der: nicht · ein: kein</b>Das ist <b class="nn">nicht</b> mein Auto. · Das ist <b class="kk">kein</b> Auto.</div>
		</div>
		<div class="key"><b>Key:</b> <span class="sp"><b class="kk">kein</b> = no before a noun, with the endings of ein</span> <span class="sp"><b class="nn">nicht</b> = no to anything else</span> <span class="sp">kein · keine · keinen · keinem, like ein <span class="aside">see Chart 1</span></span></div>
`;

const css = `
/* kein nicht version */
.lk.a .trio { justify-content: space-between }
.dm .w { font-size: 1.85cqw }
.dm small b { color: var(--navy) }
b.kk { background: var(--navy); color: #fff; border-radius: .3cqw; padding: 0 .3cqw; font-weight: 800 }
b.nn { background: var(--terracotta-ink); color: #fff; border-radius: .3cqw; padding: 0 .3cqw; font-weight: 800 }
.idea .chip .w { font-size: 1.7cqw }
.kn { flex: 1; min-height: 0; display: grid; grid-template-columns: 1fr 1fr; gap: .9cqw }
.col { min-height: 0; display: flex; flex-direction: column; gap: .6cqw }
.bx { flex: 1; min-height: 0; display: flex; flex-direction: column; border: .25cqw solid var(--navy); border-radius: .8cqw; overflow: hidden; background: #fff }
.bx.n, .bx.t { border-color: var(--terracotta-ink) }
.bx.t { flex: 1.15 } .bx.o { flex: .85 }
.bh { background: var(--navy); color: #fff; display: flex; align-items: baseline; gap: .8cqw; padding: .05cqw .9cqw .2cqw }
.bx.n .bh, .bx.t .bh { background: var(--terracotta-ink) }
.bh b { font-family: var(--serif); font-size: 1.5cqw; font-weight: 700; line-height: 1.2 }
.bh span { font-size: .74cqw; font-weight: 800; letter-spacing: .05em; text-transform: uppercase }
.card { flex: 1; min-height: 0; display: grid; grid-template-columns: 8.4cqw 1fr; align-items: center; gap: .6cqw; padding: 0 .8cqw; border-top: .1cqw solid #dde3ec }
.bh + .card { border-top: 0 }
.card .lab { font-size: .8cqw; font-weight: 700; line-height: 1.2; color: var(--muted) }
.ss { display: flex; gap: 1.2cqw; font-family: var(--serif); font-size: 1.2cqw; font-weight: 600; white-space: nowrap; min-width: 0 }
.tr { flex: 1; min-height: 0; display: flex; align-items: center; justify-content: space-between; gap: .8cqw; padding: 0 .9cqw; border-top: .1cqw solid #f0e2d9 }
.bh + .tr { border-top: 0 }
.ts { font-family: var(--serif); font-size: 1.3cqw; font-weight: 600; white-space: nowrap }
.tl { font-size: .82cqw; font-weight: 700; color: var(--terracotta-ink); white-space: nowrap }
.og { flex: 1; min-height: 0; display: grid; grid-template-columns: 1fr 1fr; grid-auto-rows: 1fr; gap: 0 1cqw; padding: .15cqw .9cqw .25cqw }
.oi { display: grid; grid-template-columns: 5.6cqw 1fr; grid-template-rows: auto auto; align-items: center; column-gap: .5cqw; border-top: .1cqw solid #dde3ec; min-height: 0 }
.oi:nth-child(-n+2) { border-top: 0 }
.ow { grid-row: 1 / 3; font-family: var(--serif); font-size: 1.15cqw; font-weight: 700; color: var(--terracotta-ink); line-height: 1.1 }
.oe { font-size: .72cqw; font-weight: 700; color: var(--muted); text-transform: uppercase; letter-spacing: .04em; line-height: 1.2 }
.os { font-family: var(--serif); font-size: 1.05cqw; font-weight: 600; white-space: nowrap; line-height: 1.3 }
.os b.kk, .os b.nn { padding: 0 .2cqw }
.rules s { color: #8b857c }
`;

let html = readFileSync(SKELETON, 'utf8');
const a = html.indexOf('<div class="focus">'), b = html.indexOf('</div></div>\n\t</div>\n\n\t<p class="note">');
if (a < 0 || b < 0) throw new Error('markers not found');
html = html.slice(0, a) + body + '\t' + html.slice(b);
html = html.replace('</style>', css + '</style>');
const rep = (x, y) => { if (!html.includes(x)) throw new Error('missing: ' + x); html = html.replace(x, y); };
rep('<title>Noun Gender Chart</title>', '<title>kein or nicht Chart</title>');
html = html.replace(/<h1>Chart 15[^<]*<\/h1>\s*<p>[^<]*/, '<h1>Chart 19, kein or nicht</h1>\n\t\t<p>Saying no: kein with nouns, nicht with the rest, and where nicht stands.');
rep('<small>Chart 15</small>der, die or das?', '<small>Chart 19</small>kein or nicht?');
rep('data-qr="15"', 'data-qr="19"');
html = html.replace(/<div class="path">[\s\S]*?<\/div>/, `<div class="path">
				<span><b>1</b>No to a noun with ein? kein</span>
				<span><b>2</b>Anything else? nicht</span>
				<span><b>3</b>Put nicht in its place</span>
			</div>`);
writeFileSync(FILE, html);
console.log('chart 19 built', Math.round(html.length / 1024) + ' KB,', count, 'examples');
