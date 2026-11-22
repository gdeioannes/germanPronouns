// Chart 20 (mein, dein, sein, ihr), reworked: writes tool/charts/src/20-possessives.html on the
// 15-gender.html skeleton. Step 1 (left): the owner picks the word. Step 2 (middle): the thing and
// its case pick the ending, the endings of ein. Right: the sein/ihr trap (two owners × two things)
// and possessives in real sentences. Endings in the case colours. Course level A1.1 → A2.1.
// Run from the repo root: node tool/charts/build/build-20.mjs
import { readFileSync, writeFileSync } from 'node:fs';

const SKELETON = 'tool/charts/src/15-gender.html';
const FILE = 'tool/charts/src/20-possessives.html';

const OWNERS = [
	['ich', 'mein', 'my', 'mein Buch'], ['du', 'dein', 'your', 'dein Handy'], ['er', 'sein', 'his', 'sein Auto'],
	['sie', 'ihr', 'her', 'ihr Auto'], ['es', 'sein', 'its', 'sein Name'], ['wir', 'unser', 'our', 'unser Haus'],
	['ihr', 'euer', 'your, all of you', 'euer Garten'], ['sie', 'ihr', 'their', 'ihr Haus'], ['Sie', 'Ihr', 'your, polite', 'Ihr Pass']
];
const NOUNS = [['m', 'Vater'], ['f', 'Mutter'], ['n', 'Kind'], ['p', 'Eltern']];
const CASES = [
	['nom', 'Nominativ', 'who?', ['', 'e', '', 'e']],
	['akk', 'Akkusativ', 'whom?', ['en', 'e', '', 'e']],
	['dat', 'Dativ', 'to whom?', ['em', 'er', 'em', 'en']],
	['gen', 'Genitiv', 'whose?', ['es', 'er', 'es', 'er']]
];
const NOUNFORM = { gen: ['Vaters', 'Mutter', 'Kindes', 'Eltern'], dat: ['Vater', 'Mutter', 'Kind', 'Eltern'] };
const SENT = [
	['akk', 'Ich besuche mein[en] Vater.'], ['dat', 'Ich helfe mein[er] Mutter.'],
	['gen', 'Das ist das Auto mein[es] Bruders.'], ['akk', 'Hast du dein[en] Schlüssel?'],
	['akk', 'Wir besuchen unser[e] Oma.'], ['akk', 'Habt ihr eur[e] Tickets?'],
	['nom', 'Ist das Ihr Koffer?'], ['dat', 'Er spielt mit sein[er] Tochter.']
];

let count = 0;
const owners = OWNERS.map(([p, w, en, ex]) => { count++; return `<div class="ow"><span class="op">${p}</span><span class="oa">→</span><b class="oww">${w}</b><span class="oen">${en}</span><span class="oex">${ex}</span></div>`; }).join('');
let table = `<div class="tc0"></div>${NOUNS.map(([g, n]) => `<div class="tn ${g}">${{ m: 'der', f: 'die', n: 'das', p: 'die' }[g]} ${n}<small>${{ m: 'masculine', f: 'feminine', n: 'neuter', p: 'plural' }[g]}</small></div>`).join('')}`;
for (const [c, name, q, ends] of CASES) {
	table += `<div class="tcase ${c}"><b>${name}</b><span>${q}</span></div>`;
	table += ends.map((e, i) => { count++; const noun = (NOUNFORM[c] || [])[i] || NOUNS[i][1]; const plN = c === 'dat' && i === 3 ? 'Eltern' : noun; return `<div class="tcell"><span>mein${e ? `<b class="${c}">${e}</b>` : '<i class="zero"></i>'} ${plN}</span></div>`; }).join('');
}
const sent = SENT.map(([c, s]) => { count++; return `<span>${s.replace(/\[([^\]]+)\]/, `<b class="${c}">$1</b>`)}</span>`; }).join('');

