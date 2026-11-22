// Chart 26 (Perfekt): writes tool/charts/src/26-perfekt.html on the 15-gender.html skeleton.
// Question 1 (left): haben or sein? Question 2 (right): which of four patterns builds the
// participle? Bottom right: the common irregular participles, sein ones marked.
// Conjugated helper = solid terracotta chip, participle = terracotta outline (as in Charts 3, 4).
// Course level A1.2 → A2.1. Run from the repo root: node tool/charts/build/build-26.mjs
import { readFileSync, writeFileSync } from 'node:fs';

const SKELETON = 'tool/charts/src/15-gender.html';
const FILE = 'tool/charts/src/26-perfekt.html';

const SEIN = [
	['moving from A to B', 'gehen · fahren · fliegen · kommen · laufen · reisen', 'Ich [bin] nach Rom {geflogen}.'],
	['a change of state', 'aufstehen · einschlafen · aufwachen · werden · sterben', 'Er [ist] früh {aufgestanden}.'],
	['and these three', 'sein · bleiben · passieren', 'Was [ist] {passiert}?']
];
const HABEN = [
	['with an object', 'Ich [habe] einen Film {gesehen}. &ensp; Er [hat] Brot {gekauft}.'],
	['doing, not moving', 'Wir [haben] {gearbeitet}. &ensp; Ich [habe] gut {geschlafen}.'],
	['sich verbs', 'Ich [habe] mich {gefreut}. &ensp; Wir [haben] uns {getroffen}.'],
	['haben itself', 'Sie [hat] keine Zeit {gehabt}. &ensp; Ich [habe] Glück {gehabt}.']
];
const PAT = [
	['ge- … -t', 'regular verbs', 'machen → {gemacht} · kaufen → {gekauft} · spielen → {gespielt} · arbeiten → {gearbeitet}'],
	['ge- … -en', 'irregular verbs, often a new vowel', 'sehen → {gesehen} · schreiben → {geschrieben} · trinken → {getrunken} · gehen → {gegangen}'],
	['…ge…', 'split-off prefix: ge goes inside', 'aufmachen → {aufgemacht} · einkaufen → {eingekauft} · anrufen → {angerufen} · aufstehen → {aufgestanden}'],
	['no ge-', 'be- ver- er- ent- zer- and -ieren', 'besuchen → {besucht} · verstehen → {verstanden} · erzählen → {erzählt} · telefonieren → {telefoniert}']
];
// * = sein
const IRR = 'gegessen getrunken geschlafen gesehen geschrieben gelesen gesprochen genommen gegeben gefunden geholfen getroffen gedacht gebracht gewusst gegangen* gekommen* gefahren* geblieben* gewesen* geworden*';

