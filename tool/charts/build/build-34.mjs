// Chart 34 (nach, in or zu?): writes tool/charts/src/34-nach-in-zu.html on the 15-gender.html
// skeleton. Five columns, one per preposition of direction (nach, in, zu, an, auf), each with what
// it is used for and six destinations; under each, the matching Wo? and Woher? forms, so the
// learner sees the three questions as one system. Course level A1.2 → A2.2.
// Run from the repo root: node tool/charts/build/build-34.mjs
import { readFileSync, writeFileSync } from 'node:fs';

const SKELETON = 'tool/charts/src/15-gender.html';
const FILE = 'tool/charts/src/34-nach-in-zu.html';

// [prep, case, used for, destinations, Wo?, Woher?]; [x] = Akkusativ ending, {x} = Dativ ending
const COLS = [
	['nach', 'no article', 'cities, countries without an article, home, directions',
		['nach Berlin', 'nach Wien', 'nach Spanien', 'nach Deutschland', 'nach Hause', 'nach links', 'nach oben'],
		['in Berlin', 'zu Hause'], ['aus Berlin', 'von zu Hause']],
	['in', 'Akkusativ', 'countries with an article, rooms and buildings you go inside, nature areas',
		['in d[ie] Schweiz', 'in d[ie] Türkei', 'in d[ie] USA', 'in[s] Kino', 'in[s] Büro', 'in d[en] Wald', 'in d[ie] Berge'],
		['in d{er} Schweiz', 'i{m} Kino'], ['aus d{er} Schweiz', 'aus d{em} Kino']],
	['zu', 'Dativ', 'people, shops and doctors, a place as a point to reach',
		['zu mein{er} Oma', 'zu Peter', 'zu{m} Arzt', 'zu{m} Bäcker', 'zu{r} Post', 'zu{m} Bahnhof', 'zu{r} Arbeit'],
		['bei mein{er} Oma', 'bei{m} Arzt'], ['von mein{er} Oma', 'vo{m} Arzt']],
	['an', 'Akkusativ', 'water and edges: you stop beside it',
		['an[s] Meer', 'an d[en] See', 'an d[en] Strand', 'an d[ie] Nordsee', 'an d[en] Rhein', 'an d[ie] Grenze', 'an d[ie] Tafel'],
		['a{m} Meer', 'a{m} See'], ['vo{m} Meer', 'vo{m} See']],
	['auf', 'Akkusativ', 'islands, open places, events, up on top',
		['auf d[ie] Insel', 'auf d[en] Markt', 'auf ein[e] Party', 'auf[s] Land', 'auf d[en] Berg', 'auf d[en] Spielplatz', 'auf d[ie] Toilette'],
		['auf d{em} Markt', 'auf d{er} Party'], ['vo{m} Markt', 'von d{er} Party']]
];

let count = 0;
const fx = (t) => t.replace(/\[([^\]]+)\]/g, '<b class="ak">$1</b>').replace(/\{([^}]+)\}/g, '<b class="dt">$1</b>');
const caseCls = (c) => (c === 'Akkusativ' ? 'akc' : c === 'Dativ' ? 'dtc' : 'noc');
const cols = COLS.map(([p, c, use, dest, wo, woher]) => {
	count += dest.length + wo.length + woher.length;
	return `<div class="dc"><div class="dh"><b class="dp">${p}</b><span class="${caseCls(c)}">${c === 'no article' ? 'no article' : '+ ' + c}</span></div>
		<p class="du">${use}</p>
		<div class="dl">${dest.map((d) => `<span><i>${fx(d)}</i></span>`).join('')}</div>
		<div class="dq"><small>Wo?</small>${wo.map((d) => `<span>${fx(d)}</span>`).join('')}</div>
		<div class="dq fr"><small>Woher?</small>${woher.map((d) => `<span>${fx(d)}</span>`).join('')}</div></div>`;
}).join('');

const body = `<div class="focus">
			<div class="look">
				<div class="lk a"><div class="trio">
					<div class="dm"><div class="w"><b class="dpi">nach</b> Berlin</div><small><b>a city</b> no article</small></div>
					<div class="dm"><div class="w"><b class="dpi">in</b> d<b class="ak">ie</b> Schweiz</div><small><b>a country with die</b> + Akkusativ</small></div>
					<div class="dm"><div class="w"><b class="dpi">zu</b><b class="dt">m</b> Arzt</div><small><b>a person, a shop</b> + Dativ</small></div>
				</div>
				<div class="cap1"><span class="c1"><b>1</b>English says to for every trip: to Berlin, to Switzerland, to the doctor. German picks the word from the kind of place: a city, a country with an article, a person, the sea, an island.</span><span class="c2"><b>2</b>Find the kind of place in a column, then read down: the top half says where you go (Wohin?), the bottom says where you are (Wo?) and where you come from (Woher?).</span></div><h3 class="lt">Look here first: <strong>the place picks the word</strong></h3></div>
			</div>
			<div class="idea"><h3>The one idea: <strong>what kind of place?</strong></h3>
				<div class="proof"><span class="chip"><span class="w"><b class="dpi">nach</b> Wien · <b class="dpi">in</b> d<b class="ak">ie</b> Türkei · <b class="dpi">zu</b> Oma</span></span><p>A city, a country with die, a person: three trips, three words.</p></div></div>
		</div>

		<div class="dir">${cols}</div>

		<div class="rules">
			<div class="rl">three questions</div>
			<div><b class="lead">go · be · come from</b>nach → in → aus · in → in → aus · zu → bei → von · an → an → von · auf → auf → von</div>
			<div><b class="lead">home</b>Ich gehe <b class="dpi">nach</b> Hause. · Ich bin <b class="dpi">zu</b> Hause. · Ich komme von zu Hause. <span class="aside">see Chart 2</span></div>
			<div class="rl warn">watch out</div>
			<div><b class="lead">nach or in?</b>Is there an article? <s>nach die Schweiz</s> → in die Schweiz · <s>in Spanien fahren</s> → nach Spanien fahren</div>
			<div><b class="lead">in or zu?</b>in = inside: in die Schule (as a pupil), ins Kino · zu = to the door: zur Schule, zum Bahnhof <span class="aside">see Chart 27</span></div>
		</div>
		<div class="key"><b>Key:</b> <span class="sp">in d<b class="ak">ie</b> = Akkusativ ending, a trip (Wohin?)</span> <span class="sp">i<b class="dt">m</b> = Dativ ending (Wo? and after zu)</span> <span class="sp">the case colours of Chart 1</span></div>
`;

