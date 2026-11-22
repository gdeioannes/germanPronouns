// Chart 17 (nouns that add -n), reworked: writes tool/charts/src/17-n-nouns.html on the
// 15-gender.html skeleton. Left: a normal noun beside four n-nouns in every case, so the extra -n
// stands out; then sentences. Right: which nouns belong (four groups). Added -n/-en in terracotta.
// Course level A2.2 → B1.1. Run from the repo root: node tool/charts/build/build-17.mjs
import { readFileSync, writeFileSync } from 'node:fs';

const SKELETON = 'tool/charts/src/15-gender.html';
const FILE = 'tool/charts/src/17-n-nouns.html';

const COLS = ['Tisch', 'Junge', 'Student', 'Herr', 'Name'];
const CASES = [
	['nom', 'Nominativ', 'der', ['Tisch', 'Junge', 'Student', 'Herr', 'Name']],
	['akk', 'Akkusativ', 'den', ['Tisch', 'Junge+n', 'Student+en', 'Herr+n', 'Name+n']],
	['dat', 'Dativ', 'dem', ['Tisch', 'Junge+n', 'Student+en', 'Herr+n', 'Name+n']],
	['gen', 'Genitiv', 'des', ['Tisch~es', 'Junge+n', 'Student+en', 'Herr+n', 'Name+ns']],
	['pl', 'Plural', 'die', ['Tisch~e', 'Junge+n', 'Student+en', 'Herr+en', 'Name+n']]
];
const GROUPS = [
	['der … -e: people and animals', 'Junge · Kollege · Kunde · Neffe · Franzose · Löwe · Affe · Hase', 'Kennst du den Junge[n]?'],
	['-ent -ant -ist -at -oge -graf: people', 'Student · Präsident · Praktikant · Polizist · Tourist · Soldat · Biologe · Fotograf', 'Frag den Polizist[en]!'],
	['a few short ones', 'Herr · Mensch · Nachbar · Bauer · Held · Bär · Prinz', 'Ich helfe dem Nachbar[n].'],
	['-ns in the Genitiv', 'Name · Gedanke · Buchstabe · Glaube · and das Herz', 'die Farbe des Herz[ens]']
];
const SENT = ['Ich spreche mit dem Kollege[n].', 'Das ist das Auto des Student[en].', 'Wir haben einen neuen Kunde[n].', 'Ein Brief an Herr[n] Müller'];

let count = 0;
const cell = (w) => { count++; if (w.includes('+')) { const [s, e] = w.split('+'); return `${s}<b>${e}</b>`; } if (w.includes('~')) { const [s, e] = w.split('~'); return `${s}<i>${e}</i>`; } return w; };
const br = (t) => t.replace(/\[([^\]]+)\]/g, '<b>$1</b>');
let table = `<div class="tc0"></div>${COLS.map((c, i) => `<div class="th${i ? '' : ' norm'}">${c}<small>${i ? 'n-noun' : 'a normal noun'}</small></div>`).join('')}`;
for (const [c, name, art, forms] of CASES) table += `<div class="tcase ${c}"><b>${name}</b><span>${art}</span></div>${forms.map((f, i) => `<div class="tcell${i ? '' : ' norm'}"><span><small>${art}</small> ${cell(f)}</span></div>`).join('')}`;
const groups = GROUPS.map(([h, w, s]) => { count += w.split(' · ').length + 1; return `<div class="gr"><div class="nh">${h}</div><div class="gw">${w}</div><div class="gs">${br(s)}</div></div>`; }).join('');

