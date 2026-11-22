// Chart 24 (noun gender by meaning): the partner of Chart 15 (gender by ending).
// Writes tool/charts/src/24-gender-meaning.html, using 15-gender.html as the skeleton (header,
// rule rows, key, shared CSS), so the two gender charts read as a pair.
// Three article columns; two bands: families with no exception (solid label) and families with
// one exception to learn (pale label + "but …" line). Content: course level A1.2 → A2.2.
// Run from the repo root: node tool/charts/build/build-24.mjs
import { readFileSync, writeFileSync } from 'node:fs';

const SKELETON = 'tool/charts/src/15-gender.html';
const FILE = 'tool/charts/src/24-gender-meaning.html';

// [family, words, exception html or '']; exceptions name their own article, coloured by gender
const g = (a, w) => `<span class="g${{ der: 'm', die: 'f', das: 'n' }[a]}">${a}</span> ${w}`;
const BANDS = [
	['Always', 'the whole family', 5, [
		[
			['Days', 'Montag · Dienstag · Freitag · Sonntag', ''],
			['Months', 'Januar · März · Mai · Juli · Dezember', ''],
			['Seasons', 'Frühling · Sommer · Herbst · Winter', ''],
			['Compass points', 'Norden · Süden · Osten · Westen', '']
		],
		[
			['Numbers', 'Eins · Drei · Sieben · Zehn · Elf', ''],
			['Big numbers', 'Million · Milliarde · Billion', ''],
			['Ships, by their name', 'Titanic · Bismarck · Santa Maria · Mayflower', '']
		],
		[
			['Colours as nouns', 'Rot · Blau · Grün · Gelb · Weiß', ''],
			['Languages', 'Deutsch · Englisch · Türkisch · Thai', ''],
			['Verbs used as nouns', 'Essen · Leben · Lesen · Schwimmen', ''],
			['Letters', 'A · B · C · Ö · ß', '']
		]
	]],
	['Mostly', 'learn the exception', 4, [
		[
			['Times of day', 'Morgen · Mittag · Abend', g('die', 'Nacht')],
			['Weather', 'Regen · Schnee · Wind · Sturm', g('das', 'Gewitter') + ' · ' + g('die', 'Wolke')],
			['Alcohol', 'Wein · Sekt · Schnaps · Whisky', g('das', 'Bier')],
			['Men, male animals', 'Mann · Vater · Bruder · Onkel · Hahn', g('das', 'Söhnchen')]
		],
		[
			['Flowers', 'Rose · Tulpe · Nelke · Lilie · Orchidee', g('der', 'Mohn')],
			['Fruit', 'Banane · Birne · Kirsche · Orange', g('der', 'Apfel') + ' · ' + g('der', 'Pfirsich')],
			['Women, female animals', 'Frau · Mutter · Tochter · Tante · Kuh', g('das', 'Mädchen')],
			['Rivers in Germany', 'Donau · Elbe · Mosel · Spree · Weser', g('der', 'Rhein') + ' · ' + g('der', 'Main')]
		],
		[
			['Metals', 'Gold · Silber · Eisen · Kupfer', g('der', 'Stahl')],
			['Babies, young animals', 'Baby · Kalb · Lamm · Fohlen · Küken', g('der', 'Welpe')],
			['Fractions', 'Drittel · Viertel · Achtel · Zehntel', g('die', 'Hälfte')],
			['Countries and cities', 'Deutschland · Italien · Berlin · Wien', g('die', 'Schweiz') + ' · ' + g('die', 'Türkei')]
		]
	]]
];
const G = ['m', 'f', 'n'];

let grid = `<div></div><div class="gh m"><b>der</b><span>masculine</span></div><div class="gh f"><b>die</b><span>feminine</span></div><div class="gh n"><b>das</b><span>neuter</span></div>`;
let count = 0;
for (const [bi, [label, sub, , cols]] of BANDS.entries()) {
	grid += `<div class="bl b${bi}"><b>${label}</b><span>${sub}</span></div>`;
	for (const [ci, fams] of cols.entries()) {
		const cards = fams.map(([name, words, but]) => {
			count += words.split(' · ').length;
			return `<div class="card"><div class="top"><span class="lab">${name}</span>${but ? `<span class="but"><b>but</b> ${but}</span>` : ''}</div><div class="ws">${words.replace(/ · /g, ' <i>·</i> ')}</div></div>`;
		}).join('');
		grid += `<div class="fc ${G[ci]} b${bi}">${cards}</div>`;
	}
}