const body = `<div class="focus">
			<div class="look">
				<div class="lk a"><div class="trio">
					<div class="dm"><div class="w">Tom: <span class="pp">sein</span> Hund</div><small><b>owner</b> Tom is he: sein</small></div>
					<div class="dm"><div class="w">Anna: <span class="pp">ihr</span> Hund</div><small><b>owner</b> Anna is she: ihr</small></div>
					<div class="dm"><div class="w">Anna: <span class="pp">ihr</span><b class="nom">e</b> Katze</div><small><b>thing</b> die Katze: ending -e</small></div>
				</div>
				<div class="cap1"><span class="c1"><b>1</b>Who owns it? The owner picks the word: Tom's dog is sein Hund, Anna's dog is ihr Hund. The thing does not change this word.</span><span class="c2"><b>2</b>What is owned, and what job does it do in the sentence? That picks the ending, exactly like the endings of ein. The coloured endings show the case.</span></div><h3 class="lt">Look here first: <strong>two questions, two choices</strong></h3></div>
			</div>
			<div class="idea"><h3>The one idea: <strong>owner → word, thing → ending</strong></h3>
				<div class="proof"><span class="chip"><span class="w"><span class="pp">ihr</span><b class="nom">e</b> Katze</span></span><p>ihr, because Anna owns it. -e, because Katze is a die word, here in the Nominativ.</p></div></div>
		</div>

		<div class="poss">
			<div class="bx po"><div class="bh"><b>1 · Who owns it?</b><span>the owner picks the word</span></div>${owners}</div>
			<div class="bx pe"><div class="bh"><b>2 · What is owned, in which case?</b><span>the ending, like ein</span></div><div class="tbl">${table}</div>
				<div class="sent"><div class="sh">In sentences</div>${sent}</div></div>
			<div class="bx pm"><div class="bh"><b>sein or ihr?</b><span>two owners, two pets</span></div>
				<div class="mx"><div></div><div class="mh m">der Hund</div><div class="mh f">die Katze</div>
					<div class="mo">Tom<small>er</small></div><div class="mc"><span class="pp">sein</span> Hund</div><div class="mc"><span class="pp">sein</span><b class="nom">e</b> Katze</div>
					<div class="mo">Anna<small>sie</small></div><div class="mc"><span class="pp">ihr</span> Hund</div><div class="mc"><span class="pp">ihr</span><b class="nom">e</b> Katze</div>
					<div class="mo">Tom + Anna<small>sie, plural</small></div><div class="mc"><span class="pp">ihr</span> Hund</div><div class="mc"><span class="pp">ihr</span><b class="nom">e</b> Katze</div>
				</div>
				<p class="mn">Across: the owner changes the word. Down: the thing changes the ending.</p>
			</div>
		</div>

		<div class="rules">
			<div class="rl">spelling</div>
			<div><b class="lead">euer drops an e</b>euer Garten, but eur<b class="nom">e</b> Stadt, eur<b class="akk">en</b> Garten · unser keeps it: unser<b class="nom">e</b> Stadt</div>
			<div><b class="lead">Ihr with a capital = your, polite</b>Ist das <b>Ihr</b> Koffer? (your) · Ist das <b>ihr</b> Koffer? (her or their)</div>
			<div class="rl warn">watch out</div>
			<div><b class="lead">ask who owns it, not what it is</b>Anna und <span class="pp">ihr</span> Bruder · Tom und <span class="pp">sein</span><b class="nom">e</b> Schwester</div>
			<div><b class="lead">the endings of ein, kein</b>ein<b class="akk">en</b> → mein<b class="akk">en</b> · ein<b class="dat">em</b> → dein<b class="dat">em</b> · plural: mein<b class="nom">e</b> Eltern <span class="aside">see Chart 1</span></div>
		</div>
		<div class="key"><b>Key:</b> <span class="sp"><span class="pp">sein</span> = the word the owner picks</span> <span class="sp">endings by case: <b class="nom">Nom</b> <b class="akk">Akk</b> <b class="dat">Dat</b> <b class="gen">Gen</b></span> <span class="sp"><i class="zero"></i> = no ending</span> <span class="sp">der <span class="gm">blue</span>, die <span class="gf">red</span>, das <span class="gn">green</span></span></div>
`;