const css = `
/* nach in zu version */
.lk.a .trio { justify-content: space-between }
.dm .w { font-size: 2cqw }
.dm small b { color: var(--navy) }
b.dpi { background: var(--navy); color: #fff; border-radius: .3cqw; padding: 0 .35cqw; font-weight: 700 }
b.ak { background: #fff4b3; border-radius: .2cqw; padding: 0 .08cqw; font-weight: 800 }
b.dt { background: #e6defa; color: #3d2380; border-radius: .2cqw; padding: 0 .08cqw; font-weight: 800 }
.idea .chip .w { font-size: 1.45cqw }
.dir { flex: 1; min-height: 0; display: grid; grid-template-columns: repeat(5, 1fr); gap: .7cqw }
.dc { min-height: 0; min-width: 0; display: flex; flex-direction: column; border: .25cqw solid var(--navy); border-radius: .8cqw; overflow: hidden; background: #fff }
.dh { display: flex; align-items: baseline; justify-content: space-between; background: var(--navy); color: #fff; padding: .05cqw .8cqw .2cqw }
.dh b.dp { font-family: var(--serif); font-size: 2.2cqw; font-weight: 700; line-height: 1.1 }
.dh span { font-size: .68cqw; font-weight: 800; letter-spacing: .04em; text-transform: uppercase; border-radius: .3cqw; padding: .05cqw .35cqw }
.dh .akc { background: var(--hi); color: var(--ink) } .dh .dtc { background: #e6defa; color: #3d2380 } .dh .noc { background: #fff; color: var(--navy) }
.du { margin: 0; padding: .3cqw .8cqw .25cqw; font-size: .76cqw; font-weight: 600; line-height: 1.3; color: var(--muted); border-bottom: .1cqw solid #e3e8ef; min-height: 2.6cqw }
.dl { flex: 1; min-height: 0; display: flex; flex-direction: column; padding: .1cqw .8cqw }
.dl span { flex: 1; display: flex; align-items: center; font-family: var(--serif); font-size: 1.28cqw; font-weight: 600; white-space: nowrap; border-top: .08cqw dashed #dfe5ee }
.dl i { font-style: normal }
.dl span:first-child { border-top: 0 }
.dq { display: grid; grid-template-columns: 3.6cqw 1fr; grid-auto-rows: auto; column-gap: .4cqw; padding: .2cqw .8cqw; background: #f3f0fb; border-top: .12cqw solid #d8cff2 }
.dq.fr { background: #f6f4f0; border-top-color: #e3ded5 }
.dq small { grid-row: 1 / 3; align-self: center; font-size: .66cqw; font-weight: 800; letter-spacing: .04em; text-transform: uppercase; color: #5b3aa8 }
.dq.fr small { color: var(--muted) }
.dq span { font-family: var(--serif); font-size: 1.05cqw; font-weight: 600; white-space: nowrap; line-height: 1.35 }
.rules s { color: #8b857c }
.key b.ak, .key b.dt { padding: 0 .1cqw }
`;

let html = readFileSync(SKELETON, 'utf8');
const a = html.indexOf('<div class="focus">'), b = html.indexOf('</div></div>\n\t</div>\n\n\t<p class="note">');
if (a < 0 || b < 0) throw new Error('markers not found');
html = html.slice(0, a) + body + '\t' + html.slice(b);
html = html.replace('</style>', css + '</style>');
const rep = (x, y) => { if (!html.includes(x)) throw new Error('missing: ' + x); html = html.replace(x, y); };
rep('<title>Noun Gender Chart</title>', '<title>nach, in or zu Chart</title>');
html = html.replace(/<h1>Chart 15[^<]*<\/h1>\s*<p>[^<]*/, '<h1>Chart 34, nach, in or zu?</h1>\n\t\t<p>Where you go, where you are, where you come from: nach, in, zu, an, auf.');
rep('<small>Chart 15</small>der, die or das?', '<small>Chart 34</small>nach, in or zu?');
rep('data-qr="15"', 'data-qr="34"');
html = html.replace(/<div class="path">[\s\S]*?<\/div>/, `<div class="path">
				<span><b>1</b>What kind of place?</span>
				<span><b>2</b>Find its column</span>
				<span><b>3</b>Wohin, Wo or Woher?</span>
			</div>`);
writeFileSync(FILE, html);
console.log('chart 34 built', Math.round(html.length / 1024) + ' KB,', count, 'phrases');