let count = 0;
const fx = (t) => t.replace(/\[([^\]]+)\]/g, '<b class="hv">$1</b>').replace(/\{([^}]+)\}/g, '<b class="pt">$1</b>');
const body = `<div class="focus">
			<div class="look">
				<div class="lk a"><div class="trio">
					<div class="dm"><div class="w">Ich <b class="hv">habe</b> <b class="pt">gegessen</b>.</div><small><b>haben</b> most verbs</small></div>
					<div class="dm"><div class="w">Ich <b class="hv">bin</b> <b class="pt">gefahren</b>.</div><small><b>sein</b> from A to B</small></div>
					<div class="dm"><div class="w">Ich <b class="hv">bin</b> <b class="pt">eingeschlafen</b>.</div><small><b>sein</b> a change of state</small></div>
				</div>
				<div class="cap1"><span class="c1"><b>1</b>The Perfekt is the past you speak: haben or sein in second place, the participle at the very end. Ich habe gestern Pizza gegessen.</span><span class="c2"><b>2</b>Question 1 (left): does the verb take you from A to B, or change your state? Then sein. Almost everything else takes haben. Question 2 (right): build the participle with one of four patterns.</span></div><h3 class="lt">Look here first: <strong>two choices, and the participle goes last</strong></h3></div>
			</div>
			<div class="idea"><h3>The one idea: <strong>haben or sein + participle</strong></h3>
				<div class="proof"><span class="chip"><span class="w">Ich <b class="hv">habe</b> gestern Pizza <b class="pt">gegessen</b>.</span></span><p>The verb splits in two: haben or sein in second place, the participle closes the sentence.</p></div></div>
		</div>

		<div class="perf">
			<div class="bx q1"><div class="bh"><b>1 · haben or sein?</b></div>
				<div class="hs">
					<div class="sein"><div class="sh"><b>sein</b><span>a few, but frequent</span></div>${SEIN.map(([l, v, e]) => { count += v.split(' · ').length + 1; return `<div class="si"><span class="lab">${l}</span><span class="vv">${v}</span><span class="ex">${fx(e)}</span></div>`; }).join('')}</div>
					<div class="haben"><div class="sh"><b>haben</b><span>everything else</span></div>${HABEN.map(([l, e]) => { count++; return `<div class="si"><span class="lab">${l}</span><span class="ex">${fx(e)}</span></div>`; }).join('')}</div>
				</div>
			</div>
			<div class="right">
				<div class="bx q2"><div class="bh"><b>2 · How is the participle built?</b></div>${PAT.map(([f, l, ex]) => { count += 4; return `<div class="pr"><span class="pf">${f}</span><span class="pl">${l}</span><span class="pe">${fx(ex)}</span></div>`; }).join('')}</div>
				<div class="bx ir"><div class="bh"><b>Learn these by heart</b><span>the most common irregular participles · <i class="sd"></i> = with sein</span></div><div class="il">${IRR.split(' ').map((w) => { count++; return `<span class="${w.endsWith('*') ? 'sw' : ''}">${w.replace('*', '')}</span>`; }).join('')}</div></div>
			</div>
		</div>

		<div class="rules">
			<div class="rl">same verb</div>
			<div><b class="lead">fahren: sein or haben</b>Ich <b class="hv">bin</b> nach Rom <b class="pt">gefahren</b> (I went) · Ich <b class="hv">habe</b> das Auto <b class="pt">gefahren</b> (I drove it: an object, so haben)</div>
			<div><b class="lead">in a side clause, both at the end</b>…, weil ich lange <b class="pt">gearbeitet</b> <b class="hv">habe</b>. <span class="aside">see Chart 3</span></div>
			<div class="rl warn">watch out</div>
			<div><b class="lead">-ieren never takes ge-</b>studiert · telefoniert · fotografiert · repariert · passiert</div>
			<div><b class="lead">war and hatte in speech too</b>Ich <b class="hv">war</b> in Rom · Ich <b class="hv">hatte</b> keine Zeit: shorter than bin gewesen, habe gehabt <span class="aside">see Chart 6</span></div>
		</div>
		<div class="key"><b>Key:</b> <span class="sp"><b class="hv">habe</b> = haben or sein, changes with the person</span> <span class="sp"><b class="pt">gegessen</b> = the participle, never changes</span> <span class="sp"><span class="sw">gegangen</span> = takes sein</span></div>
`;