const css = `
/* possessives version */
.lk.a .trio { justify-content: space-between }
.dm .w { font-size: 1.95cqw }
.dm small b { color: var(--navy) }
.pp { font-weight: 800; color: var(--navy); text-decoration: underline; text-decoration-thickness: .2cqw; text-underline-offset: .2cqw }
b.nom, b.akk, b.dat, b.gen { font-weight: 800; border-radius: .25cqw; padding: 0 .15cqw }
b.nom { box-shadow: inset 0 0 0 .14cqw var(--ink) } b.akk { background: var(--hi) } b.dat { background: var(--dat); color: #fff } b.gen { background: var(--gen, #0b6e74); color: #fff }
i.zero { display: inline-block; width: .55em; height: .8em; border: .12cqw dashed #8f887b; border-radius: .2cqw; vertical-align: -.05em; margin-left: .05em }
.idea .chip .w { font-size: 1.9cqw }
.poss { flex: 1; min-height: 0; display: grid; grid-template-columns: .74fr 1.8fr .86fr; gap: .8cqw }
.bx { min-height: 0; min-width: 0; display: flex; flex-direction: column; border: .25cqw solid var(--navy); border-radius: .8cqw; overflow: hidden; background: #fff }
.bh { background: var(--navy); color: #fff; display: flex; flex-direction: column; padding: .15cqw .9cqw .3cqw }
.bh b { font-family: var(--serif); font-size: 1.4cqw; font-weight: 700; line-height: 1.2 }
.bh span { font-size: .72cqw; font-weight: 800; letter-spacing: .05em; text-transform: uppercase }
.ow { flex: 1; min-height: 0; display: grid; grid-template-columns: 2.4cqw 1.3cqw 4.2cqw 1fr; grid-template-rows: auto auto; align-items: center; column-gap: .3cqw; padding: 0 .8cqw; border-top: .1cqw solid #dde3ec }
.bh + .ow { border-top: 0 }
.op { grid-row: 1 / 3; font-family: var(--serif); font-size: 1.3cqw; font-weight: 700 }
.oa { grid-row: 1 / 3; color: var(--muted); font-size: 1cqw }
.oww { grid-row: 1 / 3; font-family: var(--serif); font-size: 1.45cqw; font-weight: 800; color: var(--navy) }
.oen { font-size: .72cqw; font-weight: 700; color: var(--muted); text-transform: uppercase; letter-spacing: .03em; line-height: 1.2; white-space: nowrap }
.oex { font-family: var(--serif); font-size: 1.02cqw; font-weight: 600; line-height: 1.2; white-space: nowrap }
.tbl { display: grid; grid-template-columns: 6cqw repeat(4, minmax(0, 1fr)); flex: 1.5; min-height: 0 }
.tn { font-family: var(--serif); font-size: 1.15cqw; font-weight: 700; text-align: center; padding: .3cqw .2cqw .15cqw; border-bottom: .15cqw solid var(--navy); display: flex; flex-direction: column; line-height: 1.1 }
.tn small { font-family: var(--sans); font-size: .62cqw; font-weight: 800; letter-spacing: .05em; text-transform: uppercase; color: var(--muted) }
.tn.m { color: var(--m) } .tn.f { color: var(--f) } .tn.n { color: var(--n) } .tn.p { color: #4a4a4a }
.tcase { display: flex; flex-direction: column; justify-content: center; padding: 0 .6cqw; border-top: .1cqw solid #dde3ec; border-left: .45cqw solid #ccc }
.tcase.nom { border-left-color: var(--ink) } .tcase.akk { border-left-color: var(--hi) } .tcase.dat { border-left-color: var(--dat) } .tcase.gen { border-left-color: var(--gen, #0b6e74) }
.tcase b { font-size: .86cqw; font-weight: 800 } .tcase span { font-size: .72cqw; color: var(--muted); font-weight: 600 }
.tcell { display: flex; align-items: center; justify-content: center; font-family: var(--serif); font-size: 1.2cqw; font-weight: 700; border-top: .1cqw solid #dde3ec; white-space: nowrap }
.sent { flex: 1; min-height: 0; display: grid; grid-template-columns: 1fr 1fr; grid-template-rows: auto repeat(4, 1fr); column-gap: 1cqw; padding: .2cqw .9cqw .35cqw; border-top: .2cqw solid var(--navy); background: #f6f8fb; font-family: var(--serif); font-size: 1.12cqw; font-weight: 600 }
.sent .sh { grid-column: 1 / -1; font-family: var(--sans); font-size: .72cqw; font-weight: 800; letter-spacing: .05em; text-transform: uppercase; color: var(--navy); align-self: center }
.sent span { display: block; align-self: center; white-space: nowrap }
.mx { flex: 1; min-height: 0; display: grid; grid-template-columns: 5.4cqw 1fr 1fr; grid-template-rows: auto 1fr 1fr 1fr; gap: .3cqw; padding: .5cqw .6cqw .2cqw }
.mh { font-family: var(--serif); font-size: 1.1cqw; font-weight: 700; text-align: center; align-self: end }
.mh.m { color: var(--m) } .mh.f { color: var(--f) }
.mo { display: flex; flex-direction: column; justify-content: center; font-family: var(--serif); font-size: 1.1cqw; font-weight: 700; line-height: 1.1 }
.mo small { font-family: var(--sans); font-size: .66cqw; color: var(--muted); font-weight: 700 }
.mc { display: block; align-self: center; text-align: center; padding: .8cqw 0; background: var(--navy-soft); border-radius: .5cqw; font-family: var(--serif); font-size: 1.3cqw; font-weight: 700; white-space: nowrap }
.mn { margin: 0; padding: .3cqw .8cqw .5cqw; font-size: .82cqw; line-height: 1.3; font-weight: 600; color: var(--muted) }
.key .sp b.nom, .key .sp b.akk, .key .sp b.dat, .key .sp b.gen { padding: 0 .3cqw }
`;

