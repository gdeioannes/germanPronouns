// Chart 21 (ich, mich or mir?), reworked: writes tool/charts/src/21-pronouns.html on the
// 15-gender.html skeleton. Left: the pronoun table, one fixed sentence per column (only the
// pronoun changes); where one word serves two cases the cell spans both columns. Right: what makes
// a pronoun Akkusativ or Dativ, and everyday Dativ phrases. Course level A1.2 → A2.1.
// Run from the repo root: node tool/charts/build/build-21.mjs
import { readFileSync, writeFileSync } from 'node:fs';

const SKELETON = 'tool/charts/src/15-gender.html';
const FILE = 'tool/charts/src/21-pronouns.html';

// [person label, English, nom verb, nom, akk, dat]; equal neighbours are merged
const ROWS = [
	['I', 'komme', 'ich', 'mich', 'mir'],
	['you', 'kommst', 'du', 'dich', 'dir'],
	['he', 'kommt', 'er', 'ihn', 'ihm'],
	['she', 'kommt', 'sie', 'sie', 'ihr'],
	['it', 'kommt', 'es', 'es', 'ihm'],
	['we', 'kommen', 'wir', 'uns', 'uns'],
	['you all', 'kommt', 'ihr', 'euch', 'euch'],
	['they', 'kommen', 'sie', 'sie', 'ihnen'],
	['you, polite', 'kommen', 'Sie', 'Sie', 'Ihnen']
];
const AKK = ['Er sieht [mich].', 'Ich liebe [dich].', 'Ruf [mich] an!', 'Ich frage [ihn].', 'Wir besuchen [euch].', 'für [mich] · ohne [dich] · gegen [ihn]'];
const DAT = ['Hilf [mir]!', 'Ich danke [dir].', 'Das gehört [ihm].', 'Ich gebe [ihr] ein Buch.', 'Das Kleid gefällt [mir].', 'mit [mir] · bei [uns] · von [ihm] · zu [ihnen]'];
const PHR = ['Wie geht es [dir]?', '[Mir] ist kalt.', 'Es tut [mir] leid.', 'Das schmeckt [mir].', 'Ist [dir] langweilig?', 'Das ist [mir] egal.'];

let count = 0;
let table = `<div class="th0"></div><div class="th nom"><b>Nominativ</b><span>___ komme</span></div><div class="th akk"><b>Akkusativ</b><span>Anna sieht ___.</span></div><div class="th dat"><b>Dativ</b><span>Anna hilft ___.</span></div>`;
for (const [en, verb, n, a, d] of ROWS) {
	table += `<div class="pe">${en}</div>`;
	if (n === a) { count += 2; table += `<div class="pc na"><i><b>${n}</b><small>${verb}</small></i><em>same word</em><i><b>${a}</b></i></div><div class="pc dat"><b>${d}</b></div>`; count++; }
	else if (a === d) { count += 3; table += `<div class="pc nom"><b>${n}</b><small>${verb}</small></div><div class="pc ad"><i><b>${a}</b></i><em>same word</em><i><b>${d}</b></i></div>`; }
	else { count += 3; table += `<div class="pc nom"><b>${n}</b><small>${verb}</small></div><div class="pc akk"><b>${a}</b></div><div class="pc dat"><b>${d}</b></div>`; }
}
const list = (arr, c) => arr.map((s) => { count++; return `<span>${s.replace(/\[([^\]]+)\]/g, `<b class="${c}">$1</b>`)}</span>`; }).join('');

