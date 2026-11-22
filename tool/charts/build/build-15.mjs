// Chart 15 (noun gender, endings only) as "word tails": rewrites the body of tool/charts/src/15-gender.html.
// Three columns (der, die, das). Real words are set so that their endings line up inside one
// coloured stripe per article; three bands top to bottom say how far to trust the ending.
// The meaning families live on their own chart. Pictures come from the app's library (static/img).
// Run from the repo root: node tool/charts/build/build-15.mjs
import { readFileSync, writeFileSync } from 'node:fs';
import sharp from 'sharp';

const FILE = 'tool/charts/src/15-gender.html';
const pic = async (id) => 'data:image/webp;base64,' + (await sharp('static/img/' + id + '.webp').resize(320).webp({ quality: 80 }).toBuffer()).toString('base64');
const girl = await pic('maedchen');

// Every percentage is our own count (2026-11-22): the share of the nouns with that ending in the course
// word list, assets/content/shared/dictionary/de.json (3,473 one-word nouns with a gender), that take the
// article. -ur is counted without -eur, and -en (44% der) and -el (52% der) are too weak to be a rule:
// they are named in a note, not listed as "usually der".
// bands: [label, sub, rows per band, [der, die, das]]; a word is 'stem|ending'; extra = note html
const BANDS = [
	['Always', 'no exceptions', 6, [
		{ w: ['Früh|ling', 'Lehr|ling', 'Zwil|ling', 'Tour|ismus', 'Optim|ismus', 'Real|ismus'] },
		{ w: ['Wohn|ung', 'Frei|heit', 'Möglich|keit', 'Freund|schaft', 'Universi|tät', 'Ärzt|in'] },
		{ w: ['Bröt|chen', 'Mäd|chen', 'Häus|chen', 'Büch|lein', 'Fräu|lein'], note: '<b>and verbs used as things:</b> das Essen · das Leben' }
	]],
	['Nearly always', 'a few exceptions', 7, [
		{ w: ['Mot|or|75%', 'Dokt|or|75%', 'Poliz|ist', 'Stud|ent', 'Praktik|ant', 'Fris|eur', 'Ingeni|eur'] },
		{ w: ['Stat|ion|96%', 'Mus|ik|88%', 'Famil|ie|94%', 'Bäcker|ei', 'Konfer|enz', 'Nat|ur|86%', 'Gar|age|100%'] },
		{ w: ['Doku|ment', 'Instru|ment', 'Zentr|um', 'Muse|um', 'Aut|o|79%', 'Train|ing', 'Eigen|tum'] }
	]],
	['Usually', 'a good bet, with traps', 5, [
		{ w: ['Koff|er|74%', 'Somm|er|74%', 'Hon|ig', 'Tepp|ich'], note: '<b>-en, -el: only half</b> der Garten · das Kissen' },
		{ w: ['Lamp|e|87%', 'Straß|e|87%', 'Tasch|e|87%', 'Blum|e|87%'], note: '<b>the other 13%:</b> der Junge · der Name · der Käse' },
		{ w: ['Ergeb|nis|71%', 'Zeug|nis|71%', 'Geheim|nis|71%', 'Erleb|nis|71%'], note: '<b>the other 29%:</b> die Erlaubnis · die Kenntnis' }
	]]
];
const G = ['m', 'f', 'n'];

let grid = `<div></div><div class="gh m"><b>der</b><span>masculine</span></div><div class="gh f"><b>die</b><span>feminine</span></div><div class="gh n"><b>das</b><span>neuter</span></div>`;
for (const [bi, [label, sub, n, cols]] of BANDS.entries()) {
	grid += `<div class="bl b${bi}"><b>${label}</b><span>${sub}</span></div>`;
	for (const [ci, c] of cols.entries()) {
		// words that share a tail form one group: one bracket, the tail named once, one percentage
		const ws = c.w.map((w) => w.split('|'));
		let words = '';
		for (let i = 0; i < ws.length; ) {
			let j = i; while (j < ws.length && ws[j][1] === ws[i][1]) j++;
			const many = j - i > 1;
			for (let k = i; k < j; k++) words += `<span class="st" style="grid-row:${k + 1}">${ws[k][0]}</span><span class="en" style="grid-row:${k + 1}">${ws[k][1]}${!many && ws[k][2] ? `<i>${ws[k][2]}</i>` : ''}</span>`;
			if (many) words += `<div class="grp" style="grid-row:${i + 1} / ${j + 1}"><b>-${ws[i][1]}</b>${ws[i][2] ? `<i>${ws[i][2]}</i>` : ''}</div>`;
			i = j;
		}
		const extra = (c.pic ? `<img src="${await pic(c.pic)}" alt="">` : '') + (c.note ? `<p>${c.note}</p>` : '');
		grid += `<div class="tc ${G[ci]} b${bi}" style="--rows:${n}">${words}${extra ? `<div class="ex" style="grid-row:${c.w.length + 1} / -1">${extra}</div>` : ''}</div>`;
	}
}