const css = `
/* perfekt version */
.lk.a .trio { justify-content: space-between }
.dm .w { font-size: 1.85cqw }
.dm small b { color: var(--terracotta-ink) }
b.hv { background: var(--terracotta-ink); color: #fff; border-radius: .3cqw; padding: 0 .3cqw; font-weight: 800 }
b.pt { box-shadow: inset 0 0 0 .14cqw var(--terracotta-ink); color: var(--terracotta-ink); border-radius: .3cqw; padding: 0 .3cqw; font-weight: 800 }
.idea .chip .w { font-size: 1.45cqw }
.perf { flex: 1; min-height: 0; display: grid; grid-template-columns: 1fr 1.25fr; gap: .9cqw }
.right { min-height: 0; display: flex; flex-direction: column; gap: .6cqw }
.bx { min-height: 0; display: flex; flex-direction: column; border: .25cqw solid var(--navy); border-radius: .8cqw; overflow: hidden; background: #fff }
.bh { background: var(--navy); color: #fff; display: flex; align-items: baseline; gap: .8cqw; padding: .1cqw .9cqw .25cqw }
.bh b { font-family: var(--serif); font-size: 1.5cqw; font-weight: 700; line-height: 1.2 }
.bh span { font-size: .72cqw; font-weight: 800; letter-spacing: .05em; text-transform: uppercase }
.hs { flex: 1; min-height: 0; display: flex; flex-direction: column }
.sein { flex: 1.35; display: flex; flex-direction: column; background: #fdf3ec; border-bottom: .2cqw solid var(--navy) }
.haben { flex: 1; display: flex; flex-direction: column }
.sh { display: flex; align-items: baseline; gap: .7cqw; padding: .3cqw .9cqw .1cqw }
.sh b { font-family: var(--serif); font-size: 2cqw; font-weight: 700; color: var(--terracotta-ink); line-height: 1 }
.haben .sh b { color: var(--navy) }
.sh span { font-size: .74cqw; font-weight: 800; letter-spacing: .05em; text-transform: uppercase; color: var(--muted) }
.si { flex: 1; min-height: 0; display: flex; flex-direction: column; justify-content: center; gap: .1cqw; padding: 0 .9cqw; border-top: .1cqw solid #e9d9cf }
.haben .si { flex-direction: row; align-items: center; justify-content: flex-start; border-top-color: #dde3ec }
.lab { font-size: .76cqw; font-weight: 800; letter-spacing: .04em; text-transform: uppercase; color: var(--terracotta-ink) }
.haben .lab { color: var(--navy); width: 8.6cqw; flex: none }
.vv { font-family: var(--serif); font-size: 1.25cqw; font-weight: 700 }
.ex { font-family: var(--serif); font-size: 1.15cqw; font-weight: 600; white-space: nowrap }
.q2 { flex: 1.6 } .ir { flex: 1 }
.pr { flex: 1; min-height: 0; display: grid; grid-template-columns: 7.2cqw 1fr; grid-template-rows: auto auto; align-items: center; column-gap: .8cqw; padding: .1cqw .9cqw; border-top: .1cqw solid #dde3ec }
.bh + .pr { border-top: 0 }
.pf { grid-row: 1 / 3; font-family: var(--serif); font-size: 1.55cqw; font-weight: 700; color: var(--terracotta-ink); white-space: nowrap }
.pl { font-size: .76cqw; font-weight: 800; letter-spacing: .04em; text-transform: uppercase; color: var(--muted) }
.pe { font-family: var(--serif); font-size: 1.08cqw; font-weight: 600; line-height: 1.45 }
.pe b.pt { padding: 0 .2cqw }
.il { flex: 1; min-height: 0; display: flex; flex-wrap: wrap; align-content: space-evenly; gap: .2cqw .5cqw; padding: .3cqw .8cqw; font-family: var(--serif); font-size: 1.22cqw; font-weight: 700; color: var(--terracotta-ink) }
.il span { box-shadow: inset 0 0 0 .12cqw var(--terracotta-ink); border-radius: .3cqw; padding: 0 .3cqw }
.il span.sw, .key .sw { background: #fdf3ec; box-shadow: inset 0 0 0 .12cqw var(--terracotta-ink), inset .5cqw 0 0 var(--terracotta-ink); padding-left: .75cqw }
i.sd { display: inline-block; width: .7cqw; height: .7cqw; background: var(--terracotta-ink); border-radius: .1cqw; vertical-align: -.05cqw }
.bh i.sd { background: #f2c3a8 }
.key .sw { color: var(--terracotta-ink); font-weight: 700; border-radius: .3cqw; padding-right: .3cqw }
`;

let html = readFileSync(SKELETON, 'utf8');
const a = html.indexOf('<div class="focus">'), b = html.indexOf('</div></div>\n\t</div>\n\n\t<p class="note">');
if (a < 0 || b < 0) throw new Error('markers not found');
html = html.slice(0, a) + body + '\t' + html.slice(b);
html = html.replace('</style>', css + '</style>');
const rep = (x, y) => { if (!html.includes(x)) throw new Error('missing: ' + x); html = html.replace(x, y); };
rep('<title>Noun Gender Chart</title>', '<title>Perfekt Chart</title>');
html = html.replace(/<h1>Chart 15[^<]*<\/h1>\s*<p>[^<]*/, '<h1>Chart 26, the Perfekt</h1>\n\t\t<p>haben or sein, and the four ways to build the participle.');
rep('<small>Chart 15</small>der, die or das?', '<small>Chart 26</small>habe gemacht, bin gegangen');
rep('data-qr="15"', 'data-qr="26"');
html = html.replace(/<div class="path">[\s\S]*?<\/div>/, `<div class="path">
				<span><b>1</b>haben or sein?</span>
				<span><b>2</b>Build the participle</span>
				<span><b>3</b>Participle at the end</span>
			</div>`);
writeFileSync(FILE, html);
console.log('chart 26 built', Math.round(html.length / 1024) + ' KB,', count, 'verbs and forms');
