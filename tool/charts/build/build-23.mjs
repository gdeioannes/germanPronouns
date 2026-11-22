// Chart 23 (gut, besser, am besten), reworked: writes tool/charts/src/23-comparison.html on the
// 15-gender.html skeleton. Left: the three forms in four groups (regular, umlaut, -est, irregular),
// header rising in three steps. Right: comparing in sentences (als, so … wie, before a noun, immer,
// je … desto). Added letters in terracotta, {ä} = vowel gets an umlaut. Course level A2.1 → A2.2.
// Run from the repo root: node tool/charts/build/build-23.mjs
import { readFileSync, writeFileSync } from 'node:fs';

const SKELETON = 'tool/charts/src/15-gender.html';
const FILE = 'tool/charts/src/23-comparison.html';

// [group, note, rows 'base|comp|sup'] with + marking the added part
const GROUPS = [
	['add -er, -sten', 'most adjectives', ['schnell|schnell+er|am schnell+sten', 'klein|klein+er|am klein+sten', 'billig|billig+er|am billig+sten', 'schön|schön+er|am schön+sten']],
	['short, with a, o, u: umlaut', 'ä, ö, ü in both forms', ['alt|{ä}lt+er|am {ä}lt+esten', 'jung|j{ü}ng+er|am j{ü}ng+sten', 'kalt|k{ä}lt+er|am k{ä}lt+esten', 'lang|l{ä}ng+er|am l{ä}ng+sten', 'warm|w{ä}rm+er|am w{ä}rm+sten', 'kurz|k{ü}rz+er|am k{ü}rz+esten']],
	['-est after d, t, s, ß, z, sch', 'for an easier sound', ['breit|breit+er|am breit+esten', 'heiß|heiß+er|am heiß+esten', 'hübsch|hübsch+er|am hübsch+esten', 'gesund|ges{ü}nd+er|am ges{ü}nd+esten']],
	['learn these by heart', 'irregular', ['gut|besser|am besten', 'viel|mehr|am meisten', 'gern|lieber|am liebsten', 'hoch|h{ö}her|am h{ö}ch+sten', 'nah|n{ä}her|am n{ä}ch+sten', 'groß|gr{ö}ß+er|am gr{ö}ß+ten']]
];
const SIDE = [
	['more than: -er + als', ['Anna ist größ<b>er</b> <i>als</i> Tom.', 'Heute ist es kält<b>er</b> <i>als</i> gestern.']],
	['as … as: so … wie', ['Tom ist <i>so</i> groß <i>wie</i> Max.', 'Der Film ist nicht <i>so</i> gut <i>wie</i> das Buch.']],
	['before a noun: endings too', ['ein schnell<b>er</b>er Zug · die best<b>e</b> Pizza', 'mein ält<b>est</b>er Bruder · das größ<b>t</b>e Haus']],
	['more and more: immer', ['Es wird <i>immer</i> kält<b>er</b>.', 'Du sprichst <i>immer</i> besser!']],
	['the more …, the more …', ['<i>Je</i> mehr ich lerne, <i>desto</i> besser spreche ich.']]
];

let count = 0;
const f = (t) => t.replace(/\{(.)\}/g, '<u>$1</u>').replace(/\+(\S+)/, '<b>$1</b>');
let table = `<div class="st s1">schnell<small>one thing</small></div><div class="st s2">schneller<small>two things</small></div><div class="st s3">am schnellsten<small>the top</small></div>`;
for (const [g, note, rows] of GROUPS) {
	table += `<div class="gh${g.startsWith('learn') ? ' irr' : ''}"><b>${g}</b><span>${note}</span></div>`;
	for (const r of rows) { const [a, b, c] = r.split('|'); count += 3; table += `<div class="t1"><span>${f(a)}</span></div><div class="t2"><span>${f(b)}</span></div><div class="t3"><span>${f(c)}</span></div>`; }
}
const side = SIDE.map(([h, ex]) => { count += ex.length; return `<div class="sc"><div class="sh">${h}</div>${ex.map((e) => `<span>${e}</span>`).join('')}</div>`; }).join('');