const body = `<div class="focus">
			<div class="look">
				<div class="lk a"><div class="trio">
					<div class="dm s0 m"><div class="w"><span class="gm">der</span> Früh<u class="x">ling</u></div><small><b>always</b> every -ling noun is der</small></div>
					<div class="dm s1 f"><div class="w"><span class="gf">die</span> Stat<u class="x">ion</u></div><small><b>nearly always</b> 96% of -ion nouns are die</small></div>
					<div class="dm s2"><div class="w"><span class="gn">das</span> Ergeb<u class="x">nis</u></div><small><b>usually</b> 71% of -nis nouns are das</small></div>
				</div>
				<div class="cap1"><span class="c1"><b>1</b>A German noun does not show if it is <span class="gm" style="font-weight:800">der</span>, <span class="gf" style="font-weight:800">die</span> or <span class="gn" style="font-weight:800">das</span>, but its last letters often tell you.</span><span class="c2"><b>2</b>Some endings always go with one article, others only most of the time. Below, every ending sits in the colour of its article: the paler the colour, the weaker the rule.</span></div><h3 class="lt">Look here first: <strong>the ending tells you the article</strong></h3></div>
			</div>
			<div class="idea"><h3>The one idea: <strong>read the tail, not the meaning</strong></h3>
				<div class="proof"><span class="chip"><img class="girl" src="${girl}" alt=""><span class="w"><span class="gn">das</span> Mäd<u class="x">chen</u></span></span><p>A girl, yet the word is <b>das</b>, because <b>-chen</b> is always das. The ending wins.</p></div></div>
		</div>

		<div class="tails">${grid}</div>

		<div class="rules">
			<div class="rl">long words</div>
			<div><b class="lead">the last part decides</b><span class="gn">das</span> Haus + <span class="gf">die</span> Tür = <span class="gf">die</span> Haustür</div>
			<div><b class="lead">plural</b>is always <b>die</b>, whatever the gender: die Männer · die Frauen · die Kinder</div>
			<div class="rl warn">watch out</div>
			<div><b class="lead">-er is der, but</b>die Mutter · die Butter · das Zimmer · das Fenster · das Wasser</div>
			<div><b class="lead">no tail here?</b>try the meaning <span class="aside">see Chart 24</span>, or learn the word with its article</div>
		</div>
		<div class="key"><b>Key:</b> <span class="kb gm">der</span> <span class="kb gf">die</span> <span class="kb gn">das</span> the same colours on every chart <span class="sp"><b>Solid stripe</b> = right every time</span> <span class="sp"><b>The paler the stripe</b>, the less sure the rule</span> <span class="sp"><b>87%</b> = share of such nouns in our word list</span></div>
`;

