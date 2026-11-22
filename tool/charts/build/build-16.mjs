// Chart 16 (plural), reworked: writes tool/charts/src/16-plural.html on the 15-gender.html skeleton.
// Five columns = the five ways to make a plural; in each, the noun groups that take it, with the
// share of the group that follows it. Shares: own count over the app's word list
// (assets/content/shared/dictionary/de.json, compounds and nouns without a plural left out), 2026-11-22.
// Word syntax: {ü} = vowel that gets an umlaut, +en = what is added. Course level A1.1 → A2.1.
// Run from the repo root: node tool/charts/build/build-16.mjs
import { readFileSync, writeFileSync } from 'node:fs';

const SKELETON = 'tool/charts/src/15-gender.html';
const FILE = 'tool/charts/src/16-plural.html';
const A = { der: 'm', die: 'f', das: 'n' };

// column: [ending, notation, sub, cards]; card: [article(s), who, pct, words, note]
const COLS = [
	['-n / -en', '-n · -en · -nen', 'the most common', [
		[['die'], 'ending in -e', '100%', 'Tasche+n Lampe+n Straße+n Blume+n Katze+n'],
		[['die'], '-ung -heit -keit -ion -tät', '100%', 'Zeitung+en Freiheit+en Station+en Universität+en'],
		[['die'], 'women in -in', '100%', 'Freundin+nen Lehrerin+nen Ärztin+nen'],
		[['die'], 'other die nouns', 'most', 'Frau+en Tür+en Uhr+en Gabel+n Schwester+n'],
		[['der'], 'people and animals in -e', '88%', 'Junge+n Kollege+n Löwe+n Name+n'],
		[['der'], 'people in -ent -ant -ist', '100%', 'Student+en Praktikant+en Polizist+en']
	]],
	['-e', '-e · ¨-e', 'one syllable', [
		[['der'], 'one syllable', '76%', 'Tisch+e Hund+e Freund+e Schuh+e Tag+e St{ü}hl+e B{ä}um+e F{ü}ß+e Z{ä}hn+e'],
		[['das'], 'one syllable', 'half', 'Brot+e Bein+e Jahr+e Spiel+e Pferd+e'],
		[['die'], 'a few short ones', '', 'H{ä}nd+e St{ä}dt+e N{ä}cht+e W{ü}rst+e W{ä}nd+e K{ü}h+e'],
		[['das', 'die'], 'ending in -nis', '100%', 'Ergebnis+se Zeugnis+se Erlebnis+se']
	]],
	['-er', '-er · ¨-er', 'with an umlaut if it can', [
		[['das'], 'one syllable', 'a third', 'Kind+er Bild+er Ei+er Kleid+er Lied+er H{ä}us+er B{ü}ch+er Gl{ä}s+er D{ä}ch+er'],
		[['der'], 'a handful', '', 'M{ä}nn+er W{ä}ld+er Geist+er R{ä}nd+er W{ü}rm+er G{ö}tt+er'],
		[['das', 'der'], 'ending in -tum', '100%', 'Irrt{ü}m+er Reicht{ü}m+er Altert{ü}m+er']
	]],
	['-s', '-s', 'foreign and short words', [
		[[], 'ending in -a -i -o -u -y', '73%', 'Auto+s Kino+s Taxi+s Sofa+s Baby+s Foto+s Radio+s Hobby+s'],
		[[], 'from English and French', 'most', 'Handy+s Job+s Team+s Hotel+s Café+s Party+s Restaurant+s Chef+s'],
		[[], 'short forms', '100%', 'Uni+s Kita+s Oma+s Opa+s Lkw+s Pkw+s Akku+s']
	]],
	['no ending', '– · ¨', 'maybe ¨', [
		[['der', 'das'], 'ending in -er -el -en', '95%', 'Lehrer Koffer Zimmer Löffel Kissen V{ä}ter G{ä}rten {Ä}pfel Br{ü}der'],
		[['das'], '-chen and -lein', '100%', 'Mädchen Brötchen Kätzchen Büchlein Fräulein'],
		[['das'], 'Ge- … -e', '100%', 'Gebäude Gemälde Gebirge Getreide'],
		[['die'], 'only two die nouns', '', 'M{ü}tter T{ö}chter']
	]]
];