let html = readFileSync(SKELETON, 'utf8');
const a = html.indexOf('<div class="focus">'), b = html.indexOf('</div></div>\n\t</div>\n\n\t<p class="note">');
if (a < 0 || b < 0) throw new Error('markers not found');
html = html.slice(0, a) + body + '\t' + html.slice(b);
html = html.replace('</style>', css + '</style>');
const rep = (x, y) => { if (!html.includes(x)) throw new Error('missing: ' + x); html = html.replace(x, y); };
rep('<title>Noun Gender Chart</title>', '<title>Possessives Chart</title>');
html = html.replace(/<h1>Chart 15[^<]*<\/h1>\s*<p>[^<]*/, '<h1>Chart 20, mein, dein, sein, ihr</h1>\n\t\t<p>The owner picks the word, the thing picks the ending.');
rep('<small>Chart 15</small>der, die or das?', '<small>Chart 20</small>mein, dein, sein, ihr');
rep('data-qr="15"', 'data-qr="20"');
html = html.replace(/<div class="path">[\s\S]*?<\/div>/, `<div class="path">
				<span><b>1</b>Who owns it? Pick the word</span>
				<span><b>2</b>Gender and case of the thing</span>
				<span><b>3</b>Add that ending</span>
			</div>`);
writeFileSync(FILE, html);
console.log('chart 20 built', Math.round(html.length / 1024) + ' KB,', count, 'forms and sentences');