const body = `<div class="focus">
			<div class="look">
				<div class="lk a"><div class="trio">
					<div class="dm d1"><div class="w">schnell</div><small><b>one thing</b> der Zug ist schnell</small></div>
					<div class="dm d2"><div class="w">schnell<b>er</b></div><small><b>two things</b> schneller als das Auto</small></div>
					<div class="dm d3"><div class="w">am schnell<b>sten</b></div><small><b>the top</b> the fastest of all</small></div>
				</div>
				<div class="cap1"><span class="c1"><b>1</b>Add -er to compare two things, and am … -sten for the top of the group. Short words with a, o or u usually take an umlaut too: alt, älter, am ältesten.</span><span class="c2"><b>2</b>Find the adjective's group in the table: the coloured letters are what you add. Six common words do their own thing: learn them by heart.</span></div><h3 class="lt">Look here first: <strong>-er for more, am -sten for most</strong></h3></div>
			</div>
			<div class="idea"><h3>The one idea: <strong>two things: -er and als</strong></h3>
				<div class="proof"><span class="chip"><span class="w">Anna ist größ<b>er</b> als Tom.</span></span><p>Comparing two: -er and als. The top of the whole group: am … -sten.</p></div></div>
		</div>

		<div class="cmp">
			<div class="tbl">${table}</div>
			<div class="side"><div class="sideh">Comparing in sentences</div>${side}</div>
		</div>

		<div class="rules">
			<div class="rl">spelling</div>
			<div><b class="lead">-el and -er drop an e</b>teuer → teur<b class="ke">er</b> · dunkel → dunkl<b class="ke">er</b> · but am teuer<b class="ke">sten</b>, am dunkel<b class="ke">sten</b></div>
			<div><b class="lead">never mehr + adjective</b><s>mehr schnell</s> → schnell<b class="ke">er</b> · <s>mehr interessant</s> → interessant<b class="ke">er</b>, even for long words</div>
			<div class="rl warn">watch out</div>
			<div><b class="lead">after -er: als, not wie</b>größer <b>als</b> Tom · so groß <b>wie</b> Tom · <s>größer wie Tom</s></div>
			<div><b class="lead">am -sten or der -ste?</b>Anna ist am größten (after sein) · Anna ist die größte (the tallest one) · die größte Stadt</div>
		</div>
		<div class="key"><b>Key:</b> <span class="sp">schnell<b class="ke">er</b> = what you add</span> <span class="sp">k<u>ä</u>lter = the vowel changes</span> <span class="sp">endings before a noun follow Chart 5</span></div>
`;