let count = 0;
const word = (w) => {
	count++;
	const [stem, end] = w.split('+');
	return `<span class="pw">${stem.replace(/\{(.)\}/g, '<u>$1</u>')}${end ? `<b>${end}</b>` : ''}</span>`;
};
let grid = '';
for (const [end, nota, sub, cards] of COLS) {
	grid += `<div class="pc"><div class="ph"><b>${end}</b><span>${sub}</span></div>${cards.map(([arts, who, pct, words]) =>
		`<div class="card"><div class="top"><span class="lab">${arts.map((a) => `<i class="g${A[a]}">${a}</i>`).join(' ')}${arts.length ? ' ' : ''}${who}</span>${pct ? `<span class="pct">${pct}</span>` : ''}</div><div class="ws">${words.split(' ').map(word).join(' ')}</div></div>`).join('')}</div>`;
}

const body = `<div class="focus">
			<div class="look">
				<div class="lk a"><div class="trio">
					<div class="dm"><div class="w"><span class="gf">die</span> Tasche → Tasche<u class="x">n</u></div><small><b>always</b> die + -e adds -n</small></div>
					<div class="dm"><div class="w"><span class="gm">der</span> Stuhl → St<u class="v">ü</u>hl<u class="x">e</u></div><small><b>usually</b> der, one syllable: -e</small></div>
					<div class="dm"><div class="w"><span class="gn">das</span> Buch → B<u class="v">ü</u>ch<u class="x">er</u></div><small><b>often</b> das, one syllable: -er</small></div>
				</div>
				<div class="cap1"><span class="c1"><b>1</b>German has five ways to make a plural. Which one a noun takes depends on its gender and its ending, the same clues as in Chart 15.</span><span class="c2"><b>2</b>Find your noun's group in a column. The coloured letters are what you add; an underlined ä, ö or ü is a vowel that changes. The % says how many nouns in the group follow it.</span></div><h3 class="lt">Look here first: <strong>the singular tells you the plural</strong></h3></div>
			</div>
			<div class="idea"><h3>The one idea: <strong>gender + ending pick the plural</strong></h3>
				<div class="proof"><span class="chip"><span class="w"><span class="gf">die</span> Lampe → <span class="gf">die</span> Lampe<u class="x">n</u></span></span><p>Feminine and ending in -e? Add -n. That one rule covers about one German noun in six.</p></div></div>
		</div>

		<div class="plur">${grid}</div>

		<div class="rules">
			<div class="rl">always</div>
			<div><b class="lead">the plural article is die</b><span class="gm">der</span> Tisch → <span class="gf">die</span> Tische · <span class="gn">das</span> Kind → <span class="gf">die</span> Kinder · <span class="gm">ein</span> Hund → zwei Hunde, <span class="gm">kein</span> → keine</div>
			<div><b class="lead dat">Dativ plural adds -n</b>mit den Kinder<b class="d">n</b> · in den Häuser<b class="d">n</b> · but not after -n or -s: mit den Frauen, mit den Autos</div>
			<div class="rl warn">watch out</div>
			<div><b class="lead">no plural at all</b>die Milch · der Zucker · das Obst · das Geld · die Liebe: say zwei Liter Milch, zwei Stück Obst</div>
			<div><b class="lead">only plural</b>die Eltern · die Leute · die Ferien · die Geschwister · die Lebensmittel</div>
		</div>
		<div class="key"><b>Key:</b> <span class="kb gm">der</span> <span class="kb gf">die</span> <span class="kb gn">das</span> the gender of the singular <span class="sp"><b>Tag<span class="ke">e</span></b> = what you add</span> <span class="sp"><b>St<u>ü</u>hle</b> = the vowel changes</span> <span class="sp"><b>Dictionaries write it</b> der Stuhl, ¨-e</span> <span class="sp"><b>%</b> = share of the group in our word list</span></div>
`;