const body = `<div class="focus">
			<div class="look">
				<div class="lk a"><div class="trio">
					<div class="dm"><div class="w"><b class="nom">Ich</b> komme.</div><small><b>Nominativ</b> I do it</small></div>
					<div class="dm"><div class="w">Anna sieht <b class="akk">mich</b>.</div><small><b>Akkusativ</b> it is done to me</small></div>
					<div class="dm"><div class="w">Anna hilft <b class="dat">mir</b>.</div><small><b>Dativ</b> to me, for me</small></div>
				</div>
				<div class="cap1"><span class="c1"><b>1</b>Each person has three forms. The job in the sentence decides: the one who does it (Nominativ), the one it is done to (Akkusativ), the one who gets or is helped (Dativ).</span><span class="c2"><b>2</b>Read down a column: the sentence stays the same, only the pronoun changes. Where one box covers two columns, the word is the same in both cases.</span></div><h3 class="lt">Look here first: <strong>same person, three jobs</strong></h3></div>
			</div>
			<div class="idea"><h3>The one idea: <strong>the job picks the form</strong></h3>
				<div class="proof"><span class="chip"><span class="w"><b class="nom">Er</b> sieht <b class="akk">sie</b> und hilft <b class="dat">ihr</b>.</span></span><p>One woman, two jobs: she is seen (sie) and helped (ihr).</p></div></div>
		</div>

		<div class="pron">
			<div class="tbl">${table}</div>
			<div class="side">
				<div class="bx akk"><div class="bh"><b>Akkusativ</b><span>the one it is done to</span></div><div class="ls">${list(AKK, 'akk')}</div></div>
				<div class="bx dat"><div class="bh"><b>Dativ</b><span>the one who gets or is helped</span></div><div class="ls">${list(DAT, 'dat')}</div></div>
				<div class="bx ph"><div class="bh"><b>Everyday Dativ</b><span>how you feel</span></div><div class="ls">${list(PHR, 'dat')}</div></div>
			</div>
		</div>

		<div class="rules">
			<div class="rl">order</div>
			<div><b class="lead">two pronouns: Akkusativ first</b>Ich gebe <b class="akk">es</b> <b class="dat">ihm</b>. · Ich zeige <b class="akk">sie</b> <b class="dat">dir</b>. · with a noun, the pronoun first: Ich gebe <b class="dat">ihm</b> das Buch.</div>
			<div><b class="lead">du or Sie?</b>du: friends, family, children · Sie: strangers, at work: Kannst <b class="nom">du</b> mir helfen? Können <b class="nom">Sie</b> mir helfen?</div>
			<div class="rl warn">watch out</div>
			<div><b class="lead">ihr has three jobs</b><b class="nom">ihr</b> kommt (you all) · Ich helfe <b class="dat">ihr</b> (to her) · <b>ihr</b> Auto (her car) <span class="aside">see Chart 20</span></div>
			<div><b class="lead">sie, sie, Sie</b>sie kommt (she) · sie kommen (they) · Sie kommen (you, polite): the verb ending and the capital tell you</div>
		</div>
		<div class="key"><b>Key:</b> <span class="sp">cases: <b class="nom">Nom</b> <b class="akk">Akk</b> <b class="dat">Dat</b>, the colours of Chart 1</span> <span class="sp">a box across two columns = one word for two cases</span> <span class="sp">the possessives (mein, dein …) are in Chart 20</span></div>
`;