const css = `
/* comparison version */
.lk.a .trio { justify-content: space-between; align-items: flex-end }
.dm .w { font-size: 1.9cqw }
.dm.d1 { padding-bottom: 0 } .dm.d2 { padding-bottom: .3cqw } .dm.d3 { padding-bottom: .6cqw }
.dm .w b, .tbl b, .side b, .key b.ke, .rules b.ke { color: var(--terracotta-ink); font-weight: 800 }
.dm small b { color: var(--navy) }
.tbl u, .key u { text-decoration: underline; text-decoration-thickness: .18cqw; text-underline-offset: .15cqw; text-decoration-color: var(--terracotta-ink) }
.idea .chip .w { font-size: 1.6cqw }
.idea .chip .w b { color: var(--terracotta-ink) }
.cmp { flex: 1; min-height: 0; display: grid; grid-template-columns: 1.35fr 1fr; gap: 1cqw }
.tbl { min-height: 0; display: grid; grid-template-columns: 1fr 1fr 1.25fr; grid-template-rows: auto; grid-auto-rows: minmax(0, 1fr); border: .25cqw solid var(--navy); border-radius: .8cqw; overflow: hidden; background: #fff; align-items: stretch }
.st { background: var(--navy); color: #fff; font-family: var(--serif); font-size: 1.35cqw; font-weight: 700; padding: 0 .8cqw .25cqw; display: flex; flex-direction: column; justify-content: flex-end; line-height: 1.15 }
.st small { font-family: var(--sans); font-size: .66cqw; font-weight: 800; letter-spacing: .05em; text-transform: uppercase; opacity: .8 }
.st.s1 { padding-top: 1cqw; background: #47617f } .st.s2 { padding-top: .55cqw; background: #2f4a6d } .st.s3 { padding-top: .1cqw }
.gh { grid-column: 1 / -1; display: flex; align-items: baseline; gap: .7cqw; padding: .1cqw .8cqw; background: var(--navy-soft); border-top: .12cqw solid #c9d2de }
.gh b { font-size: .8cqw; font-weight: 800; letter-spacing: .04em; text-transform: uppercase; color: var(--navy) }
.gh span { font-size: .72cqw; font-weight: 600; color: var(--muted) }
.gh.irr { background: #fbe9de } .gh.irr b { color: var(--terracotta-ink) }
.t1, .t2, .t3 { display: flex; align-items: center; padding: 0 .8cqw; font-family: var(--serif); font-size: 1.04cqw; line-height: 1; font-weight: 700; white-space: nowrap; border-top: .08cqw solid #dfe4ec }
.t1 { color: #4a4640 }
.side { min-height: 0; display: flex; flex-direction: column; border: .25cqw solid var(--terracotta-ink); border-radius: .8cqw; overflow: hidden; background: #fff }
.sideh { background: var(--terracotta-ink); color: #fff; font-family: var(--serif); font-size: 1.45cqw; font-weight: 700; padding: .1cqw .9cqw .25cqw }
.sc { flex: 1; min-height: 0; display: flex; flex-direction: column; justify-content: center; gap: .15cqw; padding: 0 .9cqw; border-top: .1cqw solid #efe0d6 }
.sideh + .sc { border-top: 0 }
.sh { font-size: .76cqw; font-weight: 800; letter-spacing: .04em; text-transform: uppercase; color: var(--terracotta-ink) }
.sc span { font-family: var(--serif); font-size: 1.22cqw; font-weight: 600; white-space: nowrap }
.sc i { font-style: normal; font-weight: 800; color: #fff; background: var(--navy); border-radius: .25cqw; padding: 0 .25cqw }
.rules s { color: #8b857c }
`;

let html = readFileSync(SKELETON, 'utf8');
const a = html.indexOf('<div class="focus">'), b = html.indexOf('</div></div>\n\t</div>\n\n\t<p class="note">');
if (a < 0 || b < 0) throw new Error('markers not found');
html = html.slice(0, a) + body + '\t' + html.slice(b);
html = html.replace('</style>', css + '</style>');
const rep = (x, y) => { if (!html.includes(x)) throw new Error('missing: ' + x); html = html.replace(x, y); };
rep('<title>Noun Gender Chart</title>', '<title>Comparison Chart</title>');
html = html.replace(/<h1>Chart 15[^<]*<\/h1>\s*<p>[^<]*/, '<h1>Chart 23, comparing</h1>\n\t\t<p>-er and am -sten, the umlaut words, the irregular ones, and comparing in sentences.');
rep('<small>Chart 15</small>der, die or das?', '<small>Chart 23</small>gut, besser, am besten');
rep('data-qr="15"', 'data-qr="23"');
html = html.replace(/<div class="path">[\s\S]*?<\/div>/, `<div class="path">
				<span><b>1</b>Find the adjective's group</span>
				<span><b>2</b>Add -er or am -sten</span>
				<span><b>3</b>Two things? Add als</span>
			</div>`);
writeFileSync(FILE, html);
console.log('chart 23 built', Math.round(html.length / 1024) + ' KB,', count, 'forms and sentences');