const css = `
/* plural version */
.lk.a .trio { justify-content: space-between }
.dm .w { font-size: 1.95cqw }
.dm u.v { background: none; color: inherit; padding: 0; border-radius: 0; display: inline; box-shadow: none }
.dm u.x { background: var(--navy); color: #fff }
.dm u.v, .card .pw u, .key u { text-decoration: underline; text-decoration-thickness: .22cqw; text-underline-offset: .18cqw; text-decoration-color: var(--terracotta-ink) }
.dm small b { color: var(--navy) }
.idea .chip .w { font-size: 1.75cqw }
.idea .chip u.x { background: var(--navy) }
.plur { flex: 1; min-height: 0; display: grid; grid-template-columns: 1.3fr 1.1fr .95fr .9fr 1.1fr; gap: .8cqw }
.pc { min-height: 0; min-width: 0; display: flex; flex-direction: column; border: .3cqw solid var(--navy); border-radius: .9cqw; background: #fff; overflow: hidden }
.ph { background: var(--navy); color: #fff; display: flex; align-items: baseline; gap: .8cqw; padding: .1cqw 1cqw .35cqw }
.ph b { font-family: var(--serif); font-size: 2.6cqw; font-weight: 700; line-height: 1.1; white-space: nowrap }
.ph span { font-size: .78cqw; font-weight: 800; letter-spacing: .06em; text-transform: uppercase; line-height: 1.2 }
.card { flex: 1; min-height: 0; display: flex; flex-direction: column; justify-content: center; gap: .3cqw; padding: .3cqw .7cqw .35cqw; border-top: .12cqw solid #c9d2de }
.ph + .card { border-top: 0 }
.card .top { display: flex; align-items: baseline; justify-content: space-between; gap: .5cqw; min-width: 0 }
.card .lab { font-size: .86cqw; font-weight: 700; line-height: 1.25; color: var(--muted); min-width: 0 }
.card .lab i { font-style: normal; font-weight: 800; font-size: .95cqw }
.card .pct { flex: none; font-size: .9cqw; font-weight: 800; color: #fff; background: var(--navy); border-radius: .3cqw; padding: 0 .4cqw; line-height: 1.45 }
.card .ws { font-family: var(--serif); font-size: 1.42cqw; font-weight: 700; line-height: 1.2; color: var(--ink) }
.card .pw { white-space: nowrap; margin-right: .45cqw }
.card .pw b { color: var(--terracotta-ink); font-weight: 800 }
.rules .lead.dat { background: var(--dat, #5b3aa8); color: #fff }
.rules b.d { color: var(--dat, #5b3aa8); font-weight: 800 }
.key .ke { color: var(--terracotta-ink) }
`;

let html = readFileSync(SKELETON, 'utf8');
const a = html.indexOf('<div class="focus">'), b = html.indexOf('</div></div>\n\t</div>\n\n\t<p class="note">');
if (a < 0 || b < 0) throw new Error('markers not found');
html = html.slice(0, a) + body + '\t' + html.slice(b);
html = html.replace('</style>', css + '</style>');
const rep = (x, y) => { if (!html.includes(x)) throw new Error('missing: ' + x); html = html.replace(x, y); };
rep('<title>Noun Gender Chart</title>', '<title>Plural Chart</title>');
html = html.replace(/<h1>Chart 15[^<]*<\/h1>\s*<p>[^<]*/, '<h1>Chart 16, the plural</h1>\n\t\t<p>The five ways to make a German plural, and which nouns take each one.');
rep('<small>Chart 15</small>der, die or das?', '<small>Chart 16</small>One Tisch, two …?');
rep('data-qr="15"', 'data-qr="16"');
html = html.replace(/<div class="path">[\s\S]*?<\/div>/, `<div class="path">
				<span><b>1</b>Gender and ending of the singular</span>
				<span><b>2</b>Find that group in a column</span>
				<span><b>3</b>Add the coloured letters</span>
			</div>`);
writeFileSync(FILE, html);
console.log('chart 16 built', Math.round(html.length / 1024) + ' KB,', count, 'plural forms');