const body = `<div class="focus">
			<div class="look">
				<div class="lk a"><div class="trio">
					<div class="dm s0 m"><div class="w"><span class="gm">der</span> <u class="x">Mai</u></div><small><b>always</b> every month is der</small></div>
					<div class="dm s1 f"><div class="w"><span class="gf">die</span> <u class="x">Banane</u></div><small><b>mostly</b> fruit is die, but der Apfel</small></div>
					<div class="dm s1"><div class="w"><span class="gn">das</span> <u class="x">Gold</u></div><small><b>mostly</b> metals are das, but der Stahl</small></div>
				</div>
				<div class="cap1"><span class="c1"><b>1</b>Many nouns have no ending that gives away <span class="gm" style="font-weight:800">der</span>, <span class="gf" style="font-weight:800">die</span> or <span class="gn" style="font-weight:800">das</span>. But they belong to a family, and the family shares one article.</span><span class="c2"><b>2</b>Find your noun's family below. Solid label: the whole family, no exception. Pale label: most of it; the exception is written next to it.</span></div><h3 class="lt">Look here first: <strong>no clear ending? Ask what the word is</strong></h3></div>
			</div>
			<div class="idea"><h3>The one idea: <strong>know the family, know the article</strong></h3>
				<div class="proof"><span class="chip"><span class="w"><span class="gm">der</span> Januar … <span class="gm">der</span> Dezember</span></span><p>Twelve months, one article. Learn it once for the whole family, not twelve times.</p></div></div>
		</div>

		<div class="fam">${grid}</div>

		<div class="rules">
			<div class="rl">memory trick</div>
			<div><b class="lead">many families follow their group word</b><span class="gm">der</span> Tag → <span class="gm">der</span> Montag · <span class="gf">die</span> Zahl → <span class="gf">die</span> Drei · <span class="gn">das</span> Metall → <span class="gn">das</span> Gold · <span class="gf">die</span> Blume → <span class="gf">die</span> Rose</div>
			<div><b class="lead">but not all</b><span class="gf">die</span> Farbe, yet <span class="gn">das</span> Rot · <span class="gf">die</span> Sprache, yet <span class="gn">das</span> Deutsch · <span class="gm">der</span> Baum, yet <span class="gf">die</span> Tanne</div>
			<div class="rl warn">watch out</div>
			<div><b class="lead">the ending beats the meaning</b><span class="gn">das</span> Mädchen · <span class="gn">das</span> Kätzchen · <span class="gn">das</span> Söhnchen: -chen is always das <span class="aside">see Chart 15</span></div>
			<div><b class="lead">same word, two articles, two meanings</b><span class="gm">der</span> See is the lake · <span class="gf">die</span> See is the sea · <span class="gm">der</span> Leiter is the boss · <span class="gf">die</span> Leiter is the ladder</div>
		</div>
		<div class="key"><b>Key:</b> <span class="kb gm">der</span> <span class="kb gf">die</span> <span class="kb gn">das</span> the same colours on every chart <span class="sp"><b>Solid label</b> = the whole family</span> <span class="sp"><b>Pale label</b> = most of the family</span> <span class="sp"><b>but …</b> = the exception to learn with it</span></div>
`;

const css = `
/* meaning families version */
.lk.a .trio { justify-content: flex-start; gap: 4.2cqw }
.dm u.x { padding: .1cqw .4cqw .22cqw }
.idea .chip { padding: .45cqw .9cqw }
.idea .chip .w { font-size: 1.75cqw }
.fam { flex: 1; min-height: 0; display: grid; grid-template-columns: 7.6cqw repeat(3, minmax(0, 1fr)); grid-template-rows: auto 5fr 4fr; gap: .5cqw .9cqw }
.fc { --g: var(--m); min-height: 0; min-width: 0; display: flex; flex-direction: column; border: .3cqw solid var(--g); border-top-width: .12cqw; background: #fff }
.fc.f { --g: var(--f) } .fc.n { --g: var(--n) }
.fc.b1 { border-radius: 0 0 .9cqw .9cqw }
.card { flex: 1; min-height: 0; display: flex; flex-direction: column; justify-content: center; gap: .3cqw; padding: .25cqw .65cqw .3cqw; border-top: .12cqw solid color-mix(in srgb, var(--g) 30%, #fff) }
.card:first-child { border-top: 0 }
.card .top { display: flex; align-items: center; justify-content: space-between; gap: .6cqw; min-width: 0 }
.card .lab { font-size: .82cqw; font-weight: 800; letter-spacing: .05em; text-transform: uppercase; line-height: 1.5; padding: 0 .5cqw; border-radius: .3cqw; white-space: nowrap; background: var(--g); color: #fff }
.fc.b1 .lab { background: color-mix(in srgb, var(--g) 18%, #fff); color: var(--g) }
.card .but { font-size: .95cqw; font-weight: 600; white-space: nowrap; color: var(--ink) }
.card .but b { font-weight: 800; color: var(--muted); margin-right: .15cqw }
.card .but .gm, .card .but .gf, .card .but .gn { font-weight: 800 }
.card .ws { font-family: var(--serif); font-size: 1.48cqw; font-weight: 700; line-height: 1.12; color: var(--ink) }
.card .ws i { font-style: normal; color: color-mix(in srgb, var(--g) 55%, #fff); margin: 0 .05cqw }
`;

let html = readFileSync(SKELETON, 'utf8');
const a = html.indexOf('<div class="focus">'), b = html.indexOf('</div></div>\n\t</div>\n\n\t<p class="note">');
if (a < 0 || b < 0) throw new Error('markers not found');
html = html.slice(0, a) + body + '\t' + html.slice(b);
html = html.replace('</style>', css + '</style>');
const rep = (x, y) => { if (!html.includes(x)) throw new Error('missing: ' + x); html = html.replace(x, y); };
rep('<title>Noun Gender Chart</title>', '<title>Gender by Meaning</title>');
rep('<h1>Chart 15, der, die or das</h1>', '<h1>Chart 24, der, die or das by meaning</h1>');
html = html.replace(/(<h1>Chart 24[^<]*<\/h1>\s*<p>)[^<]*/, '$1Noun gender by meaning. When the ending says nothing, the family a noun belongs to often does.');
rep('<small>Chart 15</small>der, die or das?', '<small>Chart 24</small>der, die or das? By meaning');
rep('data-qr="15"', 'data-qr="24"');
html = html.replace(/<div class="path">[\s\S]*?<\/div>/, `<div class="path">
				<span><b>1</b>What is your word?</span>
				<span><b>2</b>Find its family</span>
				<span><b>3</b>The column is the article</span>
			</div>`);
writeFileSync(FILE, html);
console.log('chart 24 built', Math.round(html.length / 1024) + ' KB,', count, 'German words in the families');