const body = `<div class="focus">
			<div class="look">
				<div class="lk a"><div class="trio">
					<div class="dm"><div class="w">der Junge</div><small><b>Nominativ</b> no -n</small></div>
					<div class="dm"><div class="w">den Junge<b>n</b></div><small><b>Akkusativ</b> -n</small></div>
					<div class="dm"><div class="w">mit dem Junge<b>n</b></div><small><b>Dativ</b> -n</small></div>
					<div class="dm"><div class="w">des Junge<b>n</b></div><small><b>Genitiv</b> -n</small></div>
				</div>
				<div class="cap1"><span class="c1"><b>1</b>A small group of der-nouns adds -n (or -en) in every case except the Nominativ singular: der Junge, but den Jungen, dem Jungen, des Jungen.</span><span class="c2"><b>2</b>Almost all are people or animals: they end in -e, or are foreign words in -ent, -ant, -ist. The groups are on the right; compare them with the normal noun in the table.</span></div><h3 class="lt">Look here first: <strong>some der-nouns add -n everywhere but the start</strong></h3></div>
			</div>
			<div class="idea"><h3>The one idea: <strong>only the subject goes without -n</strong></h3>
				<div class="proof"><span class="chip"><span class="w">Der Student fragt den Student<b>en</b>.</span></span><p>Two students: the one who asks has no ending, the one being asked gets -en.</p></div></div>
		</div>

		<div class="nn">
			<div class="left">
				<div class="tbl">${table}</div>
				<div class="sent">${SENT.map((s) => { count++; return `<span>${br(s)}</span>`; }).join('')}</div>
			</div>
			<div class="bx"><div class="bh"><b>Which nouns?</b><span>all masculine, almost all people or animals</span></div>${groups}</div>
		</div>

		<div class="rules">
			<div class="rl">good to know</div>
			<div><b class="lead">Herr: -n, plural -en</b>an Herr<b class="kn">n</b> Müller · Sehr geehrte Damen und Herr<b class="kn">en</b></div>
			<div><b class="lead">not the plural Dativ -n</b>mit den Kinder<b class="kd">n</b> = every noun, plural only · dem Junge<b class="kn">n</b> = n-nouns, singular too <span class="aside">see Chart 16</span></div>
			<div class="rl warn">watch out</div>
			<div><b class="lead">not every noun in -e</b>der Käse, den Käse · der Tee, den Tee · der See, den See: things, so no -n</div>
			<div><b class="lead">spoken German drops it</b>you will hear <s>den Student</s>, but write and say den Student<b class="kn">en</b></div>
		</div>
		<div class="key"><b>Key:</b> <span class="sp">Junge<b class="kn">n</b> = the extra -n of an n-noun</span> <span class="sp">Tisch<i class="kg">es</i> = the normal Genitiv ending, for comparison</span> <span class="sp">case colours as in Chart 1</span></div>
`;