const css = `
/* word tails version */
.look { padding: .25cqw 1.3cqw .25cqw .5cqw; gap: 1.3cqw }
.look .girl { height: 5.8cqw; width: 4.5cqw; object-fit: cover; border-radius: .5cqw; flex: none }
.look .demo { font-family: var(--serif); font-size: 3.6cqw; font-weight: 700; gap: .9cqw; line-height: 1 }
.look .demo u.x { background: var(--n); padding: .1cqw .3cqw .25cqw; border-radius: .35cqw; display: inline-block; line-height: 1 }
.lk { min-width: 0; display: flex; flex-direction: column-reverse; gap: .45cqw }
.cap1 { gap: .4cqw }
.cap1 span { font-size: 1.08cqw; line-height: 1.35 }
.look { padding: .7cqw 1.5cqw .75cqw }
.lk { gap: .65cqw }
.look h3.lt { margin: 0; font-family: var(--serif); font-size: 1.3cqw; font-weight: 700; line-height: 1.1; color: var(--navy) }
.look h3.lt strong { color: var(--terracotta-ink) }
.look .cap1 .c1 { font-weight: 600; color: var(--ink) }
.dm { gap: .4cqw } .dm small { font-size: .95cqw } .dm small b { font-size: .86cqw }
.idea { padding: .7cqw 1.2cqw .8cqw; font-size: 1.08cqw; line-height: 1.35 }
.cap1 .c2 { color: var(--ink); font-weight: 600 }
.lk.a { flex: 1 } .lk.a .trio { justify-content: space-between }
.idea h3 { font-size: 1.3cqw }
.idea .proof { display: flex; flex-direction: column; align-items: flex-start; gap: .6cqw; margin-top: .6cqw }
.idea .chip { flex: none; background: #fff; border-radius: .6cqw; padding: .3cqw .8cqw .3cqw .4cqw; display: flex; align-items: center; gap: .6cqw }
.idea .chip .girl { height: 3.3cqw; width: 2.5cqw; object-fit: cover; border-radius: .4cqw }
.idea .chip .w { font-family: var(--serif); font-size: 2.2cqw; font-weight: 700; color: var(--ink); white-space: nowrap; line-height: 1 }
.idea .chip u.x { text-decoration: none; background: var(--n); color: #fff; padding: .1cqw .25cqw .2cqw; border-radius: .3cqw; display: inline-block }
.idea .proof p b { font-weight: 800; white-space: nowrap }
.trio { display: flex; align-items: flex-end; gap: 1.5cqw }
.dm { --g: var(--n); display: flex; flex-direction: column; gap: .3cqw }
.dm.f { --g: var(--f) }
.dm .w { font-family: var(--serif); font-size: 2.5cqw; font-weight: 700; line-height: 1; white-space: nowrap }
.dm.m { --g: var(--m) }
.look { justify-content: space-between; padding: .3cqw 1.2cqw .35cqw; gap: 1.2cqw }
.look { min-width: 0 }
.lk.b { border-left: .15cqw solid var(--navy-soft); padding-left: 1.3cqw }
.lk.b .trio { align-items: center; gap: .9cqw }
.look .lk .girl { height: 3.9cqw; width: 3cqw }
.dm u.x { text-decoration: none; background: var(--g); color: #fff; padding: .1cqw .3cqw .22cqw; border-radius: .35cqw; display: inline-block; line-height: 1 }
.dm.s1 u.x { background: color-mix(in srgb, var(--g) 26%, #fff); color: var(--g) }
.dm.s2 u.x { background: color-mix(in srgb, var(--g) 9%, #fff); color: var(--g); box-shadow: inset 0 0 0 .1cqw color-mix(in srgb, var(--g) 35%, #fff) }
.dm small { font-size: .88cqw; font-weight: 600; color: var(--ink); white-space: nowrap }
.dm small b { font-weight: 800; color: var(--g); text-transform: uppercase; letter-spacing: .05em; font-size: .8cqw; margin-right: .2cqw }
.tails { flex: 1; min-height: 0; display: grid; grid-template-columns: 8.6cqw repeat(3, minmax(0, 1fr)); grid-template-rows: auto 6fr 7fr 5fr; gap: .5cqw .9cqw }
.gh, .tc { --g: var(--m); --sw: 13cqw; --sr: 0cqw }
.gh.f, .tc.f { --g: var(--f) } .gh.n, .tc.n { --g: var(--n) }
.gh { background: var(--g); color: #fff; border-radius: .9cqw .9cqw 0 0; display: flex; align-items: baseline; gap: .9cqw; padding: 0 1.2cqw .3cqw; margin-bottom: -.5cqw }
.gh b { font-family: var(--serif); font-size: 2.9cqw; font-weight: 700; line-height: 1.1 }
.gh span { font-size: .8cqw; font-weight: 800; letter-spacing: .08em; text-transform: uppercase }
.bl { background: var(--navy); color: #fff; border-radius: .7cqw; display: flex; flex-direction: column; justify-content: center; padding: 0 .8cqw; gap: .2cqw }
.bl.b1 { background: #47617f } .bl.b2 { background: #fff; color: var(--navy); box-shadow: inset 0 0 0 .3cqw var(--navy) }
.bl b { font-family: var(--serif); font-size: 1.5cqw; line-height: 1.05 }
.bl span { font-size: .78cqw; font-weight: 600; line-height: 1.2 }
.tc { position: relative; min-height: 0; display: grid; grid-template-columns: minmax(0, 1fr) var(--sw) var(--sr); grid-template-rows: repeat(var(--rows), 1fr); align-items: center; border: .3cqw solid var(--g); border-top-width: .12cqw; background: #fff }
.tc.b2 { border-radius: 0 0 .9cqw .9cqw }
.tc::before { content: ''; position: absolute; top: 0; bottom: 0; right: var(--sr); width: var(--sw); background: var(--g) }
.tc.b1::before { background: color-mix(in srgb, var(--g) 20%, #fff) }
.tc.b1::before { background: color-mix(in srgb, var(--g) 26%, #fff) }
.tc.b2::before { background: color-mix(in srgb, var(--g) 9%, #fff) }
.tc .st, .tc .en { position: relative; font-size: 1.75cqw; font-weight: 700; line-height: 1; white-space: nowrap }
.tc .st { grid-column: 1; padding-right: 0; text-align: right; color: var(--ink) }
.tc .en { grid-column: 2; padding-left: .1cqw; color: #fff; font-weight: 800 }
.tc.b1 .en, .tc.b2 .en { color: var(--g) }
.tc .en i { float: right; margin: .1cqw .9cqw 0 0; font-style: normal; font-size: 1.05cqw; font-weight: 800; line-height: 1.5; color: #fff; background: var(--g); border-radius: .3cqw; padding: 0 .45cqw }
.tc .grp { position: relative; grid-column: 2; justify-self: end; align-self: stretch; margin: .32cqw .8cqw .32cqw 0; padding-left: .7cqw; display: flex; flex-direction: column; align-items: center; justify-content: center; gap: .15cqw; color: var(--g); min-width: 3.4cqw }
.tc .grp::before { content: ''; position: absolute; left: 0; top: 0; bottom: 0; width: .45cqw; border: .2cqw solid currentColor; border-right: 0; border-radius: .3cqw 0 0 .3cqw }
.tc.b0 .grp { color: #fff }
.tc .grp b { font-family: var(--serif); font-size: 1.45cqw; font-weight: 700; line-height: 1; white-space: nowrap }
.tc .grp i { font-style: normal; font-size: 1.05cqw; font-weight: 800; line-height: 1.5; color: #fff; background: var(--g); border-radius: .3cqw; padding: 0 .45cqw }
.tc .ex { position: relative; grid-column: 1 / -1; align-self: stretch; display: flex; align-items: center; justify-content: center; background: #fff; border-top: .12cqw solid var(--g); gap: .8cqw; padding: .3cqw .9cqw .3cqw .6cqw; min-height: 0; min-width: 0 }
.tc .ex img { height: 100%; max-height: 5.6cqw; flex: none; aspect-ratio: 1; object-fit: cover; border-radius: .6cqw; background: #fbf5e6 }
.tc .ex p { margin: 0; font-size: .92cqw; line-height: 1.3; font-weight: 500; text-align: center; min-width: 0; white-space: nowrap }
.tc .ex p b { font-weight: 800; color: var(--g) }
.rules { font-size: 1cqw }
.key { font-size: .95cqw; white-space: nowrap }
`;

let html = readFileSync(FILE, 'utf8');
const a = html.indexOf('<div class="focus">'), b = html.indexOf('</div></div>\n\t</div>\n\n\t<p class="note">');
if (a < 0 || b < 0) throw new Error('markers not found');
html = html.slice(0, a) + body + '\t' + html.slice(b);
html = html.replace(/\n\/\* (picture|decision path|flowchart|word tails) version \*\/[\s\S]*?(?=<\/style>)/, '\n').replace('</style>', css + '</style>');
html = html.replace(/<div class="path">[\s\S]*?<\/div>/, `<div class="path">
				<span><b>1</b>Look at the end of your word</span>
				<span><b>2</b>Find the same tail in a stripe</span>
				<span><b>3</b>The colour is the article</span>
			</div>`);
writeFileSync(FILE, html);
console.log('chart 15 rebuilt', Math.round(html.length / 1024) + ' KB');