const css = `
/* pronouns version */
.lk.a .trio { justify-content: space-between }
.dm .w { font-size: 2cqw }
.dm small b { color: var(--navy) }
b.nom, b.akk, b.dat { font-weight: 800; border-radius: .3cqw; padding: 0 .25cqw }
b.nom { box-shadow: inset 0 0 0 .14cqw var(--ink) } b.akk { background: var(--hi) } b.dat { background: var(--dat); color: #fff }
.idea .chip .w { font-size: 1.55cqw }
.pron { flex: 1; min-height: 0; display: grid; grid-template-columns: 1.25fr 1fr; gap: .9cqw }
.tbl { min-height: 0; display: grid; grid-template-columns: 6.2cqw repeat(3, minmax(0, 1fr)); grid-template-rows: auto repeat(9, 1fr); gap: .25cqw; }
.th { border-radius: .5cqw .5cqw 0 0; padding: .2cqw .6cqw .3cqw; display: flex; flex-direction: column; align-items: center }
.th b { font-size: .9cqw; font-weight: 800; letter-spacing: .05em; text-transform: uppercase }
.th span { font-family: var(--serif); font-size: 1.15cqw; font-weight: 700 }
.th.nom { box-shadow: inset 0 0 0 .2cqw var(--ink) } .th.akk { background: var(--hi) } .th.dat { background: var(--dat); color: #fff }
.pe { display: flex; align-items: center; justify-content: flex-end; padding-right: .5cqw; font-size: .82cqw; font-weight: 700; color: var(--muted); text-align: right; line-height: 1.15 }
.pc { position: relative; display: flex; align-items: center; justify-content: center; gap: .5cqw; border-radius: .45cqw; min-height: 0 }
.pc b { font-family: var(--serif); font-size: 1.8cqw; font-weight: 700; line-height: 1 }
.pc small { font-family: var(--serif); font-size: 1.05cqw; font-weight: 600; color: var(--muted) }
.pc i { flex: 1; display: flex; align-items: center; justify-content: center; gap: .5cqw; font-style: normal }
.pc.na, .pc.ad { gap: 0 }
.pc em { position: absolute; left: 50%; top: 50%; transform: translate(-50%, -50%); background: #fff; border-radius: .3cqw; padding: .1cqw .35cqw; box-shadow: 0 0 0 .1cqw var(--muted); font-style: normal; font-size: .62cqw; font-weight: 800; letter-spacing: .04em; text-transform: uppercase; color: var(--muted) }
.pc.nom { box-shadow: inset 0 0 0 .14cqw var(--ink); background: #fff }
.pc.akk { background: #fff4b3 } .pc.dat { background: #e6defa }
.pc.na { grid-column: span 2; background: linear-gradient(90deg, #fff 50%, #fff4b3 50%); box-shadow: inset 0 0 0 .14cqw var(--ink) }
.pc.ad { grid-column: span 2; background: linear-gradient(90deg, #fff4b3 50%, #e6defa 50%) }
.side { min-height: 0; display: flex; flex-direction: column; gap: .55cqw }
.bx { flex: 1; min-height: 0; display: flex; flex-direction: column; border: .25cqw solid var(--navy); border-radius: .8cqw; overflow: hidden; background: #fff }
.bx.akk { border-color: #c9a800 } .bx.dat, .bx.ph { border-color: var(--dat) }
.bh { display: flex; align-items: baseline; gap: .7cqw; padding: .05cqw .8cqw .2cqw; background: var(--navy); color: #fff }
.bx.akk .bh { background: var(--hi); color: var(--ink) } .bx.dat .bh, .bx.ph .bh { background: var(--dat) }
.bh b { font-family: var(--serif); font-size: 1.35cqw; font-weight: 700; line-height: 1.2 }
.bh span { font-size: .72cqw; font-weight: 800; letter-spacing: .05em; text-transform: uppercase }
.ls { flex: 1; min-height: 0; display: grid; grid-template-columns: 1fr 1fr; grid-auto-rows: 1fr; column-gap: .9cqw; padding: .1cqw .8cqw .2cqw; font-family: var(--serif); font-size: 1.15cqw; font-weight: 600 }
.ls span { display: block; align-self: center; white-space: nowrap }
.ls span:last-child:nth-child(odd) { grid-column: 1 / -1 }
.key .sp b.nom, .key .sp b.akk, .key .sp b.dat { padding: 0 .3cqw }
`;

let html = readFileSync(SKELETON, 'utf8');
const a = html.indexOf('<div class="focus">'), b = html.indexOf('</div></div>\n\t</div>\n\n\t<p class="note">');
if (a < 0 || b < 0) throw new Error('markers not found');
html = html.slice(0, a) + body + '\t' + html.slice(b);
html = html.replace('</style>', css + '</style>');
const rep = (x, y) => { if (!html.includes(x)) throw new Error('missing: ' + x); html = html.replace(x, y); };
rep('<title>Noun Gender Chart</title>', '<title>Pronouns Chart</title>');
html = html.replace(/<h1>Chart 15[^<]*<\/h1>\s*<p>[^<]*/, '<h1>Chart 21, ich, mich or mir</h1>\n\t\t<p>Personal pronouns in three cases, and what decides the case.');
rep('<small>Chart 15</small>der, die or das?', '<small>Chart 21</small>ich, mich or mir?');
rep('data-qr="15"', 'data-qr="21"');
html = html.replace(/<div class="path">[\s\S]*?<\/div>/, `<div class="path">
				<span><b>1</b>Who is it? Find the row</span>
				<span><b>2</b>What is their job? The column</span>
				<span><b>3</b>Use that form</span>
			</div>`);
writeFileSync(FILE, html);
console.log('chart 21 built', Math.round(html.length / 1024) + ' KB,', count, 'forms and sentences');