const css = `
/* n-nouns version */
.lk.a .trio { justify-content: space-between }
.dm .w { font-size: 1.85cqw }
.dm .w b, .tcell b, .gs b, .sent b, .idea .chip b, b.kn { color: var(--terracotta-ink); font-weight: 800; background: #fbe3d4; border-radius: .2cqw; padding: 0 .1cqw }
.dm small b { color: var(--navy) }
b.kd { color: var(--dat); font-weight: 800 }
.tcell i, i.kg { font-style: normal; color: #8b857c; font-weight: 700 }
.idea .chip .w { font-size: 1.6cqw }
.nn { flex: 1; min-height: 0; display: grid; grid-template-columns: 1.35fr 1fr; gap: .9cqw }
.left { min-height: 0; display: flex; flex-direction: column; gap: .6cqw }
.tbl { flex: 1; min-height: 0; display: grid; grid-template-columns: 6.2cqw .85fr repeat(4, 1fr); grid-template-rows: auto repeat(5, 1fr); border: .25cqw solid var(--navy); border-radius: .8cqw; overflow: hidden; background: #fff }
.th { background: var(--navy); color: #fff; font-family: var(--serif); font-size: 1.3cqw; font-weight: 700; text-align: center; padding: .2cqw .2cqw .25cqw; display: flex; flex-direction: column; line-height: 1.15 }
.th small { font-family: var(--sans); font-size: .62cqw; font-weight: 800; letter-spacing: .05em; text-transform: uppercase; opacity: .85 }
.th.norm { background: #8b95a3 } .tc0 { background: var(--navy) }
.tcase { display: flex; flex-direction: column; justify-content: center; padding: 0 .6cqw; border-top: .1cqw solid #dde3ec; border-left: .45cqw solid #ccc }
.tcase.nom { border-left-color: var(--ink) } .tcase.akk { border-left-color: var(--hi) } .tcase.dat { border-left-color: var(--dat) } .tcase.gen { border-left-color: var(--gen, #0b6e74) } .tcase.pl { border-left-color: #8b95a3; background: #f6f7f9 }
.tcase b { font-size: .82cqw; font-weight: 800 } .tcase span { font-family: var(--serif); font-size: 1cqw; font-weight: 700; color: var(--muted) }
.tcell { display: flex; align-items: center; justify-content: center; font-family: var(--serif); font-size: 1.3cqw; font-weight: 700; border-top: .1cqw solid #dde3ec; white-space: nowrap }
.tcell small { font-size: .9cqw; color: var(--muted); font-weight: 600 }
.tcell.norm { background: #f3f4f6; color: #5a5f66 }
.sent { display: grid; grid-template-columns: 1fr 1fr; gap: .3cqw 1cqw; padding: .4cqw .9cqw; border: .2cqw solid var(--navy); border-radius: .7cqw; background: #f6f8fb; font-family: var(--serif); font-size: 1.2cqw; font-weight: 600 }
.sent span { white-space: nowrap }
.bx { min-height: 0; display: flex; flex-direction: column; border: .25cqw solid var(--terracotta-ink); border-radius: .8cqw; overflow: hidden; background: #fff }
.bh { background: var(--terracotta-ink); color: #fff; display: flex; flex-direction: column; padding: .1cqw .9cqw .25cqw }
.bh b { font-family: var(--serif); font-size: 1.5cqw; font-weight: 700; line-height: 1.2 }
.bh span { font-size: .72cqw; font-weight: 800; letter-spacing: .05em; text-transform: uppercase }
.gr { flex: 1; min-height: 0; display: flex; flex-direction: column; justify-content: center; gap: .2cqw; padding: 0 .9cqw; border-top: .1cqw solid #efe0d6 }
.bh + .gr { border-top: 0 }
.nh { font-size: .78cqw; font-weight: 800; letter-spacing: .04em; text-transform: uppercase; color: var(--terracotta-ink) }
.gw { font-family: var(--serif); font-size: 1.22cqw; font-weight: 700; line-height: 1.3 }
.gs { font-family: var(--serif); font-size: 1.08cqw; font-weight: 600; color: var(--muted) }
.rules s { color: #8b857c }
`;

let html = readFileSync(SKELETON, 'utf8');
const a = html.indexOf('<div class="focus">'), b = html.indexOf('</div></div>\n\t</div>\n\n\t<p class="note">');
if (a < 0 || b < 0) throw new Error('markers not found');
html = html.slice(0, a) + body + '\t' + html.slice(b);
html = html.replace('</style>', css + '</style>');
const rep = (x, y) => { if (!html.includes(x)) throw new Error('missing: ' + x); html = html.replace(x, y); };
rep('<title>Noun Gender Chart</title>', '<title>N-Nouns Chart</title>');
html = html.replace(/<h1>Chart 15[^<]*<\/h1>\s*<p>[^<]*/, '<h1>Chart 17, nouns that add -n</h1>\n\t\t<p>The masculine nouns that add -n in every case but the Nominativ, and which ones they are.');
rep('<small>Chart 15</small>der, die or das?', '<small>Chart 17</small>der Junge, den Jungen');
rep('data-qr="15"', 'data-qr="17"');
html = html.replace(/<div class="path">[\s\S]*?<\/div>/, `<div class="path">
				<span><b>1</b>Is it in a group on the right?</span>
				<span><b>2</b>Not the subject? Add -n</span>
				<span><b>3</b>Plural: -n as well</span>
			</div>`);
writeFileSync(FILE, html);
console.log('chart 17 built', Math.round(html.length / 1024) + ' KB,', count, 'forms, nouns and sentences');
